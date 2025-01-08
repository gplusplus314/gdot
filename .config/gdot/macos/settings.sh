#!/bin/bash
set -e

# Close system preferences if it's open to avoid side effects
osascript -e 'tell application "System Preferences" to quit'

#
# Dock settings
#
# Enable autohide for the dock
defaults write com.apple.dock autohide -bool true
# Disable recent apps in the dock
defaults write com.apple.dock mru-spaces -bool false
# Disable showing recent applications in the dock
defaults write com.apple.dock show-recents -bool false
# Set the dock icon size to 32
defaults write com.apple.dock tilesize -int 32
# Remove all persistent apps from the dock
defaults delete com.apple.dock persistent-apps >/dev/null 2>&1 || true
# Remove all persistent others from the dock
defaults delete com.apple.dock persistent-others >/dev/null 2>&1 || true
# Restart the dock to apply changes

# Finder settings
# Set default search scope to current folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Set default view style to column view
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Disable warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Hide desktop icons
defaults write com.apple.finder CreateDesktop -bool false
# Show the path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
# Show the status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true
# Restart Finder to apply changes

# Global settings
# Set interface style to Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
# Enable full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show hidden files
defaults write NSGlobalDomain AppleShowAllFiles -bool true
# Set the initial key repeat rate to 15 (lower is faster)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Set the key repeat rate to 2 (lower is faster)
defaults write NSGlobalDomain KeyRepeat -int 2
# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Disable automatic dash substitution
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Disable automatic quote substitution
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable automatic spelling correction
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Enable function keys by default
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
# Disable natural scroll direction
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# VSCode Vim emulation key repeat tweak:
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# Disable special character popup while holding some letters on keyboard
defaults write -g ApplePressAndHoldEnabled -bool false

# Screensaver settings
# Set the delay for requiring a password after screensaver starts to 10 seconds
defaults write com.apple.screensaver askForPasswordDelay -int 10

# Disable blinking cursor
defaults write -g NSTextInsertionPointBlinkPeriod -float 10000
defaults write -g NSTextInsertionPointBlinkPeriodOn -float 10000
defaults write -g NSTextInsertionPointBlinkPeriodOff -float 10000

#
# Keyboard Shortcuts
#
# Effectively, this turns off all shortcuts you can see in System Preferences >
# Keyboard > Keyboard Shortcuts, except it does enable Spotlight Search via
# ctrl+cmd+space to get out of the way a bit. Raycast will be used with
# ctrl+space as the primary launcher.
#
# TODO: make this more robust... this will wipe out any changes done in the gui
# that haven't been exported to the plist file.
defaults import com.apple.symbolichotkeys \
  "$GDOT_HOME/macos/com.apple.symbolichotkeys.plist"

#
# Easier icloud navigation via file system
#
ICLOUD_DOCS="$HOME/Library/Mobile Documents/com~apple~CloudDocs/"
if [ ! -e "$HOME/icloud" ]; then
  # create a symbolic link to the actual iCloud directory
  ln -s "$ICLOUD_DOCS" "$HOME/icloud"
fi
#
# Restart various things to apply changes
#
killall SystemUIServer
killall Finder
killall Dock

# Homebrew Services
brew services start borders # JankyBorders

echo "All macOS settings have been applied."
