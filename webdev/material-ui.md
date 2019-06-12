## withStyles

```js
import { withStyles } from '@material-ui/core/styles';

// can also be a function that takes theme as arg
const styles = {
  redThing: {
    color: 'red'
  }
}

function MyComponent() {
  const { classes } = this.props;
  return (
    <div className={this.classes.redThing}></div>
  )
}

export default withStyles(styles)(MyComponent);
```

`classes` can be overridden by parents passing in a `classes` prop explicitly. Both `classes` objects are merged, and conflicting keys favor the parent.

Here, the `redThing` in the rendered `MyComponent` will have `{color: red, fontSize: 2em}`. If `ParentComponent`

```js
const styles = {
  redThing: {
    fontSize: '2em'
  }
}

function ParentComponent() {
  const { classes } = this.props;
  return (
    <div>
      <MyComponent classes = {classes} />
    </div>
  )
}
```

Make a theme available to use in classes:

```js
import { withTheme } from '@material-ui/core/styles';

const styles = (theme) => ({
  redThing: {
    color: theme.palette.error.main
  }
})

function MyComponent() {
  const { classes } = this.props;
  return (
    <div className={this.classes.redThing}></div>
  )
}

export default withStyles(styles)(MyComponent);
```

There's also `withTheme` but it doesn't seem to be necessary if using `withStyles`. Perhaps it's useful if you're not using `withStyles` but still need the theme for its data.

```js
import { withStyles } from '@material-ui/core/styles';

...

export default withTheme()(MyComponent);

```
