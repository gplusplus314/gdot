#!/usr/bin/env bash
set -e
set -x

cd $HOME

sudo pacman -Syu --noconfirm

# "pacman install"
function paci() {
	sudo pacman -S --needed --noconfirm "$@"
}
paci alacritty           # The stubbornly non-sixel terminal emulator
paci atuin               # CLI history in searchable sqlite
paci base-devel          # Base development packages
paci bash                # What you shouldn't do until you try it
paci bat                 # Better cat
paci cargo               # Rust package manager
paci ccache              # Compiler Cache to speed up some compilations
paci clang               # Compiler for C-family languages
paci cmake               # Configurable cross platform make
paci dfu-util            # DFU-mode firmware flashing for keyboard
paci fd                  # Alternative to find
paci figlet              # ASCII art text generator
paci fzf                 # TUI/CLI fuzzy finder
paci gcc                 # C compiler
paci git                 # Git version control
paci github-cli          # GitHub CLI
paci go                  # A gopher who lives on land above C level
paci gopls               # A very polite languang server for Go
paci hyprland            # Tiling window manager for Wayland
paci hyprpaper           # Wallpaper util
paci llvm                # Next-gen compiler backend
paci lolcat              # The purrfect addition to the CLI
paci lua-language-server # As the name implies
paci luarocks            # Package manager for Lua
paci man-db              # Manual pages
paci marksman            # Markdown language server
paci neofetch            # necessary for internet points
paci ncurses             # TUI tooling
paci neovim              # NeoVim terminal-based text editor
paci nodejs              # "JavaScript... on a SeRvEr!?!?"
paci noto-fonts-emoji    # Emoji fonts from Google
paci npm                 # Defitely not node package manager
paci pacman-contrib      # For building AUR related things
paci pipewire            # Audio stack
paci polkit-kde-agent    # Essentially a "sudo GUI" for gui apps
paci python-pip          # Package manager for Python
paci python3             # A snake that lives on land above C level
paci qt5-wayland         # QT5 lib
paci qt6-wayland         # QT6 lib
paci ripgrep             # Fast search tool
paci rust                # Crabs
paci sddm                # Display/Login/Session manager
paci shfmt               # Formats shell programs
paci stylua              # Lua formatter
paci timeshift           # BTRFS snapshot easymode
paci tldr                # Short alternative to man-pages
paci tmux                # Terminal Multiplexer
paci tree                # Show directory structure visually
paci ttf-liberation      # OSS compatible Microsoft fonts
paci wget                # Gets things from the web
paci which               # Doesn't show you the way, but shows you a path
paci wireplumber         # Audio patching
paci wofi                # Launcher
paci xdg-utils           # Desktop integrations
paci yarn                # Package manager for Node
paci zip                 # Technologic
paci zsh                 # Interactive shell of choice

paci xdg-desktop-portal-hyprland # hyprland-specific XDG Portals

# Control monitor input programmatically
paci ddcutil

# for ZMK keyboard development
paci dtc   # Device Tree Controller
paci ninja # Buid system for CMake

# for QMK keyboard development:
paci \
	qmk \
	arm-none-eabi-binutils \
	arm-none-eabi-gcc \
	arm-none-eabi-newlib \
	avr-binutils \
	avr-gcc \
	avr-libc \
	dfu-programmer

# Install Paru AUR helper from source
mkdir -p src/aur.archlinux.org
pushd src/aur.archlinux.org

# if the ./paru directory exists, exit
if [ ! -d "paru" ]; then
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si --noconfirm
	popd
fi

# "aur install"
function auri() {
	paru -S --needed --noconfirm "$@"
}
auri brave-bin      # A web browser that isn't scared of privacy
auri hyprpicker-git # Pixel color picker
auri webcord-bin    # A better Discord client
auri zoom           # Mazda's software division

# Language-specific packages:
sudo luarocks install luacheck
go install github.com/go-delve/delve/cmd/dlv@latest

# Fonts for a good terminal experience
sudo mkdir -p /usr/local/share/fonts/nerd
pushd /usr/local/share/fonts/nerd
PREFIX="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"
sudo wget "$PREFIX/SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf"
sudo wget "$PREFIX/SourceCodePro/Regular/SauceCodeProNerdFont-Regular.ttf"
sudo wget "$PREFIX/SourceCodePro/Bold/SauceCodeProNerdFontMono-Bold.ttf"
sudo wget "$PREFIX/SourceCodePro/Bold/SauceCodeProNerdFont-Bold.ttf"
sudo wget "$PREFIX/SourceCodePro/Italic/SauceCodeProNerdFontMono-Italic.ttf"
sudo wget "$PREFIX/SourceCodePro/Italic/SauceCodeProNerdFont-Italic.ttf"
sudo wget "$PREFIX/SourceCodePro/Bold-Italic/SauceCodeProNerdFontMono-BoldItalic.ttf"
sudo wget "$PREFIX/SourceCodePro/Bold-Italic/SauceCodeProNerdFont-BoldItalic.ttf"
sudo fc-cache
popd

# Make Zsh look purrdy
pushd ~/.config
if [ ! -d "powerlevel10k" ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
fi
popd

# Switch to Zsh
sudo chsh -s $(which zsh) $USER

# Bend both time and space
timedatectl set-timezone "$(curl --fail https://ipapi.co/timezone)"

# Init Alacritty config
pushd ~/.config/alacritty
./init.sh
popd

#{{{ Steam
paci lib32-mesa # 32 bit OpenGL for AMD GPUs
#}}}
