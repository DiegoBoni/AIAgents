---
description: Show the current pipeline state — active spec, stage, task progress, and quality gates.
arguments: none
output: Inline status report (no files written)
---

## Goal

Give a quick, scannable snapshot of where the current feature stands in the pipeline.
No files are written — this is a read-only diagnostic.

## Steps

1. Read `.ai/current`. If missing → report "No active spec. Run `/spec` to start."
2. Read the spec directory. Load whichever files exist:
   - `spec.md` → feature name, type (feature/bug), confidence, blocking questions
   - `plan.md` → phases, risks
   - `tasks.md` → task list with domains and validation
   - `review.md` → last review verdict (if exists)
3. Determine pipeline stage:
   - spec only → stage: **spec**
   - spec + plan → stage: **plan**
   - spec + plan + tasks → stage: **tasks** (ready for /implement)
   - tasks exist + any tasks have been implemented → stage: **implement**
   - review.md exists → stage: **review**
4. Count task statuses from `tasks.md` (look for done/blocked markers if `/implement` has been run).
5. Check `.ai/log/session.log` for recent activity (last 5 entries) if it exists.
6. Render the report.

## Output format

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Active spec : specs/features/checkout-flow
 Type        : feature
 Stage       : implement  ←  current
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Pipeline    : scan ✓ → spec ✓ → plan ✓ → tasks ✓ → [implement] → review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Tasks       : 8 total
               ✅ 5 done   (backend ×3, data ×2)
               🔄 2 in progress  (frontend ×2)
               ❌ 1 blocked  — T06: waiting on T04
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quality gates
               ✅ API contract matches spec
               ⚠️  Coverage < 80% (74%)
               ❌ E2E test not written yet
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Last review : none yet  →  run /review
 Spec confidence : high
 Blocking questions : none
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Recent activity (from .ai/log)
   14:32 EDIT src/api/checkout.ts
   14:33 EDIT src/api/checkout.test.ts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Next step: /implement  (2 tasks remaining)
            or /review  to validate done tasks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Rules

- Read-only — never write or modify files
- If a pipeline file is missing, show the stage as not started rather than erroring
- Recent activity section is optional — skip gracefully if `.ai/log/session.log` doesn't exist
- Always end with a "Next step" suggestion
