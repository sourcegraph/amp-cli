#!/bin/bash

# Script to build Debian repository from .deb packages
# Usage: ./build-debian-repo.sh <deb-files-directory> <output-directory>

set -e

DEB_DIR=${1:-"./debs"}
REPO_DIR=${2:-"repository/debian"}
DIST="stable"
COMPONENT="main"

if [ ! -d "$DEB_DIR" ]; then
    echo "Error: .deb files directory not found: $DEB_DIR"
    exit 1
fi

echo "Building Debian repository..."
echo "Source: $DEB_DIR"
echo "Output: $REPO_DIR"

# Create repository structure
mkdir -p "$REPO_DIR/dists/$DIST/$COMPONENT/binary-amd64"
mkdir -p "$REPO_DIR/dists/$DIST/$COMPONENT/binary-arm64"
mkdir -p "$REPO_DIR/pool/$COMPONENT"

# Copy .deb files to pool
echo "Copying .deb files to pool..."
cp "$DEB_DIR"/*.deb "$REPO_DIR/pool/$COMPONENT/" || true

# Generate Packages files for each architecture
echo "Generating Packages files..."

for arch in amd64 arm64; do
    packages_file="$REPO_DIR/dists/$DIST/$COMPONENT/binary-$arch/Packages"

    # Clear the packages file
    >"$packages_file"

    # Process each .deb file for this architecture
    for deb_file in "$REPO_DIR/pool/$COMPONENT"/*_${arch}.deb; do
        if [ -f "$deb_file" ]; then
            echo "Processing $(basename "$deb_file")..."

            # Extract package information
            dpkg-deb -I "$deb_file" control | sed '/^$/d' >>"$packages_file"

            # Add additional fields
            echo "Filename: pool/$COMPONENT/$(basename "$deb_file")" >>"$packages_file"
            echo "Size: $(stat -f%z "$deb_file" 2>/dev/null || stat -c%s "$deb_file")" >>"$packages_file"
            echo "MD5sum: $(md5sum "$deb_file" | cut -d' ' -f1)" >>"$packages_file"
            echo "SHA1: $(sha1sum "$deb_file" | cut -d' ' -f1)" >>"$packages_file"
            echo "SHA256: $(sha256sum "$deb_file" | cut -d' ' -f1)" >>"$packages_file"
            echo "" >>"$packages_file"
        fi
    done

    # Compress Packages file
    gzip -c "$packages_file" >"${packages_file}.gz"
done

# Generate Release file
echo "Generating Release file..."
release_file="$REPO_DIR/dists/$DIST/Release"

cat >"$release_file" <<EOF
Origin: Amp CLI
Label: Amp CLI
Suite: $DIST
Codename: $DIST
Components: $COMPONENT
Architectures: amd64 arm64
Date: $(date -Ru)
Description: Amp CLI - AI-powered coding assistant
EOF

# Calculate checksums for Release file
echo "MD5Sum:" >>"$release_file"
(cd "$REPO_DIR/dists/$DIST" && find . -type f \( -name "Packages*" \) -exec md5sum {} \; | sed 's/\.\///') >>"$release_file"

echo "SHA1:" >>"$release_file"
(cd "$REPO_DIR/dists/$DIST" && find . -type f \( -name "Packages*" \) -exec sha1sum {} \; | sed 's/\.\///') >>"$release_file"

echo "SHA256:" >>"$release_file"
(cd "$REPO_DIR/dists/$DIST" && find . -type f \( -name "Packages*" \) -exec sha256sum {} \; | sed 's/\.\///') >>"$release_file"

# Sign Release file if GPG key is available
if [ -n "$GPG_KEY_ID" ]; then
    echo "Signing Release file with GPG key: $GPG_KEY_ID"
    gpg --default-key "$GPG_KEY_ID" --armor --detach-sign --output "$REPO_DIR/dists/$DIST/Release.gpg" "$release_file"
    gpg --default-key "$GPG_KEY_ID" --clear-sign --output "$REPO_DIR/dists/$DIST/InRelease" "$release_file"
else
    echo "Warning: GPG_KEY_ID not set, repository will not be signed"
fi

echo "Debian repository built successfully!"
echo "Repository structure:"
find "$REPO_DIR" -type f | sort
