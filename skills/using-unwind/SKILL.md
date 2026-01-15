---
name: using-unwind
description: Use when starting any reverse engineering task - establishes how to find and use Unwind skills for codebase analysis, service mapping, and documentation
allowed-tools:
  - Read
  - Grep
  - Glob
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
verifying-layer-documentation → verification pass (parallel per layer)
        │
        ├── Compares each layer doc against source
        ├── Identifies accuracy issues and gaps
        ├── Applies fixes and augmentations
        └── Assigns rebuild readiness scores
        │
synthesizing-findings       → CODEBASE.md
```

## Skills

### Core Flow

| Skill | Output |
|-------|--------|
| `discovering-architecture` | `architecture.md` |
| `unwinding-codebase` | Orchestrates layer analysis |
| `verifying-layer-documentation` | Verification reports, fixes applied |
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
│   ├── database/
│   │   ├── index.md
│   │   ├── schema.md
│   │   ├── repositories.md
│   │   └── verification.md
│   ├── domain-model/
│   │   ├── index.md
│   │   ├── entities.md
│   │   └── verification.md
│   ├── service-layer/
│   │   ├── index.md
│   │   ├── services.md
│   │   ├── formulas.md
│   │   └── verification.md
│   ├── api/
│   │   ├── index.md
│   │   ├── endpoints.md
│   │   └── verification.md
│   └── [other layers...]
├── CODEBASE.md
└── REBUILD-PLAN.md
```

Each layer is a folder with `index.md` + section files for incremental writes.

## Quick Start

1. `Use unwind:discovering-architecture`
2. Review `docs/unwind/architecture.md`
3. `Use unwind:unwinding-codebase`
4. `Use unwind:verifying-layer-documentation` (runs parallel verification)
5. `Use unwind:synthesizing-findings`

**Note:** Step 4 (verification) is integrated into `unwinding-codebase` but can also be run independently to re-verify existing documentation.

## Refresh Mode

Re-run any skill to update documentation. Changes highlighted in `## Changes Since Last Review` section.
