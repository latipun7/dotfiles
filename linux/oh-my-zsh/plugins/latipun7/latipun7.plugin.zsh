########################
#   PATH environment   #
########################
export PATH=$HOME/.bin:$PATH

# linuxbrew PATH

##- linux OS
if [[ "$OSTYPE" == linux-gnu ]]; then

  # make homebrew available in sudo linux install
  if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv);
  fi

  # make available in non sudo linux install
  if [ -d "$HOME/.linuxbrew" ]; then
    eval $($HOME/.linuxbrew/bin/brew shellenv);
  fi

##- macOS
elif [[ "$OSTYPE" == darwin* ]]; then
  # prevents error of % popping up in terminal on login
  setopt PROMPT_CR
  setopt PROMPT_SP
  export PROMPT_EOL_MARK=""

  # make homebrew available in sudo mac install
  if [ -d "/usr/local/Cellar" ]; then
    eval $(/usr/local/bin/brew shellenv);
  fi

else
   echo "homebrew not available in the current OS type.";
fi

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
