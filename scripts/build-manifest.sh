#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MANIFEST_FILE="$PROJECT_ROOT/repository/manifest.json"

echo "Building manifest from GitHub releases..."

# Get releases from the last 31 days
THIRTY_ONE_DAYS_AGO=$(date -u -d '31 days ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -v-31d '+%Y-%m-%dT%H:%M:%SZ')

# Use gh CLI to get all releases with pagination, filter by date, and format as JSON
ALL_RELEASES=$(mktemp)
gh release list --limit 1000 --json tagName,publishedAt,createdAt > "$ALL_RELEASES"

jq --arg cutoff_date "$THIRTY_ONE_DAYS_AGO" '
  map(select(.publishedAt >= $cutoff_date or .createdAt >= $cutoff_date)) |
  map({
    version: .tagName,
    datetime: (.publishedAt // .createdAt)
  }) |
  sort_by(.datetime) |
  reverse
' "$ALL_RELEASES" > "$MANIFEST_FILE"

rm "$ALL_RELEASES"

echo "Manifest created at $MANIFEST_FILE"
echo "Found $(jq 'length' "$MANIFEST_FILE") releases from the last 31 days"
