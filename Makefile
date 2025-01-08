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
	flutter pub publish --dry-run
	@read -p "Do you want to publish the package? (y/n): " confirm; \
	if [ $$confirm = "y" ]; then \
		flutter pub publish; \
	fi
	./scripts/release.sh $(TARGET_DIR) $(STRICT_FLAG)


%:
	@:
