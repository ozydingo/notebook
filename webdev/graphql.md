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
