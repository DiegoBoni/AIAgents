---
description: Draft a complete feature specification with clear acceptance scenarios, designed for cross-agent handoff.
arguments: Feature description. Prefix with "bug:" to create in specs/bugs/ instead of specs/features/.
output: specs/features/<slug>/spec.md  (or specs/bugs/<slug>/spec.md)
agent_role: spec-writer (analysis-focused agent preferred — Claude or Gemini)
---

## User Input

```text
$ARGUMENTS
```

## Goal

Produce a spec that is complete, unambiguous, and structured for handoff — any agent
(Claude, Codex, Gemini, or a sub-agent) must be able to pick up this file and proceed
to `/plan` without additional context.

## Steps

1. Parse arguments:
   - If starts with `bug:` → type = `bug`, strip prefix, continue.
   - Otherwise → type = `feature`.
2. Create a short slug from the description (2-4 words, kebab-case).
3. Set the spec directory:
   - Feature: `specs/features/<slug>/`
   - Bug:     `specs/bugs/<slug>/`
4. Create the directory if it doesn't exist.
5. Read `.ai/project-context.md` top-level sections (Metadata, Stack, Architecture) — not domain sections.
6. Derive:
   - **Actors**: who initiates or is affected
   - **User journeys**: primary, alternative, and error flows
   - **Edge cases**: boundary conditions, concurrent access, empty states, failures
   - **Testable requirements**: acceptance criteria in Given / When / Then form
7. Add:
   - **Assumptions**: explicit, numbered
   - **Open questions**: max 3, marked `NEEDS CLARIFICATION`
   - **Out of scope**: what this spec intentionally excludes
   - **Handoff block**: agent assignments and readiness signal
8. Save `spec.md` inside the spec directory.
9. Write the spec directory path (e.g. `specs/features/checkout-flow`) to `.ai/current` — one line, no trailing slash.
10. Return: spec path + `.ai/current` updated + readiness status for `/plan`.

## Current spec pointer

`.ai/current` is updated every time `/spec` runs. Subsequent commands (`/plan`, `/tasks`, `/implement`)
read this file automatically when called without arguments — no need to pass the path.

To work on a different spec: pass its path explicitly, or run `/spec` again to switch.

## Output format (spec.md)

```markdown
# Spec: <Feature or Bug Name>
<!-- type: feature | bug -->
<!-- slug: <slug> -->
<!-- created: <YYYY-MM-DD> -->

## Summary
One paragraph. What this feature/bug is and why it matters.

## Actors
- Actor 1: role and permissions

## User Journeys

### Primary flow
1. Step

### Alternative flows
- Condition → outcome

### Error flows
- Condition → outcome

## Acceptance Criteria
- Given <context> When <action> Then <outcome>

## Edge Cases
- Case: expected behavior

## Out of Scope
- Item

## Assumptions
1. Assumption

## Open Questions (NEEDS CLARIFICATION)
1. Question

---
## Handoff
- Spec owner: <agent>
- Plan agent: <recommended agent>
- Implementation agent: <recommended agent>
- Spec confidence: high | medium | low
- Blocking questions: <list or "none">
- Ready for /plan: yes | no — <reason if no>
```

## Rules

- Features go in `specs/features/`, bugs in `specs/bugs/` — never mix
- Always update `.ai/current` — this is the contract with downstream commands
- Do not write implementation details — spec only, no code or data model choices
- Every acceptance criterion must be independently testable
- Mark every assumption explicitly — never assume silently
- Keep the handoff block complete — incomplete handoffs block the next agent
