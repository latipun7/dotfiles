#########################
#     Login Command     #
#########################

hash chara 2>/dev/null && chara

#########################
#    General Tweaks     #
#########################

# default file and folder mask permission
umask 022

# activate node
[[ "$(type node)" == *function* ]] && node -v &>/dev/null

#########################
#         Aliases       #
#########################

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
  alias ls=lsd
  alias l='lsd -la --group-dirs first'
  alias ll='lsd -lA --group-dirs first --total-size'
  alias lll='lsd -la --group-dirs first --total-size'
  alias lt='lsd --tree -A --group-dirs first'
fi

# bat alias
if hash bat 2>/dev/null; then
  alias cat=bat
  alias catp='bat -pp'

  function cattail() {
    tail "$@" | bat --paging=never -l log
  }
fi

# nvim alias
hash nvim 2>/dev/null && alias vi=nvim

# bitwarden alias
if hash bw 2>/dev/null; then
  alias bw-login='eval "$(bw login | grep -oE --color=never "(export BW_SESSION=".+")")"'
  alias bw-unlock='eval "$(bw unlock | grep -oE --color=never "(export BW_SESSION=".+")")"'
fi

#########################
#    ZSH Keybindings    #
#########################

# C-backspace to delete previous word
bindkey '^H' backward-kill-word
