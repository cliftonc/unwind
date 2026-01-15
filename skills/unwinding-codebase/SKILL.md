---
name: unwinding-codebase
description: Use after discovering-architecture to orchestrate layer-by-layer analysis using specialist subagents
---

# Unwinding Codebase

## Overview

Parse the architecture document and dispatch specialist subagents for each detected layer. Coordinates execution based on layer dependencies, running independent layers in parallel.

**Requires:** `docs/unwind/architecture.md` from `discovering-architecture`
**Produces:** `docs/unwind/layers/*.md` via subagents

## Prerequisites

Before using this skill:
1. Run `unwind:discovering-architecture` first
2. Verify `docs/unwind/architecture.md` exists
3. Review the architecture doc for accuracy

## The Process

### Step 1: Parse Architecture Document

1. Read `docs/unwind/architecture.md`
2. Extract the YAML `layers` block
3. Build dependency graph
4. Identify layers with `status: detected`
5. Skip layers with `status: not_detected`

### Step 2: Calculate Execution Phases

Group layers by satisfied dependencies:

```
Phase 1: database (no dependencies)
Phase 2: domain_model (needs database)
Phase 3: service_layer (needs domain_model)
Phase 4: api, messaging (parallel - both need service_layer)
Phase 5: frontend (optional - needs api)
```

### Step 3: Create Analysis Plan

Use TodoWrite to create a task for each detected layer:

```
- [ ] Analyze database layer
- [ ] Analyze domain_model layer
- [ ] Analyze service_layer layer
- [ ] Analyze api layer
- [ ] Analyze messaging layer (if detected)
- [ ] Analyze frontend layer (if detected)
```

### Step 4: Dispatch Phase by Phase

For each phase, dispatch subagents for layers with satisfied dependencies.

**Dispatch template for each layer:**

```
Task(subagent_type="general-purpose")
  description: "Analyze [layer] layer"
  prompt: |
    Use unwind:analyzing-[layer]-layer to analyze this codebase layer.

    ## Context from Architecture Discovery

    Entry points:
    [entry_points from YAML]

    Initial observations from discovery:
    [relevant section from architecture.md]

    ## Dependencies Already Analyzed

    [Include summaries from completed layer docs if available]

    ## Output

    Write your analysis to: docs/unwind/layers/[layer].md

    Follow the skill's output format exactly.
```

**Parallel execution rules:**
- Layers in the same phase with no cross-dependencies → dispatch in parallel
- Wait for all phase N tasks to complete before starting phase N+1
- Read completed layer docs to provide context to dependent layers

### Step 5: Monitor Progress

As each subagent completes:
1. Mark the corresponding todo as complete
2. Read the generated layer doc
3. Extract key findings for dependent layer context
4. Dispatch next phase when ready

### Step 6: Handle Cross-Cutting Concerns

After all layers are analyzed:
1. Collect `@cross-cutting:*` markers from all layer docs
2. If significant cross-cutting findings exist, note them for synthesis

### Step 7: Handoff to Synthesis

When all layer analysis is complete:

> Layer analysis complete. Run `unwind:synthesizing-findings` to aggregate into final documentation.

## Execution Example

Given this architecture YAML:

```yaml
layers:
  database:
    status: detected
    dependencies: []
  domain_model:
    status: detected
    dependencies: [database]
  service_layer:
    status: detected
    dependencies: [domain_model]
  api:
    status: detected
    dependencies: [service_layer]
  messaging:
    status: not_detected
    dependencies: [service_layer]
  frontend:
    status: detected
    dependencies: [api]
```

Execution plan:
1. **Phase 1:** Dispatch `analyzing-database-layer` (1 subagent)
2. **Wait** for database.md
3. **Phase 2:** Dispatch `analyzing-domain-model` with database context (1 subagent)
4. **Wait** for domain-model.md
5. **Phase 3:** Dispatch `analyzing-service-layer` with domain context (1 subagent)
6. **Wait** for service-layer.md
7. **Phase 4:** Dispatch `analyzing-api-layer` (1 subagent) - messaging skipped (not_detected)
8. **Wait** for api.md
9. **Phase 5:** Dispatch `analyzing-frontend-layer` with api context (1 subagent)
10. **Wait** for frontend.md
11. **Complete** - handoff to synthesis

## Refresh Mode

If layer docs already exist in `docs/unwind/layers/`:

1. Check `last_analyzed` timestamps in existing docs
2. For each layer, pass existing doc as "previous analysis" context
3. Subagents will highlight changes since last review
4. Updated docs include `## Changes Since Last Review` section

## Error Handling

If a subagent fails or times out:
1. Log the failure
2. Continue with other layers that don't depend on it
3. Mark dependent layers as blocked
4. Report which layers could not be analyzed
