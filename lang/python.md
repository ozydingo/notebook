## Resources

http://book.pythontips.com/en/latest/

## Module path

`sys.path` => `['.', $PYTHONPATH, *default]`

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
