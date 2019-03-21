## withStyles

```js
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
