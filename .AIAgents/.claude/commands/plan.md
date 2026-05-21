---
description: Create technical plan artifacts from a spec.
arguments: (optional) Path to spec directory or spec.md. If omitted, reads from .ai/current.
output: specs/features/<slug>/plan.md  (or specs/bugs/<slug>/plan.md)
---

## User Input

```text
$ARGUMENTS
```

## Resolving the spec

1. If arguments are provided → use that path as the spec directory (or file).
2. If no arguments → read `.ai/current` to get the active spec directory.
3. If `.ai/current` is missing or empty → stop and ask the user to run `/spec` first.
4. Read `spec.md` from the resolved directory.
5. Verify the `## Handoff` block says `Ready for /plan: yes`. If no → surface blocking questions before continuing.

## Steps

1. Resolve spec as above.
2. Analyze requirements and constraints from `spec.md`.
3. Define architecture approach and data model notes.
4. Build a phase-by-phase implementation plan with clear milestones.
5. Record risks, assumptions, and quality gates per phase.
6. Save `plan.md` in the same directory as `spec.md`.
7. Return: plan path + phase summary + open risks.

## Output format (plan.md)

```markdown
# Plan: <Feature or Bug Name>
<!-- spec: <path to spec.md> -->
<!-- created: <YYYY-MM-DD> -->

## Architecture notes
Short description of approach and key decisions.

## Data model notes
New or modified entities, fields, relationships.

## Phases

### Phase 1 — <name>
- Scope:
- Deliverables:
- Quality gate:
- Estimated complexity: S | M | L

### Phase 2 — <name>
...

## Risks
- Risk: mitigation

## Assumptions
1. Assumption

## Quality gates
- Gate: pass/fail criteria
```

## Rules

- Read only from the resolved spec directory — do not load unrelated files
- If spec confidence is `low`, note it and flag assumptions explicitly
- Do not invent architecture not supported by the project context
- Keep phases small enough that each maps to ≤5 tasks in `/tasks`
