#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MANIFEST_FILE="$PROJECT_ROOT/repository/binaries/cli/manifest.json"

echo "Building manifest from GitHub releases..."

# Get releases from the last 31 days
THIRTY_ONE_DAYS_AGO=$(date -u -d '31 days ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -v-31d '+%Y-%m-%dT%H:%M:%SZ')

# Use gh CLI to get all releases with pagination, filter by date, and format as JSON
ALL_RELEASES=$(mktemp)
if ! gh release list --limit 1000 --json tagName,publishedAt,createdAt >"$ALL_RELEASES"; then
    echo "Failed to fetch releases from GitHub"
    rm -f "$ALL_RELEASES"
    exit 1
fi

# Verify we got valid JSON
if ! jq empty "$ALL_RELEASES" 2>/dev/null; then
    echo "Invalid JSON response from GitHub API"
    echo "Response content:"
    cat "$ALL_RELEASES"
    rm -f "$ALL_RELEASES"
    exit 1
fi

# Create manifest directory if it doesn't exist
mkdir -p "$(dirname "$MANIFEST_FILE")"

# Process releases and create manifest
if ! jq --arg cutoff_date "$THIRTY_ONE_DAYS_AGO" '
  map(select(.publishedAt >= $cutoff_date or .createdAt >= $cutoff_date)) |
  map({
    version: .tagName,
    datetime: (.publishedAt // .createdAt)
  }) |
  sort_by(.datetime) |
  reverse
' "$ALL_RELEASES" >"$MANIFEST_FILE"; then
    echo "Failed to process releases data with jq"
    rm -f "$ALL_RELEASES"
    exit 1
fi

rm "$ALL_RELEASES"

# Verify the manifest was created successfully
if [ ! -f "$MANIFEST_FILE" ]; then
    echo "Manifest file was not created at $MANIFEST_FILE"
    exit 1
fi

echo "Manifest created at $MANIFEST_FILE"
echo "Found $(jq 'length' "$MANIFEST_FILE") releases from the last 31 days"

# Configure git and commit changes
git config --local user.email "amp@ampcode.com"
git config --local user.name "Amp"

# Configure git to use GitHub token if available
if [ -n "${GITHUB_TOKEN:-}" ]; then
    git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/sourcegraph/amp-cli.git"
fi

# Ensure we're on the main branch (not detached HEAD)
git checkout main || git checkout -b main

# Retry logic for concurrent workflow conflicts
for i in {1..5}; do
    echo "Attempt $i/5 to commit and push changes"

    # Pull latest changes
    git pull origin main || true

    # Add and commit changes
    git add "$MANIFEST_FILE"
    if git commit -m "Update manifest with latest releases"; then
        # Try to push
        if git push --set-upstream origin main; then
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
