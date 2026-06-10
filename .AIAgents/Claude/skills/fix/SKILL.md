---
name: fix
description: Fix a bug with minimal context — loads only the domain section relevant to the affected file. Add --trace to create a bug spec for traceability.
---

# Fix

## Arguments

Bug description and/or file path(s). Add `--trace` to create a bug spec in `specs/bugs/`.

## Output

Code fix + explanation. With `--trace`: also creates `specs/bugs/<slug>/spec.md` and updates `.ai/current`.

## Goal

Diagnose and fix the bug using the smallest possible context footprint.
Load only the domain section that matches the affected code — nothing else.

## Steps

1. Parse arguments:
   - If `--trace` flag is present → create a bug spec before fixing (see Trace mode below).
   - Otherwise → fix directly without creating spec artifacts.
2. Read the bug description and identify the affected file(s).
3. Determine the domain from the file path or description:
   - API / service / auth → `[context.backend]`
   - Component / page / state → `[context.frontend]`
   - Migration / model / query → `[context.data]`
   - Test file → `[context.testing]`
   - Pipeline / infra / config → `[context.devops]`
4. Read **only** that domain section from `.ai/project-context.md`.
5. Read the affected file(s) — no more than needed.
6. Identify root cause. State hypothesis before fixing if uncertain.
7. Apply the minimal fix that resolves the bug without side effects.
8. Flag any related risks or follow-up needed in other domains.

## Trace mode (--trace)

When `--trace` is passed:
1. Create slug from bug description (kebab-case).
2. Create `specs/bugs/<slug>/` directory.
3. Write a concise `spec.md` with: summary, root cause hypothesis, affected files, acceptance criteria (bug does not reproduce), domain.
4. Write `specs/bugs/<slug>` to `.ai/current`.
5. Proceed with the fix as normal.
6. After fixing, update `spec.md` with the actual root cause and fix summary.

Use `--trace` when:
- The bug is complex or involved multiple files
- You want the bug tracked alongside features for release notes
- The root cause is non-obvious and worth documenting

## Output

- Fixed file(s)
- Root cause: one sentence
- Fix summary: what changed and why
- Follow-up flags (if the fix has cross-domain impact)
- With `--trace`: path to `specs/bugs/<slug>/spec.md`

## Rules

- Do not load the full `project-context.md` — only the matching domain section
- Do not refactor surrounding code unless it is the direct cause of the bug
- If the root cause is unclear after reading the file, ask before guessing
- If the fix touches multiple domains, flag it and split into separate tasks
- `--trace` is opt-in — don't create spec artifacts for trivial one-line fixes
