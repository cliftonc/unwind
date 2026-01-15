---
name: using-unwind
description: Use when starting any reverse engineering task - establishes how to find and use Unwind skills for codebase analysis, service mapping, and documentation
---

# Using Unwind

## Overview

Unwind is a skills library focused on reverse engineering existing services and codebases. It provides structured approaches for understanding unfamiliar code, mapping service architectures, discovering APIs, and generating documentation.

## How to Access Skills

**In Claude Code:** Use the `Skill` tool with the skill name (e.g., `unwind:analyzing-codebase`).

## Available Skills

*Skills to be added:*

| Skill | Purpose |
|-------|---------|
| `analyzing-codebase` | Systematic approach to understanding unfamiliar codebases |
| `mapping-services` | Discovering service boundaries and dependencies |
| `discovering-apis` | Finding and documenting API endpoints |
| `tracing-data-flow` | Following data through systems |
| `documenting-architecture` | Generating architecture documentation |
| `identifying-patterns` | Recognizing design patterns in existing code |

## The Rule

**Invoke relevant skills BEFORE diving into code.** Even a 1% chance a skill might apply means you should check it.

## When to Use Unwind Skills

- Onboarding to a new codebase
- Investigating an unfamiliar service
- Documenting legacy systems
- Understanding third-party integrations
- Preparing for migrations or refactors
- Security audits and code reviews

## Red Flags

These thoughts mean STOP - check for applicable skills:

| Thought | Reality |
|---------|---------|
| "Let me just grep around" | Skills provide systematic approaches |
| "I'll figure it out as I go" | Structure prevents missed components |
| "This codebase is simple" | Simple-looking code often hides complexity |
| "I'll document later" | Document as you discover |

## Contributing

To add new skills:
1. Create a directory under `skills/` with your skill name
2. Add a `SKILL.md` with frontmatter (name, description)
3. Follow the skill writing guidelines
