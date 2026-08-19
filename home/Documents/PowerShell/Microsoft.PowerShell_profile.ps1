using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# ==============================================================================
# [1] SHELL INITIALIZATION & ENCODING
# ==============================================================================

# Force PowerShell to use UTF-8 for everything (Fixes the Starship '?' issue)
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8


# ==============================================================================
# [2] ENVIRONMENT VARIABLES
# ==============================================================================

$env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.config\komorebi"

if (Get-Command fzf -ErrorAction SilentlyContinue) {
    $env:FZF_DEFAULT_OPTS = "--border --tabstop=2 " +
        "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 " +
        "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc " +
        "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

    if (Get-Command fd -ErrorAction SilentlyContinue) {
        $env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow'
        $env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
    }
}


# ==============================================================================
# [3] ALIASES & FUNCTIONS
# ==============================================================================

Set-Alias cm chezmoi

function bye { exit }

# Eza integration
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -ErrorAction SilentlyContinue
    # Note: Using @args instead of $args safely passes parameters to native binaries
    function ls { eza --long --all --header --group-directories-first --icons --git @args }
    function ll { eza --long --all --header --group --group-directories-first --icons --git @args }
    function lt { eza --tree --all --header --group-directories-first --icons --git --ignore-glob ".git|node_modules" @args }
}

# Bat integration
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Remove-Item Alias:cat -ErrorAction SilentlyContinue
    function cat  { bat @args }
    function catp { bat -pp @args }

    function cattail {
        if ($args -match "^--follow$|^-[Ff]$") {
            tail @args | bat --paging=never --language=log
        } else {
            tail @args | bat --language=log
        }
    }
}

# Yazi integration
if (Get-Command yazi -ErrorAction SilentlyContinue) {
    function yy {
        $tmp = [System.IO.Path]::GetTempFileName()
        yazi @args --cwd-file="$tmp"
        $cwd = Get-Content $tmp -Raw -ErrorAction SilentlyContinue
        if ($cwd -and $cwd -ne $PWD.Path) { Set-Location $cwd }
        Remove-Item $tmp -ErrorAction SilentlyContinue
    }
    Set-Alias l yy
}

# Lazygit integration
if (Get-Command lazygit -ErrorAction SilentlyContinue) {
    function lg {
        $configHome = if ($env:XDG_CONFIG_HOME) { "$env:XDG_CONFIG_HOME" } else { "$HOME/.config" }
        $env:LAZYGIT_NEW_DIR_FILE = "$configHome/lazygit/newdir"
        lazygit @args
        if (Test-Path $env:LAZYGIT_NEW_DIR_FILE) {
            Set-Location (Get-Content $env:LAZYGIT_NEW_DIR_FILE -Raw)
            Remove-Item $env:LAZYGIT_NEW_DIR_FILE -ErrorAction SilentlyContinue
        }
    }
}

# Smart Clipboard
function clip {
    if (-not [Console]::IsInputRedirected) {
        if ($args.Count -eq 1 -and (Test-Path $args[0])) {
            Get-Content $args[0] -Raw | Set-Clipboard
        } elseif ($args.Count -gt 0) {
            $args -join " " | Set-Clipboard
        } else {
            Write-Warning "Usage: clip [FILE|TEXT] or pipe via stdin (e.g., echo 'text' | clip)"
        }
    } else {
        $input | Set-Clipboard
    }
}


# ==============================================================================
# [4] PSREADLINE & KEYBINDINGS
# ==============================================================================

Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# --- Custom Bindings ---
Set-PSReadLineKeyHandler -Key 'Ctrl+Spacebar' -Function AcceptSuggestion
# Set-PSReadLineKeyHandler -Key 'Tab' -Function MenuComplete
Set-PSReadLineKeyHandler -Key 'Ctrl+Backspace' -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# ^L (Push viewport / line breaks)
Set-PSReadLineKeyHandler -Key 'Ctrl+l' -ScriptBlock {
    if ($Host.UI.RawUI.WindowSize.Height) {
        [Console]::Write([string]::new([char]10, $Host.UI.RawUI.WindowSize.Height))
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

# ^K (Clear screen, clear scrollback, AND push viewport)
Set-PSReadLineKeyHandler -Key 'Ctrl+k' -ScriptBlock {
    [Console]::Write("`e[2J`e[3J`e[H")
    if ($Host.UI.RawUI.WindowSize.Height) {
        [Console]::Write([string]::new([char]10, $Host.UI.RawUI.WindowSize.Height))
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

#region PSReadLine Advanced Sample
# (Inspiration from: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1)

# F7 History View
Set-PSReadLineKeyHandler -Key F7 -BriefDescription History -LongDescription 'Show command history' -ScriptBlock {
    $pattern = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
    if ($pattern) { $pattern = [regex]::Escape($pattern) }

    $history = [System.Collections.ArrayList]@(
        $last = ''; $lines = ''
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath)) {
            if ($line.EndsWith('`')) {
                $line = $line.Substring(0, $line.Length - 1)
                $lines = if ($lines) { "$lines`n$line" } else { $line }
                continue
            }
            if ($lines) { $line = "$lines`n$line"; $lines = '' }
            if (($line -cne $last) -and (!$pattern -or ($line -match $pattern))) {
                $last = $line; $line
            }
        }
    )
    $history.Reverse()
    $command = $history | Out-GridView -Title History -PassThru
    if ($command) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
    }
}

# Standard Emacs / Windows overrides
Set-PSReadLineKeyHandler -Key Ctrl+b -BriefDescription BuildCurrentDirectory -LongDescription "Build the current directory" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("msbuild")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Key Ctrl+q -Function TabCompleteNext
Set-PSReadLineKeyHandler -Key Ctrl+Q -Function TabCompletePrevious
Set-PSReadLineKeyHandler -Key Ctrl+C -Function Copy
Set-PSReadLineKeyHandler -Key Ctrl+v -Function Paste
Set-PSReadLineKeyHandler -Chord 'Ctrl+d,Ctrl+c' -Function CaptureScreen
Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f -Function ShellForwardWord
Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord

# Smart Insert/Delete Quotes & Parens
Set-PSReadLineKeyHandler -Key '"',"'" -BriefDescription SmartInsertQuote -LongDescription "Insert paired quotes if not already on a quote" -ScriptBlock {
    param($key, $arg)
    $quote = $key.KeyChar
    $selectionStart = $null; $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $quote + $line.SubString($selectionStart, $selectionLength) + $quote)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
        return
    }

    $ast = $null; $tokens = $null; $parseErrors = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$parseErrors, [ref]$null)

    function FindToken {
        param($tokens, $cursor)
        foreach ($token in $tokens) {
            if ($cursor -lt $token.Extent.StartOffset) { continue }
            if ($cursor -lt $token.Extent.EndOffset) {
                $result = $token
                $token = $token -as [StringExpandableToken]
                if ($token) {
                    $nested = FindToken $token.NestedTokens $cursor
                    if ($nested) { $result = $nested }
                }
                return $result
            }
        }
        return $null
    }
    $token = FindToken $tokens $cursor

    if ($token -is [StringToken] -and $token.Kind -ne [TokenKind]::Generic) {
        if ($token.Extent.StartOffset -eq $cursor) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quote$quote ")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            return
        }
        if ($token.Extent.EndOffset -eq ($cursor + 1) -and $line[$cursor] -eq $quote) {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            return
        }
    }

    if ($null -eq $token -or $token.Kind -eq [TokenKind]::RParen -or $token.Kind -eq [TokenKind]::RCurly -or $token.Kind -eq [TokenKind]::RBracket) {
        if ($line[0..$cursor].Where{$_ -eq $quote}.Count % 2 -eq 1) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($quote)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quote$quote")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
        }
        return
    }

    if ($token.Extent.StartOffset -eq $cursor) {
        if ($token.Kind -eq [TokenKind]::Generic -or $token.Kind -eq [TokenKind]::Identifier -or
            $token.Kind -eq [TokenKind]::Variable -or $token.TokenFlags.hasFlag([TokenFlags]::Keyword)) {
            $end = $token.Extent.EndOffset
            $len = $end - $cursor
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($cursor, $len, $quote + $line.SubString($cursor, $len) + $quote)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($end + 2)
            return
        }
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($quote)
}

Set-PSReadLineKeyHandler -Key '(','{','[' -BriefDescription InsertPairedBraces -LongDescription "Insert matching braces" -ScriptBlock {
    param($key, $arg)
    $closeChar = switch ($key.KeyChar) { '(' { [char]')'; break }; '{' { [char]'}'; break }; '[' { [char]']'; break } }
    $selectionStart = $null; $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($selectionStart -ne -1) {
      [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $key.KeyChar + $line.SubString($selectionStart, $selectionLength) + $closeChar)
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    } else {
      [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}

Set-PSReadLineKeyHandler -Key ')',']','}' -BriefDescription SmartCloseBraces -LongDescription "Insert closing brace or skip" -ScriptBlock {
    param($key, $arg)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($line[$cursor] -eq $key.KeyChar) { [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1) }
    else { [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)") }
}

Set-PSReadLineKeyHandler -Key Backspace -BriefDescription SmartBackspace -LongDescription "Delete previous char or matching pair" -ScriptBlock {
    param($key, $arg)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($cursor -gt 0) {
        $toMatch = $null
        if ($cursor -lt $line.Length) {
            switch ($line[$cursor]) { '"' { $toMatch = '"'; break }; "'" { $toMatch = "'"; break }; ')' { $toMatch = '('; break }; ']' { $toMatch = '['; break }; '}' { $toMatch = '{'; break } }
        }
        if ($toMatch -ne $null -and $line[$cursor-1] -eq $toMatch) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
        }
    }
}

Set-PSReadLineKeyHandler -Key Alt+w -BriefDescription SaveInHistory -LongDescription "Save current line in history but do not execute" -ScriptBlock {
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}

Set-PSReadLineKeyHandler -Key Ctrl+V -BriefDescription PasteAsHereString -LongDescription "Paste the clipboard text as a here string" -ScriptBlock {
    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText()) {
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n","`n").TrimEnd()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
    } else { [Microsoft.PowerShell.PSConsoleReadLine]::Ding() }
}

Set-PSReadLineKeyHandler -Key 'Alt+(' -BriefDescription ParenthesizeSelection -LongDescription "Wrap selection in parens" -ScriptBlock {
    $selectionStart = $null; $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
        [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    }
}

Set-PSReadLineKeyHandler -Key "Alt+'" -BriefDescription ToggleQuoteArgument -LongDescription "Toggle quotes on the argument" -ScriptBlock {
    $ast = $null; $tokens = $null; $errors = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)
    $tokenToChange = $null
    foreach ($token in $tokens) {
        $extent = $token.Extent
        if ($extent.StartOffset -le $cursor -and $extent.EndOffset -ge $cursor) {
            $tokenToChange = $token
            if ($extent.EndOffset -eq $cursor -and $foreach.MoveNext()) {
                $nextToken = $foreach.Current
                if ($nextToken.Extent.StartOffset -eq $cursor) { $tokenToChange = $nextToken }
            }
            break
        }
    }
    if ($tokenToChange -ne $null) {
        $extent = $tokenToChange.Extent; $tokenText = $extent.Text
        if ($tokenText[0] -eq '"' -and $tokenText[-1] -eq '"') { $replacement = $tokenText.Substring(1, $tokenText.Length - 2) }
        elseif ($tokenText[0] -eq "'" -and $tokenText[-1] -eq "'") { $replacement = '"' + $tokenText.Substring(1, $tokenText.Length - 2) + '"' }
        else { $replacement = "'" + $tokenText + "'" }
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($extent.StartOffset, $tokenText.Length, $replacement)
    }
}

Set-PSReadLineKeyHandler -Key "Alt+%" -BriefDescription ExpandAliases -LongDescription "Replace all aliases with full command" -ScriptBlock {
    $ast = $null; $tokens = $null; $errors = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)
    $startAdjustment = 0
    foreach ($token in $tokens) {
        if ($token.TokenFlags -band [TokenFlags]::CommandName) {
            $alias = $ExecutionContext.InvokeCommand.GetCommand($token.Extent.Text, 'Alias')
            if ($alias -ne $null) {
                $resolvedCommand = $alias.ResolvedCommandName
                if ($resolvedCommand -ne $null) {
                    $extent = $token.Extent
                    $length = $extent.EndOffset - $extent.StartOffset
                    [Microsoft.PowerShell.PSConsoleReadLine]::Replace($extent.StartOffset + $startAdjustment, $length, $resolvedCommand)
                    $startAdjustment += ($resolvedCommand.Length - $length)
                }
            }
        }
    }
}

Set-PSReadLineKeyHandler -Key F1 -BriefDescription CommandHelp -LongDescription "Open help window for current command" -ScriptBlock {
    $ast = $null; $tokens = $null; $errors = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)
    $commandAst = $ast.FindAll( { $node = $args[0]; $node -is [CommandAst] -and $node.Extent.StartOffset -le $cursor -and $node.Extent.EndOffset -ge $cursor }, $true) | Select-Object -Last 1
    if ($commandAst -ne $null) {
        $commandName = $commandAst.GetCommandName()
        if ($commandName -ne $null) {
            $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
            if ($command -is [AliasInfo]) { $commandName = $command.ResolvedCommandName }
            if ($commandName -ne $null) { Get-Help $commandName -ShowWindow }
        }
    }
}

$global:PSReadLineMarks = @{}
Set-PSReadLineKeyHandler -Key Ctrl+J -BriefDescription MarkDirectory -LongDescription "Mark the current directory" -ScriptBlock { $key = [Console]::ReadKey($true); $global:PSReadLineMarks[$key.KeyChar] = $pwd }
Set-PSReadLineKeyHandler -Key Ctrl+j -BriefDescription JumpDirectory -LongDescription "Goto the marked directory" -ScriptBlock {
    $key = [Console]::ReadKey()
    $dir = $global:PSReadLineMarks[$key.KeyChar]
    if ($dir) { cd $dir; [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt() }
}
Set-PSReadLineKeyHandler -Key Alt+j -BriefDescription ShowDirectoryMarks -LongDescription "Show marked directories" -ScriptBlock {
    $global:PSReadLineMarks.GetEnumerator() | ForEach-Object { [PSCustomObject]@{Key = $_.Key; Dir = $_.Value} } | Format-Table -AutoSize | Out-Host
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

Set-PSReadLineOption -CommandValidationHandler {
    param([CommandAst]$CommandAst)
    if ($CommandAst.GetCommandName() -eq 'git') {
        $gitCmd = $CommandAst.CommandElements[1].Extent
        if ($gitCmd.Text -eq 'cmt') { [Microsoft.PowerShell.PSConsoleReadLine]::Replace($gitCmd.StartOffset, $gitCmd.EndOffset - $gitCmd.StartOffset, 'commit') }
    }
}

Set-PSReadLineKeyHandler -Key RightArrow -BriefDescription ForwardCharAndAcceptNextSuggestionWord -ScriptBlock {
    param($key, $arg)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($cursor -lt $line.Length) { [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg) }
    else { [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg) }
}

Set-PSReadLineKeyHandler -Key Alt+a -BriefDescription SelectCommandArguments -ScriptBlock {
    param($key, $arg)
    $ast = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$null, [ref]$null, [ref]$cursor)
    $asts = $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.ExpressionAst] -and $args[0].Parent -is [System.Management.Automation.Language.CommandAst] -and $args[0].Extent.StartOffset -ne $args[0].Parent.Extent.StartOffset }, $true)
    if ($asts.Count -eq 0) { [Microsoft.PowerShell.PSConsoleReadLine]::Ding(); return }
    $nextAst = $null
    if ($null -ne $arg) { $nextAst = $asts[$arg - 1] }
    else {
        foreach ($a in $asts) { if ($a.Extent.StartOffset -ge $cursor) { $nextAst = $a; break } }
        if ($null -eq $nextAst) { $nextAst = $asts[0] }
    }
    $startOffsetAdjustment = 0; $endOffsetAdjustment = 0
    if ($nextAst -is [System.Management.Automation.Language.StringConstantExpressionAst] -and $nextAst.StringConstantType -ne [System.Management.Automation.Language.StringConstantType]::BareWord) {
            $startOffsetAdjustment = 1; $endOffsetAdjustment = 2
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($nextAst.Extent.StartOffset + $startOffsetAdjustment)
    [Microsoft.PowerShell.PSConsoleReadLine]::SetMark($null, $null)
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar($null, ($nextAst.Extent.EndOffset - $nextAst.Extent.StartOffset) - $endOffsetAdjustment)
}

Set-PSReadLineKeyHandler -Chord 'Alt+x' -BriefDescription ToUnicodeChar -ScriptBlock {
    $buffer = $null; $cursor = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref] $buffer, [ref] $cursor)
    if ($cursor -lt 4) { return }
    $number = 0
    $isNumber = [int]::TryParse($buffer.Substring($cursor - 4, 4), [System.Globalization.NumberStyles]::AllowHexSpecifier, $null, [ref] $number)
    if (-not $isNumber) { return }
    try { $unicode = [char]::ConvertFromUtf32($number) } catch { return }
    [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 4, 4)
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($unicode)
}
#endregion


# ==============================================================================
# [5] MODULES & TOOLS
# ==============================================================================

# Activate Zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Activate Mise
if (Get-Command mise -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (mise activate powershell | Out-String) })
}

# Load PSFzf
if (Get-Module -ListAvailable PSFzf) {
    Import-Module PSFzf

    # Safely bind Ctrl+T (Files) and Ctrl+R (History) using the official PSFzf options
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

    # Optional: If you also want the Zsh-style Alt+C to search and jump directories:
    Set-PSReadLineKeyHandler -Key 'Alt+c' -ScriptBlock { Invoke-FuzzySetLocation }
}

# Load Posh-Git
if (Get-Module -ListAvailable posh-git) {
    Import-Module posh-git
}

# Initialize Starship Prompt
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell | Out-String)
}


# ==============================================================================
# [6] STARTUP & LOGIN
# ==============================================================================

# Push prompt to the bottom of the screen right before rendering
if ($Host.UI.RawUI.WindowSize.Height) {
    Write-Host ([string]::new([char]10, $Host.UI.RawUI.WindowSize.Height)) -NoNewline
}

# Login Banner
if ((Get-Command fortune -ErrorAction SilentlyContinue) -and (Get-Command chara -ErrorAction SilentlyContinue)) {
    $width = 47 # Default (55 - 8)
    if ($Host.UI.RawUI.WindowSize.Width) {
        $width = $Host.UI.RawUI.WindowSize.Width - 8
    }

    if (Get-Command lolcat -ErrorAction SilentlyContinue) {
        fortune | lolcat -f | chara say --random --width=$width
    } else {
        fortune | chara say --random --width=$width
    }
}
