# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

###########################
#  START  Settings        #
###########################
export PATH="$HOME/.dotfiles/bin/all:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
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

export EDITOR=nvim
export NEOVIDE_FRAMELESS=true
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

# Tell Qt apps to use the qt5ct them for DaRk MoDe!!111one
export QT_QPA_PLATFORMTHEME=qt5ct

export DOOMDIR="~/.doom.d"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

###########################
#  END    Settings        #
###########################

###########################
# START aliases and funcs #
###########################
alias vi=nvim
alias vim=nvim

# Colorize the ls output ##
alias ls='ls --color=auto'
# Use a long listing format ##
alias ll='ls -la'
# Show hidden files ##
alias l.='ls -d .* --color=auto'
# colorful grep
alias grep='grep --color'

# pushd via fzf of telescope-project.nvm
# "Pushd Project"
function pp() {
  DIR=$(cat ~/.local/share/nvim/telescope-projects.txt \
    | awk -F"=" '{print $1 " " $2}' \
    | fzf -n 1 --with-nth 1 -q "$1" -1 --preview-window 'top:60%' --preview 'echo {} | awk '"'"'{print $2}'"'"' | xargs tree -l -C -L 3' \
    | awk '{print $2}')
  pushd "$DIR"
}

alias gdot='git --git-dir=$HOME/.gdot/ --work-tree=$HOME'

function colors256() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}

lfpd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                pushd "$dir"
            fi
        fi
    fi
}
###########################
#  END  aliases and funcs #
###########################

#################
# <Keybinds>
#################
bindkey -e

# Shift-Tab to navigate backwards
bindkey '^[[Z' reverse-menu-complete

# ctrl-v to edit command line in vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^v" edit-command-line

bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

function reset-prompt() {
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}

function zle-pp() {
  pp
  reset-prompt
}
zle -N zle-pp
bindkey "^p" zle-pp

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

bindkey -s '^o' 'lfpd\n'
#################
# </Keybinds>
#################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Keep OS-Specific config SECOND TO LAST so it can override generics:
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # linux-specific stuff
  source /usr/share/nvm/init-nvm.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source $HOME/.zshrc_macos
fi

# Keep machine-specific config ABSOLUTELYE LAST to override everything:
if [ -f "$HOME/.zshrc_local" ]; then
  source $HOME/.zshrc_local
fi

