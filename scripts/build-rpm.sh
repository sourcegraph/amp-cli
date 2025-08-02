#!/bin/bash
set -euo pipefail

VERSION="$1"
VERSION="${VERSION#v}"
ARCH="${2:-}"

if [ -z "$ARCH" ]; then
    echo "Error: Architecture parameter required"
    exit 1
fi

echo "Building RPM package for version $VERSION, architecture $ARCH"

# Install RPM build tools
sudo apt-get update
sudo apt-get install -y rpm build-essential

# Setup GPG
echo "$DEB_GPG_PRIVATE_KEY" | gpg --batch --import
echo "$DEB_GPG_PUBLIC_KEY" | gpg --batch --import

# Build for the specified architecture
arch="$ARCH"
echo "Building RPM package for $arch"

# Download release binary
if [ "$arch" = "x86_64" ]; then
    asset_name="amp-linux-x64"
else
    asset_name="amp-linux-arm64"
fi

wget "https://packages.ampcode.com/binaries/cli/v${VERSION}/${asset_name}"

# Create a tar.gz file for the RPM build process with RPM-compatible directory name
rpm_version=$(echo "${VERSION}" | sed 's/-/./g')
mkdir -p amp-${rpm_version}
cp ${asset_name} amp-${rpm_version}/amp
chmod +x amp-${rpm_version}/amp
tar -czf amp-${rpm_version}.tar.gz amp-${rpm_version}/

# Update spec version (replace hyphens with dots for RPM compatibility)
cp rpm/amp.spec.template rpm/amp.spec
sed -i "s/REPLACE_WITH_VERSION/${rpm_version}/" rpm/amp.spec

# Set up RPM build environment
mkdir -p ~/rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}
cp amp-${rpm_version}.tar.gz ~/rpmbuild/SOURCES/
cp rpm/amp.spec ~/rpmbuild/SPECS/

# Build RPM
rpmbuild --target $arch -bb ~/rpmbuild/SPECS/amp.spec

# Debug: List what was actually built
echo "Listing rpmbuild RPMS directory structure:"
find ~/rpmbuild/RPMS -type f -name "*.rpm" || echo "No RPM files found"

# Sign the RPM package
for rpm_file in ~/rpmbuild/RPMS/*/amp-*.rpm; do
    if [ -f "$rpm_file" ]; then
        gpg --batch --yes --pinentry-mode loopback --passphrase "$DEB_GPG_PASSWORD" \
            --default-key "$DEB_GPG_KEY_ID" \
            --armor --detach-sign "$rpm_file"
    fi
done

# Attach RPM to GitHub Release
version_tag="v${VERSION}"
gh release upload "$version_tag" ~/rpmbuild/RPMS/*/amp-*.rpm ~/rpmbuild/RPMS/*/amp-*.rpm.asc --clobber

# Upload artifacts for repository build
mkdir -p artifacts
cp ~/rpmbuild/RPMS/*/amp-*.rpm artifacts/
cp ~/rpmbuild/RPMS/*/amp-*.rpm.asc artifacts/

echo "RPM package built and uploaded successfully"
