#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Vim Pad
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐈

kitty -o "map=kitty_mod+t no_op" -o "tab_bar_min_tabs=2" --session vim-pad.session
