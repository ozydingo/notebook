**Buildkit required!!**

```sh
DOCKER_BUILDKIT=1 docker build --secret id=credentials,src=secret.yaml -t test .
```

```sh
docker run test cat oops.txt
# => username: bosco
#    password: swordfish
docker run test ls /run/secrets
# => (no output)
```
