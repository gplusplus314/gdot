#vim: filetype=zsh

# # Gdot expects these to be exported for other commands to work properly
export GDOT_HOME="${GDOT_HOME:=$HOME/.config/gdot}"
export GDOT_GIT_DIR="${GDOT_GIT_DIR:=$GDOT_HOME/.git_repo}"
export PATH="$GDOT_HOME/sbin:$PATH"

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

# Cursor is a steady vertical bar
echo -e "\e[6 q"

export NODE_VERSIONS="$HOME/.nvm/versions/node"
export NODE_VERSION_PREFIX="v"

# # Environment and path

case $(uname -s) in
  Darwin)
    if [[ "$(uname -m)" == "arm64" ]]; then
      # Apple Silicon Mac
      HOMEBREW_PREFIX="/opt/homebrew"
    else
      # Intel Mac
      HOMEBREW_PREFIX="/usr/local"
    fi
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
    export PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
    export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
  ;;
esac

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --hook none zsh)"
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

# # Aliases and Functions

## This will make nvim open a file in the "outer" nvim instance if this alias
## is executed in an embedded terminal within nvim. Otherwise, a new instance
## will start. It will also `cd` to a directory in a subshell *before* invoking
## nvim if the first and only argument is a directory, which plays nicely with
## the session handling in my nvim config.
#function nvim() {
#	if [[ "$#" == "1" && -d "$1" ]]; then
#		(cd "$1" && command nvim --server "$NVIM" --remote)
#	else
#		command nvim --server "$NVIM" --remote "$@"
#	fi
#}

alias vim='nvim -u $HOME/.config/vim/vimrc'
alias vi='nvim -u NONE'

# kitty ssh fix
[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"

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
    echo "Usage: gclone <git_url>"
    return 1
  fi

  local domain repo_path

  if [[ "$git_url" =~ ^git@([^:]+):(.+)\.git$ ]]; then
    domain="${match[1]}"
    repo_path="${match[2]}"
  elif [[ "$git_url" =~ ^https?://([^/]+)/(.+)\.git$ ]]; then
    domain="${match[1]}"
    repo_path="${match[2]}"
  else
    echo "Unsupported Git URL format: $git_url"
    return 1
  fi

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

export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

if [ -e "$HOME/.zshrc_local" ]; then
	. "$HOME/.zshrc_local"
fi

