# Terraform

## General syntax

```tf
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```

## Arrangment

- A terraform module is a directory containing `*.tf` files. All tf files are loaded, but no subdirectories are traversed.
- Files are processed in lexigraphic order.
- `override.tf`, `override.tf.json`, `_override.tf`, and `_override.tf.json` are special files that are processed last.
- Any duplicated top-level blocks are merged. Any duplicated nested blocks are replaced.
- An exception is `resource.lifecycle`, whose keys are merged.

## Block Types

- resource
- data
- provider
- variable
- output
- locals
- module
  ...

### resource

A resource managed by terraform. Resource APIs are defined by providers.

```
resource "TYPE" "NAME" { ... }
```

Use `<RESOURCE TYPE>.<NAME>.<ATTRIBUTE>` to reference a resource's attribute later.

#### meta-arguments

- depends_on -- set dependency order
- count -- create multiple copies
- [for_each](https://www.terraform.io/language/meta-arguments/for_each) -- create multiple resources in a loop; use the `each` var to reference each item
- provider -- override the default provider
- lifecycle
- provisioner

### data

External data source, defined by providers.

### provider

Defines resources.

```
provider "NAME" { ... }
```

Use the `alias` meta-argument field to define mulitple providers of the same type with differing configurations. Use the `provider` meta-argument in a resource to use it.

### variables

```
variable "NAME" { type, description, default, validation, sensitive=false, nullable=true }
```

```
  validation { condition, error_message }
```

Use variables with `var.NAME`

Set vars:

- In the config
- `.tfvars` files
  - `terraform.tfvars{,.json}`, `*.auto.tfvars{,.json}`
  - Use `-var-file` flag for other files
- ENV: `TF_VAR_$NAME=$VALUE`
- CLI flag: `-var="$NAME=$VALUE`

#### Variable order of precedence (latest takes precedence)

- ENV
- `terraform.tfvars`
- `terraform.tfvars.json`
- `*.auto.tfvars{,.json}`, in lexical order
- `-var`, `-var-file`, in order provided.

### outputs

```
ourput "NAME" {
  value = ...
}
```

- description
- precondition
- sensitive
- depends_on

### locals

```
locals {
  NAME = VALUE
  ...
}
```

### module

```
module NAME {
  source = SOURCE_LOCATION
  ...
  ... module input values ...
}
```

- count
- for_each
- providers
- depends_on

## tf.json

### Native tf:

```tf
variable "example" {
  default = "hello"
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-abc123"
}
```

```json
{
  "variable": {
    "example": {
      "default": "hello"
    }
  }
}
```

```json
{
  "resource": {
    "aws_instance": {
      "example": {
        "instance_type": "t2.micro",
        "ami": "ami-abc123"
      }
    }
  }
}
```

## CLI features

- `terraform fmt`
- `terraform console`
- `terraform validate`

### Inspection

- graph
- output
- show
- state {list,show,...}

### Modification

- plan
- apply
- taint, untaint

### Management

- terraform workspace ...

Be cautious not to overuse workspaces. They work well for same-config, single-backend. For separate architectures, use module composition.
