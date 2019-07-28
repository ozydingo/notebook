## Resources

http://book.pythontips.com/en/latest/

## Basics

`for x in iterable`
`for (ii, x) in enumerate(iterable)`

`if`/`else`/`elif`

`for`/`continue`/`break`/`else`
`while`/`continue`/`break`/`else`

`try`/`except`/`else`/`finally`

Dict: `{'a': 1, 'b': 2}`. Key order is not guaranteed.
`dict.get(key, default)`

Falsy: `False`, `None`, `0`, `[]`, `{}`, `x if x.size == 0`

`x.is(y)` -- object equality.

`def func(*varargs, **kwargs)`

`a, b, *rest = some_iterable`

`sys.stdin`, `sys.stdout`, `sys,.stderr`

## Imports

```
import package
import package as pkg
from package import named_entity
from path.to.subpackage import thing as alias
from . import sibling
```

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

* `action`:
  * `store` (default)
  * `store_const`
  * `store_true`, `store_false`
  * `append`
  * `append_const`
  * `count`
  * `help`
  * `version`
* nargs
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

* const
  * Read from code to use internally, not read from cmd line.
* default
  * Default value. Use `argparse.SUPPRESS` to omit the key when not provided.
* type
  * `int`, `str`, `file`. Use `argparse.FileType('w')` for write file. `file` args are opened automatically.
  * You can also use a `<function(string)>` to parse the arg.
* choices
  * list of valid options
* required
  * Use only on flag args, indicated they are required. Use `nargs='?'` for an optional positional arg.
* help
  * Help string
* metavar
  * Var name in help text
* dest
  * Name of field on `args` return value. Default to arg name: name, first long-name, or short letter name.

## Array manipulation

Convert an array-like using `list(array_like)`

`filter()`, `map()`, `reduce()`. As of python3 these are lazily eval'd, so use `list(filter(fn, array_like))` to immediately access.

## Dimension ordering

Dims are numbered left to right, highest-order to lowest. Negative numbering counts from lowest / rightmost. Dim -1 spans a row; for a column vector use `np.ones((n, 1))`.

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

## Decoartion

```python
from functools import wraps

def decorate(func):
    @wraps(func)
    def decorated(*args, **kwargs):
        print("being")
        func(*args, **kwargs)
        print("end")
    return decorated

@decorate
def say():
    print("Hi")
```

Decorators can take args. Do this by defining an outer function that, when called, returns a decorator like before.

```python
def decorate(name):
    def decorate_func(func):
        @wraps(func)
        def decorated_func(*args, **kwargs):
            print("Hello, {}".format(name))
            func(*args, **kwargs)
        return decorated_func
    return decorate_func

@decorate("world")
def say():
    print("Hi")
```

Decorators can be defined from classes too:

```python
class Decorate(object):
    def __init__(self, func):
        self.func = func

    def __call__(self, *args, **kwargs):
        print("Hello")
        return self.func(*args, **kwargs)

@Decorate
def say():
    print("Hi")

say()
```
