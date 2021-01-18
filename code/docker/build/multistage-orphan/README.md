```
ducker build -t temp .
```

Builds all stages. `second` remains unused.

```
docker build -t temp --target second .
```

Builds all stages up to `second`. `first` remains unused, final build stage is not executed.
