---
name: unwinding-codebase
description: Use after discovering-architecture to orchestrate layer-by-layer analysis using specialist subagents
---

# Unwinding Codebase

**Requires:** `docs/unwind/architecture.md`
**Produces:** `docs/unwind/layers/*/` folders via subagents (each with index.md + section files)

**Principles:** See `analysis-principles.md` - completeness, machine-readable, link to source, no commentary, **incremental writes**.

## Process

### Step 1: Parse Architecture Document

1. Read `docs/unwind/architecture.md`
2. Extract `repository.link_format` for source linking
3. Extract YAML `layers` block
4. Build dependency graph
5. Skip layers with `status: not_detected`

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

    SOURCE LINKING - Use this format for all source references:
    [link_format from architecture.md]

    Replace {path}, {start}, {end} with actual values.
    Example: [UserService.ts]([link_format with path=src/services/UserService.ts, start=45, end=67])

    IMPORTANT: Write incrementally to folder structure.
    1. Create docs/unwind/layers/[layer]/ directory first
    2. Write initial index.md with skeleton sections
    3. Analyze each section and write its .md file IMMEDIATELY after analyzing
    4. Update index.md after each section file is written
    5. Do NOT buffer all content for a single write at the end

    Output folder: docs/unwind/layers/[layer]/
    - index.md (overview + links to sections)
    - section files per the skill spec

    Follow analysis-principles.md: completeness, machine-readable, link to source, no commentary.
```

**Parallel rules:**
- Same phase, no cross-dependencies → parallel
- Wait for phase N before phase N+1

### Step 4: Testing Analysis

After application layers complete, dispatch testing specialists in parallel:

```
- analyzing-unit-tests → unit-tests/ folder
- analyzing-integration-tests → integration-tests/ folder
- analyzing-e2e-tests → e2e-tests/ folder
```

Testing analysis can reference application layer docs for coverage mapping.

### Step 5: Verification Phase

After all layer analysis completes, dispatch verification agents IN PARALLEL:

```
For each analyzed layer:
  Task(subagent_type="general-purpose")
    description: "Verify [layer] documentation"
    prompt: |
      Use unwind:verifying-layer-documentation to verify the [layer] layer.

      Read docs/unwind/layers/[layer]/index.md and all linked section files.
      Compare against source files.

      Produce:
      1. Verification report at docs/unwind/layers/[layer]/verification.md
      2. Fixes applied to section files as needed
      3. Rebuild readiness score (1-10)
```

**Verification agents run in parallel** - no dependencies between layer verifications.

### Step 6: Handoff

When verification complete:
> Layer analysis and verification complete. Run `unwind:synthesizing-findings` to aggregate into CODEBASE.md.

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
7. **Phase 7: Verification** - `verifying-layer-documentation` for all layers (parallel)
8. Handoff to synthesis

## Refresh Mode

If layer folders exist:
1. Pass existing index.md and section files as context
2. Subagents add `## Changes Since Last Review` to index.md
