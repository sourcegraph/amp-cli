#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MANIFEST_FILE="$PROJECT_ROOT/repository/binaries/cli/manifest.json"

echo "Building manifest from GitHub releases..."

# Get releases from the last 31 days
THIRTY_ONE_DAYS_AGO=$(date -u -d '31 days ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -v-31d '+%Y-%m-%dT%H:%M:%SZ')

# Use gh CLI to get all releases with pagination, filter by date, and format as JSON
ALL_RELEASES=$(mktemp)
gh release list --limit 1000 --json tagName,publishedAt,createdAt >"$ALL_RELEASES"

jq --arg cutoff_date "$THIRTY_ONE_DAYS_AGO" '
  map(select(.publishedAt >= $cutoff_date or .createdAt >= $cutoff_date)) |
  map({
    version: .tagName,
    datetime: (.publishedAt // .createdAt)
  }) |
  sort_by(.datetime) |
  reverse
' "$ALL_RELEASES" >"$MANIFEST_FILE"

rm "$ALL_RELEASES"

echo "Manifest created at $MANIFEST_FILE"
echo "Found $(jq 'length' "$MANIFEST_FILE") releases from the last 31 days"

# Configure git and commit changes
git config --local user.email "amp@ampcode.com"
git config --local user.name "Amp"

# Retry logic for concurrent workflow conflicts
for i in {1..5}; do
    echo "Attempt $i/5 to commit and push changes"

    # Pull latest changes
    git pull origin main || true

    # Add and commit changes
    git add "$MANIFEST_FILE"
    if git commit -m "Update manifest with latest releases"; then
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
