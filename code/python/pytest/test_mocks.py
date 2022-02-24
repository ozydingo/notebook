import os

from my_class import MyClass

class UnixFS:
    @staticmethod
    def rm(filename):
        os.remove(filename)

class Fizz():
    def get():
        return "fizz"


def test_unix_fs(mocker): # `mocker` requires pytest-mock to be installed
    mocker.patch('os.remove')
    UnixFS.rm('file')
    os.remove.assert_called_once_with('file')

def test_foo(mocker):
    mocker.patch("my_class.MyClass.foo")
    my_class = MyClass()
    my_class.foo("bar")
    MyClass.foo.assert_called_once_with("bar")
    my_class.foo.assert_called_once_with("bar")

def test_return_value(mocker):
    mocker.patch("my_class.MyClass.foo")
    my_class = MyClass()
    print("foo?")
    value = my_class.foo(None)
    mocker.stopall()
    real_value = my_class.foo(None)
    assert value != "foo"
    assert real_value == "foo"

fizzbuzz = ["fizz", "fizz", "buzz"]
def test_multiple_responses(mocker):
    mocker.patch("my_class.MyClass.foo", side_effect=fizzbuzz)
    fizz = MyClass()

    assert fizz.foo(None) == "fizz"
    assert fizz.foo(None) == "fizz"
    assert fizz.foo(None) == "buzz"
