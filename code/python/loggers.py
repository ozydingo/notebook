import logging

bar = logging.getLogger("foo.bar")
foo = logging.getLogger("foo")

logging.basicConfig()

foo.setLevel(logging.DEBUG)

foo.debug("hello, world")
bar.debug("hello, world")
