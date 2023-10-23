#{{{ Init Powerlevel10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
#}}}

#{{{ Cross Platform Helpers
G_ARCH=$(uname -m) # "arm64", "x86_64"
if [[ "$G_ARCH" != "arm64" && "$G_ARCH" != "x86_64" ]]; then
	echo "Unsupported architecture: $G_ARCH"
	exit 1
fi
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	export G_OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	export G_OS="macos"
else
	echo "Unknown OS: $OSTYPE"
	exit 1
fi
#}}}

#{{{ PATH (and things that affect it)
export PATH="$HOME/.dotfiles/bin/all:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/opt/protobuf@3/bin:$PATH"
export PATH="$(python3 -m site --user-base)/bin:$PATH"
if [[ "$G_OS" == "macos" ]]; then
  export PATH="$HOME/.gscripts/macos:$PATH"
  if [[ "$G_ARCH" == "arm64" ]]; then
      export BREW_PREFIX="/opt/homebrew"
  elif [[ "$G_ARCH" == "x86_64" ]]; then
      export BREW_PREFIX="/usr/local"
  fi
  eval "$($BREW_PREFIX/bin/brew shellenv)"
  if [[ ! "$PATH" == *$BREW_PREFIX/opt/fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}$BREW_PREFIX/opt/fzf/bin"
  fi
fi
#}}}

#{{{ Initializers
autoload -Uz compinit
compinit
# Setup fzf
if [[ "$G_OS" == "linux" ]]; then
	if [ -n "${commands[fzf-share]}" ]; then
		source "$(fzf-share)/key-bindings.zsh"
		source "$(fzf-share)/completion.zsh"
	else
		echo "unable to set up fzf key bindings and completion"
	fi
elif [[ "$G_OS" == "macos" ]]; then
  source "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
  source "$BREW_PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null
fi
eval "$(atuin init zsh --disable-up-arrow)"
source <(kubectl completion zsh)
#}}}

#{{{ Settings
export GPG_TTY=$TTY

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

export EDITOR='env EDITOR_INVOKED=1 nvim'
export TERMINAL=alacritty

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_ALT_C_COMMAND='fd -td -L'
export FZF_ALT_C_OPTS="--preview-window 'top:60%' --preview 'tree -l -C -L 3 {}'"
export FZF_TMUX_HEIGHT='80%'
# To use custom commands instead of find, override _fzf_compgen_{path,dir}
_fzf_compgen_path() {
  echo "$1"
  command rg --files
}
_fzf_compgen_dir() {
  command fd -td -L
}
function __gfzf_compgen_preview() {
  [ -d $1 ] && tree -l -C -L 3 $1 || [ -f $1 ] && bat --color=always --style=header,grid,numbers $1
}
export FZF_COMPLETION_OPTS="--preview-window 'top:60%' --preview '[ -d {} ] && tree -l -C -L 3 {} || [ -f {} ] && bat --color=always --style=header,grid,numbers {} 2> /dev/null'"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# LLVM settings:
export LDFLAGS="-L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++,-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export CC=$(which clang)
#}}}

#{{{ Aliases and Functions
alias vi=nvim
alias vim=nvim

alias cat=bat

alias k=kubectl
alias kn=k9s

# Colorize the ls output ##
alias ls='ls --color=auto'
# Use a long listing format ##
alias ll='ls -la'
# Show hidden files ##
alias l.='ls -d .* --color=auto'
# colorful grep
alias grep='grep --color'

alias gdot='git --git-dir=$HOME/.gdot/ --work-tree=$HOME'
alias lgit='lazygit'

function colors256() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}
#}}}

#{{{ Keybinds
bindkey -e

# Shift-Tab to navigate backwards
bindkey '^[[Z' reverse-menu-complete

# ctrl-v to edit command line in vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^v" edit-command-line

# Standard ctrl-a and ctrl-e to move to beginning and end of line, but dealing
# with weirdness in Alacritty
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

function reset-prompt() {
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}

function zle-fg() {
  fg
  reset-prompt
}
zle -N zle-fg
bindkey "^z" zle-fg

function zle-pushdproj() {
	local DIR=$(cat ~/.proj | fzf )
	if [[ $DIR != '' ]]; then
		eval "pushd $DIR"
	fi
  reset-prompt
}
zle -N zle-pushdproj
bindkey "^p" zle-pushdproj

function zle-fzff() {
  local output
  output=$(fzf --preview-window 'top:60%' --preview 'bat --color=always --style=header,grid,numbers {}' < /dev/tty) && LBUFFER+=${(q-)output}
}
zle -N zle-fzff
bindkey "^f" zle-fzff

function zle-fzfd() {
  local output
  output=$(FZF_DEFAULT_COMMAND='fd -td -L' fzf --preview-window 'top:60%' --preview 'tree -l -C -L 3 {}' +m < /dev/tty) && LBUFFER+=${(q-)output}
}
zle -N zle-fzfd
bindkey "^d" zle-fzfd

function zle-fzfh() {
  local output
  output=$(FZF_DEFAULT_COMMAND='fd -td -L --base-directory ~' fzf --preview-window 'top:60%' --preview 'tree -l -C -L 3 ~/{}' +m < /dev/tty) && LBUFFER+=${(q-)output}
}
zle -N zle-fzfh
bindkey "^h" zle-fzfh
#}}}

#{{{ Machine-Specific Overrides
# Keep machine-specific config ABSOLUTELYE LAST to override everything:
if [ -f "$HOME/.zshrc_local" ]; then
  source $HOME/.zshrc_local
fi
#}}}
###start-marker|{"name":"orcsource","description":"Allows Outreach specific shell hooks"}
source "$HOME/.outreach/outreachrc.sh"
###end-marker