# Unwind

Skills library for reverse engineering codebases. Produces complete, machine-readable documentation.

## Quick Start

```
1. Use unwind:discovering-architecture
2. Review docs/unwind/architecture.md
3. Use unwind:unwinding-codebase
4. Use unwind:synthesizing-findings
```

**Output:** `docs/unwind/CODEBASE.md` + individual layer docs

[Example Output →](#) *(coming soon)*

---

## Installation

### Claude Code

```
/plugin install https://github.com/cliftonc/unwind
```

Or clone locally:
```bash
git clone https://github.com/cliftonc/unwind.git ~/.claude/plugins/unwind
/plugin install ~/.claude/plugins/unwind
```

Restart Claude Code after installation.

### Updating

```
/plugin uninstall unwind
/plugin install https://github.com/cliftonc/unwind
```

---

## Workflow

```
discovering-architecture     → architecture.md
        │
unwinding-codebase          → dispatches layer specialists
        │
        ├── database, domain, service, api
        ├── messaging, frontend (if present)
        └── unit-tests, integration-tests, e2e-tests
        │
synthesizing-findings       → CODEBASE.md
```

## Principles

- **Completeness**: Document ALL items (30 tables = 30 documented)
- **Machine-readable**: Actual code, SQL, mermaid - not markdown recreation
- **Link to source**: GitHub links with line numbers
- **No commentary**: Facts only, no speculation

See `skills/analysis-principles.md` for details.

## Skills

### Core Flow

| Skill | Purpose |
|-------|---------|
| `discovering-architecture` | Initial exploration |
| `unwinding-codebase` | Orchestrates analysis |
| `synthesizing-findings` | Aggregates to CODEBASE.md |

### Layer Specialists

| Skill | Analyzes |
|-------|----------|
| `analyzing-database-layer` | Schema, migrations, repositories |
| `analyzing-domain-model` | Entities, value objects, business rules |
| `analyzing-service-layer` | Services, DTOs, mappers, integrations |
| `analyzing-api-layer` | Endpoints, auth, contracts |
| `analyzing-messaging-layer` | Events, queues, consumers |
| `analyzing-frontend-layer` | Components, state, routing |

### Testing Specialists

| Skill | Analyzes |
|-------|----------|
| `analyzing-unit-tests` | Unit test coverage and patterns |
| `analyzing-integration-tests` | Integration test infrastructure |
| `analyzing-e2e-tests` | E2E tests and page objects |

## Output Structure

```
docs/unwind/
├── architecture.md
├── layers/
│   ├── database.md
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

Large layers split into subdirectories.

## License

MIT
