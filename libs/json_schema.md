# JSON Schema

## JSONSchema draft history

https://json-schema.org/specification.html

- draft-4
- draft-5
- draft-6
- draft-7
- draft-2019-09
- draft-2020-12

## JSON data types

- string
- number
- integer
- object
- array
- boolean
- null

JSONSchema may also use multiple types: `{"type": ["number", "string"]}`

## Type specs

https://json-schema.org/understanding-json-schema/reference/index.html

### String

- minLength / maxLength
- pattern: regex
- format: annotation-only, no guaranteed behavior
  - date-time / time [draft-7] / date [draft-7] / duration [draft-2019-09]
  - email / idn-email [draft-7]
  - hostname / idn-hostname [draft-7] / ipv4 / ipv6
  - uuid [draft-2019-09] / uri / uri-reference [draft-6] / iri [draft-7] / iri-reference [draft-7]
  - uri-template [draft-6]
  - json-pointer [draft-6]
  - regex [draft-7]

### Number

- multipleOf
- minimum / maximum / exclusiveMinimum / exclusiveMaximum

### Object

- properties: {name, schema} pairs
- patternProperties: regex as keys
- additionalProperties: true/false to allow / prohibit unspec'd props
- unevaluatedProperties [draft-2019-09]: like additionalProperties but allows composition
- required
- propertyNames [draft6]: name, schema pairs
- minProperties / maxProperties

Example `patternProperties`:

```
{
  "type": "object",
  "patternProperties": {
    "^S_": { "type": "string" },
    "^I_": { "type": "integer" }
  }
}
```

### Array

- items: single schema for all items
  - [draft-2019-09] single schema or list of schemae
- prefixItems: list of schemae (tuple validation)
  - [draft-2020-12:?] `items` can be used as `false` in conjunction to disallow additional items beyond the tuple, or a schema to specify the required type of additional items
- unevaluatedItems
- contains [draft-6]: schema to match in at least one item
- minContains [draft-2019-09] / maxContains [draft-2019-09]
- minItems / maxItems
- uniqueness

### Boolean

No options.

### Null

No options.

## Other keywords

### Specific values

- enum
- const

### Annotations

Non-functional parts of the schema

- title / descriptions
- default
- example [draft-6]
- readOnly / writeOnly [draft-7]
- deprecated [draft-2019-09]
- $comment [draft-7]

### Schema composition

- allOf / anyOf / oneOf: array of schemae
- not: schema

### Version

- $schema
  - http://json-schema.org/schema# (latest)
  - http://json-schema.org/draft-04/schema#
  - http://json-schema.org/draft-06/schema#
  - http://json-schema.org/draft-07/schema#
  - https://json-schema.org/draft/2019-09/schema

### References

- $id
- $anchor
- $ref
- $def
