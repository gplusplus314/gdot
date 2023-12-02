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
  "autohotkey" # keyboard hotkey daemon
  "cutter" # GUI for Rizin
  "cru" # custom resolution utility
  "discord" # chat
  "firefox" # not-chrome
  "firefoxpwa" # PWA support for Firefox
	"gh" # github cli
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
#winget install Microsoft.VisualStudio.2022.Community `
#  --override "--passive --config $HOME\.gscripts\win\vs2022.vsconfig" `
#  --accept-package-agreements --accept-source-agreements
#wsl --install -d "openSUSE-Tumbleweed" `
#  --accept-package-agreements --accept-source-agreements

# Get rid of Widgets
winget uninstall -id 9MSSGKG348SP
Set-ItemProperty `
  -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
  -Name "TaskbarDa" -Value 0

# link NeoVim configuration
$winNvim = Join-Path $env:LOCALAPPDATA "nvim"
$unixNvim = Join-Path (Join-Path $HOME ".config") "nvim"
#New-Item -ItemType Junction -Path $winNvim -Target $unixNvim

# This is annoying. Turn it off.
git config --global core.autocrlf false

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

# Turn off mouse acceleration:
$Path = "HKCU:\Control Panel\Mouse"
Set-ItemProperty -Path $Path -Name MouseSpeed -Value 0
Set-ItemProperty -Path $Path -Name MouseThreshold1 -Value 0
Set-ItemProperty -Path $Path -Name MouseThreshold2 -Value 0

# Disable rounded corners
$Path = "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
$Name = "RoundCornerPreference"
$Value = "0"
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}
Set-ItemProperty -Path $Path -Name $Name -Value $Value

# Disable Chat
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$Name = "HideSCAHealth"
$Value = "1"
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}
$command = "Set-ItemProperty -Path $Path -Name $Name -Value $Value"
Invoke-ElevatedCommand -CommandString $command

# Disable Widgets
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$Name = "TaskbarDa"
$Value = "0"
$command = "Set-ItemProperty -Path $Path -Name $Name -Value $Value"
Invoke-ElevatedCommand -CommandString $command

# Disable Task View
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$Name = "HideTaskViewButton"
$Value = "1"
$command = "Set-ItemProperty -Path $Path -Name $Name -Value $Value"
Invoke-ElevatedCommand -CommandString $command

# Disable rounded window corners
$Path = "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
$Name = "RoundCornerPreference"
$Value = "0"  # 0 to disable, 1 to enable
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}
Set-ItemProperty -Path $Path -Name $Name -Value $Value

# Show file extensions in Windows Explorer
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$Name = "HideFileExt"
$Value = "0"  # 0 to show extensions, 1 to hide
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}
Set-ItemProperty -Path $Path -Name $Name -Value $Value

# Hide the "Recommended" section of the Start Menu
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\StartMenu"
$Name = "Start_ShowRecommended"
$Value = "0"  # 0 to hide, 1 to show
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}
Set-ItemProperty -Path $Path -Name $Name -Value $Value

# Restart explorer so the rest of the settings take effect:
Stop-Process -f -ProcessName explorer
start explorer.exe

