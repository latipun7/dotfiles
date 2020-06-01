#!/usr/bin/env bash

set -e

CONFIG="install.conf.yml"
DOTBOT_DIR=".bot"

DOTBOT_BIN="bin/dotbot"

if [ -z "$DOTFILES" ]; then
  DOTDIR="$HOME/.files"
else
  DOTDIR="$DOTFILES"
fi

if [ ! -d "$HOME/.files" ]; then
  git clone --recurse-submodules -j 8 https://github.com/latipun7/dotfiles.git "$DOTDIR"
  chmod -R +x "$DOTDIR/install.sh" "$DOTDIR/linux/bin"
fi

git -C "$DOTDIR" submodule sync --recursive
git -C "$DOTDIR" submodule update --init --recursive

"${DOTDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${DOTDIR}" -c "${CONFIG}" "${@}"

function info() {
  echo -e "\n  \e[1;35m==>\e[0m $1 ℹ\n"
}

if ! hash bootstrap 2>/dev/null; then
  info 'Bootstrapping for the first time ...'
  "$HOME/.bin/bootstrap"
fi
