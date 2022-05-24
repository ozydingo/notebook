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
