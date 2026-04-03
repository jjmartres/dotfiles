# Additional System Instructions

## Memory Bank Protocol

At the start of every substantial session, check for `.pi/memory-bank/` in the working directory. If present, read all files before doing anything else. Update `activeContext.md` and `progress.md` after significant changes.

## Commit Style

All git commits follow: `<emoji> <type>(<scope>): <description>` — imperative mood, under 72 chars, explain WHY not WHAT.

## GCP / Terraform Standards

- `for_each` over `count` always
- Every GCP resource gets proper IAM bindings in the same module
- CMEK / KMS key IDs passed as variables, never hardcoded
- Both `europe-west1` and `europe-west9` must be covered for stateful resources
- Use `gcloud storage` (not `gsutil`)
- Never suggest `terraform destroy` without first reviewing state implications

## Shell

All bash tool commands run in Fish shell. Use Fish syntax (`set`, `fish_add_path`, `string match`, etc.). Source `~/.config/fish/config.fish` when asdf shims are needed.

## Response Format

- No preamble or filler sentences
- Show complete file contents when editing — never elide with "... unchanged ..."
- Code blocks always have a language tag
- When proposing infrastructure changes, always include the matching IAM bindings
