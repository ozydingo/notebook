# FROM ubuntu:20.04
FROM ruby:2.7.7

RUN apt-get update && apt-get install sudo build-essential

RUN useradd --create-home --shell /bin/bash runner --groups sudo && \
  echo "runner:password" | chpasswd

RUN echo "runner ALL=(ALL) NOPASSWD: /usr/bin/apt-get update,/usr/bin/apt-get install dnsutils,/usr/bin/apt-get * install dnsutils" >> /etc/sudoers.d/runner && \
    chmod 0440 /etc/sudoers.d/runner
# RUN echo "runner ALL=(ALL) NOPASSWD: /usr/bin/apt-get *" >> /etc/sudoers.d/runner && \
#     chmod 0440 /etc/sudoers.d/runner

USER runner
WORKDIR /home/runner

COPY ./install.sh /home/runner/install.sh
COPY ./Makefile /home/runner/Makefile

CMD ["make", "install"]
# CMD ["/home/runner/install.sh"]
