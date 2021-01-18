```sh
docker build -t test . && docker run test ls
# => build1-artifact.txt
```

```sh
docker build -t test --target=build1 . && docker run test ls
# => artifact.txt
#    work.log
```
