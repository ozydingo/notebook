## In Short
Define typed fields for queries, each field has a corresponding function definition. Fields can be plain data types or other custom model types, it's all the same to GraphQL.

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
