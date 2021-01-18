```sh
docker build -t ext -f Dockerfile-ext .
docker build -t test .
docker run test ls
# => file.txt
```
