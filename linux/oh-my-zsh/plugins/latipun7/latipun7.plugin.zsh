########################
#   PATH environment   #
########################
export PATH=$HOME/.bin:$PATH

########################
#    Login Command     #
########################
chara

########################
#   General Tweaks     #
########################

# default file and folder permission to 755
umask 022

# default editor
export EDITOR=vim

# batman syntax highlight -> https://github.com/sharkdp/bat#man
if hash bat 2>/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# fzf base dir
export FZF_BASE=$(command -v fzf)

########################
#        Aliases       #
########################

# lsd alias
if hash bat 2>/dev/null; then
  alias ls=lsd
  alias ll='lsd -lA --group-dirs first --total-size'
  alias lll='lsd -la --group-dirs first --total-size'
  alias lt='lsd --tree'
fi

# bat alias
if hash bat 2>/dev/null; then
  alias cat=bat
fi

########################
#   ZSH Keybindings    #
########################

# C-backspace to delete previous word
bindkey '^H' backward-kill-word

########################
#   ZSH Completions    #
########################

# brew completion
if hash brew 2>/dev/null; then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

autoload -Uz compinit && compinit
