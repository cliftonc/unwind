---
name: discovering-architecture
description: Use when starting reverse engineering on an unfamiliar codebase to identify layers, patterns, and structure before detailed analysis
---

# Discovering Architecture

## Overview

Dispatch a subagent to systematically explore a codebase and identify its architectural layers, technology choices, and structure. The subagent produces a machine-parseable architecture document that drives downstream layer-by-layer analysis.

**Output:** `docs/unwind/architecture.md`

## When to Use

- Starting work on an unfamiliar codebase
- Onboarding to a new project
- Before planning a migration or major refactor
- Beginning a security audit or code review

## The Process

### Step 1: Check for Existing Documentation

Before dispatching the subagent, check if `docs/unwind/architecture.md` exists:

```
Glob: docs/unwind/architecture.md
```

- If exists: Pass to subagent as "previous analysis" for refresh mode
- If not: Fresh discovery

### Step 2: Dispatch Discovery Subagent

Dispatch an Explore subagent with the discovery prompt:

```
Task(subagent_type="Explore")
  description: "Discover codebase architecture"
  prompt: [See Subagent Prompt below]
```

### Step 3: Review Output

When the subagent completes:
1. Verify `docs/unwind/architecture.md` was created
2. Review the layer detection summary
3. Note any layers marked as "not_detected" or "low confidence"

### Step 4: Present Results and Prompt User

After the subagent completes, present the results to the user:

```
## Architecture Discovery Complete

I've analyzed the codebase and created the architecture document.

**Output:** `docs/unwind/architecture.md`

### Summary
[Include the summary from the subagent - framework, layers detected, etc.]

### Detected Layers
[List layers with their confidence levels]

### Next Steps

Would you like me to:
1. **Continue with layer analysis** - Run `unwind:unwinding-codebase` to dispatch specialist subagents for each layer
2. **Review the architecture document first** - Open `docs/unwind/architecture.md` to verify the detection is accurate

[Use AskUserQuestion to let them choose]
```

**Important:** Always give the user the option to review before proceeding. The architecture document drives all subsequent analysis, so accuracy matters.

---

## Subagent Prompt

Use this prompt when dispatching the discovery subagent:

```
Explore this codebase to identify its architectural layers and structure.

## Your Task

Systematically explore the codebase and create an architecture document at `docs/unwind/architecture.md`.

## Phase 0: Repository Information

**CRITICAL:** Extract repository information FIRST for source linking.

Run these commands to get git info:
```bash
git remote get-url origin 2>/dev/null
git branch --show-current 2>/dev/null
```

Parse the remote URL:
- SSH format: `git@github.com:owner/repo.git` → `https://github.com/owner/repo`
- HTTPS format: `https://github.com/owner/repo.git` → `https://github.com/owner/repo`
- GitLab/Bitbucket: Similar patterns

If git info is available, set:
```yaml
repository:
  type: github|gitlab|bitbucket|unknown
  url: https://github.com/owner/repo
  branch: main
  link_format: https://github.com/owner/repo/blob/main/{path}#L{start}-L{end}
```

If git info is NOT available (not a git repo, no remote):
```yaml
repository:
  type: local
  url: null
  branch: null
  link_format: "{path}:{start}-{end}"
```

## Phase 1: Project Identification

Identify the technology stack by looking for:

**Build System:**
- `package.json` → Node.js/JavaScript
- `pom.xml` / `build.gradle` → Java
- `requirements.txt` / `pyproject.toml` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `*.csproj` → .NET

**Framework:** Check dependencies for Spring Boot, Django, Express, Rails, Next.js, etc.

**Database:** Look for connection strings, ORM config, migration directories.

## Phase 2: Directory Mapping

Scan source directories and map to layers:

| Directory Pattern | Likely Layer |
|-------------------|--------------|
| `repository/`, `dao/`, `data/` | Database |
| `model/`, `entity/`, `domain/` | Domain Model |
| `service/`, `usecase/`, `application/` | Service Layer |
| `controller/`, `api/`, `rest/`, `graphql/` | API Layer |
| `messaging/`, `events/`, `queue/`, `kafka/` | Messaging |
| `components/`, `pages/`, `views/`, `ui/` | Frontend |

## Phase 3: Confidence Assessment

For each layer, assess confidence:
- **High**: Clear directory structure, multiple files, consistent naming
- **Medium**: Some indicators but mixed patterns
- **Low**: Minimal evidence
- **Not Detected**: No evidence found

## Phase 4: Cross-Cutting Concerns

Identify aspects spanning multiple layers:
- Authentication/Authorization
- Logging
- Error Handling
- Caching
- Validation

## Phase 5: Write Architecture Document

Create `docs/unwind/architecture.md` (create the directory if needed).

Use this format:

```markdown
# Architecture Discovery: [Project Name]

> **For Claude:** REQUIRED SUB-SKILL: Use unwind:unwinding-codebase to analyze each layer.

## Discovery Metadata

- **Generated:** [ISO timestamp]
- **Project Root:** [path]
- **Framework:** [detected framework]
- **Language:** [primary language]

## Repository Information

```yaml
repository:
  type: github|gitlab|bitbucket|local
  url: https://github.com/owner/repo  # or null if local
  branch: main                         # or null if local
  link_format: https://github.com/owner/repo/blob/main/{path}#L{start}-L{end}
```

**For all downstream agents:** Use `link_format` to create source links. Replace `{path}`, `{start}`, `{end}` with actual values.

## Layer Configuration

```yaml
layers:
  database:
    status: detected|not_detected
    confidence: high|medium|low
    entry_points:
      - path/to/data/layer/
    dependencies: []

  domain_model:
    status: detected|not_detected
    confidence: high|medium|low
    entry_points:
      - path/to/domain/
    dependencies: [database]

  service_layer:
    status: detected|not_detected
    confidence: high|medium|low
    entry_points:
      - path/to/services/
    dependencies: [domain_model]

  api:
    status: detected|not_detected
    confidence: high|medium|low
    entry_points:
      - path/to/controllers/
    dependencies: [service_layer]

  messaging:
    status: detected|not_detected
    confidence: high|medium|low
    entry_points: []
    dependencies: [service_layer]

  frontend:
    status: detected|not_detected
    confidence: high|medium|low
    entry_points: []
    dependencies: [api]

cross_cutting:
  authentication:
    touches: [api, service_layer]
    entry_points:
      - path/to/security/
```

## Database Layer

**Status:** [Detected/Not Detected] | **Confidence:** [High/Medium/Low]

**Entry Points:**
- [directories/files]

**Initial Observations:**
- [What you found - technology, patterns, notable aspects]

---

[Repeat for each layer with status != not_detected]

---

## Cross-Cutting Concerns

### Authentication
**Touches:** [layers]
[Observations]

### [Other concerns...]

---

## Discovery Notes

- [Unknowns, questions, areas needing clarification]
```

{REFRESH_CONTEXT}

## Output

After creating the architecture document, provide a brief summary:
- Project type and framework
- Which layers were detected (with confidence)
- Any notable findings or concerns
```

---

## Refresh Mode Context

If previous architecture.md exists, add this to the subagent prompt:

```
## Previous Analysis

A previous architecture analysis exists. Compare the current codebase state to this previous analysis and:

1. Note any changes in the `## Changes Since Last Discovery` section
2. Update layer status/confidence if changed
3. Add new entry points discovered
4. Remove entry points that no longer exist
5. Update the `last_analyzed` timestamp

Previous analysis:
[CONTENTS OF EXISTING architecture.md]
```

---

## Layer Detection Reference

### Database Layer Indicators
- Directories: `repository/`, `dao/`, `data/`, `persistence/`
- Files: `*Repository.java`, `*_repository.py`, `*.repo.ts`
- ORM: Hibernate, SQLAlchemy, Prisma, TypeORM, Sequelize
- Migrations: Flyway, Liquibase, Alembic, Prisma migrations

### Domain Model Indicators
- Directories: `domain/`, `model/`, `entity/`, `entities/`
- Files: `*Entity.java`, `models.py`, `*.entity.ts`
- Patterns: `@Entity`, `class Model`, aggregates, value objects

### Service Layer Indicators
- Directories: `service/`, `services/`, `usecase/`, `application/`
- Files: `*Service.java`, `*_service.py`, `*.service.ts`
- Patterns: `@Service`, `@Transactional`, business logic methods

### API Layer Indicators
- Directories: `controller/`, `api/`, `rest/`, `routes/`, `graphql/`
- Files: `*Controller.java`, `views.py`, `*.controller.ts`
- Patterns: `@RestController`, `@router`, route definitions

### Messaging Layer Indicators
- Directories: `messaging/`, `events/`, `queue/`, `kafka/`, `rabbitmq/`
- Files: `*Listener.java`, `*Consumer.py`, `*.handler.ts`
- Configs: Kafka, RabbitMQ, SQS configuration

### Frontend Layer Indicators
- Directories: `components/`, `pages/`, `views/`, `ui/`, `src/app/`
- Files: `*.tsx`, `*.vue`, `*.component.ts`
- Configs: React, Vue, Angular, Next.js, Nuxt
