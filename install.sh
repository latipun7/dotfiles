#!/usr/bin/env bash

set -eo pipefail

! (umask | grep -q 022) && umask 022

REPO=${GITHUB_WORKSPACE:-https://github.com/latipun7/dotfiles.git}
CONFIG="install.conf.yml"
DOTBOT_DIR=".bot"
DOTBOT_BIN="bin/dotbot"

if [ -z "$DOTFILES" ]; then
  DOTDIR="$HOME/.files"
else
  DOTDIR="$DOTFILES"
fi

if [ ! -d "$DOTDIR" ]; then
  git clone --recurse-submodules --shallow-submodules -j 7 "$REPO" "$DOTDIR"
  chmod -R +x "$DOTDIR/install.sh" "$DOTDIR/linux/bin"
fi

git -C "$DOTDIR" submodule sync --recursive
git -C "$DOTDIR" submodule update --init --recursive

"$DOTDIR/$DOTBOT_DIR/$DOTBOT_BIN" -d "$DOTDIR" -c "$DOTDIR/$CONFIG" "$@"

function info() {
  echo -e "\n  \e[1;35m==>\e[0m $1 ℹ\n"
}

if ! hash bootstrap 2>/dev/null; then
  info 'Bootstrapping for the first time ...'
  "$HOME/.bin/bootstrap"
fi
