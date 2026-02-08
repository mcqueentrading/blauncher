#!/usr/bin/env bash
# blauncher - Bash orphan process launcher with smart tab completion
# https://github.com/mcqueentrading/blauncher
# Licensed under GPL-3.0

#######################
# ORPHAN WRAPPERS
#######################

# orp - Orphan Resilient Process
# Launches a program with nohup for maximum resilience against hangups.
# The shell continues running after launch.
orp() {
    nohup setsid "$@" >/dev/null 2>&1 < /dev/null
    echo "orphan, no child" >&2
}

# op - Orphan with PID
# Launches a program detached and prints the PID.
# The shell continues running after launch.
op() {
    pid=$(setsid "$@" >/dev/null 2>&1 & echo $!)
    echo "orphan, no child ($pid)" >&2
}

# oo - Orphan and Exit
# Launches a program detached, waits for it to start, then exits the shell.
# Useful for quick launches where you don't need the terminal anymore.
oo() {
    nohup setsid "$@" >/dev/null 2>&1 < /dev/null &
    pid=$!
    echo "orphan, no child ($pid)" >&2
    
    # Wait for the process to start (polling with kill -0)
    # Timeout after 5 seconds to prevent infinite hangs
    local max_attempts=25  # 25 * 0.2s = 5 seconds
    local attempts=0
    
    while ! kill -0 "$pid" >/dev/null 2>&1; do
        sleep 0.2
        attempts=$((attempts + 1))
        
        if [ $attempts -ge $max_attempts ]; then
            echo "Warning: Process may have exited immediately" >&2
            break
        fi
    done
    
    exit
}

#######################
# TAB COMPLETION
#######################

# Smart completion function for blauncher commands
# - First argument: completes command names from $PATH
# - Subsequent arguments: completes files and directories
# - Adds trailing slash for directories
_orphan_complete() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # First argument: complete command names only
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=( $(compgen -c -- "$cur") )
    else
        # Subsequent arguments: complete files and directories
        COMPREPLY=( $(compgen -f -- "$cur") )
        
        # Special handling for single directory matches
        # Add trailing slash and prevent automatic space
        if [ ${#COMPREPLY[@]} -eq 1 ] && [ -d "${COMPREPLY[0]}" ]; then
            COMPREPLY[0]="${COMPREPLY[0]}/"
            compopt -o nospace
        fi
    fi
}

# Attach completion to all three wrapper functions
# IMPORTANT: This must come AFTER the _orphan_complete function definition
# -o nospace: prevents automatic space after completion for better directory navigation
complete -o nospace -F _orphan_complete oo op orp
