FROM python:3.7.17-slim-bullseye as python-base

FROM python-base AS python-pip
RUN python -m pip install pip

FROM python-pip AS python-setup
COPY ./requirements.txt ./requirements.txt
RUN /usr/local/bin/python -m pip install --user --upgrade pip setuptools wheel

FROM python-setup AS python-install
RUN /usr/local/bin/python -m pip install --user -r ./requirements.txt
