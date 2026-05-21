---
description: Show current pipeline state — active spec, stage, and task progress.
arguments: none
output: Inline status report (read-only)
---

## Steps

1. Read `.ai/current`. If missing → report no active spec.
2. Load existing pipeline files from the spec directory: spec.md, plan.md, tasks.md, review.md.
3. Determine stage and count task statuses.
4. Report: active spec, pipeline progress, task counts, next recommended step.

## Rules

- Read-only — never write files.
- Skip gracefully if pipeline files are missing.
- Always suggest the next step.
