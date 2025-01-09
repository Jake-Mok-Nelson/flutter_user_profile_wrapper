#!/bin/bash

# This script is a simple bash script that reads the current version from the  pubspec.yaml  file, increments the version based on the bump type, and updates the  pubspec.yaml  file with the new version. 
# To use this script, you can run the following command: 
# $ ./scripts/bump_version.sh patch

# This command will bump the version from  1.0.0  to  1.0.1 . 


set -e

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ] && [ "$#" -ne 3 ]; then
  echo "Usage: $0 [major|minor|patch] [pubspec_file] [readme_file]"
  exit 1
fi


BUMP_TYPE=$1
PUBSPEC_FILE="$2"
README_FILE="$3"

if [ -z "$PUBSPEC_FILE" ]; then
    PUBSPEC_FILE="pubspec.yaml"
fi

# Check if the pubspec.yaml file exists
if [ ! -f "$PUBSPEC_FILE" ]; then
  echo "$PUBSPEC_FILE file not found"
  exit 1
fi

# Check if the README.md file exists
if [ ! -f "$README_FILE" ]; then
  README_FILE="README.md"
  if [ ! -f "$README_FILE" ]; then
    echo "$README_FILE file not found"
    exit 1
  fi
fi

# Check if the bump type is valid
if [[ "$BUMP_TYPE" != "major" && "$BUMP_TYPE" != "minor" && "$BUMP_TYPE" != "patch" ]]; then
  echo "Invalid bump type. Choose from 'major', 'minor', or 'patch'."
  exit 1
fi

VERSION=$(grep '^version:' "$PUBSPEC_FILE" | awk '{print $2}')
IFS='.' read -r -a VERSION_PARTS <<< "$VERSION"

MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

case $BUMP_TYPE in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Update the pubspec file with the new version
sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"

# Find the first instance of ': ^MAJOR.MINOR.PATCH' in the README file and replace it with the new version
sed -i "0,/: ^[0-9]*\.[0-9]*\.[0-9]*/s/: ^[0-9]*\.[0-9]*\.[0-9]*/: ^$NEW_VERSION/" "$README_FILE"

echo "Bumped version from $VERSION to $NEW_VERSION"
