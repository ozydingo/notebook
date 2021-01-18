**Buildkit required!!**

```sh
DOCKER_BUILDKIT=1 docker build --ssh default -t test .
docker run test ls private
# => README.md
```
