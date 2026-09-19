# ═══════════════════════════════════════════════════════════════════
#  env.nu — Environment Variables
#  Nushell equivalent of .zshenv
#  XDG: Linux only. Windows/macOS use platform defaults.
# ═══════════════════════════════════════════════════════════════════

# ── Home directory (Windows doesn't set $env.HOME by default) ─────
if ($env.HOME? | is-empty) {
    $env.HOME = $env.USERPROFILE
}

# ── XDG Base Directories (Linux only) ─────────────────────────────
if ($nu.os-info.name == "linux") {
    $env.XDG_CONFIG_HOME = ($env.XDG_CONFIG_HOME? | default ($env.HOME | path join ".config"))
    $env.XDG_CACHE_HOME  = ($env.XDG_CACHE_HOME?  | default ($env.HOME | path join ".cache"))
    $env.XDG_DATA_HOME   = ($env.XDG_DATA_HOME?   | default ($env.HOME | path join ".local" "share"))
    $env.XDG_STATE_HOME  = ($env.XDG_STATE_HOME?  | default ($env.HOME | path join ".local" "state"))
}

# ── Tool Home Directories (Linux only) ────────────────────────────
# On Windows/macOS, these tools use their own default paths.
if ($nu.os-info.name == "linux") {
    $env.npm_config_userconfig = ($env.XDG_CONFIG_HOME | path join "npmrc")
    $env.YARN_CACHE_FOLDER     = ($env.XDG_CACHE_HOME  | path join "yarn")
    $env.YARN_GLOBAL_FOLDER    = ($env.XDG_DATA_HOME   | path join "yarn")
    $env.RUSTUP_HOME           = ($env.XDG_DATA_HOME   | path join "rustup")
    $env.CARGO_HOME            = ($env.XDG_DATA_HOME   | path join "cargo")
    $env.TERMINFO              = ($env.XDG_DATA_HOME   | path join "terminfo")
    $env.TERMINFO_DIRS         = $"($env.TERMINFO):/usr/share/terminfo"
    $env.GOPATH                = ($env.XDG_DATA_HOME   | path join "go")
    $env.WGETRC                = ($env.XDG_CONFIG_HOME | path join "wgetrc")
    $env.NODE_REPL_HISTORY     = ($env.XDG_DATA_HOME   | path join "node_repl_history")
    $env.WAKATIME_HOME         = ($env.XDG_CONFIG_HOME | path join "wakatime")
    $env.PM2_HOME              = ($env.XDG_CACHE_HOME  | path join "pm2")
    $env.PSQLRC                = ($env.XDG_CONFIG_HOME | path join "pg" "psqlrc")
    $env.PGPASSFILE            = ($env.XDG_CONFIG_HOME | path join "pg" "pgpass")
    $env.PSQL_HISTORY          = ($env.XDG_STATE_HOME  | path join "psql_history")
    $env.PGSERVICEFILE         = ($env.XDG_CONFIG_HOME | path join "pg" "pg_service.conf")
    $env.CUDA_CACHE_PATH       = ($env.XDG_CACHE_HOME  | path join "nv")
    $env.HARMONOID_CACHE_DIR   = ($env.XDG_CACHE_HOME  | path join "harmonoid")
}

# ── PATH ──────────────────────────────────────────────────────────
use std/util "path add"

# Homebrew (macOS: /opt/homebrew, Linux: linuxbrew)
if ($nu.os-info.name == "macos") and ("/opt/homebrew/bin/brew" | path exists) {
    $env.HOMEBREW_PREFIX = "/opt/homebrew"
    $env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
    $env.HOMEBREW_REPOSITORY = "/opt/homebrew"
    path add "/opt/homebrew/bin"
    path add "/opt/homebrew/sbin"
} else if ($nu.os-info.name == "linux") {
    for brew in ["/home/linuxbrew/.linuxbrew" ($env.HOME | path join ".linuxbrew")] {
        if ($brew | path join "bin" "brew" | path exists) {
            $env.HOMEBREW_PREFIX = $brew
            $env.HOMEBREW_CELLAR = ($brew | path join "Cellar")
            $env.HOMEBREW_REPOSITORY = ($brew | path join "Homebrew")
            path add ($brew | path join "bin")
            path add ($brew | path join "sbin")
            break
        }
    }
}

# Local bin
let local_bin = ($env.HOME | path join ".local" "bin")
if ($local_bin | path exists) { path add $local_bin }

# Mise shims
let mise_shims = ($env.XDG_DATA_HOME? | default ($env.HOME | path join ".local" "share") | path join "mise" "shims")
if ($mise_shims | path exists) { path add $mise_shims }

# Cargo bin
let cargo_bin = if ($env.CARGO_HOME? | is-not-empty) {
    $env.CARGO_HOME | path join "bin"
} else {
    $env.HOME | path join ".cargo" "bin"
}
if ($cargo_bin | path exists) { path add $cargo_bin }

# Go bin
let go_bin = if ($env.GOPATH? | is-not-empty) {
    $env.GOPATH | path join "bin"
} else {
    $env.HOME | path join "go" "bin"
}
if ($go_bin | path exists) { path add $go_bin }

# Node global modules
if (which node | is-not-empty) {
    if ($nu.os-info.name == "windows") {
        $env.NODE_PATH = ($env.APPDATA | path join "npm" "node_modules")
    } else {
        let node_bin = (which node | first | get path)
        $env.NODE_PATH = ($node_bin | path dirname | path dirname | path join "lib" "node_modules")
    }
}

# ── fzf (Catppuccin Mocha) ───────────────────────────────────────
if (which fzf | is-not-empty) {
    $env.FZF_DEFAULT_OPTS = (
        "--border --tabstop=2"
        + " --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
        + " --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
        + " --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    )
    if (which fd | is-not-empty) {
        $env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow"
        $env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
    }
}

# ── GPG Agent (Unix only) ────────────────────────────────────────
if ($nu.os-info.name != "windows") {
    $env.GPG_TTY = (tty)
}

# ── Bat as man pager ─────────────────────────────────────────────
if (which bat | is-not-empty) {
    $env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
    $env.MANROFFOPT = "-c"
    $env.BAT_CONFIG_DIR = ($env.HOME | path join ".config" "bat")
}

# ── Misc ──────────────────────────────────────────────────────────
$env.LESS = "--RAW-CONTROL-CHARS --ignore-case"
$env.FORCE_COLOR = "true"
