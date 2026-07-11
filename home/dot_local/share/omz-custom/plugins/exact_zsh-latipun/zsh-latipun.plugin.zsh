# ░▀█▀░█░█░█▀▀░█▀█░█░█░█▀▀
# ░░█░░█▄█░█▀▀░█▀█░█▀▄░▀▀█
# ░░▀░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀

# Default file and folder mask permission
umask 022

# Activate node if defined as a function
(( $+functions[node] )) && node -v &>/dev/null

# Activate zoxide
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# NPM completion (cached for faster startup)
if (( $+commands[npm] )); then
  local npm_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/npm_completion"
  if [[ ! -f "$npm_cache" ]]; then
    mkdir -p "${npm_cache:h}"
    npm completion > "$npm_cache" 2>/dev/null
  fi
  source "$npm_cache"
fi

# Populate LS_COLORS via vivid (cached and auto-updated when config changes)
if (( $+commands[vivid] )); then
  local vivid_theme="${XDG_CONFIG_HOME:-$HOME/.config}/vivid/catppuccin-mocha.yml"
  local vivid_cache="${XDG_CACHE_HOME:-$HOME/.cache}/vivid_colors"

  if [[ ! -f "$vivid_cache" || "$vivid_theme" -nt "$vivid_cache" ]]; then
    mkdir -p "${vivid_cache:h}"
    vivid generate "$vivid_theme" > "$vivid_cache" 2>/dev/null
  fi

  export LS_COLORS="$(< "$vivid_cache")"
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# ░█▀█░█░░░▀█▀░█▀█░█▀▀░█▀▀░█▀▀
# ░█▀█░█░░░░█░░█▀█░▀▀█░█▀▀░▀▀█
# ░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

# Git aliases
alias gcob='git checkout --orphan'
alias gmff='git merge --ff-only'
alias gfu='git fetch upstream'
alias grao='git remote add origin'
alias grau='git remote add upstream'
alias grsh='git remote show'
alias gruh='git reset --hard upstream/$(git_current_branch 2>/dev/null || echo main)'

alias v='$VISUAL'
alias cm=chezmoi

# Utility aliases
(( $+commands[btop] )) && alias top=btop
(( $+commands[asciiquarium] )) && alias fishes='asciiquarium --transparent'

# Paru / Pacman aliases & functions
if (( $+commands[paru] )); then
  alias yay=paru
  alias yeet='paru -Rns'
fi

if (( $+commands[pacman] )) && (( $+commands[yay] || $+commands[paru] )); then
  backup-packages-list() {
    comm -23 <(yay -Qqe | sort) <({ expac -l '\n' '%E' base base-devel 2>/dev/null } | sort -u) > "$HOME/Documents/packages.list"
  }

  get-packages-list() {
    [[ -s "$HOME/Documents/packages.list" ]] || backup-packages-list
    xargs < "$HOME/Documents/packages.list"
  }
fi

# Eza alias
if (( $+commands[eza] )); then
  alias ls='eza --long --all --header --group-directories-first --icons --git'
  alias ll='eza --long --all --header --group --group-directories-first --icons --git'
  alias lt='eza --tree --all --header --group-directories-first --icons --git --ignore-glob ".git|node_modules"'
fi

# Bat alias & log helpers
if (( $+commands[bat] )); then
  alias cat=bat
  alias catp='bat -pp'

  cattail() {
    echo "$*"
    if [[ "$*" == *(--follow|-[Ff])* ]]; then
      tail "$@" | bat --paging=never --language=log
    else
      tail "$@" | bat --language=log
    fi
  }
  compdef _tail cattail

  catjournal() {
    if [[ "$*" == *(--follow|-[Ff])* ]]; then
      journalctl "$@" | bat --paging=never --language=log
    else
      journalctl "$@" | bat --language=log
    fi
  }
  compdef _journalctl catjournal
fi

# Terminal integration
if [[ "$TERM" == *kitty* ]]; then
  alias ssh='kitty +kitten ssh'
  alias icat='kitty +kitten icat'
elif [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
  alias icat='wezterm imgcat'
fi

# LF integration
if (( $+commands[lf] )); then
  lfcd() {
    local dir
    dir="$(command lf -print-last-dir "$@")" && cd -- "$dir"
  }
fi

# Yazi integration
if (( $+commands[yazi] )); then
  yy() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(< "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
  compdef _yazi yy
  alias l=yy
fi

# Lazygit integration
if (( $+commands[lazygit] )); then
  lg() {
    export LAZYGIT_NEW_DIR_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/lazygit/newdir"
    lazygit "$@"
    if [[ -f "$LAZYGIT_NEW_DIR_FILE" ]]; then
      cd -- "$(< "$LAZYGIT_NEW_DIR_FILE")"
      rm -f -- "$LAZYGIT_NEW_DIR_FILE" >/dev/null
    fi
  }
fi

(( $+commands[lazydocker] )) && alias lzd=lazydocker

# Bitwarden functions
if (( $+commands[bw] )); then
  bw-login() { export BW_SESSION="$(bw login --raw)"; }
  bw-unlock() { export BW_SESSION="$(bw unlock --raw)"; }
fi

# WSL-specific settings
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  alias cbcopy="iconv -f utf8 -t utf16 | clip.exe"
fi

# ░█░█░█▀▀░█░█░█▀▄░▀█▀░█▀█░█▀▄░█▀▀
# ░█▀▄░█▀▀░░█░░█▀▄░░█░░█░█░█░█░▀▀█
# ░▀░▀░▀▀▀░░▀░░▀▀░░▀▀▀░▀░▀░▀▀░░▀▀▀

clear-scrollback-buffer() {
  clear && printf '\e[3J' && printf '\n%.0s' {1..$(( $(tput lines) - 1 ))}
  zle && zle .reset-prompt && zle -R
}
zle -N clear-scrollback-buffer

push-viewport() {
  printf '\n%.0s' {1..$(( $(tput lines) ))}
  zle && zle .reset-prompt && zle -R
}
zle -N push-viewport

# Keybindings
bindkey '^K' clear-scrollback-buffer
bindkey '^L' push-viewport
bindkey '^H' backward-kill-word # <C-BS>
bindkey '^V' describe-key-briefly

# Menu selection navigation
bindkey -M menuselect '^N' down-history
bindkey -M menuselect '^P' up-history
bindkey -M menuselect '^J' down-history
bindkey -M menuselect '^K' up-history
bindkey -M menuselect '^L' forward-char
bindkey -M menuselect '^H' backward-char

# Tab & Shift-Tab completion menu controls
bindkey '\t' down-line-or-select
[[ -n "$terminfo[kcbt]" ]] && bindkey "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect '\t' menu-complete
[[ -n "$terminfo[kcbt]" ]] && bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

# Autosuggestions trigger
bindkey '^ ' autosuggest-accept # <C-Space>
