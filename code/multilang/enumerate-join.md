```ruby
stuff = ["hello", "world"]
stuff.each.with_index{|word, index| puts [index, word].join(': ')}
```

```javascript
stuff = ["hello", "world"]
stuff.forEach((word, index) => {console.log([index, word].join(': '))})
```

```python
stuff = ["hello", "world"]
for (index, thing) in enumerate(stuff):
  print(': '.join([index, thing]))
```

```perl
my @stuff = ("hello", "world");
for my $index (0 .. $#stuff) {
  print join(': ', ($index, $stuff[$index])) . "\n";
}
```
