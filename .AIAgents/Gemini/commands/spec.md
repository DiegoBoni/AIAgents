---
description: Build a structured feature or bug specification optimized for requirements analysis and cross-agent handoff.
arguments: Feature description. Prefix with "bug:" to create in specs/bugs/.
output: specs/features/<slug>/spec.md  (or specs/bugs/<slug>/spec.md)
agent_role: spec-writer (Gemini preferred — analysis and requirements focus)
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Parse type: `bug:` prefix → `specs/bugs/`; otherwise → `specs/features/`.
2. Create slug and directory.
3. Analyze the request: actors, value proposition, risks, constraints.
4. Derive user journeys and acceptance criteria (Given/When/Then).
5. Surface edge cases and ambiguities — mark as `NEEDS CLARIFICATION`.
6. Write `spec.md` with: summary, actors, journeys, criteria, assumptions, out-of-scope items.
7. Add handoff block:
   ```
   ## Handoff
   - Spec owner: Gemini
   - Plan agent: Claude (recommended)
   - Implementation agent: Claude or Codex
   - Spec confidence: <level>
   - Blocking questions: <list or "none">
   - Ready for /plan: yes|no
   ```
8. Write spec directory path to `.ai/current` (e.g. `specs/features/checkout-flow`).
9. Return unresolved ambiguities and confidence level.

## Rules

- Always update `.ai/current` — downstream commands read it automatically.
- Requirements only — no architecture or implementation decisions.
- Every open question must include a suggested resolution path.
