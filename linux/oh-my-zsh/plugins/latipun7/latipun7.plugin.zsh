########################
#   PATH environment   #
########################
export PATH=$HOME/.bin:/usr/share/doc/git/contrib/credential/libsecret:$PATH

########################
#    Login Command     #
########################
hash chara 2>/dev/null && chara

########################
#   General Tweaks     #
########################

# default file and folder mask permission
umask 022

# default directory of this dotfiles
export DOTFILES="$HOME/.files"

# launch dbus use for git-credential-libsecret
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  eval "$(dbus-launch --sh-syntax)"
fi

# default editor
export EDITOR=nvim
export SUDO_EDITOR=nvim

# batman syntax highlight for man pages -> https://github.com/sharkdp/bat#man
hash bat 2>/dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# activate node
[[ "$(type node)" = *function* ]] && node -v &>/dev/null

########################
#        Aliases       #
########################

alias psudo="sudo env \"PATH=$PATH\""

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

########################
#   ZSH Keybindings    #
########################

# C-backspace to delete previous word
bindkey '^H' backward-kill-word

########################
#   ZSH Completions    #
########################

# brew completion
hash brew 2>/dev/null &&
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)

autoload -Uz compinit && compinit
