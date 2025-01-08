# Makefile for Flutter commands and to release the package

.PHONY: clean test test-scripts bump-version bump release

clean:
	flutter clean

# Runs the flutter tests
test:
	flutter test

# Runs bash script files in ./scripts/ that end in _test.sh
test-scripts:
	./scripts/run_tests.sh

# Reads the version from pubspec.yaml and increments it based on the type of bump (major, minor, patch)
bump:
	@if [ "$(word 2,$(MAKECMDGOALS))" != "" ]; then \
		./scripts/bump_version.sh $(word 2,$(MAKECMDGOALS)); \
	else \
		read -p "Enter the type of bump (major, minor, patch): " bump_type; \
		./scripts/bump_version.sh $$bump_type; \
	fi
bump-version: bump

# Publishes the package to pub.dev
release:
	./scripts/release.sh --strict

%:
	@:
