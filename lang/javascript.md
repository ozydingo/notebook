## Exports

### Name exports

lib.js

```js
export const sqrt = Math.sqrt;
export function square(x) {
    return x * x;
}
export function diag(x, y) {
    return sqrt(square(x) + square(y));
}
```

main.js

```js
import { square, diag } from 'lib';
console.log(square(11)); // 121
console.log(diag(4, 3)); // 5
```

of

```js
import * as lib from 'lib';
console.log(lib.square(11)); // 121
console.log(lib.diag(4, 3)); // 5
```

### Default exports

//------ myFunc.js ------

```js
export default function () { ... };
```

//------ main1.js ------

```js
import myFunc from 'myFunc';
myFunc();
```

### Mixed

//------ underscore.js ------

```js
export default function (obj) {
    ...
};
export function each(obj, iterator, context) {
    ...
}
export { each as forEach };
```

//------ main.js ------

```js
import _, { each } from 'underscore';
```

## Promises

```js
function getOrCreateThing() {
  return new Promise(function(resolve, reject) {
    getThingAsync(function(err, data) {
      if (data) return resolve(data);
      createThingAsync(settings, function(err, data) {
        if (errO0 return reject(err));
        getThingAsync(function(err, data) {
          return err ? reject(err) : resolve(data);
        })
      })
    })
  })
}
```

Promise states:

* Fulfilled
* Rejected
* Pending
* Settled -- Fulfilled or Rejected

Basic usage:

```js
var promise = new Promise(function(resolve, reject) {
  // do a thing, possibly async, then…

  if (/* everything turned out fine */) {
    resolve("Stuff worked!");
  }
  else {
    reject(Error("It broke"));
  }
});

promise.then(function(result) {
  console.log(result); // "Stuff worked!"
}, function(err) {
  console.log(err); // Error: "It broke"
});
```

The `reject` and `resolve` functions are the keys to transitioning the promise into the next state / callback.

Chaining methods that take a single value (i.e., `result`) and transform it can be shortcutted, because the syntax works out:

```js
promise.then(JSON.parse).then(function(parsed_result){...})
```

If the return value of `then` is a value, the function passed to `then` is called with it. If the return value is promise-like, the function passed to `then` will wait on that returns value to "settle" and be called with the result once it does.

```js
promise.then(function(x){ return new Promise(...); }).then(function(settledValue){...})
```

You can handle errors uusing

```js
promise.then(successFn, errorFn)
```

or

```js
promise.then(successFn).catch(errorFn)
```

These are almost the same; the `errorFn` arg in `then` is optional, and `catch(errorFn)` is just an alias for `then(undefined, errorFn)`. Note, however, that in the latter case the catch will be called if the success function fails, while with `then(func1, func2)`, only one of `func1` and `func2` will be called.

Simple wait-for-something loop

```js
let x = {}

wait = function(x) {
  return new Promise((resolve, reject) => {
    let check = function(x) {
      if ( x.value ) {
        console.log("Resolving value: ", x);
        resolve(x.value);
      }
      else {
        console.log("Still waiting: ", x);
        setTimeout(() => check(x), 1000);
      }      
    }
    check(x);
  });
}
```

Let's make a waitFor function:

```js
waitFor = function(isReady, getValue) {
  return new Promise((resolve, reject) => {
    let check = function() {
      if (isReady()) {
        resolve(getValue());
      } else {
        setTimeout(check, 1000);
      }
    }
    check();
  })
}

let x = {}
waitFor(() => x.ready, () => x.value ).then((val) => console.log("Got ", val));
x.value = 42;
setTimeout(() => x.ready = true, 2000);
```

Cool.

## Async / Await

`async f() {...}` => f is guaranteed to return a promise. Javascript will make sure of it.

```js
(async function f(){ return 1; })()
//=> Promise {<resolved>: 1}
```

`await p` can only be used inside an `async` function, and causes Javascript to wait until the Promise `p` settles.

```js
waitFor = function(isReady, getValue) {
  return new Promise((resolve, reject) => {
    let check = function() {
      if (isReady()) {
        resolve(getValue());
      } else {
        setTimeout(check, 1000);
      }
    }
    check();
  })
}

let x = {}
(async () => {
  let value = await waitFor(() => x.ready, () => x.value )
  console.log("Got ", value);
})()

x.value = 42;
setTimeout(() => x.ready = true, 2000);
```

## Destructuring

Variable assignment through object destructuring, which supports renaming and default values:

```
const obj = {a: 1, b: 2, c: 3};
let {a, b} = obj;
// a == 1, b == 2
let {a: variableA} = obj;
// variableA == 1
let {c = 30} = obj;
// c == 3
let {x: variableX = 10} = obj;
// variableX == 10
```

Nested destructuring will set only the inner values:

```
> {a: {x, y}} = {a: {x: 2, y: 3, z: 4}, b: 2}
{ a: { x: 2, y: 3, z: 4 }, b: 2 }
> a
Thrown:
ReferenceError: a is not defined
> x
2
> y
3
>
```

Default values can be applied at any level, thought the syntax is a little cryptic:

```
> {a: {x, y} = {}, c = 10} = {b: 2}
{ b: 2 }
> a
Thrown:
ReferenceError: a is not defined
> b
Thrown:
ReferenceError: b is not defined
> x
undefined
> y
undefined
> c
10
```

Using nested destructuring without the matching shape will result in an error:

```
> {a: {x, y}} = {b: 2}
Thrown:
TypeError: Cannot destructure property `x` of 'undefined' or 'null'.
```

Use default values if this is a possibility.

Function arguments can follow the same syntax. Like nested destructuring, this will result in an error if no or incorrectly shaped args were passed to the function.

```
function foo({a: varA = 30}){console.log(varA)}
foo(1)
// 30
foo({a: 2})
// 2
> foo({})
// 30
> foo()
// Thrown:
// TypeError: Cannot destructure property `a` of 'undefined' or 'null'.
//    at foo (repl:1:13)
```

Just like before, use default args if this might happen.

```
function foo({a: varA = 30} = {}){console.log(varA)}
> foo()
// 30
```

Array destructuring works as you'd expect:

```
a = [1,2,3];
[x, y] = a;
x
// 1
y
// 2
```

The spread operator can be applied in both array and object desatructuring

```
obj1 = {a: 1, b: 2};
{a: 2, ...obj1}
// { a: 3, b: 2 }

> a = [1,2,3]
[ 1, 2, 3 ]
> [...a, 4, 5]
[ 1, 2, 3, 4, 5 ]
```

However spread assignment appears to only work for arrays:

```
a = [1,2,3];
[x, ...z] = a;
x
// 1
z
// [2, 3]

obj1 = {a: 1, b: 2, c: 3}
{a, ...obj2} = obj1;
// Error!
```

You can of course just use `obj1` in this case.

## Tagged template literals

```
function tag(strings, ...rest){
  console.log("string: ", strings)
  console.log("rest", rest)
}

tag`hello${1} and goodbye ${2}`
//=> string:  [ 'hello', ' and goodbye ', '' ]
//=> rest [ 1, 2 ]
```

Default tagging function is concatenation, hence the main usages as string interpolation.

A tagging function is a regular function an need not return a string.

## This

Summary of https://www.youtube.com/watch?v=eWDXgsIgTGk

0. The "default binding", or the default `this` value, is the `window` (browser) or `global` (node) object.

1. Inside a function, `this` is the calling context. For a bare function, that's the window or global object, for a constructor, that's the object being constructed.

```js
function() F { return this; };
F()
// => Object [global] {...}
new F()
// =>  F {}
```

2. Binding with `bind`, `call`, `apply` sets the value of `this` to the argumnet.

```js
function() F { return this; };
F.call(17)
// => [Number: 17]
F.apply(17)
// => [Number: 17]
F.bind(17)()
// => [Number: 17]
```

3. Implicit binding: `this` depends on the calling context. When a function is called as a member of an object, that object is the context. However, the same function stored as a different variable has a different context.

```js
let obj = {
  name: "me",
  f() { return this; }
}
obj.f() // context is `obj`
// => { name: 'me', f: [Function: f] }
let g = obj.f
g() // context is global
// => Object [global] {...}
let h = {
  j: obj.f
}
h.j() // context is `h` even though `this` was written in `obj`.
// => { j: [Function: f] }
```

This can be confusing in callback / promise land, but it boils down to the same rules as above.
```js
let k = {
  showThis() { console.log(this); },
  deferThis() {
    const p = new Promise((r, j) => r());
    p.then(this.showThis)
  },
}
k.showThis() // context is k
// (output) => { showThis: [Function: showThis], deferThis: [Function: deferThis] }
k.deferThis() // context of `this` inside the callback is global, as the callback function is passed as an arg to another context.
// (output) => Object [global] {...}
```

4. use strict -- no default global / window binding: throws error if no context / binding.

5. Arrow functions: use "lexical scope", aka what every other variable uses. "Where the function was written". Ignores explicit binding.

```js
let obj = {
  name: "arrow",
  f: () => { return this; }
}
obj.f()
// Object [global] {...}
obj.f.call(1)
// Object [global] {...}

let withContext = function() {
  return () => { return this; };
}
withContext.call(17)() // context inside `withContext` is made to be 17
// [Number: 17]
```

This is often why arrow functions are preferred for readability of `this` in async js.

```js
let k = {
  showThis() { console.log(this); },
  deferThis() {
    const p = new Promise((r, j) => r());
    p.then(this.showThis)
  },
  arrowThis() {
    const p = new Promise((r, j) => r());
    p.then(() => this.showThis())
  }
}

k.showThis() // context is k
// {
//   showThis: [Function: showThis],
//   deferThis: [Function: deferThis],
//   arrowThis: [Function: arrowThis]
// }
k.deferThis() // context of `this` inside the callback is global
// (output) => Object [global] {...}
k.arrowThis() // context is k because arrow functions.
// {
//   showThis: [Function: showThis],
//   deferThis: [Function: deferThis],
//   arrowThis: [Function: arrowThis]
// }
```

6. Event listeners: `this` is `event.currentTarget`

### Classes are just functions:

```js
class C {
  constructor() {
    this.f = function() { return this; }
    this.g = () => { return this; }
  }

  h() { return this; }
}
```

* `this` will typically be the object

```js
(new C()).f()
// C { f: [Function], g: [Function] }
(new C()).g()
// C { f: [Function], g: [Function] }
(new C()).h()
// C { f: [Function], g: [Function] }
```

* When functions are reassigned, contexts change. Arrow functions don't care.

```js
let f = (new C()).f
let g = (new C()).g
let h = (new C()).h

f()
// undefined
g()
// C { f: [Function], g: [Function] }
h()
// undefined

f.call(17)
// 17
g.call(17)
// C { f: [Function], g: [Function] }
h.call(17)
// 17
```
