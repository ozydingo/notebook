# build with:
# `docker build --build-arg FILE=./hello.txt -t test .`

FROM ubuntu:latest
WORKDIR /app
ARG FILE=~/.bashrc
COPY ${FILE} .
