# Amp CLI Docker Image

This directory contains a Docker image that installs the Amp CLI on Ubuntu.

## Building the Image

```bash
docker build -t amp-cli docker/
```

## Running the Container

```bash
# Show help
docker run --rm amp-cli

# Run amp with specific commands
docker run --rm amp-cli amp --version

# Run interactively
docker run --rm -it amp-cli bash
```

## Image Details

- **Base Image**: `ubuntu:latest`
- **Amp Installation**: Uses the official install script from the repository
- **User**: Runs as non-root user `ampuser` for security
- **Default Command**: Shows amp help

## Usage Examples

```bash
# Build the image
docker build -t amp-cli docker/

# Run amp commands
docker run --rm amp-cli amp --help
docker run --rm amp-cli amp --version

# Interactive shell with amp available
docker run --rm -it amp-cli bash
```
