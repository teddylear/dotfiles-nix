#!/usr/bin/bash

SESSIONNAME="personal"
tmux new-session -s $SESSIONNAME -c "$HOME/Documents/journal" -d
tmux rename-window -t 0 "JOURNAL"
tmux send-key -t 0 vim Space . Enter\

tmux new-window -c "$HOME/dotfiles-nix" -n "DOTFILES" -t $SESSIONNAME
tmux move-window -s 1 -t 9

tmux attach -t $SESSIONNAME
