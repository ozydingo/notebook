FROM alpine
WORKDIR app
RUN --mount=type=secret,id=credentials cat /run/secrets/credentials > ./oops.txt
