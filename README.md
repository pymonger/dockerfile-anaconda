dockerfile-anaconda
-------------------

```
docker build --rm --force-rm -t scispark/anaconda:v0.1_000 \
-f Dockerfile --build-arg id=$ID --build-arg gid=`id -g` .
```
