#!/bin/bash
set -ex

USERNAME="${USERNAME:-"${_REMOTE_USER:-"root"}"}"

if [ "${USERNAME}" = "root" ]; then
    HOME_DIR="/root"
else
    HOME_DIR="/home/${USERNAME}"
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Error: Cannot determine OS, /etc/os-release not found"
    exit 1
fi

# Function to append a string to both zshrc and bashrc
append_to_shell_configs() {
    local content="$1"
    echo "${content}" >> "${HOME_DIR}/.zshrc"
    echo "${content}" >> "${HOME_DIR}/.bashrc"
}

PACKAGES=(
    bat
    jq
    kitty-terminfo
    pkg-config
    sqlite3
    libsqlite3-dev
    silversearcher-ag
    fd-find
)

# Install dependencies
apt-get update -qq
apt-get install -y "${PACKAGES[@]}"

# Set up bat alias for user
append_to_shell_configs 'alias bat=batcat'

# Copy dircolors to user's home directory
cp "$(dirname "$0")/dircolors" "${HOME_DIR}/.dircolors"
# Ensure proper ownership
if [ "${USERNAME}" != "root" ]; then
    chown ${USERNAME}:${USERNAME} "${HOME_DIR}/.dircolors"
fi

append_to_shell_configs 'test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"'

