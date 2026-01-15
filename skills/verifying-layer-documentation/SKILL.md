---
name: verifying-layer-documentation
description: Use after layer analysis is complete to verify and augment documentation against source code. Run as parallel agents per layer.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(mkdir:*, ls:*)
  - Write(docs/unwind/**)
  - Edit(docs/unwind/**)
  - Task
---

# Verifying Layer Documentation

**Purpose:** Second-pass verification that compares generated documentation against actual source code to identify gaps, inaccuracies, and missing categorization.

**When to Run:** After all layer analysis skills have completed and before `synthesizing-findings`.

**Execution:** Launch parallel agents, one per layer that was analyzed.

## Process Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    VERIFICATION PHASE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│   │   Database   │  │   Service    │  │     API      │          │
│   │   Verifier   │  │   Verifier   │  │   Verifier   │          │
│   └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│          │                 │                 │                   │
│   ┌──────┴───────┐  ┌──────┴───────┐  ┌──────┴───────┐          │
│   │    Domain    │  │   Frontend   │  │   Messaging  │          │
│   │   Verifier   │  │   Verifier   │  │   Verifier   │          │
│   └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                  │
│   Each verifier:                                                 │
│   1. Reads layer documentation                                   │
│   2. Reads source files                                          │
│   3. Compares item-by-item                                       │
│   4. Produces verification report                                │
│   5. Augments documentation with fixes                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Agent Dispatch

For each layer that has documentation, spawn a verification agent:

```markdown
## Verification Agent Prompt Template

You are verifying the {LAYER} layer documentation for completeness and accuracy.

**Documentation:** `docs/unwind/layers/{layer}/index.md` (and all linked section files)
**Source Files:** {SOURCE_PATHS}

### Your Tasks

1. **READ ALL SECTION FILES**
   - Read `docs/unwind/layers/{layer}/index.md`
   - Follow links to read all section files
   - Build complete picture of documented items

2. **COUNT VERIFICATION**
   - Count actual items in source (tables, routes, hooks, etc.)
   - Compare to documented count
   - Report: "Documented: X, Actual: Y, Gap: Z"

3. **ITEM-BY-ITEM COMPARISON**
   For each documented item:
   - Does it exist in source? (VERIFIED / NOT FOUND)
   - Is the documentation accurate? (ACCURATE / INACCURATE)
   - What details are missing?

4. **MISSING ITEM DETECTION**
   For each item in source:
   - Is it documented? (DOCUMENTED / MISSING)
   - If missing, what category? (MUST / SHOULD / DON'T)

5. **CATEGORIZATION CHECK**
   - Does each item have [MUST], [SHOULD], or [DON'T] tag?
   - Are the tags appropriate?

6. **PRODUCE VERIFICATION REPORT**
   Create `docs/unwind/layers/{layer}/verification.md` with:
   - Accuracy issues found
   - Missing items to add
   - Suggested fixes
   - Updated documentation sections

### Output Format

```markdown
# {Layer} Verification Report

## Summary

| Metric | Count |
|--------|-------|
| Documented Items | X |
| Actual Items | Y |
| Accuracy Issues | Z |
| Missing Items | W |
| Rebuild Readiness | N/10 |

## Accuracy Issues

### Issue 1: {description}
**Documented:** {what docs say}
**Actual:** {what code shows}
**Fix:** {corrected documentation}

## Missing Items

### {Item Name} [MUST/SHOULD/DON'T]
{Documentation that should be added}

## Augmented Sections

{Complete replacement sections for the documentation}
```
```

## Layer-Specific Verification

### Database Layer Verification

**Focus Areas:**
- Table count matches schema file
- Every column documented for every table
- JSONB schemas extracted and documented
- FK relationships include ON DELETE behavior
- All indexes listed

**Checklist:**
```markdown
[ ] Table count: Documented vs Actual
[ ] Each table has field-level documentation
[ ] JSONB columns have structure documented
[ ] Indexes are listed with columns
[ ] ER diagram matches relationships
```

### Service Layer Verification

**Focus Areas:**
- All formulas have source:line references
- Edge cases documented (especially conditionals)
- Hardcoded constants extracted
- Fallback chains documented

**Checklist:**
```markdown
[ ] Core formulas verified against source
[ ] Edge cases for each formula documented
[ ] Constants table complete
[ ] Rate resolution chain accurate
```

### API Layer Verification

**Focus Areas:**
- Route file count matches directory
- All endpoints listed per route
- Permission requirements documented
- External API contracts captured

**Checklist:**
```markdown
[ ] Route count: Documented vs Actual
[ ] Each route has endpoint summary
[ ] Missing routes explicitly noted
[ ] Permission matrix complete
```

### Domain Model Verification

**Focus Areas:**
- Validation schemas have constraint tables
- All enum values documented
- Permission matrix complete
- Self-reference rules captured

**Checklist:**
```markdown
[ ] Validation schema count matches
[ ] Each schema has min/max/required table
[ ] All enums have value tables
[ ] Permission matrix is complete
```

### Frontend Layer Verification

**Focus Areas:**
- Page count matches directory
- User flows documented (not React code)
- Permission gates documented
- API dependencies listed

**Checklist:**
```markdown
[ ] Page count: Documented vs Actual
[ ] Each page has purpose and user flow
[ ] Tech-specific code removed
[ ] API interactions documented
```

## Output Files

Each verifier produces:

1. **`docs/unwind/layers/{layer}/verification.md`** - Verification report (inside the layer folder)
2. **Updates to section files** - Fixes applied to specific section .md files as needed

## Integration with Synthesis

After all verifiers complete, the `synthesizing-findings` skill should:
1. Read all `*-verification.md` reports
2. Aggregate findings
3. Update overall rebuild readiness score
4. Include verification summary in final `CODEBASE.md`

## Example Agent Prompts

### Database Verifier

```
Verify the database layer documentation.

1. Read docs/unwind/layers/database/index.md
2. Read all linked section files (schema.md, repositories.md, etc.)
3. Read src/schema.ts (or equivalent schema file)
4. Count all tables in schema
5. For each table:
   - Is it documented in schema.md?
   - Are all columns documented?
   - Are types accurate?
6. For each JSONB column:
   - Is the structure documented in jsonb-schemas.md?
7. Produce verification report at docs/unwind/layers/database/verification.md
```

### Service Verifier

```
Verify the service layer documentation.

1. Read docs/unwind/layers/service-layer/index.md
2. Read all linked section files (services.md, formulas.md, etc.)
3. Read all files in src/server-libs/ (or equivalent)
4. For each documented formula in formulas.md:
   - Find the source code
   - Verify the formula matches exactly
   - Check for edge cases
5. For each calculation function:
   - Are all branches documented?
   - Are hardcoded constants listed?
6. Produce verification report at docs/unwind/layers/service-layer/verification.md
```

### API Verifier

```
Verify the API layer documentation.

1. Read docs/unwind/layers/api/index.md
2. Read all linked section files (endpoints.md, auth.md, etc.)
3. List all files in src/routes/ (or equivalent)
4. For each route file:
   - Is it mentioned in endpoints.md?
   - Are all endpoints listed?
5. For missing routes, document them
6. Produce verification report at docs/unwind/layers/api/verification.md
```

## Rebuild Readiness Scoring

Each verifier assigns a score:

| Score | Meaning |
|-------|---------|
| 9-10 | Ready for AI rebuild - comprehensive, accurate |
| 7-8 | Mostly ready - minor gaps, no blocking issues |
| 5-6 | Significant gaps - rebuild possible with assumptions |
| 3-4 | Major gaps - rebuild would miss key functionality |
| 1-2 | Not ready - documentation insufficient |

**Scoring Criteria:**

| Factor | Weight |
|--------|--------|
| Item count accuracy | 20% |
| Field/detail accuracy | 30% |
| MUST items documented | 30% |
| JSONB/complex schemas | 10% |
| Categorization complete | 10% |
