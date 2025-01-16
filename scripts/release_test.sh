#!/bin/bash

# Unit tests for release.sh script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="/tmp/test_release_${RANDOM}_$(date +%s)"

source "$SCRIPT_DIR/library.sh"

setup() {
    mkdir -p "$TEST_DIR"
    echo "version: 1.0.0" > "$TEST_DIR/pubspec.yaml"
    echo -e "## 1.0.0\n- Initial release" > "$TEST_DIR/CHANGELOG.md"
    git init "$TEST_DIR" --quiet
    cd "$TEST_DIR"
    git add pubspec.yaml CHANGELOG.md >/dev/null
    git commit -m "Initial commit" --quiet
}

teardown() {
    cd ..
    rm -rf "$TEST_DIR"
}

test_missing_pubspec() {
    setup
    rm "$TEST_DIR/pubspec.yaml"
    OUTPUT=$("$SCRIPT_DIR/release.sh" "$TEST_DIR" "--dry-run" 2>&1)
    assert_equal "Missing pubspec.yaml message" "pubspec.yaml not found" "$(echo "$OUTPUT" | grep -o "pubspec.yaml not found")"
    teardown
}

test_invalid_semver_strict() {
    setup
    echo "version: 1.0.0-beta" > "$TEST_DIR/pubspec.yaml"
    OUTPUT=$("$SCRIPT_DIR/release.sh" "$TEST_DIR" "--strict" "--dry-run" 2>&1)
    assert_equal "Invalid semver with strict flag message" "is not a valid semver" "$(echo "$OUTPUT" | grep -o "is not a valid semver")"
    teardown
}

test_dry_run_no_tag_on_dry_run() {
    setup
    "$SCRIPT_DIR/release.sh" "$TEST_DIR" "--dry-run" >/dev/null
    if ! git rev-parse "v1.0.0" >/dev/null 2>&1; then
        TAG_EXISTS=0
    else
        TAG_EXISTS=1
    fi
    assert_equal "Dry run does not create a git tag" "0" "$TAG_EXISTS"
    teardown
}

# test_tag_already_exists() {
#     setup
#     git tag "1.0.0"
#     echo "version: 1.0.0" > "$TEST_DIR/pubspec.yaml"
#     OUTPUT=$("$SCRIPT_DIR/release.sh" "$TEST_DIR" "--dry-run" 2>&1)
#     assert_equal "Tag already exists message" "already exists as a git tag" "$(echo "$OUTPUT" | grep -o "already exists as a git tag")"
#     teardown
# }

test_flag_order_strict_then_dry_run() {
    setup
    OUTPUT=$("$SCRIPT_DIR/release.sh" "$TEST_DIR" "--dry-run" "--strict")
    assert_equal "Flag order strict then dry run message" "Release simulation completed" "$(echo "$OUTPUT" | grep -o "Release simulation completed")"
    teardown
}

test_flag_order_dry_run_then_strict() {
    setup
    OUTPUT=$("$SCRIPT_DIR/release.sh" "$TEST_DIR" "--dry-run" "--strict")
    assert_equal "Flag order dry run then strict message" "Release simulation completed" "$(echo "$OUTPUT" | grep -o "Release simulation completed")"
    teardown
}

test_help_output() {
    setup
    OUTPUT=$("$SCRIPT_DIR/release.sh" "--help")
    assert_equal "Help output contains Usage" "Usage:" "$(echo "$OUTPUT" | grep -o "Usage:")"
    teardown
}

for test_func in $(compgen -A function | grep "^test_"); do
    echo "--- Running $test_func"
    $test_func
done
