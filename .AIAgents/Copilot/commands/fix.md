---
description: Fix a bug with minimal context. Add --trace to create a bug spec for traceability.
arguments: Bug description and/or file path(s). Optional: --trace
output: Code fix + root cause summary. With --trace: also specs/bugs/<slug>/spec.md
usage: Paste this prompt into Copilot Chat, replacing <DESCRIPTION> with the bug details
---

## Prompt

Fix this bug: <DESCRIPTION>

Steps:
1. Check if `--trace` is in the description. If yes, create `specs/bugs/<slug>/spec.md` and write path to `.ai/current`.
2. Determine domain from file path or description.
3. Read only `[context.<domain>]` from `.ai/project-context.md`.
4. Read the affected file(s) — no more.
5. Identify the root cause. Apply the minimal fix. Run lint and relevant tests.
6. Return: root cause, fix summary, test result, any cross-domain flags.
7. If `--trace`: update `spec.md` with the actual root cause and fix applied.

Rules:
- Load only the matching domain section — do not scan the whole project.
- Do not refactor surrounding code unless it directly causes the bug.
- `--trace` is opt-in — skip for trivial one-line fixes.
