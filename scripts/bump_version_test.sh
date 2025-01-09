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
    assert_equal "Patch bump version" "1.0.1" "$VERSION"
    teardown
}

# Test minor version bump
test_minor_bump() {
    setup
    $SCRIPT_DIR/bump_version.sh minor "$TEST_PUBSPEC" "$TEST_README"
    VERSION=$(grep '^version:' "$TEST_PUBSPEC" | awk '{print $2}')
    assert_equal "Minor bump version" "1.1.0" "$VERSION"
    teardown
}

# Test major version bump
test_major_bump() {
    setup
    $SCRIPT_DIR/bump_version.sh major "$TEST_PUBSPEC" "$TEST_README"
    VERSION=$(grep '^version:' "$TEST_PUBSPEC" | awk '{print $2}')
    assert_equal "Major bump version" "2.0.0" "$VERSION"
    teardown
}

test_invalid_argument() {
    setup
    $SCRIPT_DIR/bump_version.sh invalid_argument "$TEST_PUBSPEC" "$TEST_README"
    assert_equal "Invalid argument exit status" "1" "$?"
    teardown
}

test_bump_requirements_in_readme() {
    setup
    "$SCRIPT_DIR/bump_version.sh" patch "$TEST_PUBSPEC" "$TEST_README"
    README_PATCH_VERSION=$(get_semver $TEST_README)
    assert_equal "After patch bump, TEST_README should have version ^1.0.1" "^1.0.1" "$README_PATCH_VERSION"
    teardown
}

for test_func in $(compgen -A function | grep "^test_"); do
    echo "--- Running $test_func"
    $test_func
done
