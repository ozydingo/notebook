FROM alpine as build1
WORKDIR /build

# Do something that produces leftover state
RUN for a in {1..10}; do echo $a >> ./work.log; done
RUN wc -l work.log > artifact.txt

FROM alpine
WORKDIR /app
COPY --from=build1 /build/artifact.txt ./build1-artifact.txt
