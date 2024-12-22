#vim: filetype=zsh

# # Gdot expects these to be exported for other commands to work properly
export GDOT_HOME="${GDOT_HOME:=$HOME/.config/gdot}"
export GDOT_GIT_DIR="${GDOT_GIT_DIR:=$GDOT_HOME/.git_repo}"
export PATH="$GDOT_HOME/bin:$PATH"


# # Settings

export GPG_TTY=$TTY
export EDITOR=vim

export ZSH_THEME_TERM_TITLE_IDLE="%~"
export ZSH_THEME_TERM_TAB_TITLE_IDLE="%~"

# Colorful `man`-style commands
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Tab Autocompletion Settings
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

# Don't close the shell on Ctrl-D
set -o ignoreeof


# # Environment and path

#!/bin/bash

# Determine Homebrew prefix based on system type
if [[ "$(uname -s)" == "Darwin" ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
        # Apple Silicon Mac
        HOMEBREW_PREFIX="/opt/homebrew"
    else
        # Intel Mac
        HOMEBREW_PREFIX="/usr/local"
    fi
else
    echo "Unsupported system."
    exit 1
fi
export PATH="$HOMEBREW_PREFIX/bin:$PATH"
. "$HOME/.cargo/env"
export PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"


# # Aliases and Functions

alias lvim='NVIM_APPNAME=lvim nvim -u $HOME/.config/lvim/init.lua'
alias vim='nvim -u $HOME/.config/vim/vimrc'
alias vi='nvim -u NONE'
alias cat=bat

# Colorize the ls output ##
alias ls='ls --color=auto'
# Use a long listing format ##
alias ll='ls -la'
# Show hidden files ##
alias l.='ls -d .* --color=auto'
# colorful grep
alias grep='grep --color'

function colors256() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}

# # Keybinds
bindkey -e # use emacs style bindings on readline prompt

