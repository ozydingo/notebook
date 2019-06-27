## Resources

http://book.pythontips.com/en/latest/

## Module path

`sys.path` => `['.', $PYTHONPATH, *default]`

## Argparse

```
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('operation', type=str, )
parser.add_argument('integers', metavar='N', type=int, nargs='+',
                    help='an integer for the accumulator')
parser.add_argument('--sum', dest='accumulate', action='store_const',
                    const=sum, default=max,
                    help='sum the integers (default: find the max)')

args = parser.parse_args()
print args.accumulate(args.integers)
```

### action

* `store` (default)
* `store_const`
* `store_true`, `store_false`
* `append`
* `append_const`
* `count`
* `help`
* `version`

### nargs

* [unspecified]: single argument
* `'?'`: optional positional argument
* `'*'`: list
* `'+'`: list with at least one required
* `argparse.REMAINDER`: remaining args

```
parser.add_argument('one', type=str)
parser.add_argument('two', type=str, nargs='*')
```

and

```
parser.add_argument('one', type=str)
parser.add_argument('two', type=str, nargs=argparse.REMAINDER)
```

seem to be equivalent. `'*'` is additionally useful for multiple args to a flag, e.g. `--foo 1 2 3`

### const

Read from code to use internally, not read from cmd line.

### default

Default value. Use `argparse.SUPPRESS` to omit the key when not provided.

### type

`int`, `str`, `file`. Use `argparse.FileType('w')` for write file. `file` args are opened automatically.

You can also use a `<function(string)>` to parse the arg.

### choices

list of valid options

### required

Use only on flag args, indicated they are required. Use `nargs='?'` for an optional positional arg.

### help

Help string

### metavar

Var name in help text

### dest

Name of field on `args` return value. Default to arg name: name, first long-name, or short letter name.



## pipenv

https://pipenv.readthedocs.io/en/latest/install/

## pyenv

`pyenv install 2.7.12`
pyenv build failed, consult https://github.com/pyenv/pyenv/wiki/Common-build-problems:
`brew install readline xz`
> already installed

> When running Mojave or higher (10.14+) you will also need to install the additional SDK headers by downloading them from Apple Developers. You can also check under /Library/Developer/CommandLineTools/Packages/ as some versions of Mac OS will have the pkg locally.

Run `sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /`, then `pyenv install 2.7.12` succeeded.

## Array manipulation

Convert an array-like using `list(array_like)`

`filter()`, `map()`, `reduce()`. As of python3 these are lazily eval'd, so use `list(filter(fn, array_like))` to immediately access.

## Matrix math

`@` operator for matrix multiplication. Same as `np.dot` under specific assumed conditions.

```python
import numpy as np
y = np.ones(4)
y @ y
#=> 4.0

x = np.ones((1,4))
x @ x
#=> ValueError: dimension mismatch
x @ x.tranpose()
#=> array([[4.]])
x.transpose() @ x
#=> array([[1., 1., 1., 1.],
#       [1., 1., 1., 1.],
#       [1., 1., 1., 1.],
#       [1., 1., 1., 1.]])
```

## Introspection

`dir(obj)` - list methods of obj. `dir()` lists method in current scope.

`type(obj)` - get class / type

`id(obj)` - object id

`import inpsect` -- use the awesome "inspect" module. Use: `inspect.getfile(object)` and `insepct.isfunction(obj)` More at [https://docs.python.org/3/library/inspect.html](https://docs.python.org/3/library/inspect.html).
