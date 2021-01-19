FROM ruby:2.6 as cpan
RUN apt-get update && apt-get -y upgrade
# RUN apt-get upgrade -y perl
ENV PERL_MM_USE_DEFAULT=1
RUN cpan JSON

FROM ruby:2.6
# ENV PERLLIB=/usr/local/lib/x86_64-linux-gnu/perl/5.26.1/
RUN mkdir /usr/local/share/perl/
RUN echo hi > /usr/local/share/perl/hello
COPY --from=cpan /usr/local /usr/local
