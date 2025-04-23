#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

echo "Running kd-utils tests..."

# Function to test if a package is installed
test_package_installed() {
  if dpkg -l | grep -q " $1 "; then
    echo -e "${GREEN}✓ Package $1 is installed${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ Package $1 is not installed${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Function to test if a command exists
test_command_exists() {
  if command -v $1 >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Command $1 exists${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ Command $1 does not exist${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Function to test if a file exists
test_file_exists() {
  if [ -f "$1" ]; then
    echo -e "${GREEN}✓ File $1 exists${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ File $1 does not exist${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Test if packages are installed
echo "Testing installed packages..."
test_package_installed "bat"

# Test if commands are available
echo "Testing command availability..."
test_command_exists "batcat"

# Test if alias exists in .zshrc
USERNAME="${USERNAME:-"${_REMOTE_USER:-"root"}"}"

echo "Testing configuration files..."
test_file_exists "${HOME}/.dircolors"

# Test if the bat alias is set in .zshrc
if grep -q "alias bat=batcat" "${HOME}/.zshrc"; then
  echo -e "${GREEN}✓ bat alias is set in .zshrc${NC}"
  TESTS_PASSED=$((TESTS_PASSED + 1))
else
  echo -e "${RED}✗ bat alias is not set in .zshrc${NC}"
  TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test if dircolors configuration is set in .zshrc
if grep -q "test -r ~/.dircolors && eval \"\$(dircolors -b ~/.dircolors)\" || eval \"\$(dircolors -b)\"" "${HOME}/.zshrc"; then
  echo -e "${GREEN}✓ dircolors configuration is set in .zshrc${NC}"
  TESTS_PASSED=$((TESTS_PASSED + 1))
else
  echo -e "${RED}✗ dircolors configuration is not set in .zshrc${NC}"
  TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Print summary
echo "============================"
echo "Test summary:"
echo "Tests passed: ${TESTS_PASSED}"
echo "Tests failed: ${TESTS_FAILED}"

if [ $TESTS_FAILED -eq 0 ]; then
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
else
  echo -e "${RED}Some tests failed!${NC}"
  exit 1
fi 