#!/bin/dash

# Create a temporary file
tmpfile=$(mktemp)

# Open the temp file in Vim
nvim -u "$HOME/.config/vim/vimrc" "$tmpfile"

# After Vim exits, copy contents to clipboard (strips trailing newline)
perl -pe 'chomp if eof' "$tmpfile" | pbcopy

# clean up temp file
rm "$tmpfile"
