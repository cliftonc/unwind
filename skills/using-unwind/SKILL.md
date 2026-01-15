---
name: using-unwind
description: Use when starting any reverse engineering task - establishes how to find and use Unwind skills for codebase analysis, service mapping, and documentation
---

# Using Unwind

## Overview

Unwind provides structured skills for reverse engineering codebases. Produces complete, machine-readable documentation with source links.

## Principles

See `analysis-principles.md`:
- **Completeness**: Document ALL items (30 tables = 30 documented)
- **Machine-readable**: Use actual code, SQL, mermaid - not markdown recreation
- **Link to source**: GitHub links with line numbers where possible
- **No commentary**: Facts only, no speculation or recommendations

## Workflow

```
discovering-architecture     → architecture.md
        │
unwinding-codebase          → dispatches layer specialists
        │
        ├── analyzing-database-layer     → database.md
        ├── analyzing-domain-model       → domain-model.md
        ├── analyzing-service-layer      → service-layer.md
        ├── analyzing-api-layer          → api.md
        ├── analyzing-messaging-layer    → messaging.md (if present)
        ├── analyzing-frontend-layer     → frontend.md (if present)
        ├── analyzing-unit-tests         → unit-tests.md
        ├── analyzing-integration-tests  → integration-tests.md
        └── analyzing-e2e-tests          → e2e-tests.md
        │
synthesizing-findings       → CODEBASE.md
```

## Skills

### Core Flow

| Skill | Output |
|-------|--------|
| `discovering-architecture` | `architecture.md` |
| `unwinding-codebase` | Orchestrates layer analysis |
| `synthesizing-findings` | `CODEBASE.md` |

### Layer Specialists

| Skill | Output |
|-------|--------|
| `analyzing-database-layer` | `database.md` |
| `analyzing-domain-model` | `domain-model.md` |
| `analyzing-service-layer` | `service-layer.md` |
| `analyzing-api-layer` | `api.md` |
| `analyzing-messaging-layer` | `messaging.md` |
| `analyzing-frontend-layer` | `frontend.md` |

### Testing Specialists

| Skill | Output |
|-------|--------|
| `analyzing-unit-tests` | `unit-tests.md` |
| `analyzing-integration-tests` | `integration-tests.md` |
| `analyzing-e2e-tests` | `e2e-tests.md` |

## Output Structure

```
docs/unwind/
├── architecture.md
├── layers/
│   ├── database.md (or database/)
│   ├── domain-model.md
│   ├── service-layer.md
│   ├── api.md
│   ├── messaging.md
│   ├── frontend.md
│   ├── unit-tests.md
│   ├── integration-tests.md
│   └── e2e-tests.md
└── CODEBASE.md
```

Large layers split into subdirectories with index.

## Quick Start

1. `Use unwind:discovering-architecture`
2. Review `docs/unwind/architecture.md`
3. `Use unwind:unwinding-codebase`
4. `Use unwind:synthesizing-findings`

## Refresh Mode

Re-run any skill to update documentation. Changes highlighted in `## Changes Since Last Review` section.
