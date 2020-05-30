#!/usr/bin/env bash

set -e

CONFIG="install.conf.yml"
DOTBOT_DIR=".bot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
git submodule sync --recursive
git submodule update --init --recursive

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

function info() {
  echo -e "\n  \e[1;35m==>\e[0m $1 ℹ\n"
}

if ! hash chara 2>/dev/null; then
  info 'Bootstrapping for the first time ...'
  "$HOME/.bin/bootstrap"
fi
