---
description: Deep review of implementation against spec — Gemini's strength is finding gaps between intent and code.
arguments: (optional) Path to spec directory. If omitted, reads from .ai/current.
output: specs/<type>/<slug>/review.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Resolve spec directory from arguments or `.ai/current`.
2. Read `spec.md` (full), `plan.md` (risks and quality gates), `tasks.md` (domain map).
3. Get changed files via `git diff --name-only HEAD` or by spec creation date.
4. Read changed files per domain.
5. For each acceptance criterion: assess implementation depth, test coverage, and edge case handling.
   - ✅ green: satisfied + tested + edge cases covered
   - ⚠️ amber: core case implemented, edge cases or tests missing
   - ❌ red: not implemented or directly contradicts spec
6. Flag any behavioral drift — where the implementation technically passes but violates the spec's intent.
7. Check quality gates and risks from `plan.md`.
8. Save `review.md` in the spec directory with verdict and prioritized next steps.

## Gemini value-add

Go beyond pass/fail — surface:
- Undocumented assumptions in the implementation
- Behaviors that work now but will break at scale or edge conditions
- Missing error flows that the spec listed but the code skips

## Rules

- Load only domain sections matching the spec's tasks.
- Distinguish between "not implemented" and "implemented differently than spec intended".
- Every ❌ and ⚠️ must have a concrete, actionable resolution.
