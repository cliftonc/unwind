---
name: unwinding-codebase
description: Use after discovering-architecture to orchestrate layer-by-layer analysis using specialist subagents
---

# Unwinding Codebase

**Requires:** `docs/unwind/architecture.md`
**Produces:** `docs/unwind/layers/*.md` via subagents

**Principles:** See `analysis-principles.md` - completeness, machine-readable, link to source, no commentary.

## Process

### Step 1: Parse Architecture Document

1. Read `docs/unwind/architecture.md`
2. Extract YAML `layers` block
3. Build dependency graph
4. Skip layers with `status: not_detected`

### Step 2: Execution Phases

```
Phase 1: database (no dependencies)
Phase 2: domain_model (needs database)
Phase 3: service_layer (needs domain_model)
Phase 4: api, messaging (parallel - need service_layer)
Phase 5: frontend (optional - needs api)
Phase 6: unit_tests, integration_tests, e2e_tests (parallel - no layer dependencies)
```

### Step 3: Dispatch Subagents

For each layer, dispatch:

```
Task(subagent_type="general-purpose")
  description: "Analyze [layer] layer"
  prompt: |
    Use unwind:analyzing-[layer]-layer to analyze this codebase layer.

    Entry points from architecture.md:
    [entry_points]

    Write to: docs/unwind/layers/[layer].md

    Follow analysis-principles.md: completeness, machine-readable, link to source, no commentary.
```

**Parallel rules:**
- Same phase, no cross-dependencies → parallel
- Wait for phase N before phase N+1

### Step 4: Testing Analysis

After application layers complete, dispatch testing specialists in parallel:

```
- analyzing-unit-tests → unit-tests.md
- analyzing-integration-tests → integration-tests.md
- analyzing-e2e-tests → e2e-tests.md
```

Testing analysis can reference application layer docs for coverage mapping.

### Step 5: Handoff

When complete:
> Layer analysis complete. Run `unwind:synthesizing-findings` to aggregate into CODEBASE.md.

## Execution Example

```yaml
layers:
  database: { status: detected, dependencies: [] }
  domain_model: { status: detected, dependencies: [database] }
  service_layer: { status: detected, dependencies: [domain_model] }
  api: { status: detected, dependencies: [service_layer] }
  messaging: { status: not_detected }
  frontend: { status: detected, dependencies: [api] }
```

Execution:
1. Phase 1: `analyzing-database-layer`
2. Phase 2: `analyzing-domain-model`
3. Phase 3: `analyzing-service-layer`
4. Phase 4: `analyzing-api-layer` (messaging skipped)
5. Phase 5: `analyzing-frontend-layer`
6. Phase 6: `analyzing-unit-tests`, `analyzing-integration-tests`, `analyzing-e2e-tests` (parallel)
7. Handoff to synthesis

## Refresh Mode

If layer docs exist:
1. Pass existing doc as context
2. Subagents add `## Changes Since Last Review`
