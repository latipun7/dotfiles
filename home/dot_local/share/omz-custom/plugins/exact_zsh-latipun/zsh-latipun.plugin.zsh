# ░▀█▀░█░█░█▀▀░█▀█░█░█░█▀▀
# ░░█░░█▄█░█▀▀░█▀█░█▀▄░▀▀█
# ░░▀░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀

# default file and folder mask permission
umask 022

# activate node
[[ "$(type node)" == *function* ]] && node -v &>/dev/null

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
    tail "$@" | bat --paging=never -l log
  }
  compdef _tail cattail

  function catjournal() {
    journalctl "$@" | bat --paging=never -l log
  }
  compdef _journalctl catjournal
fi

# editor alias
alias v='$VISUAL'

# kitens alias
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

# bitwarden alias
if hash bw 2>/dev/null; then
  alias bw-login='eval "$(bw login | grep -oE --color=never "(export BW_SESSION=".+")")"'
  alias bw-unlock='eval "$(bw unlock | grep -oE --color=never "(export BW_SESSION=".+")")"'
fi

# ░█░█░█▀▀░█░█░█▀▄░▀█▀░█▀█░█▀▄░█▀▀
# ░█▀▄░█▀▀░░█░░█▀▄░░█░░█░█░█░█░▀▀█
# ░▀░▀░▀▀▀░░▀░░▀▀░░▀▀▀░▀░▀░▀▀░░▀▀▀

# C-backspace to delete previous word
bindkey '^H' backward-kill-word
