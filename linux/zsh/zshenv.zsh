#########################
# Environment Variables #
#########################

# Make linuxbrew PATH available before sourcing OMZ
if [[ "$OSTYPE" == linux-gnu ]]; then
  [ -d "/home/linuxbrew/.linuxbrew" ] &&
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  [ -d "$HOME/.linuxbrew" ] &&
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == darwin* ]]; then
  [ -d "/usr/local/Cellar" ] &&
    eval "$(/usr/local/bin/brew shellenv)"
else
  echo "homebrew not available in the current OS type."
fi

# FNM Shell Setup
if [ -d "$HOME/.fnm" ]; then
  export PATH=$HOME/.fnm:$PATH
fi

if hash fnm &>/dev/null; then
  eval "$(fnm env --shell zsh | sed -e 's/PATH="\(.*\)":\$PATH/PATH="\1:$PATH"/g')"
fi

# default directory of this dotfiles
export DOTFILES="$HOME/.files"

source "$DOTFILES/linux/bin/lib/_functions.sh"

pythonexe=$(hash brew 2>/dev/null && echo "$(brew --prefix)/opt/python/libexec/bin")
homeexe="$HOME/.bin:$HOME/.local/bin"
pathexe=("$homeexe" "$pythonexe" "$PATH")
export PATH=$(concat ":" "${pathexe[@]}")

if hash fnm 2>/dev/null && hash node 2>/dev/null; then
  nodelink=$(readlink -e "$(which node)")
  NODE_PATH=$(cd "${nodelink:0:-4}../lib/node_modules" && pwd)
  export NODE_PATH
fi

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

if [ -f "$HOME/.zshenv.private" ]; then
  source "$HOME/.zshenv.private"
fi
