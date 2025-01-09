#!/bin/bash
set -e

REPO_NAME=$(basename `git rev-parse --show-toplevel`)

if [ -z "$REPO_NAME" ]; then
    echo "Error: Not a git repository"
    exit 1
fi

# Bail on git changes
if ! git diff-index --quiet HEAD --; then
    echo "Error: Uncommitted changes"
    exit 1
fi


# Generate a website of the full example
cd example
if [ -d "full" ]; then
    cd full
    flutter build web --release --base-href="/$REPO_NAME/"
    rm -rf ../../docs
    cp -r build/web ../../docs
fi

# Publish the example
git add ../../docs && \
    git commit -m "Update example" && \
    git push origin
