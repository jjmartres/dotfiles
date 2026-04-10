# Neovim Keymaps

All custom keymaps defined in this configuration. LazyVim default keymaps are not listed here — see https://www.lazyvim.org/keymaps for those.

`<leader>` = `Space`

---

## AI (opencode)

| Mode | Key | Description |
|------|-----|-------------|
| `n` `x` | `<C-a>` | Ask opencode with current selection |
| `n` `x` | `<C-x>` | Execute opencode action picker |
| `n` `t` | `<C-.>` | Toggle opencode panel |
| `n` `x` | `go` | Add range to opencode session |
| `n` | `goo` | Add current line to opencode session |
| `n` | `<S-C-u>` | Scroll opencode panel up |
| `n` | `<S-C-d>` | Scroll opencode panel down |
| `n` | `+` | Increment number under cursor (remapped from `<C-a>`) |

---

## Git — General

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>gg` | Lazygit |
| `n` | `<leader>gb` | Git file log |
| `n` | `<leader>gC` | Commit (runs fish `commit` function) |

## Git — Hunks (`<leader>gh`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `]h` | Next hunk |
| `n` | `[h` | Previous hunk |
| `n` | `]H` | Last hunk |
| `n` | `[H` | First hunk |
| `n` `x` | `<leader>ghs` | Stage hunk |
| `n` `x` | `<leader>ghr` | Reset hunk |
| `n` | `<leader>ghS` | Stage buffer |
| `n` | `<leader>ghu` | Undo stage hunk |
| `n` | `<leader>ghR` | Reset buffer |
| `n` | `<leader>ghp` | Preview hunk inline |
| `n` | `<leader>ghb` | Blame line (full) |
| `n` | `<leader>ghB` | Blame buffer |
| `n` | `<leader>ghd` | Diff this |
| `n` | `<leader>ghD` | Diff this ~ |
| `o` `x` | `ih` | Select hunk (text object) |

## Git — Diff (`<leader>gd`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>gd` | Open diff view |
| `n` | `<leader>gD` | Close diff view |
| `n` | `<leader>gf` | Current file history |
| `n` | `<leader>gF` | Branch history |

## Git — GitLab (`<leader>gl`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>glr` | Review MR |
| `n` | `<leader>gls` | MR summary |
| `n` | `<leader>glA` | Approve MR |
| `n` | `<leader>glR` | Revoke approval |
| `n` | `<leader>glc` | Create comment |
| `n` | `<leader>gld` | Toggle discussions |
| `n` | `<leader>gln` | Create note |
| `n` | `<leader>glp` | Pipeline status |
| `n` | `<leader>glo` | Open MR in browser |
| `n` | `<leader>glm` | Merge MR |
| `n` | `<leader>gla` | Add assignee |
| `n` | `<leader>glM` | List MRs |

## Git — GitHub (`<leader>go`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>gop` | List PRs |
| `n` | `<leader>goi` | List issues |
| `n` | `<leader>gor` | Start review |
| `n` | `<leader>gos` | Submit review |
| `n` | `<leader>goc` | Add comment |
| `n` | `<leader>goa` | Create PR |
| `n` | `<leader>goo` | Open PR in browser |

---

## Diagnostics (`<leader>x`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>xx` | Workspace diagnostics (Trouble) |
| `n` | `<leader>xX` | Buffer diagnostics (Trouble) |
| `n` | `<leader>xL` | Location list (Trouble) |
| `n` | `<leader>xQ` | Quickfix list (Trouble) |
| `n` | `[q` | Previous trouble/quickfix item |
| `n` | `]q` | Next trouble/quickfix item |

---

## Code (`<leader>c`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>cs` | Symbols (Trouble) |
| `n` | `<leader>cS` | LSP references/definitions (Trouble) |

---

## File & Find (`<leader>f`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>fk` | Search keymaps (Telescope) |
| `n` | `<leader>fp` | Projects picker |
| `n` | `-` | Open parent directory (Oil) |
| `n` | `<leader>-` | Open parent directory (Oil float) |

---

## Motion

| Mode | Key | Description |
|------|-----|-------------|
| `n` `x` `o` | `s` | Flash jump |
| `n` `x` `o` | `S` | Flash treesitter jump |
| `o` | `r` | Remote flash |
| `o` `x` | `R` | Treesitter search |
| `c` | `<c-s>` | Toggle flash search |

---

## Editing — Surround (`gs`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `gsa` | Add surrounding |
| `n` | `gsd` | Delete surrounding |
| `n` | `gsr` | Replace surrounding |
| `n` | `gsf` | Find surrounding (right) |
| `n` | `gsF` | Find surrounding (left) |
| `n` | `gsh` | Highlight surrounding |
| `n` | `gsn` | Update n_lines |

---

## Terminal (`<leader>t`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>tt` | Toggle terminal |
| `n` | `<leader>tf` | Float terminal |
| `n` | `<leader>th` | Horizontal terminal |
| `n` | `<leader>tv` | Vertical terminal |
| `n` | `<C-/>` | Toggle floating terminal (Snacks) |

---

## UI (`<leader>u`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>uG` | Toggle git signs |
| `n` | `<leader>um` | Toggle render markdown |
| `n` | `<leader>m` | Toggle zen mode (zen-mode.nvim) |

---

## Notes / Zettelkasten (`<leader>z`)

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<leader>zn` | New note |
| `n` | `<leader>zp` | New project note |
| `n` | `<leader>zi` | New incident note |
| `n` | `<leader>zd` | Daily note |
| `n` | `<leader>zf` | Find notes |
| `n` | `<leader>zt` | Find by tags |
| `n` | `<leader>zg` | Grep notes |
| `n` | `<leader>zl` | Insert link |
| `v` | `<leader>zl` | Insert link at selection |
| `n` | `<leader>zb` | Backlinks |
| `n` | `<leader>zo` | Outgoing links |
| `v` | `<leader>znt` | New note from title selection |
| `v` | `<leader>znc` | New note from content selection |

**Markdown buffers only:**

| Mode | Key | Description |
|------|-----|-------------|
| `n` | `<CR>` | Follow link |
| `n` | `<BS>` | Go back |

---

## Snippets

| Mode | Key | Description |
|------|-----|-------------|
| `i` | `<Tab>` | Jump to next placeholder (or insert tab) |
| `s` | `<Tab>` | Jump forward in snippet |
| `i` `s` | `<S-Tab>` | Jump backward in snippet |

---

## Dashboard (startup screen)

| Key | Description |
|-----|-------------|
| `n` | New file |
| `f` | Find file |
| `g` | Find text (live grep) |
| `r` | Recent files |
| `c` | Config files |
| `s` | Restore session |
| `l` | Lazy plugin manager |
| `q` | Quit |
