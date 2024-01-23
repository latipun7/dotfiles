#!/usr/bin/env bash
# shellcheck disable=SC2154

set -euo pipefail

esc="\033"
reset="${esc}[0m"

# 256 Colors Foreground
for color in {0..255}; do
  declare "color${color}=${esc}[38;5;${color}m"
done

# 256 Colors Background
for bg in {0..255}; do
  declare "bg${bg}=${esc}[48;5;${bg}m"
done

function print_help() {
  echo
}

function die() {
  local _ret="${2:-1}"
  if [[ $_ret != 0 ]]; then
    test "${_PRINT_HELP:-no}" = yes && print_help >&2
    echo -e "$1" >&2
  else
    test "${_PRINT_HELP:-no}" = yes && print_help
    echo -e "$1"
  fi

  exit "${_ret}"
}

function info() {
  echo -e "\n${color14}==>${reset} $1 ℹ\n"
}

function step() {
  echo -e "\n${color13}==>${reset} $1 👟\n"
}

function success() {
  echo -e "\n${color2}==>${reset} $1 ✔\n"
}

function fail() {
  die "\n${color1}==>${reset} $1 ❌\n" 1
}

#===================================================0

deps=(gzip chezmoi git wget curl tar lazygit fd rg nvim grep delta rbw unzip)

function check_dependencies() {
  step "Checking dependencies..."

  for dep in "${deps[@]}"; do
    type -p "$dep" &>/dev/null || {
      fail "Could not find '${color6}${dep}${reset}', is it installed?" >&2
    }
  done

  info "OK!"
}

function bootstrap_dotfiles() {
  step "Install dotfiles..."
  chezmoi init latipun7 --ssh --apply
}

function main() {
  check_dependencies
  bootstrap_dotfiles
  success "All done 👏\n    Please restart your terminal 🎉"
}

main
