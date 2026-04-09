# Neovim Plugins

LazyVim-based configuration. Each file in this directory is auto-loaded by Lazy.nvim.

---

## Git

| Plugin | File | Description |
|--------|------|-------------|
| `lewis6991/gitsigns.nvim` | `git.lua` | Signs in the gutter for added/changed/deleted lines. Stage, reset, preview, and blame individual hunks without leaving the buffer. `<leader>gh*` keymaps, `ih` text object for hunk selection, `<leader>uG` to toggle signs. |
| `sindrets/diffview.nvim` | `diff.lua` | Side-by-side diff view and full git file history browser. `<leader>gd` open, `<leader>gD` close, `<leader>gf` current file history, `<leader>gF` branch history. |
| `harrisoncramer/gitlab.nvim` | `forge.lua` | GitLab MR review, discussions, approvals, pipeline status, and merge — all inside Neovim. Requires a GitLab personal access token. `<leader>gl*` keymaps. |
| `pwntester/octo.nvim` | `forge.lua` | GitHub PR and issue management, inline code review, comments, and approvals via Telescope. Requires a GitHub personal access token. `<leader>go*` keymaps. |

---

## UI & Appearance

| Plugin | File | Description |
|--------|------|-------------|
| `folke/snacks.nvim` | `ui.lua` | Dashboard with git status and MR summary on startup, zen mode, floating terminal (`<C-/>`), Snacks picker, and Oil file rename hook. |
| `nvim-lualine/lualine.nvim` | `statusline.lua` | Status line. Replaces the right-most section with a live clock. |
| `folke/which-key.nvim` | `keymaps.lua` | Keymap popup with group labels and Nerd Font icons for `+git`, `+terminal`, `+zettelkasten`, and more. |
| `f-person/auto-dark-mode.nvim` | `theme.lua` | Polls macOS every 5s and switches between `catppuccin-macchiato` (dark) and `catppuccin-latte` (light) automatically. |
| `folke/zen-mode.nvim` | `focus.lua` | Centres the buffer at 120 columns, hides line numbers and sign column, enables Twilight. `<leader>m`. |
| `MeanderingProgrammer/render-markdown.nvim` | `markdown.lua` | Renders Markdown headings, code blocks, and lists visually inside the buffer. Toggle with `<leader>um`. |
| `catppuccin` | `colorscheme.lua` | Default colorscheme set to `catppuccin-macchiato`. |

---

## Navigation

| Plugin | File | Description |
|--------|------|-------------|
| `folke/flash.nvim` | `motion.lua` | Jump to any visible position with 1-2 keystrokes. `s` to jump, `S` for treesitter-aware jump, `r` remote flash in operator mode. |
| `stevearc/oil.nvim` | `explorer.lua` | File manager that edits the filesystem like a buffer. `-` opens parent directory, `<leader>-` opens as float. Handles renames via the snacks hook. |
| `nvim-telescope/telescope.nvim` | `finder.lua` | Fuzzy finder with fzf-native sorting. Ignores `.git/`, `node_modules/`, `.terraform/`, and `vendor/` by default. |

---

## Diagnostics

| Plugin | File | Description |
|--------|------|-------------|
| `folke/trouble.nvim` | `diagnostics.lua` | Persistent panel for LSP diagnostics, references, quickfix, and location lists. `<leader>xx` workspace diagnostics, `<leader>xX` buffer diagnostics, `<leader>cs` symbols, `<leader>xQ` quickfix. |

---

## Editing

| Plugin | File | Description |
|--------|------|-------------|
| `nvim-mini/mini.surround` | `editing.lua` | Add, delete, replace surrounding characters. `gsa` add, `gsd` delete, `gsr` replace, all under the `gs` group registered in which-key. |

---

## Syntax & Parsing

| Plugin | File | Description |
|--------|------|-------------|
| `nvim-treesitter/nvim-treesitter` | `syntax.lua` | Syntax parsing for accurate highlighting, indentation, and text objects. Parsers installed: bash, fish, go, hcl, helm, lua, markdown, terraform, toml, yaml, and more. |

---

## Completion & Snippets

| Plugin | File | Description |
|--------|------|-------------|
| `Saghen/blink.cmp` | `completion.lua` | Completion engine. Sources: LSP, path, snippets, buffer, Supermaven (AI), and `codecompanion` in AI chat buffers. Supermaven suggestions appear in the dropdown with priority over other sources. |
| `supermaven-inc/supermaven-nvim` | `completion.lua` | AI completion provider feeding into blink.cmp. Inline ghost text disabled — suggestions surface through the blink dropdown instead. |
| `L3MON4D3/LuaSnip` | `snippets.lua` | Snippet engine. Loads VS Code snippets from `friendly-snippets` and `./snippets`. `<Tab>`/`<S-Tab>` to jump placeholders. |

---

## Formatting & Spelling

| Plugin | File | Description |
|--------|------|-------------|
| `stevearc/conform.nvim` | `formatting.lua` | Format on save. Fish → `fish_indent`, Go → `gofumpt`, JSON → `prettier`, Lua → `stylua`, Markdown → `prettier`, sh → `shfmt`, TOML → `taplo`, YAML → `yamlfmt`. |
| `typos-lsp` | `spelling.lua` | LSP that catches common typos across all filetypes. |
| `harper-ls` | `spelling.lua` | English grammar checker (American dialect). Runs as hints to avoid noise. |

---

## Language-specific

| Plugin | File | Description |
|--------|------|-------------|
| `hashivim/vim-terraform` | `terraform.lua` | Terraform/HCL syntax, auto-alignment, and `terraform fmt` on save. |
| `gopls` via `nvim-lspconfig` | `go.lua` | Go language server with custom root detection: prefers `go.mod` (including `app/go.mod`, `src/go.mod`), falls back to `.git` root. |
| `towolf/vim-helm` | `helm.lua` | Syntax highlighting for Helm chart templates (YAML + Go templating). |
| `cameron-wags/rainbow_csv.nvim` | `csv.lua` | Colours each CSV/TSV column differently. Supports comma, semicolon, pipe, and whitespace delimiters. |

---

## Notes & Zettelkasten

| Plugin | File | Description |
|--------|------|-------------|
| `zk-org/zk-nvim` | `notes.lua` | Full Zettelkasten workflow backed by the `zk` CLI and `~/.notes`. Create notes by title, group, or daily; search by content or tag; insert and navigate wiki-style links. `<Enter>` follows links, `<Backspace>` goes back. |
| `okuuva/auto-save.nvim` | `autosave.lua` | Autosaves only `working-sessions` Markdown files inside `$ZK_NOTEBOOK_DIR`. Everything else is untouched. |

---

## Terminal

| Plugin | File | Description |
|--------|------|-------------|
| `akinsho/toggleterm.nvim` | `terminal.lua` | Multiple terminal layouts. `<leader>tt` toggle, `<leader>tf` float, `<leader>th` horizontal, `<leader>tv` vertical. |

---

## AI & Workflow

| Plugin | File | Description |
|--------|------|-------------|
| `nickjvandyke/opencode.nvim` | `ai.lua` | OpenCode AI agent inside Neovim. `<C-a>` sends selection to it, `<C-x>` opens action picker, `<C-.>` toggles the panel. `go`/`goo` operator motions to add ranges to the session. |

---

## Project Navigation

| Plugin | File | Description |
|--------|------|-------------|
| custom | `projects.lua` | Reads `$NVIM_PROJECTS_FILE` (generated by the `code` Fish function) into a Snacks picker. Selecting a project `cd`s into it and opens a scoped file finder. `<leader>fp`. |

---

## Environment Variables

| Variable | Used by | Description |
|----------|---------|-------------|
| `NVIM_PROJECTS_FILE` | `projects.lua` | Path to the project list file (one absolute path per line). Written by the `code` Fish function as `$CODE_CACHE_DIR/$CODE_DEFAULT_SESSION.nvim`. |
| `ZK_NOTEBOOK_DIR` | `autosave.lua` | Root of the Zettelkasten notebook. Autosave is scoped to `working-sessions` files within it. |
