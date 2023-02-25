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

# populate LS_COLORS
if hash vivid 2>/dev/null; then
  LS_COLORS="$(vivid generate ~/.config/vivid/catppuccin-mocha.yml)"
  export LS_COLORS

  # take advantage of LS_COLORS for zsh completion
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
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

if hash btop 2>/dev/null; then
  alias top=btop
fi

if hash asciiquarium 2>/dev/null; then
  alias fishes='asciiquarium --transparent'
fi

# paru alias
if hash paru 2>/dev/null; then
  alias yay=paru
  alias yeet='paru -Rns'
fi

if hash pacman 2>/dev/null && hash yay 2>/dev/null; then
  function backup-packages-list() {
    comm -23 <(yay -Qqe | sort) <({ yay -Qqg base-devel; expac -l '\n' '%E' base; echo 'base' } | sort -u) > "$HOME/Documents/packages.list"
  }

  function get-packages-list() {
    if ! [[ -s "$HOME/Documents/packages.list" ]]; then
      backup-packages-list
    fi
    cat "$HOME/Documents/packages.list" | xargs
  }
fi

# exa alias
if hash exa 2>/dev/null; then
  alias ls='exa --long --all --header --group-directories-first --icons --git'
  alias ll='exa --long --all --header --group --group-directories-first --icons --git'
  alias lt='exa --tree --all --header --group-directories-first --icons --git --ignore-glob ".git|node_modules"'
fi

# bat alias
if hash bat 2>/dev/null; then
  alias cat=bat
  alias catp='bat -pp'

  function cattail() {
    echo "$*"
    if [[ "$*" == *(--follow|-[Ff] )* ]]; then
      tail "$@" | bat --paging=never --language=log
    else
      tail "$@" | bat --language=log
    fi
  }
  compdef _tail cattail

  function catjournal() {
    if [[ "$*" == *(--follow|-[Ff] )* ]]; then
      journalctl "$@" | bat --paging=never --language=log
    else
      journalctl "$@" | bat --language=log
    fi
  }
  compdef _journalctl catjournal
fi

# terminal alias
if [[ "$TERM" == *kitty* ]]; then
  alias ssh='kitty +kitten ssh'
  alias icat='kitty +kitten icat'
elif [[ "$TERM_PROGRAM" == WezTerm ]]; then
  alias icat='wezterm imgcat'
fi

# lf alias
if hash lf 2>/dev/null; then
  function lfcd() {
    tmp="$(mktemp -t lf-cd-XXXXXX)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
      dir="$(cat "$tmp")"
      rm -f "$tmp"
      if [ -d "$dir" ]; then
        if [ "$dir" != "$(pwd)" ]; then
          cd "$dir"
        fi
      fi
    fi
  }
  compdef _lf lfcd

  alias l=lfcd
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
  alias bw-login='eval "export BW_SESSION=$(bw login --raw)"'
  alias bw-unlock='eval "export BW_SESSION=$(bw unlock --raw)"'
fi

# ░█░█░█▀▀░█░█░█▀▄░▀█▀░█▀█░█▀▄░█▀▀
# ░█▀▄░█▀▀░░█░░█▀▄░░█░░█░█░█░█░▀▀█
# ░▀░▀░▀▀▀░░▀░░▀▀░░▀▀▀░▀░▀░▀▀░░▀▀▀

# https://unix.stackexchange.com/questions/517025/zsh-clear-scrollback-buffer
# https://github.com/romkatv/powerlevel10k/issues/563#issuecomment-599010321
function clear-scrollback-buffer {
  clear && printf '\e[3J' && printf '\n%.0s' {1..$(( $(tput lines) - 1 ))}
  zle && zle .reset-prompt && zle -R
}
zle -N clear-scrollback-buffer

function push-viewport {
  printf '\n%.0s' {1..$(( $(tput lines) ))}
  zle && zle .reset-prompt && zle -R
}
zle -N push-viewport

bindkey '^K' clear-scrollback-buffer
bindkey '^L' push-viewport
bindkey '^H' backward-kill-word # <C-BS>
bindkey '^V' describe-key-briefly
bindkey -M menuselect '^N' down-history
bindkey -M menuselect '^P' up-history
bindkey -M menuselect '^J' down-history
bindkey -M menuselect '^K' up-history
bindkey -M menuselect '^L' forward-char
bindkey -M menuselect '^H' backward-char

# need zsh-autosuggestions plugin above this plugin
bindkey '^ ' autosuggest-accept # <C-Space>

# need zsh-autocomplete plugin above this plugin
bindkey '^N' down-line-or-select
bindkey '^P' up-line-or-search
