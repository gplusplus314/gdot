#vim: filetype=zsh

# # Gdot expects these to be exported for other commands to work properly
export GDOT_HOME="${GDOT_HOME:=$HOME/.config/gdot}"
export GDOT_GIT_DIR="${GDOT_GIT_DIR:=$GDOT_HOME/.git_repo}"
export PATH="$GDOT_HOME/bin:$PATH"


# # Settings

export GPG_TTY=$TTY
export EDITOR='nvim -u $HOME/.config/vim/vimrc'

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

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init --hook none zsh)"

# # Aliases and Functions

# This will make nvim open a file in the "outer" nvim instance if this alias
# is executed in an embedded terminal within nvim. Otherwise, a new instance
# will start, as 
alias nvim='nvim --server $NVIM --remote' 

alias lvim='NVIM_APPNAME=lvim nvim -u $HOME/.config/lvim/init.lua'
alias vim='nvim -u $HOME/.config/vim/vimrc'
alias vi='nvim -u NONE'
alias cat=bat
if [[ "$KITTY_WINDOW_ID" != "" ]]; then
  alias ssh='kitty ssh'
fi

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

# Allow Ranger to `cd` your current shell by exiting with capital Q
function ranger {
  local IFS=$'\t\n'
  local tempfile="$(mktemp -t tmp.XXXXXX)"
  local ranger_cmd=(
    command
    ranger
    --cmd="map Q quitallcd $tempfile"
  )
  
  ${ranger_cmd[@]} "$@"
  local target_dir=$(cat -- "$tempfile" | tr -d ' ')
  local cwd=$(echo -n `pwd` | tr -d ' ')
  if [[ -f "$tempfile" ]] && [[ "$target_dir" != "" ]] && \
      [[ "$target_dir" != "$cwd" ]]; then
    cd -- "$target_dir"
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}
alias r='ranger'

# Clone a Git repo into ~/src/..., using its url as the mkdir -p
gclone() {
  local git_url="$1"
  local base_dir="$HOME/src"

  if [[ -z "$git_url" ]]; then
    echo "Usage: clone_with_structure <git_url>"
    return 1
  fi

  local domain=$(echo "$git_url" | awk -F '[/:]' '{print $4}')

  local os_type="$(uname -s)"
  case "$os_type" in
    Linux)
      repo_path=$(echo "$git_url" | sed -r 's|https?://[^/]+/||; s|\.git$||')
      ;;

    Darwin|FreeBSD|OpenBSD|NetBSD)
      repo_path=$(echo "$git_url" | sed -E 's|https?://[^/]+/||; s|\.git$||')
      ;;

    *)
      echo "Unsupported OS: $os_type"
      return 1
      ;;
  esac

  local target_dir="$base_dir/$domain/$repo_path"
  mkdir -p "$(dirname "$target_dir")"

  git clone "$git_url" "$target_dir" && echo "Repository cloned to: $target_dir"
}



# # Keybinds
bindkey -e # use emacs style bindings on readline prompt

# Command history search
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
bindkey '^r' atuin-search
