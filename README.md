# blauncher

`blauncher` is a small Bash utility for launching programs from the terminal
in a fully detached (orphaned) state — similar to how you’d launch apps via
a menu like `wofi`, but **from the shell**, while keeping **bash autocompletion**
working normally.

It defines a few lightweight wrapper functions around `setsid` and `nohup`
to make terminal-launched programs behave like GUI-launched ones.

---

## Orphan Process Bash Wrappers

This project defines three Bash functions (`o`, `op`, `orp`) for running
commands as detached (orphaned) processes using `setsid`.

Tab completion works normally for commands and files.

---

## Functions

- **`orp`** — Launches a program fully detached using `nohup` and `setsid`.  
  The shell continues running after the program is launched. Program will survive logout. 

- **`op`** — Launches a program detached using `setsid` and prints the PID.  
  The shell continues running after the program is launched.

- **`o`** — Launches a program detached using `setsid`, prints the PID,  
  waits until the process exists, and then exits the shell.


---

## Installation

Add the following to your `~/.bashrc` (or `~/.bash_profile`):

```bash
# --- orphan wrappers ---

orp() {
    nohup setsid "$@" >/dev/null 2>&1 < /dev/null
    echo "orphan, no child ($!)" >&2
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
```

Reload your shell or run:
```
source ~/.bashrc
```
License

Licensed under the GNU General Public License v3.0 (GPL-3.0).

You are free to use, modify, and redistribute this software, provided that
any redistributed versions remain licensed under GPL-3.0 and include the
source code.

See the LICENSE
 file for the full license text.

GitHub: https://github.com/mcqueentrading
