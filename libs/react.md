# React

## Prelude: adding React to a(n existing) webpage

From [here](https://reactjs.org/docs/add-react-to-a-website.html). Start by adding a single React component to the existing website: import the scripts (in the `<body>` it would seem), and create a `div` with id that gets targeted by the first react js file.

```html
    <div id="react-dashboard"></div>
    ...
    <script src="https://unpkg.com/react@16/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@16/umd/react-dom.development.js" crossorigin></script>
    <script src="js/react/react-dashboard.js"></script>
```

where `js/react/react-dashboard.js` contains

```js
'use strict';

const e = React.createElement;

class LikeButton extends React.Component {
  constructor(props) {
    super(props);
    ...
  }
  ...
  render() {...}
}

const domContainer = document.querySelector('#react-dashboard');
ReactDOM.render(e(LikeButton), domContainer);
```

> Tip: [minify your javascript](https://gist.github.com/gaearon/42a2ffa41b8319948f9be4076286e1f3)

## Using JSX

For developemtn / demos, you can

* Load babel: `<script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>`
* Add `type="text/babel"` to a `<script>` tag that uses JSX.

This is slow. For production:

* `npm install babel-cli@6 babel-preset-react-app@3`
* `npx babel --watch $SOURCE_DIR --out-dir $OUT_DIR --presets react-app/prod`
* To to a one-time build, omit `--watch`

This last command will watch for js files recursively in `$SOURCE_DIR` and compile them into a parallel structure into `$OUT_DIR`. E.g. use `src`, `.` to build files from `src` right into the root.
