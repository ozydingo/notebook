# WAT

[https://www.destroyallsoftware.com/talks/wat](https://www.destroyallsoftware.com/talks/wat)

## Python

Ternary operator: instead of `condition ? value1 : value2`, you have `value1 if condition else value2`

In pdb, `list` command masks `list` class name.

Tuples hiding in plain sight

```
def f():
  {
    'a': 1,
  },

f()
# => ({'a': 1},)
# That's a tuple
```

Unsortable

```
>>> sorted([1,2, 0])
[0, 1, 2]
>>> sorted([1,2,np.nan, 0])
[1, 2, nan, 0]
```

## Bash

`[-z]`, [`-n`]: I literally have to use a pneumonic each time to remember which one means what.

## Mutli

Sting join:

* Ruby, Javascript: `['foo', 'bar'].join('-')]`
* Python: `'-'.join(['foo', 'bar'])`
* Perl: `join('-', ['foo', 'bar'])`

## OpenCV

```python
output = cv2.rectangle(image, (0, 0), (10, 10), color=(0,0,0))
# => OK
output = cv2.rectangle(image, (0.0, 0), (10, 10), color=(0,0,0))
# ---------------------------------------------------------------------------
# TypeError                                 Traceback (most recent call last)
# <ipython-input-50-200ba873e75b> in <module>
# ----> 1 output = cv2.rectangle(image, (0.0, 0), (10, 10), color=(0,0,0))
#
# TypeError: argument for rectangle() given by name ('color') and position (3)
```

Color tuples are (B G, R) instead of (R, G, B)

More: https://www.learnopencv.com/why-does-opencv-use-bgr-color-format/
