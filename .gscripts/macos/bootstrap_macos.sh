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

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask alacritty
brew install --cask alfred
brew install --cask amethyst
brew install --cask discord
brew install --cask firefox
brew install --cask flameshot
brew install --cask gcc-arm-embedded
brew install --cask hammerspoon
brew install --cask karabiner-elements
brew install --cask wezterm

brew install \
  bat \
  ccache \
  cmake \
  coreutils \
  deno \
  dfu-util \
  dtc \
  fd \
  figlet \
  firefoxpwa \
  fish \
  fzf \
  gh \
  git \
  go \
  gopls \
  llvm \
  lolcat \
  lua-language-server \
  luarocks \
  marksman \
  neovim \
  ninja \
  nvm \
  python3 \
  qmk\qmk\qmk \
  ripgrep \
  stylua \
  tldr \
  tmux \
  tree \
  wget \
  zsh

# Build tool for ZMK
pip3 install --user -U west

pushd ~/.config
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
popd

/usr/local/opt/ncurses/bin/infocmp -x tmux-256color > ~/tmux-256color.src
sudo /usr/bin/tic -x ~/tmux-256color.src
rm ~/tmux-256color.src

sudo echo "/usr/local/bin/zsh" >> /etc/shells

pushd ~/Library/Fonts
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
popd

##################################
# The following are interactive: #
##################################
echo "\n"
echo "A few more things need to be installed/configured that require human" \
     "interaction. Are you ready?"
read -p "Press enter to continue!"

chsh -s /usr/local/bin/zsh

$(brew --prefix)/opt/fzf/install

