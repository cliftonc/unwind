# Unwind

Skills library for reverse engineering codebases. Produces complete, machine-readable documentation and phased rebuild plans to reliably re-build the service or application in a new technology or modernised framework.

## Purpose

Generate documentation that enables an AI agent to rebuild your system in a different language or framework while maintaining:
- External API contract compatibility
- Business logic accuracy
- Data model integrity

## Quick Start

### Install

```
/plugin install https://github.com/cliftonc/unwind
```
Restart Claude Code after installation.

### Use
```
1. Use unwind:discovering-architecture
2. Review docs/unwind/architecture.md
3. Use unwind:unwinding-codebase
4. Use unwind:verifying-layer-documentation
5. Use unwind:synthesizing-findings
```

**Output:**
- `docs/unwind/REBUILD-PLAN.md` - Phased migration strategy with validation checkpoints
- `docs/unwind/CODEBASE.md` - Reference documentation
- `docs/unwind/layers/*.md` - Detailed layer analysis

---

### Updating

```
/plugin uninstall unwind
/plugin install https://github.com/cliftonc/unwind
```

---

## Workflow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              UNWIND WORKFLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────────────────┐                                               │
│  │ discovering-architecture │ ──────► architecture.md                       │
│  └────────────┬─────────────┘         (layers, entry points, tech stack)    │
│               │                                                              │
│               ▼                                                              │
│  ┌──────────────────────────┐                                               │
│  │   unwinding-codebase     │ ──────► Dispatches layer specialists          │
│  └────────────┬─────────────┘                                               │
│               │                                                              │
│       ┌───────┴───────┬───────────┬───────────┬───────────┐                │
│       ▼               ▼           ▼           ▼           ▼                │
│  ┌─────────┐    ┌──────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐         │
│  │Database │    │ Domain   │ │ Service │ │   API   │ │ Frontend │         │
│  │ Layer   │    │  Model   │ │  Layer  │ │  Layer  │ │  Layer   │         │
│  └────┬────┘    └────┬─────┘ └────┬────┘ └────┬────┘ └────┬─────┘         │
│       │              │            │           │           │                 │
│       └──────────────┴────────────┴───────────┴───────────┘                │
│                              │                                              │
│                              ▼                                              │
│  ┌───────────────────────────────────────────────────────────┐             │
│  │           verifying-layer-documentation                    │             │
│  │   (Parallel verification agents compare docs to source)    │             │
│  └─────────────────────────────┬─────────────────────────────┘             │
│                                │                                            │
│       ┌────────────────────────┼────────────────────────┐                  │
│       ▼                        ▼                        ▼                  │
│  ┌──────────┐           ┌──────────┐            ┌──────────┐              │
│  │ Accuracy │           │  Gaps    │            │ Rebuild  │              │
│  │  Issues  │           │ Detected │            │ Scores   │              │
│  └──────────┘           └──────────┘            └──────────┘              │
│                                │                                            │
│                                ▼                                            │
│  ┌──────────────────────────────────────────────────────────┐              │
│  │              synthesizing-findings                        │              │
│  │   (Generates REBUILD-PLAN.md + CODEBASE.md)              │              │
│  └──────────────────────────────────────────────────────────┘              │
│                                │                                            │
│               ┌────────────────┴────────────────┐                          │
│               ▼                                 ▼                          │
│     ┌──────────────────┐              ┌──────────────────┐                 │
│     │  REBUILD-PLAN.md │              │   CODEBASE.md    │                 │
│     │  (Action plan)   │              │  (Reference doc) │                 │
│     └──────────────────┘              └──────────────────┘                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Principles

All analysis follows these principles (see `skills/analysis-principles.md`):

| Principle | Description |
|-----------|-------------|
| **Completeness** | Document ALL items - exact counts, not "30+" |
| **Machine-readable** | Actual code, SQL, mermaid - not prose summaries |
| **Link to source** | File paths with line numbers for verification |
| **No commentary** | Facts only, no speculation or recommendations |
| **Rebuild categorization** | Tag items as MUST/SHOULD/DON'T keep |
| **JSONB schemas** | Extract and document complex field structures |
| **Hardcoded constants** | List all magic numbers affecting business logic |
| **Edge cases** | Document conditional behavior variations |

## Skills

### Core Flow

| Skill | Purpose | Output |
|-------|---------|--------|
| `discovering-architecture` | Initial codebase exploration | `architecture.md` |
| `unwinding-codebase` | Orchestrates layer analysis | Dispatches specialists |
| `verifying-layer-documentation` | Second-pass verification | `*-verification.md`, fixes |
| `synthesizing-findings` | Generates rebuild plan | `REBUILD-PLAN.md`, `CODEBASE.md` |

### Layer Specialists

| Skill | Analyzes | Key Requirements |
|-------|----------|------------------|
| `analyzing-database-layer` | Schema, migrations, repositories | All tables, JSONB schemas, indexes |
| `analyzing-domain-model` | Entities, validation, business rules | Constraint tables, permission matrix |
| `analyzing-service-layer` | Services, calculations, integrations | Formulas with source refs, edge cases |
| `analyzing-api-layer` | Endpoints, auth, contracts | OpenAPI/TSRest specs, route inventory |
| `analyzing-messaging-layer` | Events, queues, consumers | AsyncAPI specs, event schemas |
| `analyzing-frontend-layer` | Components, state, routing | User flows (WHAT), not implementation (HOW) |

### Testing Specialists

| Skill | Analyzes |
|-------|----------|
| `analyzing-unit-tests` | Unit test coverage and patterns |
| `analyzing-integration-tests` | Integration test infrastructure |
| `analyzing-e2e-tests` | E2E tests and page objects |

## Output Structure

```
docs/unwind/
├── architecture.md                    # Layer detection, tech stack
├── layers/
│   ├── database.md                    # All tables, fields, relationships
│   ├── database-verification.md       # Verification report
│   ├── domain-model.md                # Entities, validation rules
│   ├── domain-model-verification.md
│   ├── service-layer.md               # Services, calculations, formulas
│   ├── service-layer-verification.md
│   ├── api.md                         # Endpoints, OpenAPI specs
│   ├── api-verification.md
│   ├── messaging.md                   # Events, AsyncAPI specs
│   ├── frontend.md                    # User flows, state requirements
│   ├── frontend-verification.md
│   ├── unit-tests.md
│   ├── integration-tests.md
│   └── e2e-tests.md
├── REBUILD-PLAN.md                    # Phased migration strategy
└── CODEBASE.md                        # Reference documentation
```

Large layers split into subdirectories with index.

## Rebuild Plan

The `REBUILD-PLAN.md` provides:

1. **External Contract Compatibility** - OpenAPI/AsyncAPI specs that MUST be preserved
2. **Phased Approach** - Database → Domain → Services → API → Frontend
3. **Validation Checkpoints** - Concrete tests for each phase
4. **Migration Strategy** - Data migration and parallel running approach

## Rebuild Categorization

Each documented item is tagged:

| Tag | Meaning | Action |
|-----|---------|--------|
| **MUST** | Essential for comparable functionality | Implement exactly |
| **SHOULD** | Valuable but implementation-flexible | Preserve intent |
| **DON'T** | Tech-stack specific | Omit from rebuild |

## Rebuild Readiness Scores

Each layer receives a readiness score (1-10):

| Score | Meaning |
|-------|---------|
| 9-10 | Ready for AI rebuild - comprehensive, accurate |
| 7-8 | Mostly ready - minor gaps, no blocking issues |
| 5-6 | Significant gaps - rebuild possible with assumptions |
| 3-4 | Major gaps - rebuild would miss key functionality |
| 1-2 | Not ready - documentation insufficient |

## License

MIT
