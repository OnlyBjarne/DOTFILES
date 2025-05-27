#!/bin/bash

# Get the base name of the current working directory to use as the session name
SESSION_NAME=$(basename "$PWD")

# Configuration for mprocs
MPROCS_CONFIG_FILE="mprocs.yaml"
MPROCS_COMMAND="mprocs" # The command to run mprocs

# Commands for each window
NVIM_COMMAND="nvim"
LAZYGIT_COMMAND="lazygit"
FALLBACK_COMMAND="bash" # Command if mprocs.yaml is not found

# Desired window index to land on when attaching (0-indexed)
# Window 0: nvim
# Window 1: mprocs / fallback shell
# Window 2: lazygit
ATTACH_WINDOW_INDEX=1 # Attach to the mprocs/fallback window

# Check if a tmux session with this name already exists
tmux has-session -t "$SESSION_NAME" 2>/dev/null

if [ $? != 0 ]; then
    echo "Starting new tmux session: $SESSION_NAME"

    # Create the new session in detached mode, starting in the current directory.
    # This automatically creates window 0.
    tmux new-session -s "$SESSION_NAME" -d -c "$PWD"

    # Set up Window 0: nvim
    # Send the nvim command to the first window (index 0) and press Enter.
    tmux send-keys -t "$SESSION_NAME:1" "$NVIM_COMMAND" C-m
    tmux rename-window -t "$SESSION_NAME:1" "nvim" # Rename window 0 to "nvim"

    # Set up Window 1: mprocs or fallback shell
    # Check if mprocs.yaml exists to decide the command for this window
    if [ -f "$MPROCS_CONFIG_FILE" ]; then
        echo "Found '$MPROCS_CONFIG_FILE'. Setting up window for '$MPROCS_COMMAND'."
        # Create a new window (index 1) and run mprocs in it.
        tmux new-window -t "$SESSION_NAME" -n "mprocs" -c "$PWD" "$MPROCS_COMMAND"
    else
        echo "No '$MPROCS_CONFIG_FILE' found. Setting up window for '$FALLBACK_COMMAND'."
        # Create a new window (index 1) and run the fallback command (e.g., bash).
        tmux new-window -t "$SESSION_NAME" -n "cli" -c "$PWD" "$FALLBACK_COMMAND"
    fi

    # Set up Window 2: lazygit
    # Create another new window (index 2) and run lazygit in it.
    tmux new-window -t "$SESSION_NAME" -n "lazygit" -c "$PWD" "$LAZYGIT_COMMAND"

else
    echo "Attaching to existing tmux session: $SESSION_NAME"
    # If the session already exists, we don't create new windows.
    # We assume the windows are already set up from a previous run.
fi

# Attach to the tmux session and select the desired window
echo "Attaching to tmux session '$SESSION_NAME' at window $ATTACH_WINDOW_INDEX..."
tmux attach-session -t "$SESSION_NAME:$ATTACH_WINDOW_INDEX"
