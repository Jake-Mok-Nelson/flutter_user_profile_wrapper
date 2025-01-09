#!/bin/bash
set -e

cd example
if [ -d "full" ]; then
    cd full
    flutter build web --release
    rm -rf ../../docs
    cp -r build/web ../../docs
fi
