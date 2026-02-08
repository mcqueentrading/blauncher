# blauncher

A lightweight Bash utility for launching GUI applications from the terminal as fully detached (orphaned) processes. 

**blauncher** lets you start applications from the command line without blocking your terminal, cluttering it with output, or tying the application's lifecycle to your shell session. Launch Firefox, file managers, media players, or any GUI app and have them run completely independently — exactly like clicking an icon in a desktop environment, but with the speed and flexibility of the command line plus full bash tab completion.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

---

## Why blauncher?

When you launch GUI applications from the terminal normally, they:
- **Block your terminal** until you close the app or use `&`
- **Die when you close the terminal** even with `&`
- **Clutter your shell** with stdout/stderr output
- **Remain tied to your session** and can be interrupted

**blauncher** solves all of these problems by:
- Creating true orphan processes that outlive your terminal
- Silencing all output automatically
- Providing smart tab completion for commands and file paths
- Making terminal-launched apps behave exactly like GUI-launched apps

---

## Features

✅ **Full detachment** — Apps continue running even after closing the terminal  
✅ **Clean shell** — No output clutter, no blocking  
✅ **Smart tab completion** — Command names, file paths, and directories autocomplete properly  
✅ **Multiple launch modes** — Choose between different levels of detachment  
✅ **Lightweight** — Pure bash, no external dependencies  
✅ **Modular** — Installs to `~/.local/bin` with just one line added to `~/.bashrc`

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

### Quick Install (Recommended)

Run the installer script which will:
- Download blauncher to `~/.local/bin/`
- Add `~/.local/bin` to your PATH (if needed)
- Add a single source line to your `~/.bashrc`

```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh | bash
source ~/.bashrc
```

**What gets added to your ~/.bashrc:**
```bash
# Source blauncher for oo, op, orp commands
[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"
```

That's it! Just one clean line.

### Manual Installation

See [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) for detailed manual installation steps.

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/uninstall.sh | bash
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

For more examples, see [EXAMPLES.md](EXAMPLES.md).

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

**Solution:** Make sure you're using the latest version of blauncher. The improved completion function fixes this issue.

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

**Check:** Make sure you've reloaded your shell after installation:

```bash
source ~/.bashrc
```

Or open a new terminal.

### Command not found after installation

Make sure `~/.local/bin` is in your PATH:

```bash
echo $PATH | grep -q "$HOME/.local/bin" && echo "In PATH ✓" || echo "Not in PATH ✗"
```

The installer should add this automatically, but if it's missing, add to your `~/.bashrc`:

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
├── EXAMPLES.md            # Usage examples
├── INSTALLATION_GUIDE.md  # Detailed installation guide
├── CONTRIBUTING.md        # Contribution guidelines
├── CHANGELOG.md           # Version history
├── LICENSE                # GPL-3.0 license
├── .gitignore            # Git ignore rules
├── blauncher.sh          # Installer script (downloads actual blauncher)
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

**Questions?** Open an issue on [GitHub](https://github.com/mcqueentrading/blauncher/issues)
