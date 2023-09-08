# Setup fzf
# ---------
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	if [ -n "${commands[fzf-share]}" ]; then
		source "$(fzf-share)/key-bindings.zsh"
		source "$(fzf-share)/completion.zsh"
	fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ ! "$PATH" == *$BREW_PREFIX/opt/fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}$BREW_PREFIX/opt/fzf/bin"
  fi

  # Auto-completion
  # ---------------
  [[ $- == *i* ]] && source "$BREW_PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null
  
  # Key bindings
  # ------------
  source "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
fi
