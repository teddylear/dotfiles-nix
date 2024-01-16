#!/run/current-system/sw/bin/fish

set SESSIONNAME "tmuxsession"
tmux new-session -s "$SESSIONNAME" -c "$HOME/Documents" -d
tmux rename-window -t 0 "Documents"
tmux send-key -t 0 vim Space . Enter\

tmux new-window -c "$HOME/dotfiles-nix" -n "DOTFILES" -t "$SESSIONNAME"
tmux move-window -s 1 -t 9

tmux attach -t "$SESSIONNAME"
