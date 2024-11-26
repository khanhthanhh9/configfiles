#!/usr/bin/env bash

languages=$(echo "golang c cpp typescript rust python" | tr " " "\n")
core_utils=$(echo "find xargs sed awk" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "GIMME YOUR QUERY: " query

if echo "$languages" | grep -qs "$selected"; then
  tmux split-window -p 22 -h -l 82% bash -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less"
  echo "language selected"
else
  tmux split-window -p 22 -h bash -c "curl cht.sh/$selected~$query | less"
  echo "core selected"
fi

