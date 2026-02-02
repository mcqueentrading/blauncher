# blauncher
bash function for terminal launching of programs. replicate the actions you'd take to launch something popular like wofi but with terminal, with bash auto complete still working. Few various functionallities.
# Orphan Process Bash Wrappers

This defines three Bash functions (`o`, `op`, `orp`) for running commands as detached (orphaned) processes using `setsid`. Tab completion works normally for commands and files.

---

## Functions

- `orp` — Runs a command fully detached using `nohup` and `setsid`. Does **not** exit the shell.
- `op` — Runs a command detached using `setsid` and prints the PID. Does **not** exit the shell.
- `o` — Runs a command detached using `setsid`, prints the PID, and exits the shell.

---

## Installation

Add the following to your `~/.bashrc`:


# --- orphan wrappers ---

orp() {
    nohup setsid "$@" >/dev/null 2>&1 < /dev/null
    echo "orphan, no child ($pid)" >&2
}

op() {
    pid=$(setsid "$@" >/dev/null 2>&1 & echo $!)
    echo "orphan, no child ($pid)" >&2
}

o() {
    nohup setsid "$@" >/dev/null 2>&1 < /dev/null &
    pid=$!
    echo "orphan, no child ($pid)" >&2

    # wait indefinitely for the process to exist, silently
    while ! kill -0 "$pid" >/dev/null 2>&1; do
        sleep 0.2
    done

    exit
}


# --- completion function (MUST come first) ---
_orphan_complete() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -c -f -- "$cur") )
}

# --- attach completion (MUST come after function) ---
complete -F _orphan_complete o op orp









######################################################
######################################################
## License
Licensed under the GNU General Public License v3.0 (GPL-3.0).

You are free to use, modify, and redistribute this software, provided that
any redistributed versions remain licensed under GPL-3.0 and include the
source code.

See the [LICENSE](LICENSE) file for the full license text.
https://github.com/mcqueentrading
