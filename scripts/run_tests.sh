#!/bin/bash

set -e

for test_script in ./scripts/*_test.sh; 
do
  if [ -f "$test_script" ]; then
    echo "Running $test_script"
    bash "$test_script"
  fi
done
