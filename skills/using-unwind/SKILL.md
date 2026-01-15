---
name: using-unwind
description: Use when starting any reverse engineering task - establishes how to find and use Unwind skills for codebase analysis, service mapping, and documentation
---

# Using Unwind

## Overview

Unwind is a skills library focused on reverse engineering existing services and codebases. It provides structured approaches for understanding unfamiliar code, mapping service architectures, discovering APIs, and generating documentation.

## The Workflow

```
discovering-architecture     ← Start here: explore codebase
        │
        ▼
    architecture.md          ← Machine-parseable layer map
        │
        ▼
unwinding-codebase           ← Orchestrates layer specialists
        │
        ├──► analyzing-database-layer
        ├──► analyzing-domain-model
        ├──► analyzing-service-layer
        ├──► analyzing-api-layer
        ├──► analyzing-messaging-layer (if present)
        └──► analyzing-frontend-layer (if present)
        │
        ▼
    layers/*.md              ← Detailed layer documentation
        │
        ▼
synthesizing-findings        ← Combine into final doc
        │
        ▼
    CODEBASE.md              ← Complete documentation
```

## Quick Start

1. **Start with discovery:**
   ```
   Use unwind:discovering-architecture
   ```

2. **Review the architecture document:**
   Check `docs/unwind/architecture.md` for accuracy

3. **Run layer analysis:**
   ```
   Use unwind:unwinding-codebase
   ```

4. **Synthesize findings:**
   ```
   Use unwind:synthesizing-findings
   ```

## Available Skills

### Core Flow

| Skill | Purpose |
|-------|---------|
| `discovering-architecture` | Initial exploration, identifies layers and patterns |
| `unwinding-codebase` | Orchestrates layer-by-layer analysis with subagents |
| `synthesizing-findings` | Aggregates layer docs into unified CODEBASE.md |

### Layer Specialists

| Skill | Purpose |
|-------|---------|
| `analyzing-database-layer` | Schema, migrations, ORM, data access patterns |
| `analyzing-domain-model` | Entities, value objects, business rules, aggregates |
| `analyzing-service-layer` | Business logic, transformation, DTOs, integrations |
| `analyzing-api-layer` | REST/GraphQL endpoints, auth, contracts |
| `analyzing-messaging-layer` | Events, queues, async patterns |
| `analyzing-frontend-layer` | Components, state, routing, API integration |

## Output Structure

All documentation is written to the target project:

```
docs/unwind/
├── architecture.md       # Discovery output
├── layers/
│   ├── database.md
│   ├── domain-model.md
│   ├── service-layer.md
│   ├── api.md
│   ├── messaging.md      # If messaging exists
│   └── frontend.md       # If frontend exists
└── CODEBASE.md           # Final synthesized documentation
```

## Refresh Mode

All skills support incremental review:
- If docs exist, they load previous analysis
- Changes are highlighted in `## Changes Since Last Review`
- Re-run skills to update documentation after code changes

## When to Use Unwind Skills

- Onboarding to a new codebase
- Investigating an unfamiliar service
- Documenting legacy systems
- Understanding third-party integrations
- Preparing for migrations or refactors
- Security audits and code reviews

## The Rule

**Invoke relevant skills BEFORE diving into code.** Even a 1% chance a skill might apply means you should check it.

## Red Flags

These thoughts mean STOP - check for applicable skills:

| Thought | Reality |
|---------|---------|
| "Let me just grep around" | Skills provide systematic approaches |
| "I'll figure it out as I go" | Structure prevents missed components |
| "This codebase is simple" | Simple-looking code often hides complexity |
| "I'll document later" | Document as you discover |

## Contributing

To add new skills:
1. Create a directory under `skills/` with your skill name
2. Add a `SKILL.md` with frontmatter (name, description)
3. Follow the skill writing guidelines from `superpowers:writing-skills`
