#=======================#
#    General Tweaks     #
#=======================#

# default file and folder mask permission
umask 022

# activate node
[[ "$(type node)" == *function* ]] && node -v &>/dev/null

#=======================#
#         Aliases       #
#=======================#

alias psudo='sudo env PATH="$PATH"'
alias openvpn-install='curl -fsLS https://git.io/vpn | sudo bash'

# git alias
alias gcob='git checkout --orphan'
alias gmff='git merge --ff-only'
alias gfu='git fetch upstream'
alias grao='git remote add origin'
alias grau='git remote add upstream'
alias grsh='git remote show'
alias gruh='git reset --hard upstream/$(git_current_branch)'

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

# nvim alias
hash nvim 2>/dev/null && alias v=nvim

# nnn alias
if hash nnn 2>/dev/null; then
  function n() {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
      echo "nnn is already running"
      return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, either remove the "export" as in:
    #    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    #    (or, to a custom path: NNN_TMPFILE=/tmp/.lastd)
    # or, export NNN_TMPFILE after nnn invocation
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

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

#=======================#
#    ZSH Keybindings    #
#=======================#

# C-backspace to delete previous word
bindkey '^H' backward-kill-word
