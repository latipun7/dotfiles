# ═══════════════════════════════════════════════════════════════════
#  config.nu — Main Configuration
#  Nushell equivalent of .zshrc + zsh-latipun plugin
# ═══════════════════════════════════════════════════════════════════

# ═══════════════════════════════════════════════════════════════════
#  Tool Inits (Auto-generated & cached)
# ═══════════════════════════════════════════════════════════════════
def ensure-init [
    name: string
    filename: string
    generator: closure
] {
    let autoload_dir = ($nu.data-dir | path join "vendor/autoload")
    if not ($autoload_dir | path exists) {
        mkdir $autoload_dir
    }

    let file_path = ($autoload_dir | path join $filename)

    let needs_update = if not ($file_path | path exists) {
        true
    } else {
        let modified = (ls $file_path | get modified.0)
        # Refresh if file age is more than 1 week (1wk)
        if ($modified | is-empty) { true } else { ((date now) - $modified) > 1wk }
    }

    if $needs_update {
        try {
            do $generator | save -f $file_path
        } catch {
            print $"(ansi yellow)Warning: Failed to generate init cache for ($name)(ansi reset)"
        }
    }
}

# ── Execute Generators ─────────────────────────────────────────────
ensure-init "zoxide" "zoxide.nu" {|| zoxide init nushell }
ensure-init "mise" "mise.nu" {|| mise activate nu }
ensure-init "starship" "starship.nu" {|| starship init nu }
ensure-init "fzf" "fzf_integration.nu" {|| fzf --nushell }

# ── Prompt: Starship ──────────────────────────────────────────────
# Install: https://starship.rs | scoop install starship
# Config:  ~/.config/starship.toml  — use a Catppuccin Mocha theme
#          to match the original Powerlevel10k look.
# Init:    starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Transient prompt — after Enter, replace full prompt with just ❯
$env.TRANSIENT_PROMPT_COMMAND = {|| starship module character }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""

# ── History ───────────────────────────────────────────────────────
$env.config.history = {
    file_format: sqlite
    max_size: 1_000_000
    sync_on_enter: true
    isolation: true
}

# ── UI ────────────────────────────────────────────────────────────
$env.config.show_banner = false
$env.config.table.mode = "rounded"
$env.config.table.index_mode = "always"
$env.config.table.show_empty = false
$env.config.footer_mode = "auto"
$env.config.color_config = {
    separator: dark_gray
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    date: yellow
    filesize: cyan
    row_index: green_bold
    bool: light_red
    int: purple
    float: purple
    string: white
    nothing: light_red
    binary: light_red
    cell_path: white
    duration: yellow
    range: yellow
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: { fg: white bg: red attr: b }
}

# ── Edit Mode ─────────────────────────────────────────────────────
$env.config.edit_mode = "emacs"

# ── Completions ───────────────────────────────────────────────────
$env.config.completions = {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: prefix
    external: {
        enable: true
        max_results: 100
        completer: null
    }
}

# ── LS Colors (vivid) ────────────────────────────────────────────
def --env _setup-ls-colors [] {
    if (which vivid | is-empty) { return }
    let vivid_theme = ($env.XDG_CONFIG_HOME? | default ($env.HOME | path join ".config") | path join "vivid" "catppuccin-mocha.yml")
    let vivid_cache = ($env.XDG_CACHE_HOME?  | default ($env.HOME | path join ".cache")  | path join "vivid_colors")

    if ($vivid_theme | path exists) and (not ($vivid_cache | path exists)) {
        mkdir ($vivid_cache | path dirname)
        ^vivid generate $vivid_theme | save -f $vivid_cache
    }
    if ($vivid_cache | path exists) {
        $env.LS_COLORS = (open $vivid_cache | str trim)
    }
}
_setup-ls-colors

# ── Abbreviations ─────────────────────────────────────────────────
# Expand on Space/Enter — the expanded form is what gets saved to history.
$env.config.abbreviations = ($env.config.abbreviations | default {} | merge {
    gc:    "git commit"
    gca:   "git commit --amend"
    gp:    "git push"
    gpl:   "git pull"
    gst:   "git status"
    gco:   "git checkout"
    gsw:   "git switch"
    glog:  "git log --oneline --graph --decorate"
    s:     "sudo"
})

# ═════════════════════════════════════════════════════════════════
#  ALIASES
# ═════════════════════════════════════════════════════════════════

# ── Git ───────────────────────────────────────────────────────────
alias gcob  = git checkout --orphan
alias gmff  = git merge --ff-only
alias gfu   = git fetch upstream
alias grao  = git remote add origin
alias grau  = git remote add upstream
alias grsh  = git remote show

# ── Utilities ─────────────────────────────────────────────────────
alias cm = chezmoi
alias bye = exit
alias top = btop
alias fishes = asciiquarium --transparent

# ── Package Manager (Arch Linux) ──────────────────────────────────
alias yay  = paru
alias yeet = paru -Rns

# ── Eza (Modern replacement for ls) ───────────────────────────────
# Biarkan `ls` bawaan Nushell tetap mengembalikan structured table.

def la [...args] {
    if (which eza | is-empty) { print "eza not found"; return }
    ^eza --long --all --header --group-directories-first --icons --git ...$args
}

def ll [...args] {
    if (which eza | is-empty) { print "eza not found"; return }
    ^eza --long --all --header --group --group-directories-first --icons --git ...$args
}

def lt [...args] {
    if (which eza | is-empty) { print "eza not found"; return }
    ^eza --tree --all --header --group-directories-first --icons --git --ignore-glob ".git|node_modules" ...$args
}

# ── Bat ───────────────────────────────────────────────────────────
alias cat  = bat
alias catp = bat -pp

def cattail [...args] {
    if (which bat | is-empty) { print "bat not found"; return }
    if ($args | any {|a| $a in ["--follow" "-f" "-F"]}) {
        ^tail ...$args | ^bat --paging=never --language=log
    } else {
        ^tail ...$args | ^bat --language=log
    }
}

def catjournal [...args] {
    if (which bat | is-empty) { print "bat not found"; return }
    if ($args | any {|a| $a in ["--follow" "-f" "-F"]}) {
        ^journalctl ...$args | ^bat --paging=never --language=log
    } else {
        ^journalctl ...$args | ^bat --language=log
    }
}

# ── Terminal Integration ──────────────────────────────────────────
alias ssh  = kitty +kitten ssh
alias icat = kitty +kitten icat

# ═════════════════════════════════════════════════════════════════
#  CUSTOM COMMANDS
# ═════════════════════════════════════════════════════════════════

# ── Visual Editor ─────────────────────────────────────────────────
def v [...args] {
    let editor = ($env.VISUAL? | default ($env.EDITOR? | default "nvim"))
    run-external $editor ...$args
}

# ── LF: cd on exit ───────────────────────────────────────────────
def --env lfcd [...args] {
    if (which lf | is-empty) { print "lf not found"; return }
    let dir = (^lf -print-last-dir ...$args)
    if ($dir | is-not-empty) { cd $dir }
}

# ── Yazi: cd on exit ─────────────────────────────────────────────
def --env l [...args] {
    if (which yazi | is-empty) { print "yazi not found"; return }
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    ^yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp | str trim)
    if ($cwd | path exists) and ($cwd != $env.PWD) { cd $cwd }
    rm -fp $tmp
}

# ── Lazygit: cd on exit ──────────────────────────────────────────
def --env lg [...args] {
    if (which lazygit | is-empty) {
        print "lazygit not found"
        return
    }
    let dir_file = ($env.XDG_CONFIG_HOME? | default ($env.HOME | path join ".config") | path join "lazygit" "newdir")
    $env.LAZYGIT_NEW_DIR_FILE = $dir_file
    ^lazygit ...$args
    if ($dir_file | path exists) {
        cd (open $dir_file | str trim)
        rm -f $dir_file
    }
}

# ── Lazydocker ────────────────────────────────────────────────────
alias lzd = lazydocker

# ── Bitwarden ─────────────────────────────────────────────────────
def --env bw-login [] {
    if (which bw | is-empty) { print "bw not found"; return }
    $env.BW_SESSION = (^bw login --raw)
}
def --env bw-unlock [] {
    if (which bw | is-empty) { print "bw not found"; return }
    $env.BW_SESSION = (^bw unlock --raw)
}

# ── Clipboard ─────────────────────────────────────────────────────
# Detects backend once per call. Supports Windows, macOS, WSL,
# and native Linux (Wayland/X11).
def _clip-apply [] {
    let data = $in
    match $nu.os-info.name {
        "windows" => { $data | ^clip.exe }
        "macos"   => { $data | ^pbcopy }
        _ => {
            if ($env.WSL_DISTRO_NAME? | is-not-empty) {
                if (which wl-copy | is-not-empty) {
                    $data | ^wl-copy
                } else if (which win32yank.exe | is-not-empty) {
                    $data | ^win32yank.exe -i --crlf
                } else if (which pwsh.exe | is-not-empty) {
                    $data | ^pwsh.exe -NoProfile -NonInteractive -Command "[Console]::InputEncoding = [System.Text.Encoding]::UTF8; Set-Clipboard -Value ([Console]::In.ReadToEnd())"
                } else {
                    $data | ^powershell.exe -NoProfile -NonInteractive -Command "[Console]::InputEncoding = [System.Text.Encoding]::UTF8; Set-Clipboard -Value ([Console]::In.ReadToEnd())"
                }
            } else {
                if (which wl-copy | is-not-empty) {
                    $data | ^wl-copy
                } else if (which xclip | is-not-empty) {
                    $data | ^xclip -selection clipboard
                } else if (which xsel | is-not-empty) {
                    $data | ^xsel --clipboard --input
                } else {
                    print -e "Error: No clipboard backend found."
                }
            }
        }
    }
}

def clip [...args: string] {
    let stdin = $in
    if ($stdin | is-not-empty) {
        # Piped: echo "text" | clip
        $stdin | _clip-apply
    } else if ($args | length) == 1 and ($args.0 | path exists) {
        # File: clip filename.txt
        open $args.0 | _clip-apply
    } else if ($args | length) > 0 {
        # String: clip "Hello World"
        ($args | str join " ") | _clip-apply
    } else {
        print -e "Usage: clip [FILE|TEXT] or pipe via stdin (e.g., echo 'text' | clip)"
    }
}

# ── Git: reset to upstream ────────────────────────────────────────
def _git-current-branch [] {
    try { ^git branch --show-current | str trim } catch { "main" }
}

def gruh [] {
    let branch = (_git-current-branch)
    git reset --hard $"upstream/($branch)"
}

# ── Package Lists (Arch Linux) ────────────────────────────────────
def backup-packages-list [] {
    if (which pacman | is-empty) or ((which yay | is-empty) and (which paru | is-empty)) {
        print "pacman + yay/paru not found"
        return
    }
    let base_pkgs = try { ^expac -l "\n" "%E" base base-devel | lines | sort } catch { [] }
    let installed = (^yay -Qqe | lines | sort)
    let custom = ($installed | where {|p| $p not-in $base_pkgs })
    $custom | str join "\n" | save -f ($env.HOME | path join "Documents" "packages.list")
}

def get-packages-list [] {
    if (which pacman | is-empty) or ((which yay | is-empty) and (which paru | is-empty)) {
        print "pacman + yay/paru not found"
        return
    }
    let list = ($env.HOME | path join "Documents" "packages.list")
    if not ($list | path exists) { backup-packages-list }
    open $list | lines | each {|p| $p | str trim } | where {|p| $p | is-not-empty }
}

# ═════════════════════════════════════════════════════════════════
#  KEYBINDINGS
# ═════════════════════════════════════════════════════════════════

def push-viewport [] {
    let rows = (try { (term size).rows } catch { 24 })
    print (seq 1 $rows | each {|| char newline} | str join "")
}

def clear-scrollback [] {
    print $"(char -u "001b")[3J"
    clear
    push-viewport
}

$env.config.keybindings ++= [
    # Ctrl+K — Clear scrollback buffer (like zsh)
    {
        name: clear_scrollback
        modifier: control
        keycode: char_k
        mode: [emacs vi_insert vi_normal]
        event: { send: executehostcommand cmd: "clear-scrollback" }
    }
    # Ctrl+L — Push viewport / soft clear (like zsh, overrides default clear)
    {
        name: push_viewport
        modifier: control
        keycode: char_l
        mode: [emacs vi_insert vi_normal]
        event: { send: executehostcommand cmd: "push-viewport" }
    }
    # Ctrl+Backspace (Ctrl+H) — Kill previous word
    {
        name: backward_kill_word
        modifier: control
        keycode: char_h
        mode: emacs
        event: { edit: CutWordLeft }
    }
    # Ctrl+Space — Accept history hint (autosuggestion)
    {
        name: accept_autosuggestion
        modifier: control
        keycode: Space
        mode: emacs
        event: { send: HistoryHintComplete }
    }
]

# Push prompt to bottom on startup
push-viewport
