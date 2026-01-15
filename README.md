# Unwind

A skills library for reverse engineering existing services and codebases. Provides structured approaches for understanding unfamiliar code, mapping service architectures, discovering APIs, and generating documentation.

## Installation

### Claude Code

Install from the plugin marketplace:
```
/plugin install unwind
```

Or for local development:
```
/plugin install /path/to/unwind
```

### Codex

See [.codex/INSTALL.md](.codex/INSTALL.md)

### OpenCode

See [.opencode/INSTALL.md](.opencode/INSTALL.md)

## The Workflow

```
discovering-architecture     ← Start here: explore codebase
        │
        ▼
    architecture.md          ← Machine-parseable layer map
        │
        ▼
unwinding-codebase           ← Orchestrates layer specialists
        │
        ├──► analyzing-database-layer
        ├──► analyzing-domain-model
        ├──► analyzing-service-layer
        ├──► analyzing-api-layer
        ├──► analyzing-messaging-layer (if present)
        └──► analyzing-frontend-layer (if present)
        │
        ▼
    layers/*.md              ← Detailed layer documentation
        │
        ▼
synthesizing-findings        ← Combine into final doc
        │
        ▼
    CODEBASE.md              ← Complete documentation
```

## Skills

### Core Flow

| Skill | Purpose |
|-------|---------|
| `using-unwind` | Getting started and skill overview |
| `discovering-architecture` | Initial exploration, identifies layers and patterns |
| `unwinding-codebase` | Orchestrates layer-by-layer analysis with subagents |
| `synthesizing-findings` | Aggregates layer docs into unified CODEBASE.md |

### Layer Specialists

| Skill | Purpose |
|-------|---------|
| `analyzing-database-layer` | Schema, migrations, ORM, data access patterns |
| `analyzing-domain-model` | Entities, value objects, business rules, aggregates |
| `analyzing-service-layer` | Business logic, transformation, DTOs, integrations |
| `analyzing-api-layer` | REST/GraphQL endpoints, auth, contracts |
| `analyzing-messaging-layer` | Events, queues, async patterns |
| `analyzing-frontend-layer` | Components, state, routing, API integration |

## Output Structure

All documentation is written to the target project:

```
docs/unwind/
├── architecture.md       # Discovery output
├── layers/
│   ├── database.md
│   ├── domain-model.md
│   ├── service-layer.md
│   ├── api.md
│   ├── messaging.md      # If messaging exists
│   └── frontend.md       # If frontend exists
└── CODEBASE.md           # Final synthesized documentation
```

## Philosophy

- **Systematic over ad-hoc**: Use structured approaches rather than random exploration
- **Document as you go**: Capture discoveries immediately
- **Verify assumptions**: Test your understanding before documenting it as fact
- **Build incrementally**: Start with high-level understanding, drill down as needed
- **Refresh supported**: Re-run skills to update documentation after code changes

## Contributing

1. Fork the repository
2. Create a new skill under `skills/`
3. Follow the skill writing guidelines (`superpowers:writing-skills`)
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE)
