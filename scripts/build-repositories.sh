#!/bin/bash
set -euo pipefail

VERSION="$1"
VERSION="${VERSION#v}"

echo "Building package repositories for version $VERSION"

# Setup GPG
if [ -n "${GPG_PRIVATE_KEY:-}" ]; then
  echo "$GPG_PRIVATE_KEY" | gpg --import --batch
  export GPG_KEY_ID="${GPG_KEY_ID}"
else
  echo "GPG_PRIVATE_KEY secret not set, skipping GPG setup"
  export GPG_KEY_ID=""
fi

# Download package artifacts (assuming they're already downloaded in workflow)
echo "Processing package artifacts..."

# Install repository tools
sudo apt-get update
sudo apt-get install -y createrepo-c dpkg-dev

# Prepare package directories
mkdir -p debs rpms
find artifacts -name "*.deb" -exec cp {} debs/ \;
find artifacts -name "*.rpm" -exec cp {} rpms/ \;

# Build Debian repository
echo "Building Debian repository..."
chmod +x ./repository/scripts/build-debian-repo.sh
./repository/scripts/build-debian-repo.sh debs repository/debian

# Build RPM repository
echo "Building RPM repository..."
chmod +x ./repository/scripts/build-rpm-repo.sh
./repository/scripts/build-rpm-repo.sh rpms repository/rpm

# Export GPG public key
if [ -n "$GPG_KEY_ID" ]; then
  echo "Exporting GPG public key for repositories..."
  mkdir -p repository/gpg
  gpg --armor --export "$GPG_KEY_ID" > repository/gpg/amp-cli.asc
  echo "GPG public key exported to repository/gpg/amp-cli.asc"
else
  echo "Warning: GPG_KEY_ID not set, creating placeholder"
  mkdir -p repository/gpg
  echo "# GPG key not available" > repository/gpg/amp-cli.asc
fi

# Create release assets
echo "Creating release assets..."
tar -czf debian-repo.tar.gz -C repository debian
tar -czf rpm-repo.tar.gz -C repository rpm

# Copy GPG key to release location
mkdir -p release-assets/gpg
cp repository/gpg/amp-cli.asc release-assets/gpg/ ||
  echo "GPG key not found, will be created manually"

# Upload repositories to release
version_tag="v${VERSION}"
gh release upload "$version_tag" \
  debian-repo.tar.gz \
  rpm-repo.tar.gz \
  release-assets/gpg/amp-cli.asc \
  --clobber

# Index.html is already available as a static file in repository/
echo "Using static index.html for repository listing"

# Deploy to GCP bucket (if GCP authentication is set up)
if command -v gsutil >/dev/null 2>&1; then
  echo "Uploading repository files to gs://packages.ampcode.com/"
  gsutil -m rsync -r -d repository/ gs://packages.ampcode.com/

  # Set appropriate content types and cache headers
  gsutil -m setmeta -h "Content-Type:text/html" \
    -h "Cache-Control:public, max-age=300" \
    gs://packages.ampcode.com/index.html || true

  gsutil -m setmeta -h "Content-Type:application/pgp-keys" \
    -h "Cache-Control:public, max-age=86400" \
    "gs://packages.ampcode.com/gpg/*.asc" || true

  gsutil -m setmeta -h "Cache-Control:public, max-age=3600" \
    "gs://packages.ampcode.com/debian/**" || true

  gsutil -m setmeta -h "Cache-Control:public, max-age=3600" \
    "gs://packages.ampcode.com/rpm/**" || true

  echo "Repository deployment completed successfully"
else
  echo "Warning: gsutil not available, skipping GCP deployment"
fi
