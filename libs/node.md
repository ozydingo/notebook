# Node.js cheatsheet

## The Event Loop

* Timers - execute timers that are past their threshold
* Pending callbacks - system operations
* Poll - check the poll queue for a computed period of time.
 * New poll events can be added to the queue while the event loop is in the poll phase. Watch out for resource-hogging operations!
 * If queue is empty, looks for `setImmediate()` calls to execute.
 * If queue empty and timers have elapsed, loop back to timer phase
* Check - `setImmediate()`
* Close Callbacks

`process.nextTick(callback)` execute `callback` immediately after current phase. Dangerous.

Keep request response work light. Don't block the event loop, or DDOS is easy.

Start the server:

```javascript
const http = require('http');

const server = http.createServer((request, response) => {
  // magic happens here!
});
```

same as

```javascript
const http = require('http');

const server = http.createServer();
server.on('request', (request, response) => {
  // the same kind of magic happens here!
});
```

Extract useful info from the request

```javascript
const { method, url } = request;
const { headers } = request;  // rawHeaders is also available
const userAgent = headers['user-agent'];
```

Read the request body (stream)
```javascript
let body = [];
request.on('data', (chunk) => {
  body.push(chunk);
}).on('end', () => {
  body = Buffer.concat(body).toString();
  // at this point, `body` has the entire request body stored in it as a string
});
```

Register an error event listner. The error event is a special Node event that will `throw` if not attended.

```js
request.on('error', (err) => {
  // This prints the error message and stack trace to `stderr`.
  console.error(err.stack);
});
```

`response` is an element of `ServerResponse` < `WritableStream`

```js
response.statusCode = 404   // (default 200)
response.setHeader('Content-Type', 'application/json');
response.setHeader('X-Powered-By', 'bacon');
response.write('<html>');
response.write('<body>');
response.write('<h1>Hello, World!</h1>');
response.write('</body>');
response.write('</html>');
response.end();   // can pass final data to write as arg
```
