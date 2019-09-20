# Use an official Python runtime as a parent image
FROM python:3.7-slim

# Set the working directory to /work
WORKDIR /work

# Copy the current directory contents into the container at /work
COPY ./src /work

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Define environment variable
ENV NAME worker

# Run app.py when the container launches
CMD ["rq", "worker"]
