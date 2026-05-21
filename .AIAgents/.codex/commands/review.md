---
description: Validate implementation against spec acceptance criteria.
arguments: (optional) Path to spec directory. If omitted, reads from .ai/current.
output: specs/<type>/<slug>/review.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Resolve spec directory from arguments or `.ai/current`.
2. Read acceptance criteria from `spec.md`.
3. Get changed files via `git diff --name-only HEAD`.
4. Read changed files relevant to this spec's domains.
5. For each criterion: check implementation and test coverage.
   - ✅ green: implemented + tested
   - ⚠️ amber: implemented, no test
   - ❌ red: not found
6. Check quality gates from `plan.md`.
7. Save `review.md` in the spec directory.
8. Return verdict and gaps.

## Rules

- Load only domain sections matching the spec's tasks.
- Do not run tests — check test file coverage.
- Save review.md even when all green.
