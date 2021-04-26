#########################
# Environment Variables #
#########################

# default directory of this dotfiles
export DOTFILES="$HOME/.files"

pythonlink=$(hash brew 2>/dev/null && echo ":$(brew --prefix)/opt/python/libexec/bin")
export PATH=$HOME/.bin:/usr/share/doc/git/contrib/credential/netrc$pythonlink:$PATH

export NODE_PATH=$HOME/.config/yarn/global/node_modules

export DOCKER_HOST="tcp://127.0.0.1:2375"

# default editor
export EDITOR=nvim
export SUDO_EDITOR=nvim

# Invoking gpg-agent
# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
# GPG_TTY="$(tty)" see: romkatv/powerlevel10k#524
export GPG_TTY="$TTY"

# batman syntax highlight for man pages -> https://github.com/sharkdp/bat#man
hash bat 2>/dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

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
alias openvpn-install='curl -fsLSo "$HOME/openvpn-install.sh" https://git.io/vpn && bash "$HOME/openvpn-install.sh"'

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
hash bat 2>/dev/null && alias cat=bat

# nvim alias
hash nvim 2>/dev/null && alias vi=nvim

#########################
#    ZSH Keybindings    #
#########################

# C-backspace to delete previous word
bindkey '^H' backward-kill-word

#########################
#    ZSH Completions    #
#########################

# brew completion
hash brew 2>/dev/null &&
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)

autoload -Uz compinit && compinit
