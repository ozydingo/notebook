```sh
echo 1 > source; (docker build --no-cache -t temp . && echo "Build complete") & sleep 2 && echo 2 > source && echo "source updated"
docker run temp
```

Result:

```
1
```

Conclusion: once docker context is sent, changes to local disk do not matter.
