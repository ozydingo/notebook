## String encoding

Note: we're using "they’re", not "they're".

```
str = "they’re"
str.bytes
# => [116, 104, 101, 121, 226, 128, 153, 114, 101]
str.encode("ascii")
# => Encoding::UndefinedConversionError: U+2019 from UTF-8 to US-ASCII
str.force_encoding("ascii")
# => "they\xE2\x80\x99re"
str.encode("ascii", undef: :replace)
# => "they???re"
str.encode("ascii", undef: :replace).bytes
# => [116, 104, 101, 121, 63, 63, 63, 114, 101]
str.force_encoding("Windows-1252").encode('utf-8')
# => "theyâ€™re"
```

## Method parameters

```rb
def foo(a, b = 2, c: 1, d:); end
method(:foo).parameters
# => [[:req, :a], [:opt, :b], [:keyreq, :d], [:key, :c]]
```

## Pattern matching

Inline:

```rb
data = {x: 1, y: {a: 2, b: 3}}
data => {x:, y: {a:}}

x
# => 1
a
# => 2
```

Only leaf nodes are matched:

```rb
y
# !!! undefined local variable or method `y'
```

`in` operator

```rb
data = {x: 1, y: {a: 2, b: 3}}
data in {x: Integer, y: {z:}}
# => false
data in {x: Integer, y: {a:}}
# => true
data in {x: Integer, y: {a: Integer}}
# => true
data in {x: Integer, y: {a: String}}
# => false
```

Use in `case/in`

```rb
data = {x: 1, y: {a: 2, b: 3}}
case data
in {x: Integer, y: {z:}}
  puts "got a z"
in {x: Integer, y: {a:}}
  puts "got an a"
else
  puts "neither"
end

case data
in {x: Integer, y: {a: String}}
  puts "x is an integer and y.a is a string"
in {x: Integer, y: {a: Integer}}
  puts "x is an integer and y.a is also an integer"
else
  puts "neither"
end
```

Find patterns

```rb
["hello", "world"] in [*, /^h/, /^w/, *]
# => true
```
