# PATH environment
export PATH=$HOME/.bin:$PATH

# login command
chara

# default file and folder permission to 755
umask 022

# Aliases
alias ls=lsd
alias ll='lsd -lA --group-dirs first --total-size'
alias lll='lsd -la --group-dirs first --total-size'
alias lt='lsd --tree'
