#!/usr/bin/env bash
set -e
set -x

sessions=$(/usr/local/bin/tmux list-sessions -F '#S' 2> /dev/null | grep '^[0-9]\+$' | sort -n)

new=0
for old in $sessions
do
  /usr/local/bin/tmux rename -t $old $new
  ((new++))
done

exit 0
