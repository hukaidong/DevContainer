#!/bin/sh
set -e

USERNAME="${USERNAME:-"${_REMOTE_USER:-"root"}"}"
HOME_DIR="/home/${USERNAME}"

# Verify system is Debian (not Ubuntu or other derivatives)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "debian" ]; then
        echo "Error: This script only supports Debian. Detected system: $NAME"
        exit 1
    fi
else
    echo "Error: Cannot determine OS, /etc/os-release not found"
    exit 1
fi

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
echo "alias bat=batcat" >> ${HOME_DIR}/.zshrc

# Copy dircolors to user's home directory
cp "$(dirname "$0")/dircolors" "${HOME_DIR}/.dircolors"
# Ensure proper ownership
if [ "${USERNAME}" != "root" ]; then
    chown ${USERNAME}:${USERNAME} "${HOME_DIR}/.dircolors"
fi

echo 'test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"' >> "${HOME_DIR}/.zshrc"

