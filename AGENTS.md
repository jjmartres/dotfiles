# Agent Context — dotfiles

## Identity

You are assisting me. This is a personal dotfiles repository managed with **GNU Stow**.

---

## Repository Structure

Every top-level directory is a **Stow package**. Its internal layout mirrors `$HOME`, so `stow */` creates symlinks from each package into `$HOME`.

```
dotfiles/
├── bootstrap.sh              # Entry point: dispatches by OS, then stow */
├── bootstrap.d/darwin/       # macOS bootstrap scripts (numbered, run in order)
├── bootstrap.d/linux/        # Linux bootstrap scripts
├── Brewfile                  # Declarative package manifest — source of truth
├── .stowrc                   # target=$HOME; ignore patterns
├── .pre-commit-config.yaml   # YAML lint, EOF, trailing-whitespace checks
├── fish/                     # Primary shell (functions/, conf.d/, completions/)
├── nvim/                     # Neovim — LazyVim-based
├── zellij/                   # Terminal multiplexer + layouts
├── git/                      # Global gitconfig + template
├── starship/                 # Cross-shell prompt
├── atuin/                    # Shell history sync
├── television/               # Fuzzy finder — custom cable channels
├── worktrunk/                # Git worktree manager
└── …                         # One directory per tool
```

---

## Bootstrap & Deploy Commands

```fish
# Full bootstrap (macOS)
sh ./bootstrap.sh

# Deploy all symlinks (after editing configs)
stow --dir=(pwd) --target=$HOME */

# Restow a single package after changes
stow -R fish
stow -R zellij

# Simulate before deploying (dry-run)
stow --simulate --dir=(pwd) --target=$HOME */
```

### Brewfile Management

```fish
brew bundle --file ~/dotfiles/Brewfile   # install / reconcile
brew install <pkg> && brew bundle dump --force               # add + record
brew bundle cleanup --file ~/dotfiles/Brewfile               # audit
```

---

## Lint / Validation

No automated tests. Validation is pre-commit hooks + manual stow simulation.

```fish
pre-commit run --all-files          # run all hooks on every file
pre-commit run check-yaml --all-files
pre-commit run trailing-whitespace --all-files
pre-commit run end-of-file-fixer --all-files
```

Hooks (run on `pre-commit` and `pre-push` stages):
- `check-yaml` — validates all YAML files
- `end-of-file-fixer` — every file must end with a newline
- `trailing-whitespace` — strips trailing whitespace

### Full System Update

```fish
update   # nvim plugins → Mason → CLT → asdf → brew bundle → brew upgrade → cleanup
```

---

## Shell Environment

- **Shell**: Fish (`/opt/homebrew/bin/fish`)
- **Always use Fish syntax** — no bashisms
- **Forbidden**: `export`, `source`, `$()` subshells (use `(cmd)`), `[[`, `&&`/`||` (use `; and`/`; or`)
- **Prompt**: Starship — theme driven by `$DEFAULT_THEME`
- **Multiplexer**: Zellij (default shell = fish)
- **Version manager**: asdf (`~/.asdf/shims`)

### Theme System

`$DEFAULT_THEME` is auto-detected at shell init via macOS dark/light mode:
- Dark → `catppuccin-macchiato` · Light → `catppuccin-latte`

Never hardcode a theme name. All tools use Catppuccin; always reference `$DEFAULT_THEME`.

---

## Code Style Guidelines

### Fish — Functions

- **One function per file**, filename = function name: `functions/my_fn.fish`
- First line: `function name --description "..."`
- `set -l` for locals; `set -gx` for exported globals
- **Critical scoping rule**: `set -l` inside an `if`/`else` branch is local to that branch only.
  Declare the variable before the conditional, then reassign without `-l` inside branches:
  ```fish
  set -l layout default          # declare outside
  if test -f "$dir/$name.kdl"
      set layout $name           # reassign, no -l
  end
  ```
- Use `set_color` for terminal output — never raw ANSI codes
- Argument validation: `test (count $argv) -eq N`
- Multi-branch argument parsing: `switch`/`case`, not nested `if`
- Flag parsing pattern: loop `$argv`, match flags with `switch`, collect positionals separately
- Exit codes: `return 0` success, `return 1` error
- Long logic belongs in `functions/` — never inline in `conf.d/`

### Fish — conf.d/ Load Order

| Prefix | Purpose |
|--------|---------|
| `000_` | Initialization (Homebrew path, theme detection) |
| `100_` | Environment variable exports |
| `200_` | Aliases and abbreviations |
| `600_` | Work-specific (gitignored) |

- Use `abbr` for git shortcuts (expand inline) — not `alias`
- Use `alias` only for non-git shell shortcuts

### Fish — Completions

Completion files live in `fish/.config/fish/completions/<command>.fish`. Conventions:
- Always start with `complete -c <cmd> -f` to disable default file completion
- Use helper functions prefixed `__<cmd>_` for dynamic candidate lists
- Condition flags with `-n` guards using `contains -- <flag> (commandline -opc)`
- Re-enable directory completion for path arguments with `complete -c <cmd> -F -n "..."`
- Suppress conflicting flags from each other with mutual `-n` guards

### Zellij — Layouts (KDL)

- Layouts live in `zellij/.config/zellij/layouts/<name>.kdl`
- `default.kdl` is the fallback when no session-specific layout exists
- Tab name icons: use Nerd Font glyphs (`󱃾`, ``, `󰆦`, `` etc.)
- Suspended tabs: use `start_suspended=true` for heavy processes (k9s, nibbler)
- Plain terminal tab: `tab name="  terminal" { pane }`

### Brewfile

- Groups separated by `## Category` comments
- Format: `brew "name"  # Description` (align comments at column 42)
- Taps before formulae; fonts before shell utilities
- Platform conditionals: `if OS.mac?` inline, not separate blocks

### YAML / Configuration

- 2-space indentation; no YAML anchors unless necessary
- All YAML must pass `check-yaml`

### Terraform

- `for_each` over `count` always
- Explicit `depends_on` when ordering matters
- `lifecycle { prevent_destroy = true }` on stateful resources (CloudSQL, GCS, KMS)

### Python

- Type hints on all functions and class attributes
- `uv` for dependency management (`uv add`, `uv sync`) — never `pip install`
- Dataclasses over plain dicts; `pydantic` for external data validation

### Git Commits

Conventional commits with emoji (enforced by the `commit` function):

| Emoji | Type | Use for |
|-------|------|---------|
| ✨ | `feat:` | new feature |
| 🐛 | `fix:` | bug fix |
| ♻️ | `refactor:` | restructure without behaviour change |
| 🚀 | `ci:` | CI/CD changes |
| 📝 | `docs:` | documentation |
| 🔧 | `chore:` | maintenance |
| 🔒 | `security:` | security fix |
| ⬆️ | `deps:` | dependency update |

Default branch: `develop`. Push with `--force-with-lease`, never `--force`.

---

## Environment Variables (code function)

The `code` function reads these at runtime; set them in `conf.d/101_secrets_exports.fish`:

| Variable | Purpose | Default |
|----------|---------|---------|
| `CODE_CACHE_DIR` | Repository list cache location | `~/.fish_code_function_cache` |
| `CODE_DEFAULT_SESSION` | Default Zellij session name | _(empty)_ |
| `CODE_DEFAULT_PATH` | Default repository search root | _(empty)_ |

---

## Secrets & Sensitive Files

Never commit — gitignored by pattern:

| File / Pattern | Contents |
|----------------|----------|
| `fish/conf.d/101_secrets_exports.fish` | API keys, tokens, credentials |
| `fish/functions/gcloud_config_generate.fish` | GCP auth config |
| `fish/*company_name*` | Employer-specific aliases |
| `*.lock.json` (except `Brewfile.lock.json`) | Lock files |

Use `git-crypt` for sensitive files that must be committed. Atuin filters `gcloud secrets`, `gcloud kms`, `gcloud auth`, and `gcloud compute ssh` from history.

---

## AI Workflow

- **Primary agent**: `opencode` with project-specific agent detection from `opencode.json`
- **Commit generation**: `commit` function — opencode + Gemini 2.5 Pro → auto-push + GitLab MR
- **Worktree commits**: `worktrunk` via opencode `/commit` slash command
- **Default model**: `google-vertex/gemini-2.5-pro`

### Memory Bank

At session start for substantial tasks, check for `.opencode/memory-bank/` in the project root. If present, read all files before proceeding (`projectbrief.md`, `activeContext.md`, `systemPatterns.md`, `techContext.md`, `progress.md`).

---

## Response Style

- Be concise — no preamble or filler
- Show **complete** file content when editing configs — never truncate with `# ... rest unchanged`
- Fish syntax in all terminal examples
- Maintain Brewfile comment alignment and category grouping when editing
- After changes to a stow package, note the required restow: `stow -R <package>`
