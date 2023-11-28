$erroractionpreference = "stop"

$response = Read-Host "This script is not perfectly idempotent. Do you want to continue? (Y/N)"
if ($response -ne 'Y' -and $response -ne 'y') {
    Write-Host "Exiting script."
    exit
}

scoop bucket add extras
scoop bucket add 'nerd-fonts'

$packages = @(
  "autohotkey" # keyboard hotkey daemon
  "cutter" # GUI for Rizin
  "discord" # chat
  "flow-launcher" # launcher
  "git" # version/source control
  "komorebi" # tiling window manager
  "llvm" # compiler toolchain
  "neovim" # editor
  "obsidian" # notes
  "powertoys" # tweaks
  "ripgrep" # fast grep
  "rizin" # CLI/TUI RE toolkit
  "rustup-msvc" # rust
  "starship" # cli prompt
  "sysinternals" # internals for the sys
  "ungoogled-chromium" # browser
  "wezterm" # terminal emulator
  "winget" # Package Manager for things Scoop can't do

  # Fonts
  "SourceCodePro-NF"
  "SourceCodePro-NF-Mono"
  "SourceCodePro-NF-Propo"
)
$str = $packages -join " "
scoop install $str

# These require attendance:
winget install Microsoft.VisualStudio.2022.Community `
  --override "--passive --config $HOME\.gscripts\win\vs2022.vsconfig"
wsl --install -d "openSUSE-Tumbleweed"
winget uninstall -id 9MSSGKG348SP # Get rid of Widgets

# link NeoVim configuration
$winNvim = Join-Path $env:LOCALAPPDATA "nvim"
$unixNvim = Join-Path (Join-Path $HOME ".config") "nvim"
New-Item -ItemType Junction -Path $winNvim -Target $unixNvim

# This is annoying. Turn it off.
git config --global core.autocrlf false

# Dark mode:
Set-ItemProperty `
  -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize `
  -Name AppsUseLightTheme -Value 0 -Type Dword -Force
Set-ItemProperty `
  -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize `
  -Name SystemUsesLightTheme -Value 0 -Type Dword -Force

# Turn off mouse acceleration:
$Path = "HKCU:\Control Panel\Mouse"
Set-ItemProperty -Path $Path -Name MouseSpeed -Value 0
Set-ItemProperty -Path $Path -Name MouseThreshold1 -Value 0
Set-ItemProperty -Path $Path -Name MouseThreshold2 -Value 0

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
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force
}
$command = "Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoWinKeys -Value 1"
Start-Process powershell.exe -ArgumentList "-Command `"$command`"" -Verb RunAs

# Set the wallpaper
Set-ItemProperty `
  -Path "HKCU:\Control Panel\Desktop\" `
  -name wallpaper `
  -value $HOME\Pictures\wallpaper\win11dark.png

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

# Disable rounded window corners
$splat = @{
    Path        = 'HKCU:\SOFTWARE\Microsoft\Windows\DWM'
    Name        = 'UseWindowFrameStagingBuffer'
    Value       = 0
    Type        = 'DWord'
    Force       = $True
    ErrorAction = 'Stop'
}
Set-ItemProperty @splat

# Remove "Gallery" from file explorer
$splat = @{
    Path        = 'HKCU:\SOFTWARE\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}'
    Name        = 'System.IsPinnedToNameSpaceTree'
    Value       = 0
    Type        = 'DWord'
    Force       = $True
    ErrorAction = 'Stop'
}
Set-ItemProperty @splat

# Auto hide taskbar:
$Path = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$v=(Get-ItemProperty -Path $Path).Settings
$v[8]=3
Set-ItemProperty -Path $Path -Name Settings -Value $v

# Restart explorer so the rest of the settings take effect:
Stop-Process -f -ProcessName explorer
start explorer.exe

