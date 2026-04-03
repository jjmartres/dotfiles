# pi Coding Agent — Personal Configuration

Ported from [jjmartres/opencode](https://github.com/jjmartres/opencode).

## Installation

```fish
# 1. Install pi
npm install -g @mariozechner/pi-coding-agent

# 2. Deploy global config
mkdir -p ~/.pi/agent
cp settings.json      ~/.pi/agent/settings.json
cp auth.json          ~/.pi/agent/auth.json        # then chmod 600
cp AGENTS.md          ~/.pi/agent/AGENTS.md
cp APPEND_SYSTEM.md   ~/.pi/agent/APPEND_SYSTEM.md
cp -r themes/         ~/.pi/agent/themes/
cp -r prompts/        ~/.pi/agent/prompts/
cp -r skills/         ~/.pi/agent/skills/

chmod 600 ~/.pi/agent/auth.json

# 3. Set environment variables (add to ~/.config/fish/config.fish)
set -x ANTHROPIC_API_KEY     "sk-ant-..."
set -x VERTEXAI_PROJECT_ID   "your-gcp-project"
set -x VERTEXAI_REGION       "europe-west1"
set -x OPENROUTER_API_KEY    "sk-or-..."   # optional

# 4. Authenticate Vertex AI (for Gemini models)
gcloud auth application-default login
# OR use /login inside pi and select Google Gemini CLI

# 5. Launch
pi
```

## Provider Setup

### Google Vertex AI (primary — Gemini 2.5 Pro)

Pi does not have a native `google-vertex` provider like opencode. Use one of:

**Option A — Google Gemini CLI (recommended, free tier available)**
```
pi
/login   → select "Google Gemini CLI"
```
Then set model: `/model` → `gemini-2.5-pro`

**Option B — Gemini API key**
```fish
set -x GEMINI_API_KEY "..."
```
Provider: `google`, model: `gemini-2.5-pro`

**Option C — Vertex AI via Application Default Credentials**
```fish
set -x GOOGLE_CLOUD_PROJECT $VERTEXAI_PROJECT_ID
gcloud auth application-default login
```
Provider: `google-vertex` (once supported in your pi version)

### Anthropic (fallback)
```fish
set -x ANTHROPIC_API_KEY "sk-ant-..."
```
Switch with: `pi --provider anthropic --model claude-sonnet-4-20250514`
Or Ctrl+L inside pi.

### OpenRouter (optional)
```fish
set -x OPENROUTER_API_KEY "sk-or-..."
```

## Model Cycling (Ctrl+P)

Configured models for quick cycling:
- `gemini-2.5-pro` (default — big tasks)
- `gemini-2.5-flash` (fast — small tasks, equivalent to opencode's `small_model`)
- `claude-opus-4-*` (heavy reasoning)
- `claude-sonnet-4-*` (balanced)
- `claude-haiku-4-*` (fast Anthropic)

## Prompt Templates (= opencode commands)

Type `/` to expand. All your opencode `/command` shortcuts are preserved:

| pi prompt | opencode command | What it does |
|-----------|-----------------|--------------|
| `/commit` | `/commit` | Gitmoji conventional commit workflow |
| `/review` | `/review` | Review recent git changes |
| `/sync-branch` | `/sync-branch` | Rebase + force-with-lease push |
| `/test` | `/test` | Run tests with coverage |
| `/documentation` | `/documentation` | Update project documentation |
| `/memory-bank` | `/memory-bank` | Manage memory bank |
| `/datadog` | `/datadog` | Datadog CLI reference |
| `/compose-email` | `/compose-email` | Draft email (What-Why-How) |

## Skills (= opencode agents + skills)

Invoke with `/skill:name` or let pi load them automatically:

### Infrastructure / Platform
| Skill | When to use |
|-------|-------------|
| `terraform-engineer` | Writing modules, GCP IaC, state management |
| `kubernetes-specialist` | GKE, Gateway API, Shared VPC, RBAC |
| `sre-engineer` | SLOs, runbooks, incident post-mortems |
| `devops-engineer` | GitLab CI, Docker, pipeline design |
| `security-engineer` | CMEK, IAM audits, S3NS/Thales, PCI DSS |
| `platform-engineer` | Cloud Foundation, shared tooling, GitOps |

### AI / Data
| Skill | When to use |
|-------|-------------|
| `llm-architect` | Hermes/Nibbler architecture, Vertex AI, RAG |
| `mlops-engineer` | Vertex AI pipelines, LoRA fine-tuning |
| `data-engineer` | Datastream, Dataflow, CloudSQL replication |

### Specialised
| Skill | When to use |
|-------|-------------|
| `fintech-engineer` | Payment architecture, DORA/PSD2/GDPR |
| `code-reviewer` | Thorough code review |
| `debugger` | Root cause analysis, GKE failures |
| `git-workflow-manager` | GitLab MRs, rebase, branch hygiene |

### Tools
| Skill | When to use |
|-------|-------------|
| `glab` | GitLab CLI operations |
| `asdf` | Version manager setup/troubleshooting |
| `code-docs` | Google Style docs (Python/Go/Terraform) |
| `datadog` | Datadog observability queries |
| `mermaid-diagrams` | Architecture diagrams |
| `marp-slide` | Presentation slides |
| `worktrunk` | Git worktree + parallel agent sessions |
| `mcp-builder` | Build MCP servers |
| `memory-bank` | Session memory management |
| `httpie` | HTTP API testing |
| `jira` | Jira MCP operations |
| `notion` | Notion MCP operations |
| `work-on-ticket` | Jira ticket → branch workflow |

## Memory Bank

Pi has no persistent memory between sessions. The memory bank compensates:

```fish
# Per-project memory lives at:
.pi/memory-bank/
├── projectbrief.md
├── productContext.md
├── activeContext.md     ← most important
├── systemPatterns.md
├── techContext.md
└── progress.md
```

At session start, pi reads `AGENTS.md` and will check for `.pi/memory-bank/` if the `memory-bank` skill is loaded. Use `/memory-bank` to initialise or update.

## MCP — smartplaylist

Your opencode config had a `smartplaylist` MCP at `http://personal.local:8000/mcp`. Pi has no built-in MCP support. Options:

1. **Wrap as CLI tool** — expose it as a command and create a SKILL.md that teaches pi how to call it
2. **Extension** — write a TypeScript pi extension that proxies MCP calls

## Key Differences from opencode

| opencode | pi |
|----------|----|
| `google-vertex` native provider | Use Gemini CLI login or `GEMINI_API_KEY` |
| `default_agent: plan` | Use `/skill:terraform-engineer` etc. |
| Agent files in `agent/` | Converted to `skills/` |
| Built-in MCP | No built-in MCP — use CLI tools + skills |
| `rules/*.md` loaded always | Use `AGENTS.md` + `APPEND_SYSTEM.md` |
| `.opencode/memory-bank/` | `.pi/memory-bank/` |
| `autoupdate: true` | `pi update` manually |
