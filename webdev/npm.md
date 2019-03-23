# NPM

## NPM scripts

https://medium.freecodecamp.org/introduction-to-npm-scripts-1dbb2ae01633

`scripts` field in `package.json` (same level as `dependencies`)

e.g.

```
"scripts": {
    "say-hello": "echo 'Hello, world!'",
    ...
}
```

Run by `npm run say-hello` or `npm run-script say-hello`

Some script names are special:

```
"scripts": {
    "start": "node index.js",
    ...
}
```

Run simply by `npm start`

Get cross-platform script support by doing it in js:

```
"scripts": {
  ...
  "doit": "node doit_in_js.js"
  ...
}
```

 Note you can pass args into `npm run`, accessed in js via `process.argv`

 Add `pre` or `post` to a script name in `package.json` to have scripts that will automatically run before or after the named script.

 ```
 "scripts": {
    "say-hello": "echo 'Hello World'",
    "presay-hello": "echo 'I run before say-hello'",
    "postsay-hello": "echo 'I run after say-hello'"
}
```

More: https://css-tricks.com/why-npm-scripts/ -- linting, minifying, building, cleaning, etc

## Binaries

When installing a dependency with an executable binary, e.g. `npm i -D eslint`, you can run it in `./node_modules/.bin/eslint` or `npx eslint`. If run from an npm-script, this is unecessary;l you can simply use

```
"scripts": {
  "lint": "eslint src/js"
}
```
