---
name: memory-bank
description: >
  Manage the project memory bank — a set of Markdown files in `.pi/memory-bank/`
  that persist context across sessions. Use when the user says "update memory bank",
  "init memory bank", "read memory bank", or when starting a new substantial task
  on an existing project. Also auto-triggers at session start if `.pi/memory-bank/`
  exists in the working directory.
license: MIT
compatibility: pi
---

# Memory Bank

The memory bank compensates for the fact that every pi session starts fresh. It is a set of Markdown files stored at `.pi/memory-bank/` in the project root that capture everything needed to resume work effectively.

## Storage Location

**ALWAYS** store at `.pi/memory-bank/` (not `.opencode/memory-bank/`).

```
.pi/
└── memory-bank/
    ├── projectbrief.md      ← foundation: goals, scope, requirements
    ├── productContext.md    ← why it exists, problems solved, UX goals
    ├── activeContext.md     ← current focus, recent changes, next steps
    ├── systemPatterns.md    ← architecture, key decisions, design patterns
    ├── techContext.md       ← tech stack, setup, constraints, dependencies
    └── progress.md          ← what works, what's left, known issues
```

## Session Start Protocol

1. Check: does `.pi/memory-bank/` exist in cwd?
2. **Yes** → Read ALL files before doing anything else
3. **No** → If this is a substantial task, offer to initialise it

## Core Workflows

### Initialise (new project)

```bash
mkdir -p .pi/memory-bank
```

Create each core file with a brief skeleton based on what you can infer from the codebase:

- `projectbrief.md` — what is this project? what are the goals?
- `productContext.md` — why does it exist? what problem does it solve?
- `activeContext.md` — what is the current task/focus?
- `systemPatterns.md` — what architectural patterns are used?
- `techContext.md` — what technologies, tools, versions are in play?
- `progress.md` — what is done? what remains?

### Update (during/after work)

Update when:
- A new pattern or architecture decision is made
- A significant feature or change is implemented
- The user explicitly says **update memory bank**
- Context needs clarification for future sessions

Always update `activeContext.md` and `progress.md`. Update others as relevant.

### Read (session resume)

When resuming work, read all files and briefly summarise:
- What the project is
- Where things were left off
- What the immediate next steps are

## File Templates

### projectbrief.md
```markdown
# Project Brief

## Overview
[1-2 sentence description]

## Goals
- [goal 1]
- [goal 2]

## Scope
[what is in scope / out of scope]

## Constraints
[technical, regulatory, timeline constraints]
```

### activeContext.md
```markdown
# Active Context

## Current Focus
[what is being worked on right now]

## Recent Changes
- [change 1]
- [change 2]

## Next Steps
1. [next step 1]
2. [next step 2]

## Open Questions / Blockers
- [question or blocker]

## Key Decisions Made
- [decision + rationale]
```

### progress.md
```markdown
# Progress

## Working
- [feature/component that works]

## In Progress
- [what is currently being built]

## TODO
- [what remains]

## Known Issues
- [issue + workaround if any]

## Completed Milestones
- [milestone + date]
```

## Important Notes

- Never store secrets, API keys, or credentials in memory bank files
- Keep files concise — they are read on every session start, so brevity matters
- `activeContext.md` and `progress.md` are the most critical files; always keep them current
- Additional files/folders can be created for complex features, API specs, deployment procedures, etc.
