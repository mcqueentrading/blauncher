# blauncher

A lightweight Bash utility for launching GUI applications from the terminal as fully detached (orphaned) processes — similar to how you'd launch apps via launchers like `wofi` or `rofi`, but **from the shell** with **full bash tab completion**.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

---

## Why blauncher?

When you launch GUI applications from the terminal, they typically:
- Block your terminal until you close the app
- Die when you close the terminal
- Clutter your shell with stdout/stderr output

**blauncher** solves all of these problems by launching programs as true orphan processes using `setsid` and `nohup`, while preserving bash's intelligent tab completion for commands, files, and directories.

---

## Features

✅ **Full detachment** — Apps continue running even after closing the terminal  
✅ **Clean shell** — No output clutter, no blocking  
✅ **Smart tab completion** — Command names, file paths, and directories autocomplete properly  
✅ **Multiple launch modes** — Choose between different levels of detachment  
✅ **Lightweight** — Pure bash, no external dependencies  
✅ **Modular** — Can be installed to `~/.local/bin` or added directly to `~/.bashrc`

---

## Functions

blauncher provides three wrapper functions:

### `oo` (orphan and exit)
Launches a program fully detached, waits for it to start, then **exits the shell**.

**Best for:** Quick launches where you don't need the terminal anymore.

```bash
oo firefox
oo nemo /home/user/Documents
oo vlc ~/Videos/movie.mp4
```

### `op` (orphan with PID)
Launches a program detached, prints the PID, and **keeps the shell running**.

**Best for:** When you want to track the PID or continue using the terminal.

```bash
op code ~/projects
# Output: orphan, no child (12345)
```

### `orp` (orphan resilient)
Launches a program with `nohup` for maximum resilience against hangups and signals.

**Best for:** Long-running processes that must survive logout/reboot.

```bash
orp chromium
orp thunderbird
```

---

## Installation

### Method 1: Modular Install (Recommended)

Installs blauncher as a separate file in `~/.local/bin` and adds a single source line to `~/.bashrc`.

**Benefits:**
- Cleaner `~/.bashrc` (just one line)
- Easy to update/remove
- Standard location for user scripts
- Better for sharing with other users

**Quick Install:**
```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/install-modular.sh | bash
source ~/.bashrc
```

**Manual Install:**

1. Download blauncher.sh:
   ```bash
   mkdir -p ~/.local/bin
   curl -o ~/.local/bin/blauncher.sh https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh
   chmod +x ~/.local/bin/blauncher.sh
   ```

2. Add to your `~/.bashrc`:
   ```bash
   echo '[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"' >> ~/.bashrc
   ```

3. Reload:
   ```bash
   source ~/.bashrc
   ```

**Uninstall:**
```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/uninstall.sh | bash
```

---

### Method 2: Inline Install

Adds blauncher code directly to your `~/.bashrc`.

**Benefits:**
- Everything in one place
- No separate files to manage
- Slightly faster (no extra file read)

**Install:**

Copy the code from [`blauncher.sh`](blauncher.sh) and paste it at the end of your `~/.bashrc`:

```bash
# blauncher - orphan process wrappers
# https://github.com/mcqueentrading/blauncher

orp() {
    nohup setsid "$@" >/dev/null 2>&1 < /dev/null
    echo "orphan, no child" >&2
}

op() {
    pid=$(setsid "$@" >/dev/null 2>&1 & echo $!)
    echo "orphan, no child ($pid)" >&2
}

oo() {
    nohup setsid "$@" >/dev/null 2>&1 < /dev/null &
    pid=$!
    echo "orphan, no child ($pid)" >&2
    
    # Wait for process to start
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

# Tab completion function
_orphan_complete() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # First argument: complete command names
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=( $(compgen -c -- "$cur") )
    else
        # Subsequent arguments: complete files and directories
        COMPREPLY=( $(compgen -f -- "$cur") )
        
        # Add trailing slash for directories and prevent space
        if [ ${#COMPREPLY[@]} -eq 1 ] && [ -d "${COMPREPLY[0]}" ]; then
            COMPREPLY[0]="${COMPREPLY[0]}/"
            compopt -o nospace
        fi
    fi
}

# Attach completion to all three functions
complete -o nospace -F _orphan_complete oo op orp
```

Then reload:

```bash
source ~/.bashrc
```

---

## Usage Examples

### Basic Usage

```bash
# Launch Firefox
oo firefox

# Open file manager in specific directory
oo nemo /home/user/Downloads

# Play a video
oo vlc ~/Videos/example.mp4

# Open VS Code in a project folder
op code ~/projects/my-app
```

### Tab Completion

The tab completion works intelligently:

```bash
# Complete command names
oo fire<TAB>       # → oo firefox

# Complete file paths
oo nemo ~/Doc<TAB> # → oo nemo ~/Documents/

# Navigate directories
oo nemo ~/Documents/<TAB>  # Shows directory contents
```

### Advanced Examples

```bash
# Launch multiple apps
oo chromium &
oo spotify &
oo slack &

# Open specific file in editor
op gedit ~/notes.txt

# Launch with command arguments
oo mpv --loop-file video.mp4
```

---

## How It Works

### Process Detachment

blauncher uses two key utilities:

1. **`setsid`** — Creates a new session and detaches the process from the terminal
2. **`nohup`** — Makes the process immune to hangup signals (SIGHUP)

This combination ensures processes continue running independently of the terminal.

### Tab Completion Logic

The `_orphan_complete` function provides smart completion:

- **First argument:** Completes executable command names from `$PATH`
- **Subsequent arguments:** Completes file and directory paths
- **Directory handling:** Adds trailing `/` for directories and prevents automatic spaces

---

## Troubleshooting

### Tab completion adds space instead of showing options

**Solution:** The improved completion function in the latest version fixes this. Make sure you've updated to the latest version.

### Program doesn't receive file path arguments

**Problem:** Running `oo nemo /path/to/folder` opens nemo in the home directory instead.

**Solution:** Quote paths with spaces or special characters:

```bash
oo nemo "/home/user/My Documents"
```

The current version handles this correctly with `"$@"` expansion.

### Process exits immediately

Some applications fork themselves and exit their initial process. This can confuse the `oo` function's wait loop.

**Solution:** Use `op` or `orp` instead, which don't wait for the process.

### Tab completion not working

**Check:** Make sure the `complete` command appears **after** the function definitions:

```bash
# ✅ Correct order:
_orphan_complete() { ... }
complete -F _orphan_complete oo op orp

# ❌ Wrong order:
complete -F _orphan_complete oo op orp
_orphan_complete() { ... }
```

### Modular install: command not found

Make sure `~/.local/bin` is in your PATH:

```bash
echo $PATH | grep -q "$HOME/.local/bin" && echo "In PATH ✓" || echo "Not in PATH ✗"
```

If not in PATH, add it to your `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

---

## Comparison with Other Methods

| Method | Detached | Survives Logout | Clean Output | Tab Completion |
|--------|----------|----------------|--------------|----------------|
| `firefox &` | ❌ | ❌ | ❌ | ✅ |
| `nohup firefox &` | ✅ | ✅ | ❌ | ✅ |
| `setsid firefox` | ✅ | ⚠️ | ❌ | ✅ |
| **`oo firefox`** | ✅ | ✅ | ✅ | ✅ |

---

## Customization

### Change Function Names

Don't like `oo`, `op`, `orp`? Rename them:

```bash
# Rename functions
alias launch='oo'
alias detach='op'
alias daemon='orp'

# Update completion
complete -o nospace -F _orphan_complete launch detach daemon
```

### Add Aliases

Create shortcuts for common applications:

```bash
alias browser='oo firefox'
alias files='oo nemo'
alias editor='op code'
```

---

## File Structure

```
blauncher/
├── README.md              # This file
├── QUICKSTART.md          # Quick start guide
├── EXAMPLES.md            # Usage examples
├── CONTRIBUTING.md        # Contribution guidelines
├── CHANGELOG.md           # Version history
├── LICENSE                # GPL-3.0 license
├── .gitignore            # Git ignore rules
├── blauncher.sh          # Main script
├── install-modular.sh    # Modular installer (to ~/.local/bin)
├── install.sh            # Inline installer (to ~/.bashrc)
├── uninstall.sh          # Uninstaller
└── test.sh               # Test suite
```

---

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## License

Licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

You are free to use, modify, and redistribute this software, provided that:
- Any redistributed versions remain licensed under GPL-3.0
- You include the source code
- You retain copyright notices

See the [LICENSE](LICENSE) file for the full license text.

---

## Author

Created by [mcqueentrading](https://github.com/mcqueentrading)

If you find this useful, please consider giving it a ⭐ on GitHub!

---

## Related Projects

- [wofi](https://hg.sr.ht/~scoopta/wofi) — Wayland-native launcher
- [rofi](https://github.com/davatorium/rofi) — X11 window switcher and launcher
- [dmenu](https://tools.suckless.org/dmenu/) — Dynamic menu for X

---

**Questions?** Open an issue on [GitHub](https://github.com/mcqueentrading/blauncher/issues)
