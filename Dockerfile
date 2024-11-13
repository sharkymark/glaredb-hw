# Define the argument before its first use
FROM python:3.9-slim

# get utilities in the container
RUN apt-get update && apt-get install -y build-essential curl ssh git net-tools htop

# Install Rust and Cargo
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.80.1 --no-modify-path

# Set the PATH environment variable to include Rust's bin directory
ENV PATH="$PATH:/root/.cargo/bin"

# Install pip dependencies
RUN pip install --no-cache-dir --upgrade pip && pip install pandas jupyterlab