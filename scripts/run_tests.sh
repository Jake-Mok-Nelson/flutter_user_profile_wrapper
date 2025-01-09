#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

total_tests=0
passed_tests=0
failed_tests=0
verbose=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --verbose)
            verbose=true
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

echo "Starting test execution..."
echo ""

for test_script in ./scripts/*_test.sh; 
do
  if [ -f "$test_script" ]; then
    ((total_tests++))
    echo "===================================================================="
    echo "Running ${test_script}..."
    output=$(bash "$test_script" 2>&1)
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
      echo -e "${GREEN}PASSED${NC}"
      ((passed_tests++))
    else
      echo -e "${RED}FAILED${NC}"
      ((failed_tests++))
      echo "$output"
    fi
    if [ "$verbose" = true ]; then
      echo "$output"
    fi
  fi
done

echo "===================================================================="
echo -e "${GREEN}$passed_tests${NC}/${total_tests} tests passed"
echo -e "${RED}$failed_tests${NC}/${total_tests} tests failed"

# Exit with the number of failed tests as the exit code
exit $failed_tests