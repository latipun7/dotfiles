# ═══════════════════════════════════════════════════════════════════
#  login.nu — Login Greeting
#  Nushell equivalent of .zlogin
#  Only runs when Nushell is started as a login shell (nu -l).
# ═══════════════════════════════════════════════════════════════════

if (which chara | is-empty) {
    return
}

let width = ((term size).columns - 8)
let has_lolcat = (which lolcat | is-not-empty)

if (which fortune | is-not-empty) {
    if $has_lolcat {
        ^fortune | ^lolcat -f | ^chara say --random $"--width=($width)"
    } else {
        ^fortune | ^chara say --random $"--width=($width)"
    }
} else if (which rfortune | is-not-empty) {
    if $has_lolcat {
        ^rfortune | ^lolcat -f | ^chara say --random $"--width=($width)"
    } else {
        ^rfortune | ^chara say --random $"--width=($width)"
    }
}
