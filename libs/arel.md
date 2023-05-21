# Arel in Ruby

[Some else's Cheat Sheet](https://gist.github.com/ProGM/c6df08da14708dcc28b5ca325df37ceb)

## Basics

### Database constructs

|               |                         |
| ------------- | ----------------------- |
| Table         | `Arel::Table.new(name)` |
| Table (Rails) | `MyModel.arel_table`    |
| Field         | `table[name]`           |
| Function      | `field.function`        |

Example: `Arel::Table.new("posts")["likes"].sum.as("foo")`

### Literals

|         |                                   |
| ------- | --------------------------------- |
| `*`     | `Arel.star`                       |
| `'foo'` | `Arel::Nodes.build_quoted('foo')` |

### Select

```rb
posts = Arel::Table.new("posts")
posts.project("title", "author_id")
posts.project(posts["title"], posts["author_id"])
```

### Conditions

```rb
posts = Arel::Table.new("posts")
posts[:author_id].eq(3).and(posts[:type].in(['comment', 'response']))
```

### Joins

```rb
posts = Arel::Table.new("posts")
comments = Arel::Table.new("comments")
posts.join(comments, Arel::Nodes::OuterJoin).on(posts[:id].eq(comments[:post_id]))
```
