---
description: Show current pipeline state with risk and confidence assessment.
arguments: none
output: Inline status report (read-only)
---

## Steps

1. Read `.ai/current`. If missing → report no active spec.
2. Load spec.md, plan.md, tasks.md, review.md from the spec directory.
3. Determine pipeline stage and task progress.
4. Assess: spec confidence, blocking questions, outstanding risks from plan.md.
5. Report: stage, task counts, risk posture, next recommended step.

## Gemini value-add

Surface risks that could derail the remaining pipeline steps — not just "what's done" but
"what could go wrong next."

## Rules

- Read-only — never write files.
- Skip gracefully if pipeline files are missing.
