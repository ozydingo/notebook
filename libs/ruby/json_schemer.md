# JsonSechemer

## Error types

### Wrong type

Key identifier: `"type" => $TYPE`

```rb
require "json_schemer"
schema = {
  "type" => "object",
  "properties" => {"foo" => {"type" => "string"}},
}
data = {"foo" => 1}
pp JSONSchemer.schema(schema).validate(data).to_a
```

```rb
[{"data"=>1,
  "data_pointer"=>"/foo",
  "schema"=>{"type"=>"string"},
  "schema_pointer"=>"/properties/foo",
  "root_schema"=>{"type"=>"object", "properties"=>{"foo"=>{"type"=>"string"}}},
  "type"=>"string"}]
```

### Extra property

Key identifier: `"type" => "schema", "schema_pointer"=>"*/additionalProperties"`

```rb
require "json_schemer"
schema = {
  "type" => "object",
  "properties" => {},
  "additionalProperties" => false,
}
data = {"foo" => 1}
pp JSONSchemer.schema(schema).validate(data).to_a
```

```rb
[{"data"=>1,
  "data_pointer"=>"/foo",
  "schema"=>false,
  "schema_pointer"=>"/additionalProperties",
  "root_schema"=>
   {"type"=>"object", "properties"=>{}, "additionalProperties"=>false},
  "type"=>"schema"}]
```

### Missing required property

Key idenfitier: `"type" => "required"`

```rb
require "json_schemer"
schema = {
  "type" => "object",
  "required" => ["foo"],
  "properties" => {"foo" => {"type" => "string"}},
}
data = {}
pp JSONSchemer.schema(schema).validate(data).to_a
```

```rb
[{"data"=>{},
  "data_pointer"=>"",
  "schema"=>
   {"type"=>"object",
    "required"=>["foo"],
    "properties"=>{"foo"=>{"type"=>"string"}}},
  "schema_pointer"=>"",
  "root_schema"=>
   {"type"=>"object",
    "required"=>["foo"],
    "properties"=>{"foo"=>{"type"=>"string"}}},
  "type"=>"required",
  "details"=>{"missing_keys"=>["foo"]}}]
```
