#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -eq 0 ]; then
    echo "usage: tui_tmux_window.sh <command> [args...]" >&2
    exit 2
fi

if [ -z "${TMUX:-}" ]; then
    echo "tui_tmux_window.sh: must be run inside tmux" >&2
    exit 1
fi

if [ "$#" -eq 1 ]; then
    window_name=${1%%[[:space:]]*}
    window_name=${window_name##*/}
    shell_command=$1
else
    window_name=${1##*/}
    shell_command=$(printf '%q ' "$@")
    shell_command=${shell_command% }
fi

tmux new-window -n "$window_name" -c "#{pane_current_path}" "$shell_command; tmux last-window"
