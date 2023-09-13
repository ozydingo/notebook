Q: Can you copy a file from layer FOO to layer BAR and keep a fully cached build if BAR has changed, but the item copied has not?

To test, see Dockerfile.

Answer: yes

```
=> CACHED [final 3/4] COPY --from=base /test/foo.txt .
=> [final 4/4] COPY --from=base /test/bar.txt .
```
