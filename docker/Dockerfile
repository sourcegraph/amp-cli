FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV AMP_VERSION=1.0.0

# Update package list and install required packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install amp using the official install script
RUN curl -fsSL https://raw.githubusercontent.com/sourcegraph/amp-cli/main/install.sh | bash

# Create a non-root user
RUN useradd -m -s /bin/bash ampuser

# Switch to non-root user
USER ampuser
WORKDIR /home/ampuser

# Verify installation
RUN amp --help

# Default command
CMD ["amp", "--help"]
