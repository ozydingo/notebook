## Terms

There is approximately zero consensus in the broader testing community about the actual definitions of these terms. But let's go with https://martinfowler.com/articles/mocksArentStubs.html:

- Doubles are any object swapped in for test purposes, include all of the below.
- Dummy objects are passed around but never actually used. Usually they are just used to fill parameter lists.
- Fake objects actually have working implementations, but usually take some shortcut which makes them not suitable for production (an in memory database is a good example).
- Stubs provide canned answers to calls made during the test, usually not responding at all to anything outside what's programmed in for the test.
- Spies are stubs that also record some information based on how they were called. One form of this might be an email service that records how many messages it was sent.
- Mocks are what we are talking about here: objects pre-programmed with expectations which form a specification of the calls they are expected to receive.

With these definitions, everything defined by `rspec-mocks` either by `double` or `spy` are in fact stubs _and_ spies but not mocks. They can be made into mocks by using `expect(...).to recieve`. However, `expect(...).to have_received` is preferred as it allows your test to obey "arrange, act, assert" ordering.

## Mocks

Doubles are dumb objects with a string name and no allowed methods. All method expectations must be explicit.

```rb
x = double("my double")
x.hello
# => RSpec::Mocks::MockExpectationError: #<Double "my double"> received unexpected message :hello with (no args)
allow(x).to receive(:hello)
x.hello
# => nil
```

There are three ways to specify mock message return values:

```rb
# lazy evaluation of return value
x = double("x")
allow(x).to receive(:hello) { Random.rand(10) }
# up front evaluation of return value
y = double("y")
allow(y).to receive(:hello).and_return(Random.rand(10))
# up front, hash shortcut
z = double("my other double", hello: "hi")

3.times.map { x.hello }
# => [0, 9, 4]
3.times.map { y.hello }
# => [4, 4, 4]
3.times.map { z.hello }
# => ["hi", "hi", "hi"]
```

Consecutive return values require the second form:

```rb
y = double("y")
allow(y).to receive(:hello).and_return(1,2,3)
5.times.map { y.hello }
# => [1, 2, 3, 3, 3]
```

Use `instance_double` to easily restrict message mocks to the class' methods' signature.

```rb
x = double("dummy")
allow(x).to receive(:next)
y = instance_double("Integer", "not dummy")
allow(y).to receive(:next)

x.next(0)
# => nil
y.next(0)
# => ArgumentError: Wrong number of arguments. Expected 0, got 1.
```

Similarly, `class_double` matches class method signatures.

`object_double` matches signatures to a given object

```rb
x = object_double({a: 1, b: 2}, "my hash")
allow(x).to receive(:to_a)
x.to_a(1)
# => ArgumentError: Wrong number of arguments. Expected 0, got 1
```

An rspec `spy` is the same as an rspec `double`, but it allows any messages to be passed.

```rb
x = spy("x")
x.hello
# error is not raise
expect(x).to have_received(:hello)
# => true
```

This is the same as using a `double` with the `as_null_object` method:

```rb
x = double("x").as_null_object
```

## Verifying messages on spies

Use `expect(...).to have_received` to verify that a method was called.

```rb
x = double; allow(x).to receive(:hello)
x.hello
expect(x).to have_received(:hello)
```

Set constraints on the number of times a method is expected to be called with `exactly`, `at_least` and `at_most`

```rb
x = double; allow(x).to receive(:hello)
3.times { x.hello }
expect(x).to have_received(:hello).exactly(3).times
expect(x).to have_received(:hello).at_least(1).times
expect(x).to have_received(:hello).at_most(10).times
```

Set constraints on arguments using `with`

```rb
x = double; allow(x).to receive(:hello)
3.times { x.hello }
expect(x).to have_received(:hello).at_least(1).times.with(no_args)
x.hello("there")
expect(x).to have_received(:hello).with("there")
expect(x).to have_received(:hello).with(/th/)
```

For more types of argument matchers, see [this table](https://relishapp.com/rspec/rspec-mocks/v/3-2/docs/setting-constraints/matching-arguments)
