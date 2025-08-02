#!/bin/bash

# Script to build RPM repository from .rpm packages
# Usage: ./build-rpm-repo.sh <rpm-files-directory> <output-directory>

set -e

RPM_DIR=${1:-"./rpms"}
REPO_DIR=${2:-"repository/rpm"}

if [ ! -d "$RPM_DIR" ]; then
    echo "Error: .rpm files directory not found: $RPM_DIR"
    exit 1
fi

echo "Building RPM repository..."
echo "Source: $RPM_DIR"
echo "Output: $REPO_DIR"

# Install createrepo if not available
if ! command -v createrepo_c >/dev/null 2>&1 && ! command -v createrepo >/dev/null 2>&1; then
    echo "Error: createrepo or createrepo_c is required but not installed."
    echo "Install with: dnf install createrepo_c (or yum install createrepo)"
    exit 1
fi

# Create repository directory
mkdir -p "$REPO_DIR"

# Copy .rpm files
echo "Copying .rpm files..."
cp "$RPM_DIR"/*.rpm "$REPO_DIR/" || true

# Create repository metadata
echo "Creating repository metadata..."
if command -v createrepo_c >/dev/null 2>&1; then
    createrepo_c "$REPO_DIR"
else
    createrepo "$REPO_DIR"
fi

# Sign repository if GPG key is available
if [ -n "$GPG_KEY_ID" ]; then
    echo "Signing repository with GPG key: $GPG_KEY_ID"

    # Sign the repomd.xml file
    gpg --default-key "$GPG_KEY_ID" --detach-sign --armor "$REPO_DIR/repodata/repomd.xml"

    # Also sign individual RPM files if not already signed
    for rpm_file in "$REPO_DIR"/*.rpm; do
        if [ -f "$rpm_file" ]; then
            echo "Signing $(basename "$rpm_file")..."
            rpm --addsign "$rpm_file" || echo "Warning: Failed to sign $(basename "$rpm_file")"
        fi
    done

    # Recreate metadata after signing
    if command -v createrepo_c >/dev/null 2>&1; then
        createrepo_c --update "$REPO_DIR"
    else
        createrepo --update "$REPO_DIR"
    fi
else
    echo "Warning: GPG_KEY_ID not set, repository will not be signed"
fi

# Create .repo file template
echo "Creating repository configuration template..."
cat >"$REPO_DIR/amp-cli.repo" <<EOF
[amp-cli]
name=Amp CLI Repository
baseurl=https://packages.ampcode.com/binaries/cli/rpm/
enabled=1
gpgcheck=1
gpgkey=https://packages.ampcode.com/binaries/cli/gpg/amp-cli.asc
EOF

echo "RPM repository built successfully!"
echo "Repository structure:"
find "$REPO_DIR" -type f | sort

echo ""
echo "To use this repository, add the following to /etc/yum.repos.d/amp-cli.repo:"
cat "$REPO_DIR/amp-cli.repo"
