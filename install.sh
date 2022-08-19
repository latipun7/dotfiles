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

deps=(gzip chezmoi git wget curl tar lazygit fd rg nvim grep delta)

function print_missing_dep_msg() {
  if [ "$#" -eq 1 ]; then
    fail "Unable to find dependency ${color6}$1${reset}.\n    Please install it first and re-run the installer."
  fi
  exit 1
}

function check_dependencies() {
  step "Checking dependencies..."

  for dep in "${deps[@]}"; do
    if ! hash "$dep" 2>/dev/null; then
      print_missing_dep_msg "$dep"
    fi
  done

  info "OK!"
}

function get_fnm_url() {
  latest_url='https://github.com/Schniz/fnm/releases/latest/download'

  if [[ "$(uname -s)" == *Linux* ]]; then
    case "$(uname -m)" in
      arm | armv7*)
        URL="$latest_url/fnm-arm32.zip"
        ;;
      aarch* | armv8*)
        URL="$latest_url/fnm-arm64.zip"
        ;;
      *)
        URL="$latest_url/fnm-linux.zip"
        ;;
    esac
  fi

  if [[ "$(uname -s)" == *Darwin* ]]; then
    USE_HOMEBREW="true"
  fi
}

function install_fnm() {
  step "Install ${color6}fnm${reset}"

  if [ "${USE_HOMEBREW:-false}" = "true" ]; then
    if hash brew 2>/dev/null; then
      step "Brewing ${color6}fnm${reset} ..."
      brew install fnm
    else
      fail "Missing ${color6}brew${reset}!\n    Not installing due to missing dependencies."
    fi
  else
    DOWNLOAD_DIR="$(mktemp -dp /tmp "fnm-XXXXX")"
    INSTALL_DIR="$HOME/.local/bin"

    mkdir -p "$INSTALL_DIR"

    step "Downloading $URL ..."

    if ! curl --progress-bar -fsLSo "$DOWNLOAD_DIR/fnm.zip" "$URL"; then
      fail "Download ${color6}fnm${reset} failed. Check that the release/filename are correct."
    fi

    gzip -dS .zip "$DOWNLOAD_DIR/fnm.zip"

    if [ -f "$DOWNLOAD_DIR/fnm" ]; then
      mv "$DOWNLOAD_DIR/fnm" "$INSTALL_DIR/fnm"
    else
      mv "$DOWNLOAD_DIR/fnm/fnm" "$INSTALL_DIR/fnm"
    fi

    chmod +x "$INSTALL_DIR/fnm"

    if ! (echo "$PATH" | grep -q '/.local/bin:'); then
      export PATH=$INSTALL_DIR:$PATH
    fi

    rm -rf "$DOWNLOAD_DIR" # clean temp directory
  fi

  DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fnm"
  mkdir -p "$DATA_DIR"
  export FNM_DIR=$DATA_DIR
}

function setup_fnm_node() {
  if ! hash fnm; then
    get_fnm_url
    install_fnm
  fi

  hash fnm &>/dev/null && eval "$(fnm env --use-on-cd)"

  step "Install latest LTS nodeJS..."
  fnm install --lts && fnm use 'lts/*'

  step "Install global node modules..."

  export npm_config_cache="$HOME/.cache/npm"
  npm update --location=global
  corepack enable
  npm install @bitwarden/cli --location=global

  success "${color6}fnm${reset}, ${color6}node${reset}, and ${color6}bitwarden cli${reset} already installed!"
}

function login_bitwarden() {
  step "Login / unlock bitwarden vault..."

  # login and unlock `bw`, if already login, unlock if not unlocked yet.
  if bw login; then
    eval "$(bw unlock | grep -oE --color=never "(export BW_SESSION=".+")")"
  else
    ! (env | grep -q 'BW_SESSION') &&
      eval "$(bw unlock | grep -oE --color=never "(export BW_SESSION=".+")")"
  fi
}

function bootstrap_dotfiles() {
  step "Install dotfiles..."
  chezmoi init latipun7 --apply --verbose
}

function main() {
  check_dependencies
  setup_fnm_node
  login_bitwarden
  bootstrap_dotfiles
  success "All done 👏\n    Please restart your terminal 🎉"
}

main
