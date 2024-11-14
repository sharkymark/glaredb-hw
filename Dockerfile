# Define the argument before its first use
FROM --platform=linux/amd64 python:3.9-slim

# get utilities in the container
RUN apt-get update && apt-get install -y build-essential curl ssh git net-tools htop

# Install pip dependencies
RUN pip install --no-cache-dir --upgrade pip && pip install pandas jupyterlab