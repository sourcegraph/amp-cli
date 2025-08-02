#!/bin/bash
set -euo pipefail

VERSION="$1"
VERSION="${VERSION#v}"

echo "Building Homebrew formula for version $VERSION"

# Download binaries and calculate checksums
echo "Downloading binaries to calculate checksums..."
if ! gh release download "v${VERSION}" --repo sourcegraph/amp-cli \
    --pattern "amp-darwin-arm64.zip" --pattern "amp-darwin-x64.zip" \
    --pattern "amp-linux-arm64" --pattern "amp-linux-x64"; then
    echo "Failed to download release assets from sourcegraph/amp-cli v${VERSION}"
    exit 1
fi

# Verify all expected files were downloaded
for file in "amp-darwin-arm64.zip" "amp-darwin-x64.zip" "amp-linux-arm64" "amp-linux-x64"; do
    if [ ! -f "$file" ]; then
        echo "Expected file $file not found after download"
        echo "Available files:"
        ls -la
        exit 1
    fi
done

# Calculate SHA256 checksums
darwin_arm64_sha=$(shasum -a 256 amp-darwin-arm64.zip | cut -d' ' -f1)
darwin_x64_sha=$(shasum -a 256 amp-darwin-x64.zip | cut -d' ' -f1)
linux_arm64_sha=$(shasum -a 256 amp-linux-arm64 | cut -d' ' -f1)
linux_x64_sha=$(shasum -a 256 amp-linux-x64 | cut -d' ' -f1)

echo "Checksums calculated:"
echo "Darwin ARM64: $darwin_arm64_sha"
echo "Darwin x64: $darwin_x64_sha"
echo "Linux ARM64: $linux_arm64_sha"
echo "Linux x64: $linux_x64_sha"

# Copy template to working file
cp Formula/amp.rb.template Formula/amp.rb

# Replace placeholders with actual values
sed -i "" "s/VERSION_PLACEHOLDER/$VERSION/g" Formula/amp.rb
sed -i "" "s/REPLACE_WITH_DARWIN_ARM64_SHA256/$darwin_arm64_sha/g" Formula/amp.rb
sed -i "" "s/REPLACE_WITH_DARWIN_AMD64_SHA256/$darwin_x64_sha/g" Formula/amp.rb
sed -i "" "s/REPLACE_WITH_LINUX_ARM64_SHA256/$linux_arm64_sha/g" Formula/amp.rb
sed -i "" "s/REPLACE_WITH_LINUX_AMD64_SHA256/$linux_x64_sha/g" Formula/amp.rb

# Clean up downloaded files
rm -f amp-darwin-arm64.zip amp-darwin-x64.zip amp-linux-arm64 amp-linux-x64

# Configure git and commit changes
git config --local user.email "amp@ampcode.com"
git config --local user.name "Amp"

# Retry logic for concurrent workflow conflicts
for i in {1..5}; do
    echo "Attempt $i/5 to commit and push changes"

    # Pull latest changes
    git pull origin main || true

    # Add and commit changes
    git add Formula/amp.rb
    if git commit -m "Update Homebrew formula to v$VERSION"; then
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
