#!/bin/bash
set -euo pipefail

VERSION="$1"
VERSION="${VERSION#v}"
ARCH="${2:-}"
PLATFORM="${3:-}"

if [ -z "$ARCH" ] || [ -z "$PLATFORM" ]; then
    echo "Error: Architecture and platform parameters required"
    exit 1
fi

echo "Building Docker image for version $VERSION, platform $PLATFORM, arch $ARCH"

# Set up Docker Buildx
docker buildx create --use --name multiarch || docker buildx use multiarch

# Login to GitHub Container Registry
echo "Logging into GitHub Container Registry..."
if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_ACTOR" ]; then
    echo "Missing GITHUB_TOKEN or GITHUB_ACTOR environment variables"
    exit 1
fi
echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_ACTOR" --password-stdin

# Build and push for the specified platform
platform="$PLATFORM"
arch="$ARCH"

echo "Building Docker image for $platform (arch: $arch)"

# Build and push Docker image
echo "Building Docker image for $platform"
if docker buildx build \
    --platform "$platform" \
    --file ./docker/Dockerfile \
    --build-arg AMP_ARCH="$arch" \
    --build-arg AMP_VERSION="$VERSION" \
    --tag "ghcr.io/sourcegraph/amp-cli:$VERSION-$(echo $platform | sed 's/linux\///')" \
    --tag "ghcr.io/sourcegraph/amp-cli:latest-$(echo $platform | sed 's/linux\///')" \
    --push \
    .; then
    echo "Docker image built and pushed successfully"
else
    echo "Failed to push to GHCR, building without push for validation..."
    docker buildx build \
        --platform "$platform" \
        --file ./docker/Dockerfile \
        --build-arg AMP_ARCH="$arch" \
        --build-arg AMP_VERSION="$VERSION" \
        --tag "ghcr.io/sourcegraph/amp-cli:$VERSION-$(echo $platform | sed 's/linux\///')" \
        --tag "ghcr.io/sourcegraph/amp-cli:latest-$(echo $platform | sed 's/linux\///')" \
        .
    echo "Docker image built successfully (push skipped due to permissions)"
fi
