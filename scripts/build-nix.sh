#!/bin/bash
set -euo pipefail

VERSION="$1"
VERSION="${VERSION#v}"

echo "Building Nix package for version $VERSION"

# Install Nix if not already available
if ! command -v nix &> /dev/null; then
  echo "Installing Nix..."
  # Use single-user install for CI environment
  curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
  # Source the nix environment
  if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
  fi
  # Verify nix is available
  if ! command -v nix &> /dev/null; then
    echo "Failed to install Nix, trying alternative sourcing..."
    export PATH="$HOME/.nix-profile/bin:$PATH"
    if ! command -v nix &> /dev/null; then
      echo "Nix installation failed completely"
      exit 1
    fi
  fi
  echo "Nix installed successfully"
fi

# Download binaries and calculate checksums
echo "Downloading binaries to calculate checksums..."
gh release download "v${VERSION}" --repo sourcegraph/amp-cli \
  --pattern "amp-linux-x64" --pattern "amp-linux-arm64" \
  --pattern "amp-darwin-x64" --pattern "amp-darwin-arm64"

# Calculate SHA256 checksums
linux_x64_sha=$(sha256sum amp-linux-x64 | cut -d' ' -f1)
linux_arm64_sha=$(sha256sum amp-linux-arm64 | cut -d' ' -f1)
darwin_x64_sha=$(sha256sum amp-darwin-x64 | cut -d' ' -f1)
darwin_arm64_sha=$(sha256sum amp-darwin-arm64 | cut -d' ' -f1)

echo "Checksums calculated:"
echo "Linux x64: $linux_x64_sha"
echo "Linux ARM64: $linux_arm64_sha"
echo "Darwin x64: $darwin_x64_sha"
echo "Darwin ARM64: $darwin_arm64_sha"

# Copy template to working file
cp flake.nix.template flake.nix

# Replace placeholders with actual values (Ubuntu sed doesn't need backup extension)
sed -i "s/REPLACE_WITH_VERSION/$VERSION/" flake.nix
sed -i "s/REPLACE_WITH_LINUX_X64_SHA256/$linux_x64_sha/" flake.nix
sed -i "s/REPLACE_WITH_LINUX_ARM64_SHA256/$linux_arm64_sha/" flake.nix
sed -i "s/REPLACE_WITH_DARWIN_X64_SHA256/$darwin_x64_sha/" flake.nix
sed -i "s/REPLACE_WITH_DARWIN_ARM64_SHA256/$darwin_arm64_sha/" flake.nix

# Clean up downloaded files
rm -f amp-linux-x64 amp-linux-arm64 amp-darwin-x64 amp-darwin-arm64

# Test Nix flake
echo "Testing Nix flake..."
# Enable experimental features that flakes require
export NIX_CONFIG="experimental-features = nix-command flakes"

# Use GitHub token to avoid rate limiting if available
if [ -n "$GITHUB_TOKEN" ]; then
  export NIX_CONFIG="$NIX_CONFIG access-tokens = github.com=$GITHUB_TOKEN"
fi

# Create a flake.lock file to avoid GitHub API calls during check
nix flake lock --no-update-lock-file || true
nix flake check --no-update-lock-file
nix build .#amp

# Configure git and commit changes
git config --local user.email "amp@ampcode.com"
git config --local user.name "Amp"

# Retry logic for concurrent workflow conflicts
for i in {1..5}; do
  echo "Attempt $i/5 to commit and push changes"

  # Pull latest changes
  git pull origin main || true

  # Add and commit changes
  git add flake.nix
  if git commit -m "Update Nix flake to v$VERSION"; then
    # Try to push
    if git push; then
      echo "Successfully pushed changes on attempt $i"
      exit 0
    else
      echo "Push failed on attempt $i, retrying..."
      sleep $((i * 2))
    fi
  else
    echo "No changes to commit on attempt $i"
    exit 0
  fi
done

echo "Failed to push after 5 attempts"
exit 1
