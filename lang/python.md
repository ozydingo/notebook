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

- `action`:
  - `store` (default)
  - `store_const`
  - `store_true`, `store_false`
  - `append`
  - `append_const`
  - `count`
  - `help`
  - `version`
- nargs
  - [unspecified]: single argument
  - `'?'`: optional positional argument
  - `'*'`: list
  - `'+'`: list with at least one required
  - `argparse.REMAINDER`: remaining args

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

- const
  - Read from code to use internally, not read from cmd line.
- default
  - Default value. Use `argparse.SUPPRESS` to omit the key when not provided.
- type
  - `int`, `str`, `file`. Use `argparse.FileType('w')` for write file. `file` args are opened automatically.
  - You can also use a `<function(string)>` to parse the arg.
- choices
  - list of valid options
- required
  - Use only on flag args, indicated they are required. Use `nargs='?'` for an optional positional arg.
- help
  - Help string
- metavar
  - Var name in help text
- dest
  - Name of field on `args` return value. Default to arg name: name, first long-name, or short letter name.

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

- AssertionError -- Raised when assert statement fails.
- AttributeError -- Raised when attribute assignment or reference fails.
- EOFError -- Raised when the input() functions hits end-of-file condition.
- FloatingPointError -- Raised when a floating point operation fails.
- GeneratorExit -- Raise when a generator's close() method is called.
- ImportError -- Raised when the imported module is not found.
- IndexError -- Raised when index of a sequence is out of range.
- KeyError -- Raised when a key is not found in a dictionary.
- KeyboardInterrupt -- Raised when the user hits interrupt key (Ctrl+c or delete).
- MemoryError -- Raised when an operation runs out of memory.
- NameError -- Raised when a variable is not found in local or global scope.
- NotImplementedError -- Raised by abstract methods.
- OSError -- Raised when system operation causes system related error.
- OverflowError -- Raised when result of an arithmetic operation is too large to be represented.
- ReferenceError -- Raised when a weak reference proxy is used to access a garbage collected referent.
- RuntimeError -- Raised when an error does not fall under any other category.
- StopIteration -- Raised by next() function to indicate that there is no further item to be returned by iterator.
- SyntaxError -- Raised by parser when syntax error is encountered.
- IndentationError -- Raised when there is incorrect indentation.
- TabError -- Raised when indentation consists of inconsistent tabs and spaces.
- SystemError -- Raised when interpreter detects internal error.
- SystemExit -- Raised by sys.exit() function.
- TypeError -- Raised when a function or operation is applied to an object of incorrect type.
- UnboundLocalError -- Raised when a reference is made to a local variable in a function or method, but no value has been bound to that variable.
- UnicodeError -- Raised when a Unicode-related encoding or decoding error occurs.
- UnicodeEncodeError -- Raised when a Unicode-related error occurs during encoding.
- UnicodeDecodeError -- Raised when a Unicode-related error occurs during decoding.
- UnicodeTranslateError -- Raised when a Unicode-related error occurs during translating.
- ValueError -- Raised when a function gets argument of correct type but improper value.
- ZeroDivisionError -- Raised when second operand of division or modulo operation is zero.

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

- `__next__` should return the next value or raise a `StopIteration`.
- `__iter__` returns `self`.

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
# python 3
next(f)
next(f)
#python 2
f.next()
f.next()
# ...
```

Get a finite length of data from an infinite generator using composition:

[next(f) for _ in range(10)]

A generator can be defined by a class that defined the `__init__` and `__iter__` methods.

```python
class Fib(object):
  def __init__(self, max):
    self.prev = 0
    self.cur = 1
    self.max = max

  def __iter__(self):
     while self.cur < self.max:
       yield self.cur
       self.prev, self.cur = self.cur, self.cur + self.prev

f = Fib(10)
[ x for x in f ]
# => [1, 1, 2, 3, 5, 8]
```

A generator expression is like list composition but with parens:

```python
g1 = ( x for x in range(1000000))
g2 = (x for x in Fib(10000))
next(g2)
# => 1
next(g2)
# => 1
next(g2)
# => 2
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

## Metaclasses

Every class is an instance of a metaclass. `type` is the default metaclass. You can define your own.

```py
Bar = type('Bar', (Foo,), dict(attr=100))

x = Bar()
x.attr
# => 100
x.__class__
# => <class '__main__.Bar'>
x.__class__.__bases__
# => (<class '__main__.Foo'>,)
```

You can define your own metaclass:

```py
class Meta(type):
   def __new__(cls, name, bases, dct):
       x = super().__new__(cls, name, bases, dct)
       x.attr = 100
       return x

class Foo(metaclass=Meta):
  pass

Foo.attr
# => 100
```

## asyncio

Constructs similar to js `async`/`await`. An `async def` function returns a `coroutine`. This can be made into a `Task` inside an event loop (any other async function). Note that a returned coroutine does _not_ run automatically. A task runs soon after it is created (similar to js `Promise`).

```py
async def get_number(num):
  await asyncio.sleep(1)
  return num

async def main():
  x = asyncio.create_task(get_number(1))
  y = asyncio.create_task(get_number(2))
  z = asyncio.create_task(get_number(3))

  results = await asyncio.gather(z, y, x)
  return results

asyncio.run(main()) # Takes 1 second total
# => [3, 2, 1]
```

### Error handling

`asyncio.run` will propagate any errors. More nuance is availabe in `gather`.

```py
async def get_number(num, blowup=False):
  await asyncio.sleep(1)
  if blowup:
    raise RuntimeError("BOOM")
  return num

async def main(return_exeptions=False):
  x = asyncio.create_task(get_number(1, True))
  y = asyncio.create_task(get_number(2, False))
  z = asyncio.create_task(get_number(3, True))

  results = await asyncio.gather(z, y, x, return_exceptions=return_exeptions)
  return results

# This is the default, and will propagate exceptions. Other tasks are still running.
asyncio.run(main(False))
# !!! RuntimeError: BOOM

# Return exceptions instead of propagate
asyncio.run(main(True))
# => [RuntimeError('BOOM'), 2, RuntimeError('BOOM')]
```

### Basic API cheatsheet

- `asyncio.run` -- run the coroutine now, return control when it completes.
- `asyncio.create_task` -- schedule the coroutine and return a `Task` (this is more similar to a js `Promise`).
  - This can only be done inside an event loop (i.e. `async` function)
  - Note: you must `await` any tasks or they will not complete if your function ends earlier than the task.
- `await` -- inside an event loop, wait for completion of a `coroutine`, `Task`, or `Future`.
- `asyncio.gather` -- run multiple tasks and return their results
- `asyncio.sleep` -- sleep and yield control to the event loop
- `asyncio.sleep(0)` -- explicitly allow the event loop to execute other tasks' code if appropriate. Use this in long-running loops.
- `asyncio.wait_for(aw, timeout)` -- return an awaitable coroutine, raise `asyncio.TimeoutError` on timeout.
- `task.cancel` -- cancel a task. If the task is a gather,
- `(done, pending) = await asyncio.wait(aws, return_when=FIRST_COMPLETED)`
- `asyncio.as_completed(aws)` -- iterator that yields completed _coroutines_

```py
async def get_number(wait, num, blowup=False):
  await asyncio.sleep(wait)
  if blowup:
    raise RuntimeError("BOOM")
  return num

async def main():
  x = asyncio.create_task(get_number(1, 1))
  y = asyncio.create_task(get_number(2, 2))
  z = asyncio.create_task(get_number(3, 3, True))

  for coro in asyncio.as_completed([x, y, z]):
    result = await(coro)
    print(f"Done with {coro}: {result}")

asyncio.run(main())

```

### Blocking the event loop

Blocking operations will _not_ allow concurrent coroutines to process. For example, in this example, no `ping`s will be received while `hog` is sleeping using `time.sleep`.

```py
async def sleep_hog():
  await asyncio.sleep(1)
  print("hog start")
  time.sleep(5)
  print("hog finish")

async def get_events():
  for ii in range(20):
    print(f"ping {ii}")
    await asyncio.sleep(0.1)

async def main():
  events = asyncio.create_task(get_events())
  hog = asyncio.create_task(sleep_hog())
  await hog
  await events
```

## logging

Quick & dirty: `logging.info` etc. This uses the root logger, aka `logger.getLogger("root")`.

Diving into loggers:

```py
import logging

root = logging.getLogger()
# => <RootLogger root (WARNING)>
root.handlers
# => []
root.basicConfig() # this gets called on the first log call
root.handlers
# => [<StreamHandler <stderr> (NOTSET)>]
root.info("foo")
# => (no response)
root.setLevel(logging.INFO)
root.info("foo")
# => INFO:root:h
handler = root.handlers[0]
# =>  <StreamHandler <stderr> (NOTSET)>
formatter = handler.formatter
# => <logging.Formatter at 0xabc>
formatter._fmt
# => '%(levelname)s:%(name)s:%(message)s'
```

Loggers inherit settings from upper namespaces:

```py
import logging
logging.basicConfig() # convenience to create a default stream logger

appLogger = logging.getLogger("application")
appLogger.setLevel(logging.INFO)
subLogger = logging.getLogger("application.submodule")

subLogger.info("foo")
# => INFO:application.submodule:foo
```

To set up very manual logging patterns:

```py
import logging
# Use stream logging defaults, or pass in args if you want
logging.basicConfig()

# Define a base logger you can reference in modules to copy format and level
appLogger = logging.getLogger("application")
appLogger.propagate = False
appLogger.setLevel(logging.INFO)
handler = logging.StreamHandler()
formatter = logging.Formatter('%(levelname)s:%(name)s:%(message)s')
handler.setFormatter(formatter)
appLogger.addHandler(handler)

# then
appLogger = logging.getLogger("application")
subLogger = logging.getLogger("application.submodule")

# To add specific formatting
handler = logging.StreamHandler()
formatter = logging.Formatter('%(levelname)s:%(name)s:%(message)s')
handler.setFormatter(formatter)
subLogger.addHandler(handler)
subLogger.propagate = False
```

## mock, unittest.mock

Mock the lookup, not the definition:

To mock a `bar.baz` from package `bar` used in package `foo`, if you import the module:

```py
"""foo"""

import bar

bar.baz
```

You need to mock the module: `"bar.baz"`

But if instead you import the member/function

```py
"""foo"""

from bar import baz
```

You need to mock the member/function from your package: `"foo.baz"`

In short:

- `import foo; foo.bar` -> lookup is `foo.bar`, mock `foo.bar`
- `from foo import bar` -> lookup is `my_package.bar`, mock `my_package.bar`

See https://docs.python.org/3/library/unittest.mock.html#where-to-patch.
