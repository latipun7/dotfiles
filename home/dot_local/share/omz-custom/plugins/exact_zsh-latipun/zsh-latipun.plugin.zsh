# ░▀█▀░█░█░█▀▀░█▀█░█░█░█▀▀
# ░░█░░█▄█░█▀▀░█▀█░█▀▄░▀▀█
# ░░▀░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀

# default file and folder mask permission
umask 022

# activate node
[[ "$(type node)" == *function* ]] && node -v &>/dev/null

# activate zoxide
if hash zoxide 2>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# npm completion
if hash npm 2>/dev/null; then
  eval "$(npm completion)"
fi

# ░█▀█░█░░░▀█▀░█▀█░█▀▀░█▀▀░█▀▀
# ░█▀█░█░░░░█░░█▀█░▀▀█░█▀▀░▀▀█
# ░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

# git alias
alias gcob='git checkout --orphan'
alias gmff='git merge --ff-only'
alias gfu='git fetch upstream'
alias grao='git remote add origin'
alias grau='git remote add upstream'
alias grsh='git remote show'
alias gruh='git reset --hard upstream/$(git_current_branch)'

alias v='$VISUAL'
alias cm=chezmoi

if hash bpytop 2>/dev/null; then
  alias top=bpytop
fi

# paru alias
if hash paru 2>/dev/null; then
  alias yay=paru
  alias yeet='paru -Rns'
fi

# lsd alias
if hash lsd 2>/dev/null; then
  alias l='lsd -lA --group-dirs first'
  alias ll='lsd -lA --group-dirs first --total-size'
  alias lt='lsd --tree -A --group-dirs first'
fi

# exa alias
if hash exa 2>/dev/null; then
  alias l='exa --long --all --header --group-directories-first --icons --git'
  alias ll='exa --long --all --header --group --group-directories-first --icons --git'
  alias lt='exa --tree --all --header --group-directories-first --icons --git --ignore-glob ".git|node_modules"'
fi

# bat alias
if hash bat 2>/dev/null; then
  alias cat=bat
  alias catp='bat -pp'

  function cattail() {
    tail "$@" | bat --language log
  }
  compdef _tail cattail

  function catjournal() {
    journalctl "$@" | bat --language log
  }
  compdef _journalctl catjournal
fi

# kittens alias
if hash kitty 2>/dev/null; then
  alias ssh='kitty +kitten ssh'
  alias icat='kitty +kitten icat'
fi

# nnn alias
if hash nnn 2>/dev/null; then
  function n() {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
      echo "nnn is already running"
      return
    fi

    # Always `cd` on exit
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    LC_COLLATE=C nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
      source "$NNN_TMPFILE"
      rm -f "$NNN_TMPFILE" > /dev/null
    fi
  }
  compdef _nnn n
fi

# lazygit alias
if hash lazygit 2>/dev/null; then
  function lg() {
    export LAZYGIT_NEW_DIR_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/lazygit/newdir"

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
      cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
      rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
  }
fi

# bitwarden alias
if hash bw 2>/dev/null; then
  alias bw-login='eval "$(bw login | grep -oE --color=never "(export BW_SESSION=".+")")"'
  alias bw-unlock='eval "$(bw unlock | grep -oE --color=never "(export BW_SESSION=".+")")"'
fi

# ░█░█░█▀▀░█░█░█▀▄░▀█▀░█▀█░█▀▄░█▀▀
# ░█▀▄░█▀▀░░█░░█▀▄░░█░░█░█░█░█░▀▀█
# ░▀░▀░▀▀▀░░▀░░▀▀░░▀▀▀░▀░▀░▀▀░░▀▀▀

# https://unix.stackexchange.com/questions/517025/zsh-clear-scrollback-buffer
function clear-scrollback-buffer {
  clear && printf '\e[3J'
  zle && zle .reset-prompt && zle -R
}

zle -N clear-scrollback-buffer
bindkey '^K' clear-scrollback-buffer

# C-backspace to delete previous word
bindkey '^H' backward-kill-word
