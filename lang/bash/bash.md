## Key commands

* `ctrl` + `a` / `e`: Move cursor to beginning / end of line
* `ctrl` + `r`: Reverse-search command history
* `alt` + `r`: Revert current, modified, command recalled from history to original
* `alt` + `>`: Go to last line (AKA cancel reverse history search)
* `ctrl` + `g`: Cancel (AKA cancel reverse history search)
* `alt` + `f`/`b`: Move cursor forward / back one word
* `ctrl` + `w`, `alt` + `d`: Delete previous / next word
* `ctrl` + `t`, `alt` + `t`: Switch current & previous character / word
* `ctrl` + `d`: Delete next character
* `ctrl` + `d`: Quit current process
* `ctrl` + `x` + `x`: Toggle cursor position
* `alt` + `u` / `l`: Convert next work to upper / lower case
* `ctrl` + `v`: Enter next character verbatim (including control chars)
* `ctrl` + `k`: Kill rest of line
* `ctrl` + `u`: Kill to start of line
* `ctrl` + `y`: Yank (type most recently killed text)

## Pattern Matching

```
bash => regexp

* => .+

? => .

[CHARS] => [CHARS]

?(patterns) => (patterns)?
*(patterns) => (patterns)*
+(patterns) => (patterns)+
@(pattern-list) => pattern
!(pattern-list) ~> inverse match
```

## Parameter subsitution

```
$ ${parameter:-word}
> parameter || "word"

$ ${parameter:=word}
> parameter ||= "word"

$ ${parameter:?word}
> ???

$ ${parameter:+word}
> parameter && "word"

$ ${parameter:offset:length}
> parameter[offset..offset+length]

$ ${!prefix*}
$ ${!prefix@}
# expand to names of matching variables

$ ${!name[@]}
$ ${!name[*]}
# array expansion; "0" if not array, "" if unset.

$ ${#parameter}
> parameter.length

$ ${parameter#pattern}
# remove shortest matching leading pattern from $parameter
$ ${parameter##pattern}
# remove shortest matching leading pattern from $parameter
$ ${parameter%pattern}
# remove shortest matching trailing pattern from $parameter
$ ${parameter%%pattern}
# remove shortest matching trailing pattern from $parameter

${parameter/pattern/string}
> parameter.sub(pattern, string)
${parameter//pattern/string}
> parameter.gsub(pattern, string)

${parameter^pattern}
${parameter^^pattern}
${parameter,pattern}
${parameter,,pattern}
# case substitution, does not work on OS X

${string@operator}
# Does not work on OS X
```

Pattern matching examples:

```
string="hello, world"
[none] ~ echo ${string##he*(l)}
o, world
[none] ~ echo ${string#he*(l)}
llo, world
[none] ~ echo ${string%+([world])}
hello, worl
[none] ~ echo ${string%%+([world])}
hello,

[none] ~ echo ${string/l/L}
heLlo, world
[none] ~ echo ${string//l/L}
heLLo, worLd
```
