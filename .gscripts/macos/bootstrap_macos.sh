#!/usr/bin/env bash
echo "\n"
echo "First, you need to manually accept Apple's license agreement for Xcode." \
	"It should pop up right now. Look for the prompt in another window, then" \
	"come back here when it's done."

xcodebuild -license
echo "\n"
read -p "Xcode license accepted? Press enter to continue!"

echo "\n"
echo "Now we need to install Xcode command line tools. This will pop up in"
echo "another window. Come back here when it's done."
xcode-select --install

echo "\n"
read -p "Xcode installed? Press enter to continue!"

echo "\n"
echo "Now a ton of software is going to be installed automatically without" \
	"human interaction. This may take a while; about enough time to make an" \
	"especially delicious snacc..."

# Install Homebrew package manager
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

machine=$(uname -m)
if [[ "$machine" == "arm64" ]]; then
	BREW_PATH="/opt/homebrew"
elif [[ "$machine" == "x86_64" ]]; then
	BREW_PATH="/usr/local"
else
	echo "Unknown architecture: $machine"
	exit 1
fi
eval "$($BREW_PATH/bin/brew shellenv)"

brew install --cask alacritty          # Terminal emulator
brew install --cask alfred             # Launcher (I only use it for apps)
brew install --cask amethyst           # Dynamic tiling window manager
brew install --cask discord            # Chat app
brew install --cask firefox            # The best web browser
brew install --cask flameshot          # Screen shot tool
brew install --cask gcc-arm-embedded   # For compiling QMK keyboard firmware
brew install --cask hammerspoon        # macOS automation/scripting in Lua
brew install --cask karabiner-elements # Keyboar manipulation/remapping
brew install --cask wezterm            # Alternative, experimental terminal
brew install --cask raycast            # My main launcher

brew install atuin               # CLI history in searchable sqlite
brew install bat                 # Better cat
brew install ccache              # Compiler Cache to speed up some compilations
brew install cmake               # Configurable cross platform make
brew install coreutils           # GNU core utils, more up to date than Apple's
brew install deno                # Rust-based alternative to Node.js
brew install dfu-util            # DFU-mode firmware flashing for keyboard
brew install dtc                 # Device Tree Controller - ZMK build dep
brew install fd                  # Alternative to find
brew install figlet              # ASCII art text generator
brew install firefoxpwa          # Use Firefox to host PWAs
brew install fzf                 # TUI/CLI fuzzy finder
brew install gh                  # GitHub CLI
brew install git                 # Git version control
brew install go                  # Go programming language
brew install gopls               # Go languago server
brew install llvm                # Next-gen compiler backend
brew install lolcat              # The purrfect addition to the CLI
brew install lua-language-server # As the name implies
brew install luarocks            # Package manager for Lua
brew install marksman            # Markdown language server
brew install neovim              # NeoVim terminal-based text editor
brew install ncurses             # TUI tooling
brew install ninja               # Buid system for CMake - used by ZMK
brew install nvm                 # Node Version Manager
brew install python3             # A snake that runs code
brew install qmk\qmk\qmk         # Keyboard firmware framework for wired keebs
brew install ripgrep             # Fast search tool
brew install stylua              # Lua formatter
brew install tldr                # Short alternative to man-pages
brew install tmux                # Terminal Multiplexer
brew install tree                # Show directory structure visually
brew install wget                # Gets things from the web
brew install zsh                 # Interactive shell of choice
brew install zig --HEAD          # Zig Programming language

brew install koekeishiya/formulae/yabai # For window highlighting

# Debug tools for Go
go install github.com/go-delve/delve/cmd/dlv@latest

# Build tools for ZMK
pip3 install --user -U west
pip3 install pyelftools

# Rust
curl https://sh.rustup.rs -sSf >rustup-init.sh
chmod +x rustup-init.sh
./rustup-init.sh -y
rm rustup-init.sh

pushd ~/.config
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
popd

$BREW_PATH/opt/ncurses/bin/infocmp tmux-256color >~/tmux-256color.info
sudo tic -xe tmux-256color tmux-256color.info
rm ~/tmux-256color.info

sudo sh -c "echo $BREW_PATH/bin/zsh >> /etc/shells"

pushd ~/Library/Fonts
PREFIX="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"
wget "$PREFIX/SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf"
wget "$PREFIX/SourceCodePro/Regular/SauceCodeProNerdFont-Regular.ttf"
wget "$PREFIX/SourceCodePro/Bold/SauceCodeProNerdFontMono-Bold.ttf"
wget "$PREFIX/SourceCodePro/Bold/SauceCodeProNerdFont-Bold.ttf"
wget "$PREFIX/SourceCodePro/Italic/SauceCodeProNerdFontMono-Italic.ttf"
wget "$PREFIX/SourceCodePro/Italic/SauceCodeProNerdFont-Italic.ttf"
wget "$PREFIX/SourceCodePro/Bold-Italic/SauceCodeProNerdFontMono-BoldItalic.ttf"
wget "$PREFIX/SourceCodePro/Bold-Italic/SauceCodeProNerdFont-BoldItalic.ttf"
popd

mkdir -p ~/.local/opt
pushd ~/.local/opt
git clone https://github.com/larkery/zsh-histdb
popd

/opt/homebrew/bin/atuin import auto

##################################
# The following are interactive: #
##################################
echo "\n"
echo "A few more things need to be installed/configured that require human" \
	"interaction. Are you ready?"
read -p "Press enter to continue!"

chsh -s /usr/local/bin/zsh

$(brew --prefix)/opt/fzf/install

yabai --start-service
