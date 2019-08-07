FROM python:3.6
MAINTAINER XenonStack

# Creating Application Source Code Directory
RUN mkdir -p /kube/src

# Setting Home Directory for containers
WORKDIR /kube/src

# Installing python dependencies
COPY requirements.txt /kube/src
RUN pip install --no-cache-dir -r requirements.txt

# Copying src code to Container
COPY . /kube/src/app

# Application Environment variables
ENV APP_ENV development

# Exposing Ports
EXPOSE 5035

# Setting Persistent data
VOLUME ["/app-data"]

# Running Python Application
CMD ["python", "app.py"]
