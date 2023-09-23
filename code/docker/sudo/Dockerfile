FROM ubuntu:20.04
# FROM ruby:2.7.7

RUN apt-get update && apt-get install sudo build-essential

RUN useradd --create-home --shell /bin/bash runner --groups sudo && \
  echo "runner:password" | chpasswd

RUN echo "runner ALL=(root) NOPASSWD: /usr/bin/apt-get update,/usr/bin/apt-get install curl" >> /etc/sudoers.d/runner && \
    chmod 0440 /etc/sudoers.d/runner

USER runner
WORKDIR /home/runner

COPY ./install.sh /home/runner/install.sh
COPY ./Makefile /home/runner/Makefile

CMD ["make", "install"]
