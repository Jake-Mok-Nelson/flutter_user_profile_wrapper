
#!/bin/bash

# Unit tests for release.sh script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="/tmp/test_release"

setup() {
    mkdir -p "$TEST_DIR"
    echo "version: 1.0.0" > "$TEST_DIR/pubspec.yaml"
    echo -e "## 1.0.0\n- Initial release" > "$TEST_DIR/CHANGELOG.md"
    git init "$TEST_DIR"
    cd "$TEST_DIR"
    git add pubspec.yaml CHANGELOG.md
    git commit -m "Initial commit"
}

teardown() {
    cd ..
    rm -rf "$TEST_DIR"
}

test_valid_release() {
    setup
    "$SCRIPT_DIR/release.sh" "$TEST_DIR" "--dry-run"
    if git rev-parse "v1.0.0" >/dev/null 2>&1; then
        echo "✓ Valid release test passed"
    else
        echo "✗ Valid release test failed"
        exit 1
    fi
    teardown
}

test_missing_pubspec() {
    setup
    rm "$TEST_DIR/pubspec.yaml"
    if "$SCRIPT_DIR/release.sh" "$TEST_DIR" 2>&1 | grep -q "pubspec.yaml not found"; then
        echo "✓ Missing pubspec test passed"
    else
        echo "✗ Missing pubspec test failed"
        exit 1
    fi
    teardown
}

test_invalid_semver_strict() {
    setup
    echo "version: 1.0.0-beta" > "$TEST_DIR/pubspec.yaml"
    if "$SCRIPT_DIR/release.sh" "$TEST_DIR" "--strict" 2>&1 | grep -q "is not a valid semver"; then
        echo "✓ Invalid semver with strict flag test passed"
    else
        echo "✗ Invalid semver with strict flag test failed"
        exit 1
    fi
    teardown
}

# Run all tests
echo "Running release.sh tests..."
echo "---------------------------------"
for test_func in $(compgen -A function | grep "^test_"); do
    echo "--- Running $test_func"
    $test_func
done
echo "All tests completed."