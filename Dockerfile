# Define the argument before its first use
FROM python:3.9-slim

# get utilities in the container
RUN apt-get update && apt-get install -y curl ssh git net-tools htop

RUN curl -sSL https://glaredb.com/install.sh | sh

# Install pip dependencies
RUN pip install --no-cache-dir --upgrade pip && pip install pandas jupyterlab