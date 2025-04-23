#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'neovim-kickstart' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Optional: Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Verify the current user is 'usertest'
check "verify running as usertest" bash -c "[ \$(whoami) = 'usertest' ]"

# Verify nvim +Lazy runs successfully
check "verify nvim +Lazy runs successfully" bash -c 'nvim --headless +Lazy +qall'

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults 