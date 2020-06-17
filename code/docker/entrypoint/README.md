```
docker build --rm -t cmd  -f Dockerfile-cmd .
docker build --rm -t entrypoiny  -f Dockerfile-entrypoiny .

docker run entrypoint echo 1
> hello, world echo 1
docker run cmd echo 1
> 1
```
