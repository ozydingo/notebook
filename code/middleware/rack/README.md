## What is this

An exploration of pure Rack

## config.ru

Key methods:

* `run` -- takes an object that responds to `call` and returns a valid Rack response
  * This can be an array [code, headers, body], or a Rack::Response object
* `map` -- takes a string specifying a route and a block with a call to `run`
* `use` -- add middleware to the stack

With `config.ru` set up, run `rackup`, and you're in business.

You can also wrap multiple `run`, `map`, and `use` calls in a block using `app = Rack::Builder.new { ... }``

### Middleware

Add middleware to the stack by calling `use`. Middleware are rack apps; they must respond to `call`. They are initialized with an argument typically called `app`. This argument is another rack app that is next in the stack. To pass the request through, use `app.call(env)`. You can cause additional arguments to be passed into `initialize` by adding them after the app class in your `use` call.

```rb
use MyMiddleware, arg1, arg2, ...
```

Middlware can:

* Block: Ignore `app` and return [code, headers, body]
* Pass-through: Pass the request through to `app` and return that return value
* Modify: Pass the request through to `app` and modify the response before returning it.

## environment

At minimum a Hash, but can also be a `Rack::Request` object.

Includes, among other data:

* `REQUEST_METHOD`: The HTTP verb of the request. This is required.
* `PATH_INFO`: The request URL path, relative to the root of the application.
* `QUERY_STRING`: Anything that followed ? in the request URL string.
* `SERVER_NAME` and `SERVER_PORT`: The server’s address and port.
* `rack.version`: The rack version in use.
* `rack.url_scheme`: Is it http or https?
* `rack.input`: An IO-like object that contains the raw HTTP POST data.
* `rack.errors`: An object that response to puts, write, and flush.
* `rack.session`: A key value store for storing request session data.
* `rack.logger`: An object that can log interfaces. It should implement info, debug, warn, error, and fatal methods.
