---
description: Create a feature or bug spec, structured for cross-agent handoff.
arguments: Feature description. Prefix with "bug:" to create in specs/bugs/.
output: specs/features/<slug>/spec.md  (or specs/bugs/<slug>/spec.md)
agent_role: spec-writer
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Parse type from arguments: `bug:` prefix → `specs/bugs/`, otherwise → `specs/features/`.
2. Create slug (2-4 words, kebab-case) and directory.
3. Generate `spec.md` with: summary, actors, user journeys, acceptance criteria, edge cases, assumptions, open questions.
4. Mark unknowns as `NEEDS CLARIFICATION` (max 3).
5. Add handoff block:
   ```
   ## Handoff
   - Spec owner: Codex
   - Plan agent: <recommended>
   - Implementation agent: <recommended>
   - Spec confidence: <level>
   - Blocking questions: <list or "none">
   - Ready for /plan: yes|no
   ```
6. Save `spec.md`.
7. Write spec directory path to `.ai/current` (one line, e.g. `specs/features/checkout-flow`).
8. Return spec path and open questions.

## Rules

- Always update `.ai/current` — downstream commands depend on it.
- No implementation details — requirements only.
- Every acceptance criterion must be independently testable.
