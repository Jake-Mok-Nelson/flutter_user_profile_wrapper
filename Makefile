# Makefile for Flutter commands and to release the package

.PHONY: clean init test test-scripts bump-version bump docs release generate-demo test-example-run generate-example generate

clean:
	flutter clean
	if [ -d "docs" ]; then rm -rf docs; fi

init:
	flutter pub get

# Runs the flutter tests
test:
	flutter test

# Runs an example app in the example directory
## Example: make test-example-run full
## or make test-example-run (and choose, 1. full, 2. other, etc.)
test-example:
	cd example && flutter run -d chrome --debug

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

# Erases the Dart documentation and generates it again
docs:
	if [ -d "doc" ]; then rm -rf doc; fi
	dart doc

# Publishes the package to pub.dev
release: docs
	./scripts/release.sh ./ --strict

# Generates the example app
generate-example:
	./scripts/generate_example.sh

generate:
	dart run build_runner build --delete-conflicting-outputs

%:
	@:
