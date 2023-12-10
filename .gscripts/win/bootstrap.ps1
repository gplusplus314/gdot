$erroractionpreference = "stop"

$response = Read-Host "This script is not perfectly idempotent. Do you want to continue? (Y/N)"
if ($response -ne 'Y' -and $response -ne 'y') {
    Write-Host "Exiting script."
    exit
}

function Invoke-ElevatedCommand {
    param(
        [Parameter(Mandatory)]
        [string]$CommandString
    )

    Start-Process powershell.exe -ArgumentList "-NoProfile -Command $CommandString" -Verb RunAs -Wait
}

function Ensure-RegistryKey {
    param(
        [Parameter(Mandatory = $true)]
        [string]$KeyPath
    )

    if (-not (Test-Path $KeyPath)) {
        $command = "New-Item -Path $KeyPath -Force"
	Invoke-ElevatedCommand -CommandString $command
        Write-Host "Registry key created: $KeyPath"
    } else {
        Write-Host "Registry key already exists: $KeyPath"
    }
}

scoop bucket add extras
scoop bucket add games
scoop bucket add 'nerd-fonts'

$packages = @(
	"bat" # better cat
	"fd" # find stuffs
	"fzf" # fuzzyfind
	"gcc" # c compiler
	"gh" # github cli
	"grep" # old habits die hard
	"jq" # cli json query
	"poppler" # pdf renderer
	"unar" # universal unarchiver
	"zoxide" # z
  "autohotkey" # keyboard hotkey daemon
  "cru" # custom resolution utility
  "cutter" # GUI for Rizin
  "firefox" # not-chrome
  "firefoxpwa" # PWA support for Firefox
  "git" # version/source control
  "go" # gopher
  "komorebi" # tiling window manager
  "llvm" # compiler toolchain
  "luarocks" # moon rocks
  "neovim" # best editor
  "nodejs" # javascript thingy
  "obsidian" # notes
  "powertoys" # tweaks
  "privacy.sexy" # privacy tools
  "pwsh" # powershell core
  "ripgrep" # fast grep
  "rizin" # CLI/TUI RE toolkit
  "rustup-msvc" # rust
  "starship" # cli prompt
  "steam" # what comes out when you open a Valve
  "steamcmd" # steam cli
  "sunshine" # low latency desktop streaming server
  "sysinternals" # internals for the sys
  "ungoogled-chromium" # less-bad-chrome
  "vscode" # backup editor
  "wezterm" # terminal emulator
  "winget" # Package Manager for things Scoop can't do
  "x64dbg" # debugger
  "zig" # modern C alternative, plus good tools

  # Fonts
  "SourceCodePro-NF"
  "SourceCodePro-NF-Mono"
  "SourceCodePro-NF-Propo"
)
$str = $packages -join " "
scoop install $str

# These require attendance:
winget install Microsoft.VisualStudio.2022.Community `
  --override "--passive --config $HOME\.gscripts\win\vs2022.vsconfig" `
  --accept-package-agreements --accept-source-agreements
wsl --install -d "openSUSE-Tumbleweed" `
  --accept-package-agreements --accept-source-agreements

# Get rid of Widgets
winget uninstall -id 9MSSGKG348SP
Set-ItemProperty `
  -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
  -Name "TaskbarDa" -Value 0

# link NeoVim configuration
$winNvim = Join-Path $env:LOCALAPPDATA "nvim"
$unixNvim = Join-Path (Join-Path $HOME ".config") "nvim"
New-Item -ItemType Junction -Path $winNvim -Target $unixNvim

# This is annoying. Turn it off.
git config --global core.autocrlf false
git config --global core.eol lf

# Shell history tool
cargo install atuin
nu -c 'atuin init nu | save ~/.local/share/atuin/init.nu'

function Clone-GitRepo {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url
    )
    $parsedUrl = $Url -replace 'https?://', ''
    $directoryPath = $parsedUrl.Replace('/', '\')
    $fullPath = Join-Path $HOME "src\$directoryPath"
    if (!(Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force
    }
    git clone $Url $fullPath
}

Clone-GitRepo -Url "https://github.com/uutils/coreutils"
Push-Location "$HOME\src\github.com\uutils\coreutils"
make install
Pop-Location

# Cache Starship for NuShell
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# Dark mode:
Set-ItemProperty `
  -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize `
  -Name AppsUseLightTheme -Value 0 -Type Dword -Force
Set-ItemProperty `
  -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize `
  -Name SystemUsesLightTheme -Value 0 -Type Dword -Force

# Disable a bunch of default Windows hotkeys:
Set-ItemProperty `
  -Path "HKCU:\Control Panel\Accessibility\StickyKeys" `
  -Name "Flags" -Type String -Value "506"
Set-ItemProperty `
  -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" `
  -Name "Flags" -Type String -Value "58"
Set-ItemProperty `
  -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" `
  -Name "Flags" -Type String -Value "122"
$Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
Ensure-RegistryKey -KeyPath $Path
$command = "Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoWinKeys -Value 1"
Invoke-ElevatedCommand -CommandString $command

# Auto hide taskbar:
$Path = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$v=(Get-ItemProperty -Path $Path).Settings
$v[8]=3
Set-ItemProperty -Path $Path -Name Settings -Value $v

# Disable the search in taskbar
$splat = @{
    Path        = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search'
    Name        = 'SearchBoxTaskbarMode'
    Value       = 0
    Type        = 'DWord'
    Force       = $True
    ErrorAction = 'Stop'
}
Set-ItemProperty @splat

# Turn off mouse acceleration (does not turn off "enhance pointer precision", unfortunately)
$Path = "HKCU:\Control Panel\Mouse"
Set-ItemProperty -Path $Path -Name MouseSpeed -Value 0
Set-ItemProperty -Path $Path -Name MouseThreshold1 -Value 0
Set-ItemProperty -Path $Path -Name MouseThreshold2 -Value 0

# Show file extensions in Windows Explorer
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$Name = "HideFileExt"
$Value = "0"  # 0 to show extensions, 1 to hide
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}
Set-ItemProperty -Path $Path -Name $Name -Value $Value

# Restart explorer so the rest of the settings take effect:
Stop-Process -f -ProcessName explorer
start explorer.exe

