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
4. Use unwind:synthesizing-findings
```

**Output:**
- `docs/unwind/REBUILD-PLAN.md` - Phased migration strategy with validation checkpoints
- `docs/unwind/CODEBASE.md` - Reference documentation
- `docs/unwind/layers/*/` - Detailed layer analysis (folder per layer)

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
│  PHASE 1: DISCOVERY                                                          │
│  ┌──────────────────────────┐                                               │
│  │ discovering-architecture │ ──► architecture.md                           │
│  └────────────┬─────────────┘     (layers, entry points, repo info)         │
│               │                                                              │
│               ▼                                                              │
│  PHASE 2: LAYER ANALYSIS                                                     │
│  ┌──────────────────────────┐                                               │
│  │   unwinding-codebase     │ ──► Dispatches layer specialists              │
│  └────────────┬─────────────┘                                               │
│               │                                                              │
│       ┌───────┴───────┬───────────┬───────────┬───────────┐                │
│       ▼               ▼           ▼           ▼           ▼                │
│  ┌─────────┐    ┌──────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐         │
│  │database/│    │ domain-  │ │service- │ │  api/   │ │frontend/ │         │
│  │         │    │ model/   │ │ layer/  │ │         │ │          │         │
│  └────┬────┘    └────┬─────┘ └────┬────┘ └────┬────┘ └────┬─────┘         │
│       │              │            │           │           │                 │
│       └──────────────┴────────────┴───────────┴───────────┘                │
│                              │                                              │
│                              ▼                                              │
│  PHASE 3: GAP DETECTION                                                      │
│  ┌───────────────────────────────────────────────────────────┐             │
│  │           verifying-layer-documentation                    │             │
│  │   (Parallel agents compare docs to source)                 │             │
│  └─────────────────────────────┬─────────────────────────────┘             │
│                                │                                            │
│                                ▼                                            │
│                         ┌──────────┐                                        │
│                         │ gaps.md  │  (per layer - work list only)          │
│                         └────┬─────┘                                        │
│                              │                                              │
│                              ▼                                              │
│  PHASE 4: GAP COMPLETION                                                     │
│  ┌───────────────────────────────────────────────────────────┐             │
│  │           completing-layer-documentation                   │             │
│  │   (Parallel agents fix all gaps, delete gaps.md)          │             │
│  └─────────────────────────────┬─────────────────────────────┘             │
│                                │                                            │
│                                ▼                                            │
│  PHASE 5: SYNTHESIS                                                          │
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

## Phases Explained

### Phase 1: Discovery
Extracts repository info (for GitHub links), detects layers, identifies tech stack.

### Phase 2: Layer Analysis
Dispatches specialist agents in dependency order:
1. Database (no dependencies)
2. Domain Model (needs database)
3. Service Layer (needs domain)
4. API + Messaging (parallel, need services)
5. Frontend (needs API)
6. Tests (parallel, no layer dependencies)

Each layer writes to a folder with incremental files to avoid token limits.

### Phase 3: Gap Detection
Compares documentation against source code. Outputs ONLY what's missing to `gaps.md` - no scores, no "what's correct" text.

### Phase 4: Gap Completion
Reads `gaps.md` work lists and adds all missing documentation. Deletes `gaps.md` when complete.

### Phase 5: Synthesis
Aggregates all layer documentation into final deliverables.

---

## Principles

All analysis follows these principles (see `skills/analysis-principles.md`):

| Principle | Description |
|-----------|-------------|
| **Completeness** | Document ALL items - exact counts, not "30+" |
| **Machine-readable** | Actual code, SQL, mermaid - not prose summaries |
| **Link to source** | Uses repo info for GitHub links, or local paths |
| **No commentary** | Facts only, no speculation or recommendations |
| **Rebuild categorization** | Tag items as MUST/SHOULD/DON'T keep |
| **Incremental writes** | Write each section immediately, don't buffer |
| **Migrations: current state** | Document final schema, not migration history |

## Skills

### Core Flow

| Skill | Purpose | Output |
|-------|---------|--------|
| `discovering-architecture` | Initial codebase exploration | `architecture.md` |
| `unwinding-codebase` | Orchestrates all phases | Dispatches specialists |
| `verifying-layer-documentation` | Detects gaps in docs | `gaps.md` per layer |
| `completing-layer-documentation` | Fixes all gaps | Updated layer files |
| `synthesizing-findings` | Generates rebuild plan | `REBUILD-PLAN.md`, `CODEBASE.md` |

### Layer Specialists

| Skill | Analyzes | Key Requirements |
|-------|----------|------------------|
| `analyzing-database-layer` | Schema, repositories | All tables, JSONB schemas, indexes |
| `analyzing-domain-model` | Entities, validation | Constraint tables, permission matrix |
| `analyzing-service-layer` | Services, calculations | Formulas with source refs, edge cases |
| `analyzing-api-layer` | Endpoints, auth, contracts | OpenAPI/TSRest specs, route inventory |
| `analyzing-messaging-layer` | Events, queues | AsyncAPI specs, event schemas |
| `analyzing-frontend-layer` | Components, state | User flows (WHAT), not implementation (HOW) |

### Testing Specialists

| Skill | Analyzes |
|-------|----------|
| `analyzing-unit-tests` | Unit test coverage and patterns |
| `analyzing-integration-tests` | Integration test infrastructure |
| `analyzing-e2e-tests` | E2E tests and page objects |

## Output Structure

```
docs/unwind/
├── architecture.md                    # Layer detection, tech stack, repo info
├── layers/
│   ├── database/
│   │   ├── index.md                   # Overview, links to sections
│   │   ├── schema.md                  # All tables, fields
│   │   ├── repositories.md            # Data access patterns
│   │   └── jsonb-schemas.md           # Complex field structures
│   ├── domain-model/
│   │   ├── index.md
│   │   ├── entities.md
│   │   ├── enums.md
│   │   └── validation.md
│   ├── service-layer/
│   │   ├── index.md
│   │   ├── services.md
│   │   ├── formulas.md                # Business calculations [MUST]
│   │   └── dtos.md
│   ├── api/
│   │   ├── index.md
│   │   ├── endpoints.md
│   │   ├── contracts.md               # OpenAPI/TSRest [CRITICAL]
│   │   └── auth.md
│   ├── frontend/
│   │   ├── index.md
│   │   ├── pages.md                   # User flows, not React code
│   │   └── state.md
│   └── [test layers...]
├── REBUILD-PLAN.md                    # Phased migration strategy
└── CODEBASE.md                        # Reference documentation
```

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

## License

MIT
