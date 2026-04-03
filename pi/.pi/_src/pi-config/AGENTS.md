# Agent Context

## Identity & Role

You are assisting **Jean-Jacques Martres**, Senior Cloud & AI Engineering Lead at **Fintecture** — a French B2B fintech payment platform (7,000+ business customers across Europe), reporting to CTO Anjan Som.

## Core Environment

| Tool | Value |
|------|-------|
| Shell | Fish (`/usr/bin/fish`) — use Fish syntax in all bash tool calls |
| Editor | Neovim / LazyVim |
| Multiplexer | Zellij |
| Version manager | asdf (shims at `~/.asdf/shims`) |
| Python packages | uv (prefer over pip) |
| Notes | Zettelkasten via `zk` |
| Dotfiles | GNU Stow |

## Infrastructure Stack

- **Cloud**: GCP — multi-region (europe-west1 primary / europe-west9 DR/DGFIP)
- **Kubernetes**: Multi-cluster GKE, Gateway API, Shared VPC
- **IaC**: Terraform + Terragrunt; `for_each` over `count` always
- **CI/CD**: GitLab CI; Docker executor runners (e2-standard-16, on-demand + Spot)
- **Containers**: Artifact Registry (both regions)
- **Secrets**: GCP KMS / CMEK, S3NS (Thales sovereign cloud), PAM
- **DB**: CloudSQL + Datastream + Dataflow (active-passive replication)
- **LLM**: Vertex AI (Gemini) — project/region from `VERTEXAI_PROJECT_ID` / `VERTEXAI_REGION`
- **Microservices**: 25+ services on GKE
- **Observability**: Datadog

## Active Projects (2026)

| Project | Description |
|---------|-------------|
| **S3NS** | KMS / CMEK onboarding across europe-west1 + europe-west9 |
| **GitLab CI** | Runner fleet overhaul, gcloud storage migrations, pipeline hardening |
| **Nibbler** | AI DevOps Slack bot — shell + Block Kit daily check reporting |
| **Hermes** | RAG/search agent — Chainlit + Vertex AI Vector Search + Notion MCP + PostgreSQL + Cloud Run |

## Memory Bank

**CRITICAL**: At the start of every session, check for `.pi/memory-bank/` in the current project directory. If it exists, read ALL files before proceeding. If it does not exist and the task is substantial, create it with the standard structure.

Memory bank location: `.pi/memory-bank/` (mirrors `.opencode/memory-bank/` convention)

Core files: `projectbrief.md`, `productContext.md`, `activeContext.md`, `systemPatterns.md`, `techContext.md`, `progress.md`

Update the memory bank: after significant changes, when discovering new patterns, or when explicitly asked with **update memory bank**.

## Code Style

| Language | Rules |
|----------|-------|
| Terraform | `for_each` over `count`; explicit `depends_on`; `lifecycle { prevent_destroy = true }` on stateful resources |
| Python | Type hints; `uv` for deps; dataclasses over plain dicts |
| Shell | Fish functions for anything >5 lines; avoid bashisms |
| YAML | 2-space indent; explicit keys; no anchors unless truly needed |
| Git | Conventional commits with emoji: `✨ feat:`, `🐛 fix:`, `♻️ refactor:`, `🚀 ci:`, etc. |

## Response Style

- Be concise — omit preamble and filler
- Show **complete** file content when editing configs (no `... rest unchanged ...`)
- Prefer Fish-compatible commands
- GCP changes: always include IAM bindings + Terraform snippets together
- Check existing Terraform state implications before proposing `terraform destroy`
- After significant work, update `.pi/memory-bank/activeContext.md` and `progress.md`
