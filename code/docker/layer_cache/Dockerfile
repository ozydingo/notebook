FROM ubuntu:20.04 as base

WORKDIR /test

RUN echo foo > foo.txt
RUN echo bar2 > bar.txt

FROM ubuntu:20.04 as final

WORKDIR /test

COPY --from=base /test/foo.txt .
# Q: does cache bust here if something other than base:foo.txt changes?
COPY --from=base /test/bar.txt .
