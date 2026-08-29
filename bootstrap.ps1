$ErrorActionPreference = 'Stop'

function Write-LogInfo ([string]$Message) {
    Write-Host "==> " -NoNewline -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Green
}

function Write-LogWarn ([string]$Message) {
    Write-Host "==> " -NoNewline -ForegroundColor Yellow
    Write-Host $Message -ForegroundColor Yellow
}

function Write-LogErr ([string]$Message) {
    Write-Host "==> " -NoNewline -ForegroundColor Red
    Write-Host $Message -ForegroundColor Red
}

# 1. Prepare Execution Policy for Scoop
$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($currentPolicy -ne 'RemoteSigned' -and $currentPolicy -ne 'Unrestricted') {
    Write-LogInfo "Setting CurrentUser ExecutionPolicy to RemoteSigned..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
}

# 2. Install scoop
if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
    Write-LogInfo "Installing scoop..."
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    # Ensure scoop shim path is available for this session
    $env:PATH = "$env:USERPROFILE\scoop\shims;$env:PATH"
} else {
    Write-LogInfo "scoop is already installed."
}

# 3. Install tools via scoop
Write-LogInfo "Ensuring git, bitwarden-cli, and chezmoi are installed..."
$tools = @("git", "bitwarden-cli", "chezmoi")
foreach ($tool in $tools) {
    # Check if tool is installed in scoop
    if (-not (scoop list | Select-String -Pattern "\b$tool\b" -Quiet)) {
        scoop install $tool
    }
}

# Ensure new tool shims are definitely in PATH
$env:PATH = "$env:USERPROFILE\scoop\shims;$env:PATH"

# 4. Handle Bitwarden Authentication
Write-LogInfo "Checking Bitwarden status..."
if (-not (Get-Command "bw" -ErrorAction SilentlyContinue)) {
    Write-LogErr "Bitwarden CLI (bw) not found in PATH."
    exit 1
}

# PowerShell can parse JSON natively
$bwStatusJson = bw status | ConvertFrom-Json
$bwStatus = $bwStatusJson.status

if ($bwStatus -eq "unauthenticated") {
    Write-LogInfo "Bitwarden is unauthenticated. Logging in..."
    $env:BW_SESSION = (bw login --raw)
} elseif ($bwStatus -eq "locked") {
    Write-LogInfo "Bitwarden is locked. Unlocking..."
    $env:BW_SESSION = (bw unlock --raw)
} elseif ($bwStatus -eq "unlocked") {
    Write-LogInfo "Bitwarden is already unlocked."
    if ([string]::IsNullOrEmpty($env:BW_SESSION)) {
        Write-LogWarn "BW_SESSION is not set in the environment. Chezmoi might fail if secrets are required."
    }
} else {
    Write-LogErr "Failed to determine Bitwarden status."
    exit 1
}

Write-LogInfo "Bitwarden session exported."

# 5. Initialize and apply dotfiles
Write-LogInfo "Initializing dotfiles via chezmoi..."
chezmoi init latipun7 --apply

Write-LogInfo "Bootstrap completed successfully!"
