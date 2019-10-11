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

## String formatting

let:

```
name = 'world'
year = 2019
```

Old way: `"hello, %s, it's %d" % (name, year)`

Less old way: `"hello {name}, it's {year}".format(name=name, year=year)`

New way: `f"hello, {name}, it's {year}"`

`__str__()` -- human readable string.

`__repr__()` -- string representation.

```python
class Thing:
    def __str__(self):
        return "str"
    def __repr__(self):
        return "repr"
thing = Thing()
thing
# repr
"Thing: %s" % (thing)
# => Thing: str
"Thing: {}".format(thing)
# => Thing: str
f"Thing: {thing}"
# => Thing: str
```

Unique to f-strings:

```python
f'Thing: {thing!r}'
# => Thing: repr
name, year = 'world', 2019
message = (
    f"Hi {name}. "
    f"It's {year}."
)
message
# => "Hi world. It's 2019."
```

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

## Exceptions

* AssertionError -- Raised when assert statement fails.
* AttributeError -- Raised when attribute assignment or reference fails.
* EOFError -- Raised when the input() functions hits end-of-file condition.
* FloatingPointError -- Raised when a floating point operation fails.
* GeneratorExit -- Raise when a generator's close() method is called.
* ImportError -- Raised when the imported module is not found.
* IndexError -- Raised when index of a sequence is out of range.
* KeyError -- Raised when a key is not found in a dictionary.
* KeyboardInterrupt -- Raised when the user hits interrupt key (Ctrl+c or delete).
* MemoryError -- Raised when an operation runs out of memory.
* NameError -- Raised when a variable is not found in local or global scope.
* NotImplementedError -- Raised by abstract methods.
* OSError -- Raised when system operation causes system related error.
* OverflowError -- Raised when result of an arithmetic operation is too large to be represented.
* ReferenceError -- Raised when a weak reference proxy is used to access a garbage collected referent.
* RuntimeError -- Raised when an error does not fall under any other category.
* StopIteration -- Raised by next() function to indicate that there is no further item to be returned by iterator.
* SyntaxError -- Raised by parser when syntax error is encountered.
* IndentationError -- Raised when there is incorrect indentation.
* TabError -- Raised when indentation consists of inconsistent tabs and spaces.
* SystemError -- Raised when interpreter detects internal error.
* SystemExit -- Raised by sys.exit() function.
* TypeError -- Raised when a function or operation is applied to an object of incorrect type.
* UnboundLocalError -- Raised when a reference is made to a local variable in a function or method, but no value has been bound to that variable.
* UnicodeError -- Raised when a Unicode-related encoding or decoding error occurs.
* UnicodeEncodeError -- Raised when a Unicode-related error occurs during encoding.
* UnicodeDecodeError -- Raised when a Unicode-related error occurs during decoding.
* UnicodeTranslateError -- Raised when a Unicode-related error occurs during translating.
* ValueError -- Raised when a function gets argument of correct type but improper value.
* ZeroDivisionError -- Raised when second operand of division or modulo operation is zero.

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

## Collections

### namedtuple

```python
from collections import namedtuple
dims = namedtuple('dims', ['width', 'height'])
d = dims(width=10, height=5)
d.width
```

## Function caching

```python
from functools import lru_cache
import random

# cache values for up to 4 different arg inputs
@lru_cache(maxsize=4)
def compute(val):
    print("Computing...")
    return random.random()

compute(0)
# Computing...
# => 0.4749983769717562
compute(0)
# => 0.4749983769717562
```

## Context management

```python
class Context(object):
    def __init__(self, name):
        print("Starting")
        self.name = name
    def __enter__(self):
        print("Entering")
        print("Hello, {}".format(self.name))
        return self.name.upper()
    def __exit__(self, type, value, traceback):
        print("Exiting")

with Context("world") as object:
    print(object)

# Starting
# Entering
# Hello, world
# WORLD
# Exiting
```

## Iterators

An iterator is an object with the `__init__`, `__iter__`, and `__next__` functions.
  * `__next__` should return the next value or raise a `StopIteration`.
  * `__iter__` returns `self`.

`iter(iterable)` will create an iterator from an enumerable object.
`next(iterator)` call `__next__` on `iterator`.

## Generators

A generator is a function that keeps state and calls `yield`. Each call to `yield` returns the next value in the sequence.

```python
def fib():
  prev = 0
  cur = 1
  while True:
    yield cur
    prev, cur = cur, prev + cur

f = fib();
f.next()
f.next()
# ...
```

## Coroutines

Like generators, but accept input instead of yielding output

```python
def bro():
    print("Whassup")
    while True:
        line = yield
        if line.lower() == "bro":
            print("Bro!")

dude = bro()
next(dude)
# Whassup
dude.send("hey")
dude.send("bro")
# Bro!
```
