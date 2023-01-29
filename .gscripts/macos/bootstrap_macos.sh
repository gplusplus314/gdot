#!/usr/bin/env bash
xcodebuild -license
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask karabiner-elements
brew install --cask alacritty
brew install --cask discord
brew install --cask firefox
brew install --cask amethyst
brew install --cask alfred
brew install --cask hammerspoon
brew install --cask gcc-arm-embedded

brew install \
  bat \
  ccache \
  cmake \
  coreutils \
  dfu-util \
  dtc \
  fd \
  firefoxpwa \
  fish \
  fzf \
  gh \
  git \
  go \
  gopls \
  lua-language-server \
  luarocks \
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

brew install emacs-mac --with-dbus --with-starter --with-natural-title-bar --with-native-comp --with-mac-metal --with-xwidgets --with-imagemagick
osascript -e 'tell application "Finder" to make alias file to POSIX file "/usr/local/opt/emacs-mac/Emacs.app" at POSIX file "/Applications"'

pip3 install --user -U west

pushd ~/.config
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
popd

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d

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

chsh -s /usr/local/bin/zsh

$(brew --prefix)/opt/fzf/install

~/.emacs.d/bin/doom install

