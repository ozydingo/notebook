# YAML

## Aliasing

Note: use `echo '...' | yq 'explode(.)'` to inspect the result.

For convenience:

```
explode() {
  echo "$1" | yq 'explode(.)'
}
```

### Basic syntax

- `&NAME`: define an anchor. Placed before the value; this means
  - In front of a scalare value
  - On the line above a map, after the `-` or `KEY:` line.
- `*NAME`: reference a value as a single item. Place this wherever you would put the value
- `<<: *NAME`: merge NAME (as an object) into the current map context

### Value

```yaml
- &foo foo
- bar
- *foo
```

### Map

#### Merging an object

```yaml
- foo: &foo
    x: 1
    y: 2
- bar:
    a: 10
    x: 10
    <<: *foo
    y: 10
```

Result:

```yaml
- foo:
    x: 1
    y: 2
- bar:
    a: 10
    x: 1
    y: 10
```

#### Object in list

```yaml
- &foo
  x: 1
  y: 2
- <<: *foo
```

result

```yaml
- x: 1
  y: 2
- x: 1
  y: 2
```

- &foo
  x: 1
  y: 2
- \*foo

#### List

```yaml
foo: &foo
  - 1
  - 2
bar: *foo
```
