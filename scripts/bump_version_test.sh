#!/bin/bash



# Unit tests for bump_version.sh script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_PUBSPEC="test_pubspec.yaml"
TEST_README="test_README.md"

source "$SCRIPT_DIR/library.sh"

setup() {
    echo "version: 1.0.0" > "$TEST_PUBSPEC"
    echo "my_package: ^0.1.0" > "$TEST_README"
}

teardown() {
    rm -f "$TEST_PUBSPEC"
    rm -f "$TEST_README"
}


# Test patch version bump
test_patch_bump() {
    setup
    $SCRIPT_DIR/bump_version.sh patch "$TEST_PUBSPEC" "$TEST_README"
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
    $SCRIPT_DIR/bump_version.sh minor "$TEST_PUBSPEC" "$TEST_README"
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
    $SCRIPT_DIR/bump_version.sh major "$TEST_PUBSPEC" "$TEST_README"
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
    $SCRIPT_DIR/bump_version.sh invalid_argument "$TEST_PUBSPEC" "$TEST_README"
    if [ $? -eq 1 ]; then
        echo -e "${GREEN}✓ Invalid argument test passed${NC}"
    else
        echo -e "${RED}✗ Invalid argument test failed${NC}"
        exit 1
    fi
    teardown
}

test_bump_requirements_in_readme() {
    setup
    
    
    "$SCRIPT_DIR/bump_version.sh" patch "$TEST_PUBSPEC" "$TEST_README"
    README_PATCH_VERSION=$(get_semver $TEST_README)
    assert_equal "after patch bump, TEST_README should have with version ^1.0.1" "^1.0.1" "$README_PATCH_VERSION"

    teardown
}

for test_func in $(compgen -A function | grep "^test_"); do
    echo "--- Running $test_func"
    $test_func
done
