FROM ubuntu:latest@sha256:a08e551cb33850e4740772b38217fc1796a66da2506d312abe51acda354ff061

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install required packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Install amp binary directly
ARG AMP_VERSION=0.0.1753952694-g23a9cc
ARG AMP_ARCH=x64
RUN curl -fsSL -o /usr/local/bin/amp "https://packages.ampcode.com/binaries/cli/v${AMP_VERSION}/amp-linux-${AMP_ARCH}" \
    && chmod +x /usr/local/bin/amp

# Create a non-root user
RUN useradd -m -s /bin/bash amp

# Switch to non-root user
USER amp
WORKDIR /home/amp

# Verify installation
RUN amp --help

# Default command
CMD ["amp", "--help"]
