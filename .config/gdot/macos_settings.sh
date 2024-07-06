#!/bin/bash

# Dock settings
# Enable autohide for the dock
defaults write com.apple.dock autohide -bool true
# Disable recent apps in the dock
defaults write com.apple.dock mru-spaces -bool false
# Disable showing recent applications in the dock
defaults write com.apple.dock show-recents -bool false
# Set the dock icon size to 32
defaults write com.apple.dock tilesize -int 32
# Remove all persistent apps from the dock
defaults delete com.apple.dock persistent-apps
# Remove all persistent others from the dock
defaults delete com.apple.dock persistent-others
# Restart the dock to apply changes
killall Dock

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
killall Finder

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

# Screencapture settings
# Set the default screenshot location to the Pictures/screenshots directory
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"
# Restart SystemUIServer to apply changes
killall SystemUIServer

# Screensaver settings
# Set the delay for requiring a password after screensaver starts to 10 seconds
defaults write com.apple.screensaver askForPasswordDelay -int 10

# Universal access settings
# Reduce motion for accessibility
defaults write com.apple.universalaccess reduceMotion -bool true

# Keyboard settings
# Disable Ctrl + Left Arrow (Mission Control: Move left a space)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "<dict><key>enabled</key><false/></dict>"
# Disable Ctrl + Right Arrow (Mission Control: Move right a space)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "<dict><key>enabled</key><false/></dict>"
# Disable Ctrl + Up Arrow (Mission Control: Mission Control)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "<dict><key>enabled</key><false/></dict>"
# Disable Ctrl + Down Arrow (Mission Control: Application windows)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 "<dict><key>enabled</key><false/></dict>"

echo "Doing one-time imperative configuration steps - Requires Attendance:"
echo "\t- Setting Brave as default browser..."
open -W -a "Brave Browser" --args --make-default-browser

echo "All settings have been applied."


