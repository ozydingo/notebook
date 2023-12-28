```shell
docker buildx build --platform linux/amd64 --tag ${ECR_NAME}:latest --push .
```

Per JE: the `--push` is necessary as docker seems to discard any architecture-specifics if not pushed immediately. Worth re-verifying.
