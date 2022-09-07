# Typescript

## Primitives

- boolean
- bigint
- null
- number
- string
- symbol
- undefined
- any
- unknown

## Declaring types: basics

### Variables

```ts
const x: string = 'hello';
const user: User = {...} // custom type `User`
```

### Function args

```ts
// function name(arg: arg_type): return_type { body }
function foo(x: string, y: number): boolean {...}
```

In destructured args

```ts
function foo({ x, y, z }: { x: numbner; y: string; x: boolean }) {}
```

It can be convenience to name the type

```ts
type XYZ = { x: numbner; y: string; x: boolean };
function foo({ x, y, z }: XYZ) {}
```

### Classes

```ts
class UserAccount {
  name: string
  id: number

  constructor(name: string, id: number){...}
}
```

### Functions

```ts
function act(callback: (id: number) => boolean) {
  console.log("acting");
  return callback(1);
}
```

The type declaration `(id: number) => boolean` means `callback` is a function that takes `id: number` and returns a `boolean`. (TS therefore also infers that `act` returns a boolean.)

## Defining types

### Inference

```ts
const x = "hello"; // type of x is inferred as string
```

### Interfaces

```ts
interface User {
  name: string;
  readonly id: number;
  [wildcardField: string]: string;
}
```

### Literals

```ts
type Foo = "foo";
```

### Tuples

```ts
type TimedWord = [number, string];
```

### Unions

```ts
type Foo = string | string[];
type Bar = "foo" | "bar";
type Baz = "foo" | number;
```

### Generics

Generics parameterize types:

```ts
type StringArray = Array<string>;
type RegionArray = Array<{ startTime: number; endTime: number }>;
```

Generics get very powerful when declaring your own flexible types for use by others

```ts
interface RenderKey<T> {
  value: <T>
}

const numericKey: RenderKey<number> = { value: 123 };
const stringKey: RenderKey<string> = { value: "123" };
```

And flexibly typing functions:

```ts
function first<Type>(items: Type[]): Type | undefined {
  return items[0];
}
```

## Declaring types: intermediate

### Implicit casting

Values passed to functions can be implicitly cast if they meet all requirements. You cannot declare a const literal that has extra data though.

```ts
interface X {
  id: number;
}

function useX(x: X) {
  console.log(x.id);
}

const x: X = { id: 1 }; // ok
const y: X = { id: 1, name: "y" }; // error: not an X
const y2 = { id: 1, name: "y" }; // sure
const z = { name: "z" }; // sure

// declare a function that takes an `X`
function useX(x: X) {
  console.log(x.id);
}

useX(x); // ok
useX(y2); // ok -- y can be used as an X
useX(z); // no ok
// -> can't declare const literal with unknown fields
```

### Optionals

```ts
function foo(bar: { id: number; name?: string });

foo({ id: 1 }); // ok
foo({ id: 2, name: "foo" }); // ok
```

### Narrowing

```ts
// Error: `.toLowerCase` is not callable on `number`
function foo(x: string | number) {
  console.log(x.toLowerCase());
}
```

```ts
// Ok: type has been narrowed
function foo(x: string | number) {
  if (typeof x === "string") {
    console.log(x.toLowerCase());
  }
}
```

You can help ts narrow using type predicates

```ts
interface Fish {
  swim: () => void;
}
interface Duck {
  quack: () => void;
}

function isDuck(thing: Duck | Fish): thing is Duck {
  return (thing as Duck).quack !== undefined;
}

const duck: Duck = { quack: () => {} };

if (isDuck(duck)) {
  // ts knows duck is a Duck
} else {
  // ts knows duck is not a Duck
}
```

### Narrowing with discriminated unions

Use a discrimiating key -- a shared key with literal definitions across all entries in a union -- to allow ts to narrow types in a union.

```ts
interface Client {
  type: "client";
  projectId: number;
}

interface Admin {
  type: "admin";
  scope: string;
}

type User = Client | Admin;

function info(user: User) {
  if (user.type === "client") {
    user.projectId;
    // ts knows user is a Client
  } else {
    user.scope;
    // ts knows user is an Admin
  }
}
```

Check for exhaustive cases using `never`. TS will error if it detects that an assignment to a `never` type is reachable.

```ts
type Foo = "foo" | "bar";

function foo(x: Foo) {
  switch (x) {
    case "foo":
      return "foo";
    case "bar":
      return "bar";
    default:
      // this line will cause a ts error if
      // Foo gets additional options added later
      const _never: never = x;
  }
}
```

### Assertions

If ts can't infer a type that you know, you can provide hints.

```ts
const x = getFoo() as string;
```

A cheat if ts isn't cooperating:

```ts
const (x as any) as MyType
```

Use assettions to conform to strictly typed methods

```ts
const foo = { foo: "foo" };
function bar(x: { foo: "foo" | "bar" }) {}

bar(foo); // error
// foo is inferred as type `string`; its value might change so it cannot be inferred as a literal
```

To solve, use assertion:

```ts
const foo = { foo: "foo" as "foo" };
function bar(x: { foo: "foo" | "bar" }) {}

bar(foo); // ok
```

Or declare const

```ts
const foo = { foo: "foo" } as const;
function bar(x: { foo: "foo" | "bar" }) {}

bar(foo); // ok
```

## Defining types: intermediate

### Extending an interface

```ts
interface IdRecord {
  id: number;
}

interface NamedRecord extends IdRecord {
  name: string;
}

const namedRecord: NamedRecord = { id: 1, name: "foo" };
```

### Type intersections

```ts
type IdRecord = {
  id: number;
};

type NamedRecord = IdRecord & {
  name: string;
};
```
