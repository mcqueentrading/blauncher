# blauncher Quick Start Guide

Launch GUI applications from your terminal without blocking it, cluttering it with output, or tying apps to your shell session. Get started in 2 minutes!

## Installation

### Option 1: Automated Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/install.sh | bash
source ~/.bashrc
```

### Option 2: Manual Install

1. Download blauncher.sh:
   ```bash
   curl -o ~/.blauncher https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh
   ```

2. Add to your ~/.bashrc:
   ```bash
   echo "source ~/.blauncher" >> ~/.bashrc
   ```

3. Reload:
   ```bash
   source ~/.bashrc
   ```

## Basic Usage

### The Three Commands

**`oo`** - Launch and **exit shell**
```bash
oo firefox
```
*Use when: You just want to launch something quickly*

**`op`** - Launch and **keep shell open**
```bash
op nemo ~/Downloads
```
*Use when: You want to see the PID or keep working in the terminal*

**`orp`** - Launch with **maximum resilience**
```bash
orp thunderbird
```
*Use when: App must survive logout (email, servers, etc.)*

## Real Examples

### Open a file manager
```bash
oo nemo ~/Documents
```

### Play a video
```bash
oo vlc movie.mp4
```

### Edit code
```bash
op code ~/projects/my-app
```

### Start your browser
```bash
oo firefox
```

## Tab Completion Magic ✨

Just press TAB and it works like normal bash:

```bash
oo fire<TAB>           → oo firefox
oo nemo ~/Doc<TAB>     → oo nemo ~/Documents/
oo nemo ~/Documents/<TAB>  → Shows folder contents
```

**Directory navigation?** Works perfectly! When you tab-complete a directory, it adds a `/` so you can keep going.

## Common Gotchas

### Paths with spaces?
Use quotes:
```bash
oo nemo "~/My Documents"
```

### Want the PID?
Use `op` instead of `oo`:
```bash
op firefox
# Output: orphan, no child (12345)
```

### App exits immediately?
Some apps fork themselves. Use `op` or `orp` instead of `oo`.

## What's Next?

- See [EXAMPLES.md](EXAMPLES.md) for more use cases
- Read [README.md](README.md) for full documentation
- Check [CONTRIBUTING.md](CONTRIBUTING.md) to help improve blauncher

## Need Help?

Open an issue: https://github.com/mcqueentrading/blauncher/issues

---

**That's it!** You're ready to launch apps like a pro. 🚀
