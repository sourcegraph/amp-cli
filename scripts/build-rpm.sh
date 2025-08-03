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

# Configure git and commit changes
echo "=== GIT DEBUGGING STARTED (RPM) ==="
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
    git add rpm/amp.spec
    echo "Files added. Git status before commit:"
    git status --porcelain=v1 || true
    
    echo "Attempting commit..."
    if git commit -m "Update RPM spec to v$VERSION"; then
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

echo "RPM package built and uploaded successfully"
