# Keybindings Reference

> Notation: `Ctrl Alt` = Control + Option (three modifiers on macOS).
> Mode keys return to **Normal** automatically after the action unless noted.

---

## Global — `code` Workflow

| Command | Description |
|---------|-------------|
| `code` | Open repository picker (fzf), create/focus Zellij tab, launch Neovim |
| `code --refresh` | Force-rebuild repository cache before opening picker |
| `code --rm` | Delete the named Zellij session |
| `tab` | Open tab picker (fzf), switch to selected tab |

---

## Always Active (all modes except Locked)

### Custom — Ctrl Alt

| Key | Action |
|-----|--------|
| `Ctrl Alt t` | Open tab picker (fzf floating pane) |
| `Ctrl Alt w` | Open session manager |
| `Ctrl Alt d` | Detach from session |
| `Ctrl Alt q` | Quit session |
| `Ctrl Alt h` | Move focus left |
| `Ctrl Alt j` | Move focus down |
| `Ctrl Alt k` | Move focus up |
| `Ctrl Alt l` | Move focus right |
| `Ctrl Alt f` | Toggle fullscreen |
| `Ctrl Alt ]` | Go to previous tab |
| `Ctrl Alt [` | Go to next tab |

### Default — Alt

| Key | Action |
|-----|--------|
| `Alt h` / `Alt ←` | Move focus or tab left |
| `Alt l` / `Alt →` | Move focus or tab right |
| `Alt j` / `Alt ↓` | Move focus down |
| `Alt k` / `Alt ↑` | Move focus up |
| `Alt n` | New pane |
| `Alt f` | Toggle floating panes |
| `Alt i` | Move tab left |
| `Alt o` | Move tab right |
| `Alt =` / `Alt +` | Resize increase |
| `Alt -` | Resize decrease |
| `Alt [` | Previous swap layout |
| `Alt ]` | Next swap layout |
| `Ctrl g` | Enter Locked mode |
| `Ctrl q` | Quit |

---

## Mode Entry

| Key | Mode entered |
|-----|-------------|
| `Ctrl p` | Pane mode |
| `Ctrl t` | Tab mode |
| `Ctrl n` | Resize mode |
| `Ctrl s` | Scroll mode |
| `Ctrl h` | Move mode |
| `Ctrl o` | Session mode |
| `Ctrl g` (in Locked) | Back to Normal |

---

## Pane Mode (`Ctrl p`)

| Key | Action |
|-----|--------|
| `h/j/k/l` | Move focus left/down/up/right |
| `n` | New pane |
| `d` | New pane below |
| `r` | New pane right |
| `s` | New pane stacked |
| `x` | Close focused pane |
| `f` | Toggle fullscreen |
| `w` | Toggle floating panes |
| `e` | Embed / float pane |
| `z` | Toggle pane frames |
| `c` | Rename pane |
| `i` | Pin / unpin floating pane |
| `p` | Switch focus |

---

## Tab Mode (`Ctrl t`)

| Key | Action |
|-----|--------|
| `h/k/←/↑` | Previous tab |
| `l/j/→/↓` | Next tab |
| `n` | New tab |
| `x` | Close tab |
| `r` | Rename tab |
| `1`–`9` | Go to tab N |
| `Tab` | Toggle last used tab |
| `b` | Break pane into new tab |
| `[` | Break pane left |
| `]` | Break pane right |
| `s` | Sync tab |

---

## Resize Mode (`Ctrl n`)

| Key | Action |
|-----|--------|
| `h/j/k/l` | Increase size in direction |
| `H/J/K/L` | Decrease size in direction |
| `=` / `+` | Increase overall |
| `-` | Decrease overall |

---

## Scroll Mode (`Ctrl s`)

| Key | Action |
|-----|--------|
| `j/↓` | Scroll down |
| `k/↑` | Scroll up |
| `d` | Half page down |
| `u` | Half page up |
| `Ctrl f` / `PageDown` | Page down |
| `Ctrl b` / `PageUp` | Page up |
| `Ctrl c` | Scroll to bottom |
| `s` | Enter search |
| `e` | Edit scrollback in `$EDITOR` |

---

## Search Mode (from Scroll → `s`)

| Key | Action |
|-----|--------|
| `n` | Next match |
| `p` | Previous match |
| `c` | Toggle case sensitivity |
| `w` | Toggle wrap |
| `o` | Toggle whole word |
| `Ctrl c` | Back to scroll bottom |

---

## Session Mode (`Ctrl o`)

| Key | Action |
|-----|--------|
| `d` | Detach |
| `w` | Session manager |
| `c` | Configuration |
| `p` | Plugin manager |
| `a` | About |
| `Ctrl s` | Switch to Scroll mode |
