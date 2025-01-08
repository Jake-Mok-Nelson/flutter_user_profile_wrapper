#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Unit tests for bump_version.sh script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_PUBSPEC="test_pubspec.yaml"

setup() {
    echo "version: 1.0.0" > "$TEST_PUBSPEC"
}

teardown() {
    rm -f "$TEST_PUBSPEC"
}

# Test patch version bump
test_patch_bump() {
    setup
    $SCRIPT_DIR/bump_version.sh patch "$TEST_PUBSPEC"
    VERSION=$(grep '^version:' "$TEST_PUBSPEC" | awk '{print $2}')
    if [ "$VERSION" = "1.0.1" ]; then
        echo -e "${GREEN}✓ Patch bump test passed${NC}"
    else
        echo -e "${RED}✗ Patch bump test failed${NC}"
        exit 1
    fi
    teardown
}

# Test minor version bump
test_minor_bump() {
    setup
    $SCRIPT_DIR/bump_version.sh minor "$TEST_PUBSPEC"
    VERSION=$(grep '^version:' "$TEST_PUBSPEC" | awk '{print $2}')
    if [ "$VERSION" = "1.1.0" ]; then
        echo -e "${GREEN}✓ Minor bump test passed${NC}"
    else
        echo -e "${RED}✗ Minor bump test failed${NC}"
        exit 1
    fi
    teardown
}

# Test major version bump
test_major_bump() {
    setup
    $SCRIPT_DIR/bump_version.sh major "$TEST_PUBSPEC"
    VERSION=$(grep '^version:' "$TEST_PUBSPEC" | awk '{print $2}')
    if [ "$VERSION" = "2.0.0" ]; then
        echo -e "${GREEN}✓ Major bump test passed${NC}"
    else
        echo -e "${RED}✗ Major bump test failed${NC}"
        exit 1
    fi
    teardown
}

test_invalid_argument() {
    setup
    $SCRIPT_DIR/bump_version.sh invalid_argument "$TEST_PUBSPEC"
    if [ $? -eq 1 ]; then
        echo -e "${GREEN}✓ Invalid argument test passed${NC}"
    else
        echo -e "${RED}✗ Invalid argument test failed${NC}"
        exit 1
    fi
    teardown
}

# Run all tests
echo "Running bump_version.sh tests..."
echo "---------------------------------"
for test_func in $(compgen -A function | grep "^test_"); do
    echo "--- Running $test_func"
    $test_func
done
echo "All tests completed."
