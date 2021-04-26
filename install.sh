#!/usr/bin/env bash

set -euo pipefail

! (umask | grep -q 022) && umask 022

export DOTFILES=${DOTFILES:-$HOME/.files}

REPO=${GITHUB_WORKSPACE:-https://github.com/latipun7/dotfiles.git}
CONFIG="install.conf.yml"
DOTBOT_DIR=".bot"
DOTBOT_BIN="bin/dotbot"

if [ ! -d "$DOTFILES" ]; then
  git clone --recurse-submodules --shallow-submodules -j 7 "$REPO" "$DOTFILES"
  chmod -R +x "$DOTFILES/install.sh" "$DOTFILES/linux/bin"
fi

# shellcheck source=linux/bin/lib/_functions.sh
source "$DOTFILES/linux/bin/lib/_functions.sh"

git -C "$DOTFILES" submodule sync --recursive
git -C "$DOTFILES" submodule update --init --recursive

"$DOTFILES/$DOTBOT_DIR/$DOTBOT_BIN" -d "$DOTFILES" -c "$DOTFILES/$CONFIG" "$@"

if ! hash bootstrap 2>/dev/null; then
  info 'Bootstrapping for the first time ...'
  "$HOME/.bin/bootstrap"
fi
