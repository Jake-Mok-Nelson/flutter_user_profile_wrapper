#!/bin/bash

# This script is a simple bash script that automates the release process for a Flutter package.
# The script reads the version from the pubspec.yaml file, checks if the version is a valid semver, 
# checks if the version exists as a git tag, checks if the version exists in the CHANGELOG.md file,
# tags the repository with the version, and publishes the package to pub.dev using flutter pub publish.

set -e

# Function to print error and exit
error_exit() {
    echo "$1" >&2
    exit 1
}

# Parse arguments
TARGET_DIR=""
EXIT_ON_NON_SEMVER=false
DRY_RUN=false

show_help() {
    echo "Usage: $0 <target_directory> [--strict] [--dry-run] [--help]"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --strict)
            EXIT_ON_NON_SEMVER=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            show_help
            ;;
        *)
            if [ -z "$TARGET_DIR" ]; then
                TARGET_DIR="$1"
                shift
            else
                error_exit "Unknown argument: $1"
            fi
            ;;
    esac
done

if [ -z "$TARGET_DIR" ]; then
    show_help
fi

# Check for pubspec.yaml
PUBSPEC_FILE="$TARGET_DIR/pubspec.yaml"
if [ ! -f "$PUBSPEC_FILE" ]; then
    error_exit "pubspec.yaml not found in $TARGET_DIR"
fi

# Read version
VERSION=$(grep '^version:' "$PUBSPEC_FILE" | awk '{print $2}')
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    if [ "$EXIT_ON_NON_SEMVER" = true ]; then
        error_exit "Version $VERSION is not a valid semver (major.minor.patch)"
    fi
fi

# Check if tag exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    error_exit "Version $VERSION already exists as a git tag, this might be a duplicate release, please check"
fi

# Check changelog for matching version
CHANGELOG_FILE="$TARGET_DIR/CHANGELOG.md"
if ! grep -q "## $VERSION" "$CHANGELOG_FILE"; then
    error_exit "No matching version $VERSION in CHANGELOG.md"
fi

# Tag the repository and publish
if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would tag repository with v$VERSION"
    echo "[DRY RUN] Would publish to pub.dev"
    echo "[DRY RUN] Release simulation completed for version $VERSION"
else
    git tag "v$VERSION"
    git push origin "v$VERSION"

    # Perform flutter pub publish
    flutter pub publish --force

    echo "Released version $VERSION successfully"
fi

