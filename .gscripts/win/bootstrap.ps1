$erroractionpreference = "stop"

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
winget install Microsoft.VisualStudio.2022.BuildTools
winget install Microsoft.VisualStudio.2022.Community
scoop install vcredist2022
wsl --install -d "openSUSE-Tumbleweed"

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

# Auto hide taskbar:
$Path = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$v=(Get-ItemProperty -Path $p).Settings
$v[8]=3
Set-ItemProperty -Path $p -Name Settings -Value $v
Stop-Process -f -ProcessName explorer

# Disable a bunch of default Windows hotkeys:
$Path = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
Set-ItemProperty -Path $Path -Name NoWinKeys -Value 1

# Set the wallpaper
Set-ItemProperty -path "HKCU:\Control Panel\Desktop\" -name wallpaper -value $HOME\Pictures\wallpaper\win11dark.png

# Get rid of Widgets
winget uninstall -id 9MSSGKG348SP

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

# Restart explorer so the rest of the settings take effect:
taskkill /f /im explorer.exe
start explorer.exe

