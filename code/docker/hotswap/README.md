# Hotswap

Test what happens if you are running a container based off of an image tag and the image tag gets updated

## Test 1: Local

### Setup

```
docker build -t docker-hotswap -f Dockerfile-1 .
docker run docker-hotswap &
docker build -t docker-hotswap -f Dockerfile-2 .
docker run docker-hotswap &
```

### Result

```
Round 27
1
Round 2
2
Round 28
1
Round 3
2
```

Conclusion: runing containers are not affected
