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

This can be applied to function arguments. However, if no arg is passed we can get an error:

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

The solution is a little cryptic but can be understood; add a default empty-object value to the argument.

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
