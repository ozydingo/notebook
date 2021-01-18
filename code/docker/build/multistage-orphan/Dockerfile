FROM alpine as first
WORKDIR /app
RUN echo "foo" >> words.txt

FROM alpine as second
WORKDIR /app
RUN echo "bar" >> words.txt

FROM first
RUN echo "baz" >> words.txt
