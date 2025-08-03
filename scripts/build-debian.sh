#!/bin/bash
set -euo pipefail

VERSION="$1"
VERSION="${VERSION#v}"
ARCH="${2:-}"

if [ -z "$ARCH" ]; then
    echo "Error: Architecture parameter required"
    exit 1
fi

echo "Building Debian package for version $VERSION, architecture $ARCH"

# Setup GPG
echo "$DEB_GPG_PRIVATE_KEY" | gpg --batch --import
echo "$DEB_GPG_PUBLIC_KEY" | gpg --batch --import

# Build for the specified architecture
arch="$ARCH"
echo "Building .deb package for $arch"

# Set up architecture
if [ "$arch" = "arm64" ]; then
    sudo apt-get update
    sudo apt-get install -y gcc-aarch64-linux-gnu
fi

# Download release binary
if [ "$arch" = "amd64" ]; then
    asset_name="amp-linux-x64"
else
    asset_name="amp-linux-arm64"
fi

wget "https://packages.ampcode.com/binaries/cli/v${VERSION}/${asset_name}"
chmod +x ${asset_name}

# Create clean build directory for debian packaging
rm -rf pkgroot
mkdir -p pkgroot/usr/bin
cp ${asset_name} pkgroot/usr/bin/amp

# Copy template and update changelog version
cp debian/changelog.template debian/changelog
sed -i "s/REPLACE_WITH_VERSION/${VERSION}/" debian/changelog

# Install build dependencies
sudo apt-get update
sudo apt-get install -y debhelper build-essential

# Create DEBIAN directory structure
mkdir -p pkgroot/DEBIAN

# Calculate installed size (in KB)
size=$(du -k pkgroot/usr/bin/amp | cut -f1)

# Copy template and update control file
cp debian/control.template pkgroot/DEBIAN/control
sed -i "s/REPLACE_WITH_VERSION/${VERSION}/g" pkgroot/DEBIAN/control
sed -i "s/REPLACE_WITH_ARCHITECTURE/$arch/g" pkgroot/DEBIAN/control
sed -i "s/REPLACE_WITH_INSTALLED_SIZE/$size/g" pkgroot/DEBIAN/control

# Also update the main debian/control file from template
cp debian/control.template debian/control
sed -i "s/REPLACE_WITH_VERSION/${VERSION}/g" debian/control
sed -i "s/REPLACE_WITH_ARCHITECTURE/$arch/g" debian/control
sed -i "s/REPLACE_WITH_INSTALLED_SIZE/$size/g" debian/control

# Build package
dpkg-deb --build pkgroot amp_${VERSION}-1_$arch.deb

# Sign the package
gpg --batch --yes --pinentry-mode loopback --passphrase "$DEB_GPG_PASSWORD" \
    --default-key "$DEB_GPG_KEY_ID" \
    --armor --detach-sign amp_${VERSION}-1_$arch.deb

# Attach DEB to GitHub Release
version_tag="v${VERSION}"
gh release upload "$version_tag" amp_${VERSION}-1_$arch.deb amp_${VERSION}-1_$arch.deb.asc --clobber

# Upload artifacts for repository build
mkdir -p artifacts
cp amp_${VERSION}-1_$arch.deb artifacts/
cp amp_${VERSION}-1_$arch.deb.asc artifacts/

# Configure git and commit changes
echo "=== GIT DEBUGGING STARTED (Debian) ==="
echo "Current working directory: $(pwd)"
echo "Git status before any operations:"
git status --porcelain=v1 || true
echo "Git branch list:"
git branch -a || true
echo "Git remote info:"
git remote -v || true
echo "Current HEAD:"
git rev-parse HEAD || true

git config --local user.email "amp@ampcode.com"
git config --local user.name "Amp"

# Configure git to use GitHub token if available
if [ -n "${GITHUB_TOKEN:-}" ]; then
    echo "Setting up GitHub token authentication"
    git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/sourcegraph/amp-cli.git"
    echo "Remote URL updated to use token"
fi

# Ensure we're on the main branch (not detached HEAD)
echo "Attempting to checkout main branch..."
if git checkout main; then
    echo "Successfully checked out existing main branch"
else
    echo "Main branch doesn't exist, creating it..."
    git checkout -b main
    echo "Created main branch, exit code: $?"
fi

echo "After branch setup:"
echo "Current branch: $(git branch --show-current || echo 'N/A')"
echo "All branches:"
git branch -a || true

# Retry logic for concurrent workflow conflicts
for i in {1..5}; do
    echo "Attempt $i/5 to commit and push changes"

    # Pull latest changes
    echo "Pulling latest changes from origin/main..."
    if git pull origin main; then
        echo "Pull successful"
    else
        echo "Pull failed, continuing anyway..."
    fi

    # Add and commit changes
    echo "Adding files to git..."
    git add debian/changelog debian/control
    echo "Files added. Git status before commit:"
    git status --porcelain=v1 || true
    
    echo "Attempting commit..."
    if git commit -m "Update Debian package files to v$VERSION"; then
        echo "Commit successful. Current branch and HEAD info:"
        echo "Current branch: $(git branch --show-current || echo 'N/A')"
        echo "Current HEAD: $(git rev-parse HEAD || echo 'N/A')"
        echo "Last commit: $(git log --oneline -1 || echo 'N/A')"
        
        # Try to push
        echo "Attempting to push to origin main..."
        if git push --set-upstream origin main; then
            echo "Successfully pushed changes on attempt $i"
            break
        else
            echo "Push failed on attempt $i, retrying..."
            echo "Git status after failed push:"
            git status || true
            echo "Git branches after failed push:"
            git branch -a || true
            sleep $((i * 2))
        fi
    else
        echo "No changes to commit on attempt $i"
        echo "Git status after failed commit:"
        git status || true
        break
    fi
done

if [ $i -gt 5 ]; then
    echo "Failed to push after 5 attempts"
    exit 1
fi

echo "Debian package built and uploaded successfully"
