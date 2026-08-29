#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"; }
warn() { echo -e "${YELLOW}==>${NC} ${YELLOW}$1${NC}"; }
err() { echo -e "${RED}==>${NC} ${RED}$1${NC}"; }

# 1. Check dependencies
log "Checking required dependencies..."
DEPS=("curl" "git" "unzip" "tar")
MISSING_DEPS=()

for dep in "${DEPS[@]}"; do
  if ! command -v "$dep" > /dev/null 2>&1; then
    MISSING_DEPS+=("$dep")
  fi
done

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
  err "Missing required dependencies: ${MISSING_DEPS[*]}"
  warn "Please install them using your system's package manager and try again."
  exit 1
fi
log "All basic dependencies met."

# 2. Install mise
if ! command -v mise > /dev/null 2>&1; then
  log "Installing mise..."
  curl https://mise.run | sh
else
  log "mise is already installed."
fi

# Ensure mise and its shims are in PATH for this script session
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

# 3. Install bitwarden and chezmoi via mise
log "Ensuring bitwarden and chezmoi are installed..."
mise use --global bitwarden@latest chezmoi@latest

# 4. Handle Bitwarden Authentication
log "Checking Bitwarden status..."
if ! command -v bw > /dev/null 2>&1; then
  err "Bitwarden CLI (bw) not found in PATH."
  exit 1
fi

BW_STATUS=$(bw status | grep -o '"status":"[^"]*"' | cut -d'"' -f4 || echo "unknown")

if [ "$BW_STATUS" = "unauthenticated" ]; then
  log "Bitwarden is unauthenticated. Logging in..."
  BW_SESSION=$(bw login --raw)
  export BW_SESSION
elif [ "$BW_STATUS" = "locked" ]; then
  log "Bitwarden is locked. Unlocking..."
  BW_SESSION=$(bw unlock --raw)
  export BW_SESSION
elif [ "$BW_STATUS" = "unlocked" ]; then
  log "Bitwarden is already unlocked."
  if [ -z "${BW_SESSION:-}" ]; then
    warn "BW_SESSION is not set in the environment. Chezmoi might fail if secrets are required."
  fi
else
  err "Failed to determine Bitwarden status."
  exit 1
fi

log "Bitwarden session exported."

# 5. Initialize or update dotfiles
if [ ! -d "$(chezmoi source-path 2> /dev/null || echo "$HOME/.local/share/chezmoi")" ]; then
  log "Initializing dotfiles via chezmoi..."
  chezmoi init latipun7 --apply
else
  log "Chezmoi is already initialized. Updating and applying latest changes..."
  chezmoi update --init
fi

log "Bootstrap completed successfully!"
