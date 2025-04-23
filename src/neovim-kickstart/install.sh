#!/bin/sh
set -e

USERNAME="${USERNAME:-"${_REMOTE_USER:-"root"}"}"

apt-get update -qq
apt-get install -y make gcc ripgrep unzip git xclip curl

su ${USERNAME} -c "$(dirname $0)/user_setup.sh"
