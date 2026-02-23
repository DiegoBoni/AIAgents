---
description: Analyze a bug and produce a fix recommendation with minimal context loading.
arguments: Bug description and/or file path(s)
output: Root cause analysis + fix recommendation
---

## User Input

```text
$ARGUMENTS
```

## Goal

Diagnose the bug, identify the root cause, and recommend the minimal fix.
Load only the domain section that matches the affected code — nothing else.

## Steps

1. Read the bug description and identify the affected file(s).
2. Determine the domain from the file path or description:
   - API / service / auth → `[context.backend]`
   - Component / page / state → `[context.frontend]`
   - Migration / model / query → `[context.data]`
   - Test file → `[context.testing]`
   - Pipeline / infra / config → `[context.devops]`
3. Read **only** that domain section from `.ai/project-context.md`.
4. Read the affected file(s) — no more than needed.
5. Identify root cause with confidence level (high / medium / low).
6. Recommend the minimal fix: what to change and why.
7. Flag risks, edge cases, and any cross-domain impact.

## Output

- Root cause analysis with confidence level
- Fix recommendation: specific change + rationale
- Risk flags: what could go wrong with the fix
- Cross-domain impact (if the fix affects other domains)
- Open questions marked `NEEDS CLARIFICATION` if root cause is uncertain

## Rules

- Load only the matching domain section — not the full project context
- Focus on analysis and recommendation — implementation is handled by Codex or Claude `/fix`
- If root cause is unclear, surface hypotheses with confidence levels rather than guessing
- If fix touches multiple domains, flag explicitly and suggest splitting
