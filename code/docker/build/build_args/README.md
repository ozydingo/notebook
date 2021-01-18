Build args:

```sh
docker build --build-arg x=X --build-arg y=Y -t test . && docker run test cat args.txt
# => x: X, y: Y
```

Default build arg values

```sh
docker build -t test . && docker run test cat args.txt
# => x: , y: 2
```

ENV build arg values

```sh
x=1 docker build -t test --build-arg x . && docker run test cat args.txt
# => x: 1, y: 2
```
