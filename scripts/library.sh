#!/bin/bash


# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


# Read a file and find a semver string
get_semver() {
    cat "$1" | grep -Eo '\^?[0-9]+\.[0-9]+\.[0-9]+$'
}


assert_equal() {
    local description="$1"
    local expected="$2"
    local actual="$3"
    if [ "$expected" != "$actual" ]; then
        echo -e "${RED}✗ $description: Expected '$expected' but got '$actual'${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ $description passed${NC}"
    fi
}
