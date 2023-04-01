# YAML

## Aliasing

Note: use `echo '...' | yq 'explode(.)'` to inspect the result.

For convenience:

```sh
explode() {
  echo "$1" | yq 'explode(.)'
}
```

or

```sh
cat <<-EOF | yq 'explode(.)'
...
EOF
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
  y: 3
```

result

```yaml
- x: 1
  y: 2
- x: 1
  y: 3
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

result

```yaml
foo:
  - 1
  - 2
bar:
  - 1
  - 2
```

Bad:

```yaml
foo: &foo
  - 1
  - 2
bar:
  - 0
  - <<: *foo
```

Bad result:

```yaml
foo:
  - 1
  - 2
bar:
  - 0
  - 1: 2
```

## Whitespace

### Multi-line strings

E.g.

```yaml
key: |
  some text
  goes here
```

#### Inner newlines

- `>`: Replace inner newlines with space
- `|`: Keep inner newlines

#### Final newlines(s)

Add a character to the whitespace specifier to modify final newline behavior

- `>`, `|` (no suffix, default): Keep one final newline
- `>-`, `|-`: strip final newline(s)
- `>+`, `|+`: keep all final newlines

### Full combinations

| Symbol | Inside newlines    | Final newlines  |
| ------ | ------------------ | --------------- |
| `>`    | Replace with space | clip (keep one) |
| `>-`   | Replace with space | strip           |
| `>+`   | Replace with space | all             |
| `\|`   | Keep               | clip            |
| `\|-`  | Keep               | strip           |
| `\|+`  | Keep               | all             |

### Examples

See interactive examples at https://yaml-multiline.info/

```yaml
---
example: >
  Several lines of text,
  with some "quotes" of various 'types',
  and also a blank line:

  and some text with
    extra indentation
  on the next line,
  plus another line at the end.
---
```

Results:

`>`

```
Several lines of text, with some "quotes" of various 'types', and also a blank line:\n
and some text with\n
  extra indentation\n
on the next line, plus another line at the end.\n
```

`>-`

```
Several lines of text, with some "quotes" of various 'types', and also a blank line:\n
and some text with\n
  extra indentation\n
on the next line, plus another line at the end.
```

`>+`

```
Several lines of text, with some "quotes" of various 'types', and also a blank line:\n
and some text with\n
  extra indentation\n
on the next line, plus another line at the end.\n
\n
\n
```

`|`

```
Several lines of text,\n
with some "quotes" of various 'types',\n
and also a blank line:\n
\n
and some text with\n
  extra indentation\n
on the next line,\n
plus another line at the end.\n
```

`|-`

```
Several lines of text,\n
with some "quotes" of various 'types',\n
and also a blank line:\n
\n
and some text with\n
  extra indentation\n
on the next line,\n
plus another line at the end.
```

`|+`

```
Several lines of text,\n
with some "quotes" of various 'types',\n
and also a blank line:\n
\n
and some text with\n
  extra indentation\n
on the next line,\n
plus another line at the end.\n
\n
\n
```
