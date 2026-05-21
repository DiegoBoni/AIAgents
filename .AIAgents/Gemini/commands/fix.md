---
description: Analyze a bug and produce a fix recommendation with minimal context. Add --trace to create a bug spec in specs/bugs/.
arguments: Bug description and/or file path(s). Optional: --trace
output: Root cause analysis + fix recommendation. With --trace: also specs/bugs/<slug>/spec.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Parse `--trace` flag. If present, create `specs/bugs/<slug>/` and write a spec.md, then update `.ai/current`.
2. Determine domain from file path or description.
3. Read only `[context.<domain>]` from `.ai/project-context.md`.
4. Read the affected file(s).
5. Identify root cause with confidence level (high / medium / low).
6. Recommend the minimal fix and flag risks and cross-domain impact.
7. If `--trace`: include root cause and recommendation in `spec.md`.

## Rules

- Load only the matching domain section.
- Analysis and recommendation only — implementation is handled by Claude or Codex `/fix`.
- Surface hypotheses with confidence levels rather than guessing.
- `--trace` is opt-in — skip for trivial fixes.
