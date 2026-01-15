---
name: discovering-architecture
description: Use when starting reverse engineering on an unfamiliar codebase to identify layers, patterns, and structure before detailed analysis
---

# Discovering Architecture

## Overview

Systematically explore a codebase to identify its architectural layers, technology choices, and structure. Produces a machine-parseable architecture document that drives downstream layer-by-layer analysis.

**Output:** `docs/unwind/architecture.md`

## When to Use

- Starting work on an unfamiliar codebase
- Onboarding to a new project
- Before planning a migration or major refactor
- Beginning a security audit or code review

## The Process

### Phase 1: Project Identification

Identify the project's technology stack:

1. **Build System** - Look for:
   - `package.json` → Node.js/JavaScript
   - `pom.xml` / `build.gradle` → Java
   - `requirements.txt` / `pyproject.toml` → Python
   - `go.mod` → Go
   - `Cargo.toml` → Rust
   - `*.csproj` → .NET

2. **Framework Detection** - Look for framework markers:
   - Spring Boot, Django, Express, Rails, Next.js, etc.
   - Check dependencies in manifest files

3. **Database** - Look for:
   - Connection strings in config files
   - ORM configuration (Hibernate, SQLAlchemy, Prisma, etc.)
   - Migration directories

### Phase 2: Directory Mapping

Scan source directories and map to standard layers:

| Directory Pattern | Likely Layer |
|-------------------|--------------|
| `repository/`, `dao/`, `data/` | Database |
| `model/`, `entity/`, `domain/` | Domain Model |
| `service/`, `usecase/`, `application/` | Service Layer |
| `controller/`, `api/`, `rest/`, `graphql/` | API Layer |
| `messaging/`, `events/`, `queue/`, `kafka/` | Messaging |
| `components/`, `pages/`, `views/`, `ui/` | Frontend |
| `dto/`, `mapper/`, `transformer/` | Transformation (→ Service Layer) |

### Phase 3: Confidence Assessment

For each detected layer, assess confidence:

- **High**: Clear directory structure, multiple files, consistent naming
- **Medium**: Some indicators but mixed patterns
- **Low**: Minimal evidence, may not exist
- **Not Detected**: No evidence found

### Phase 4: Cross-Cutting Concerns

Identify aspects that span multiple layers:

- **Authentication/Authorization**: Security configs, auth middleware, JWT handling
- **Logging**: Log configuration, structured logging
- **Error Handling**: Global exception handlers, error middleware
- **Caching**: Cache configuration, Redis/Memcached usage
- **Validation**: Validation libraries, schema validation

### Phase 5: Document Generation

Create `docs/unwind/architecture.md` with:

1. Claude orchestrator instruction header
2. YAML metadata block for machine parsing
3. Per-layer sections with entry points
4. Cross-cutting concerns section
5. Discovery notes and unknowns

## Output Format

```markdown
# Architecture Discovery: [Project Name]

> **For Claude:** REQUIRED SUB-SKILL: Use unwind:unwinding-codebase to analyze each layer.

## Discovery Metadata

- **Generated:** [ISO timestamp]
- **Project Root:** [path]
- **Framework:** [detected framework]
- **Language:** [primary language]

## Layer Configuration

```yaml
layers:
  database:
    status: detected
    confidence: high
    entry_points:
      - src/repository/
    dependencies: []

  domain_model:
    status: detected
    confidence: high
    entry_points:
      - src/domain/
    dependencies: [database]

  service_layer:
    status: detected
    confidence: high
    entry_points:
      - src/service/
    dependencies: [domain_model]

  api:
    status: detected
    confidence: high
    entry_points:
      - src/controller/
    dependencies: [service_layer]

  messaging:
    status: not_detected
    confidence: high
    entry_points: []
    dependencies: [service_layer]

  frontend:
    status: detected
    confidence: medium
    entry_points:
      - src/components/
    dependencies: [api]

cross_cutting:
  authentication:
    touches: [api, service_layer]
    entry_points:
      - src/security/
```

## Database Layer

**Status:** Detected | **Confidence:** High

**Entry Points:**
- `src/repository/` - Data access layer

**Initial Observations:**
- [What you found]

---

[Repeat for each layer...]

---

## Cross-Cutting Concerns

### Authentication
**Touches:** API, Service Layer
[Observations]

---

## Discovery Notes

- [Unknowns, questions, areas needing clarification]
```

## Refresh Mode

If `docs/unwind/architecture.md` already exists:

1. Read existing document
2. Compare current codebase state to documented state
3. Add `## Changes Since Last Discovery` section highlighting:
   - New directories/files
   - Removed components
   - Changed patterns
4. Update YAML metadata with new `last_analyzed` timestamp

## After Completion

Announce:
> Architecture discovery complete. Run `unwind:unwinding-codebase` to dispatch layer analysis subagents.
