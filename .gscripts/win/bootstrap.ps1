$erroractionpreference = "stop"

# This is annoying to install, but just get it out of the way. It must be
# attended.
winget install Microsoft.VisualStudio.2022.Community

# This must also be attended. May as well do it now.
wsl --install -d "openSUSE-Tumbleweed" 

scoop bucket add main
scoop bucket add extras
scoop bucket add 'nerd-fonts'

$packages = @(
  "autohotkey" # keyboard hotkey daemon
  "cutter" # GUI for Rizin
  "discord" # chat
  "flow-launcher" # launcher
  "git" # version/source control
  "komorebi" # tiling window manager
  "neovim" # editor
  "obsidian" # notes
  "powertoys" # tweaks
  "radare2" # TUI RE tool
  "ripgrep" # fast grep
  "rizin" # CLI RE toolkit
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

# This is annoying. Turn it off.
git config --global core.autocrlf false

# link NeoVim configuration
$winNvim = Join-Path $env:LOCALAPPDATA "nvim"
$unixNvim = Join-Path $HOME ".config" "nvim"
New-Item -ItemType SymbolicLink -Path $winNvim -Target $unixNvim

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
&Set-ItemProperty -Path $p -Name Settings -Value $v
&Stop-Process -f -ProcessName explorer

# Disable a bunch of default Windows hotkeys:
$Path = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
Set-ItemProperty -Path $Path -Name NoWinKeys -Value 1

# Set the wallpaper
Set-ItemProperty -path "HKCU:\Control Panel\Desktop\" -name wallpaper -value $HOME\Pictures\wallpaper\win11dark.png

