#vim: filetype=zsh
# Auto-recompile .zshrc if it's newer than the compiled version
{
  local zshrc_compiled="$ZDOTDIR/.zshrc.zwc"
  if [[ ! -f "$zshrc_compiled" ]] || [[ "$ZDOTDIR/.zshrc" -nt "$zshrc_compiled" ]]; then
    zcompile "$ZDOTDIR/.zshrc"
  fi
} &|

case $(uname -s) in
  Darwin)
    if [[ "$(uname -m)" == "arm64" ]]; then
      # Apple Silicon Mac
      export HOMEBREW_PREFIX="/opt/homebrew"
    else
      # Intel Mac
      export HOMEBREW_PREFIX="/usr/local"
    fi
	;;
  Linux)
    if [[ -d /home/linuxbrew/.linuxbrew/share/zsh/site-functions ]]; then
      export HOMEBREW_PREFIX="/home/linuxbrew"
    elif [[ -d "$HOME/.linuxbrew/share/zsh/site-functions" ]]; then
      export HOMEBREW_PREFIX="$HOME/.linuxbrew"
    fi
    ;;
  *)
    echo "\nunexpected operating system: $(uname -s)\n"
    ;;
esac

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

# Completion system setup
# Add homebrew/linuxbrew completions to fpath (must be before compinit)
fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

autoload -Uz compinit
_comp_dump="$ZDOTDIR/cache/.zcompdump"
case $(uname -s) in
  Darwin) _comp_mtime=$(stat -f %m "$_comp_dump" 2>/dev/null || echo 0) ;;
  Linux) _comp_mtime=$(stat -c %Y "$_comp_dump" 2>/dev/null || echo 0) ;;
  *)
    echo "** error statting compdump file! **"
    _comp_mtime=0
    ;;
esac

_comp_diff=$(( $(date +%s) - $_comp_mtime ))

if [[ $_comp_mtime -eq 0 ]] || [[ ${_comp_diff} -gt 86400 ]]; then
  echo "Regenerating completions cache..."
  mkdir -p "$ZDOTDIR/cache"
  rm "$_comp_dump.zwc" 2&>1
  rm "$_comp_dump" 2&>1
  compinit -d "$_comp_dump" -i -u
  zcompile "$_comp_dump"
else
  compinit -d "$_comp_dump" -C -i -u
fi
unset _comp_dump _comp_mtime _comp_diff

# Don't close the shell on Ctrl-D
set -o ignoreeof

# Cursor is a steady vertical bar
echo -e "\e[6 q"


export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"

_cache_eval() {
  local filename="$1"
  local gen_cmd="$2"
  local cache_path="$ZDOTDIR/cache/$filename"
  [[ -f "$cache_path" ]] || {
    echo "Caching $gen_cmd -> $cache_path"
    mkdir -p "$ZDOTDIR/cache"
    eval "$gen_cmd" > "$cache_path"
  }
  source "$cache_path"
}
_cache_eval "starship.eval" "starship init zsh"
_cache_eval "direnv.eval" "direnv hook zsh"
_cache_eval "zoxide.eval" "zoxide init --hook none zsh"
_cache_eval "fnm.eval" "fnm env --use-on-cd --shell zsh"
export ATUIN_NOBIND="true"
_cache_eval "atuin.eval" "atuin init zsh"

function rbenv() {
  unset -f rbenv
  export PATH="$HOME/.rbenv/shims:$PATH"
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# # Aliases and Functions

alias vim='nvim -u $HOME/.config/vim/vimrc'
alias vi='nvim -u NONE'

# kitty ssh fix
[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"

# Colorize the ls output
alias ls='ls --color=auto'
# Use a long listing format
alias ll='ls -la'
# Show hidden files
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
bindkey '^r' atuin-search

[[ -e "$HOME/.zshrc" ]] && source "$HOME/.zshrc"
