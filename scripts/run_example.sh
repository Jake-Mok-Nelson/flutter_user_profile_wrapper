#!/bin/bash

set -e

EXAMPLE_DIR="./example"

if [ "$1" ]; then
    DIR="$EXAMPLE_DIR/$1"
    if [ -d "$DIR" ]; then
        cd "$DIR" && flutter run -d chrome --wasm
    else
        echo "Directory '$1' does not exist."
        exit 1
    fi
else
    declare -a names
    declare -a descriptions
    index=1
    for dir in "$EXAMPLE_DIR"/*/ ; do
        if [ -f "$dir/pubspec.yaml" ]; then
            name=$(grep '^name:' "$dir/pubspec.yaml" | awk '{print $2}')
            description=$(grep '^description:' "$dir/pubspec.yaml" | awk '{$1=""; print $0}' | sed 's/^ //')
            names+=("$name")
            descriptions+=("$description")
            echo "$index. $name: $description"
            ((index++))
        fi
    done
    read -p "Select an example by number: " selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -lt "$index" ]; then
        selected_dir="${names[$((selection-1))]}"
        cd "$EXAMPLE_DIR/$selected_dir"
        flutter clean
        flutter pub get
        flutter run -d chrome --wasm
    else
        echo "Invalid selection."
        exit 1
    fi
fi
