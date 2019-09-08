# GraphQL

## In Short
Define typed fields for queries, each field has a corresponding function definition. Fields can be plain data types or other custom model types, it's all the same to GraphQL.

## Why to use a graphql query builder

* GraphQL balks for quoted keys. Thus, trying to dynamically build queries is a little bit of a pain.

## Queries

* The field is the basic unit, and defines a data response shape.
* Fields can have arguments that modify the exact query
* Field names are used by default in the return, but can be aliased.
  * Aliasing allows sibling data of the same type (e.g. user1, user2)
* Reuse query code using fragments defined in the query

Dynamic queries, supported natively (efficiently) by GraphQL. These preclude the need to use server runtime to interpolate strings and create new query objects.
* $variables allow custom values to be passed into a query
  * `query($variable: <TYPE>)`
  * `query($variable: <TYPE> = <DEFAULT>)`
  * `$variable` can now be referenced in query arguments
* Directives allow customizable query shapes
  * `@include(if: Boolean)`
  * `@skip(if: Boolean)`
* Inline fragments
  * AKA type conditionals, used to include data only for specified type
  * `...on <TYPE> { <data shape to include> }`

Introspection and meta-fields:

* \_\_Schema
* \_\_Type
* \_\_TypeKind
* \_\_Field
* \_\_InputValue
* \_\_EnumValue
* \_\_Directive

## Mutations

Will generally take arguments and define its own return value shape.

Mutation fields are executed *in serial*

## Schema

All fields have zero or more arguments.

`query` and `mutation` are special entry points into any query, but otherwise are just regular types like everything else.

Leaves of a schema are scalar types (e.g. String, [Integer], etc)

The `ID` scalar type is a unique identifier, treated as String, but never needs to be human-readable.

Defining custom scalar types is possible with defined (de)serialization & validation.

`enum`s are a thing.

`interface` just like in Java. Types can declare `implements <INTERFACE>`. Can use inline fragments (`...on TYPE`) for dynamic specificty.

`union` -- polymorphic. Must use inline fragments for any query fields.

Types can be used as field arguments in addition to scalars. Define them using `input`.

## Execution

Four args to resolvers:

* `obj` - previous (parent) object
* `args` - any args to the field
* `context` - Declared context info like current user
* `info` - metainfo about the query, schema

## Authx

GraphQL is aware of authentication -- often by populating `current_user` in `context`. However, leave authorization to the business logic, do not handle it in GraphQL types. Often this means passing a `user` object from the resolver function into some internal class.

E.g. in Ruby, instead of putting any controller `can_access?` checks, use a `@current_user.posts` or `Post.for_user(user)` method. This also allows testing of this method to be decoupled from the controllers and queries.

# GraphQL-ruby

## Schema

class MySchema < GraphQL::Schema
  # Required:
  query Types::Query
  # Optional:
  mutation Types::Mutation
  subscription Types::Subscription
  introspection CustomIntrospectionClass
end

## Objects

The following GraphQL:

```
type User {
  email: String
  handle: String!
  friends: [User!]!
}
```

Is written in Ruby as:

```
class User < GraphQL::Schema::Object
  field :email, String, null: true
  field :handle, String, null: false
  field :friends, [User], null: false
  field :scores, [Integer, null: true], null: true
end
```

A `GraphQL::Schema::Object` subclass defines a basic object with fields. Typically, you'll define your own base class first: `class Types::BaseObject < GraphQL::Schema::Object`

Fields are resolved by calling a method of that name, or, in the case of a Hash, fetching the value with that key. This can be overridden using the `:method` or `:hash_key` keyword arg to `field`. Use `method: :itself` to pass self.

Define arguments, descriptions, and deprecation_reasons in a block passed to the `field` method.

Use a `limit` arg for any list return values!

An object can implement a defined interface using `implements INTERFACE_CLASS`. Interfaces are defined in modules that `include Types::BaseInterface`.

## Input Objects

Example input object

```
# Types::BaseInputObject is defined by you
class Types::PostAttributes < Types::BaseInputObject
  description "Attributes for creating or updating a blog post"
  argument :title, String, "Header for the post", required: true
  argument :full_text, String, "Full body of the post", required: true
  argument :categories, [Types::PostCategory], required: false
end
```

## Scalars, Enums, Union

Built-in scalar types:

* String
* Int
* Float
* Boolean
* ID
* ISO8601DateTime
* JSON

Define custom scalars by inheriting from some base class `Types::BaseScalar < GraphQL::Schema::Scalar` and defining two methods:

* self.coerce_input
* self.coerce_result

Example enum:

```
# Types::BaseEnum is defined by you
class Types::MediaCategory < Types::BaseEnum
  value "AUDIO", "An audio file, such as music or spoken word"
  value "IMAGE", "A still image, such as a photo or graphic"
  value "TEXT", "Written words"
  value "VIDEO", "Motion picture, may have audio"
end
```

Union classes inherit from `GraphQL::Schema::Union` and specify `possible_types(*type_classes)`.

## Authx

Handle authorization in the business layer. However, some authorization can be handled by GraphQlRuby if appropriate:

* Object authorization: `self.authorized?(object, context)`
* Visibility: `visible?`


## Mutations

`class Types::Mutation < Types::BaseObject`, attached to schema: `mutation(Types::Mutation)`. This is the only place this type is used. It defines the entry point for mutations. Specific mutations are declared as fields of this Type class. These fields are declared using mutation classes, e.g. `class Mutations::BaseMutation < GraphQL::Schema::Mutation`, `class Mutations::CreateComment < Mutations::BaseMutation`:

* `argument` describes an input param
* `field` described an output data field
  * `type` appears to be a shorthand way of defining the return type instead of individual fields
* Define the `resolve` method with the input `argument`s as keyword args to execute the mutation. The return value should match the `field` names.
* Hook up the mutation class to the base mutation as a field; e.g., `field :create_comment, mutation: Mutations::CreateComment`

Not sure I agree with this organization yet. Perhaps a better organization would be to have an `entry_points` folder containing the root types (Query, Mutation, Subscription). Mutations and Objects could be in their own folders, each with its base class `BaseMutation` and `BaseObject`. Try playing with this structure with a sufficnetly test-covered app.

Additional mutation features

* `null` class method specifies if field is nullable. Private API, apparently, yet recommended by how-to-graphql.

A mutation query is just a normal graphql query, and `BaseMutationType` works the same way as `BaseQueryType` since they both inherit from `BaseObject`. Thus is it possible to write mutations exactly as you would queries, and tbh I don't see a good reason yet why not to. But reason mey yet reveal itself.

For example:

```ruby
module Types
  class MutationType < BaseObject
    field :rename_file, MediaFileType, null: false do
      argument :id, ID, required: true
      argument :name, String, required: true
    end

    def rename_file(id:, name:)
      file = project.media_files.find(id)
      file.update_attributes!(name: name)
      return file
    end
  end
end
```

works as well as the recommended

```ruby
module Types
  class MutationType < BaseObject
    field :rename_file, mutation: Mutations::RenameFile
  end
end

module Mutations
  class RenameFile < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: true

    type Types::MediaFileType

    def resolve(id:, name:)
      file = project.media_files.find(id)
      file.update_attributes!(name: name)
      return file
    end
  end
end

```

When using the first form and *also* specifying the `mutation` keyword, Graphql-ruby calls the mutation and not the method.

## Errors

Raising works fine. `GraphQL::ExecutionError` is available.

More informative would be to add error types as types to the schema./ E.g. define an `errors` field and be sure to return an `errors` value in the return value of a Mutation (or query). Doing this requires 100% `null`able fields.

Define the `ready?` method to do GraphQL-layer authorization checks. This method can raise or can return `false, {...error_fields}` to indicate an error.

## Codeflow

It starts in `GraphqlController#execute`, which is the one route to which all graphql queries go. This calls `ServerSchema#execute` with the query params (which itself contains either the query or mutation key, or implicit). `ServerSchema` is a subclass of `GraphQL::Schema`, where `execute` is defined.

### Auth strategy

Create a mutation for signin / signout. Proper JWT is stateless, so no session. Typically, auth token is stored on the client and passed via headers. However, adding in persistence is easier on the client and allows for token invalidation.

If tokens are to be persisted on the client, why not make them completely random string instead of encoded data, and store the user data on the back-end?

Handle authorization in the business layer. This means every query and mutation is responsible for its own auth logic. This seems cumbersome, but it's pretty easy to add an auth method to Types::BaseObject and call this as needed, just like in controllers (except no before_action -- ah well I don't really like those anyway)

Explorative thoughts:

* Could be possible to defined authenticated vs unauthenticated query types, e.g. where the resolver method in `QueryType` checks for auth.
* Could define a different `GraphQL::Schema` subclass. This could be referenced either by a switch in `GraphQLController#execute` or by defining different routes for authenticated vs unauthenticated requests.
  * This requires changes on the client, but it's not unreasonable to have the client know if it's sending an auth or unauth request
