---
description: Create or update a domain skill tailored to the current project's stack, conventions, and patterns.
arguments: Skill name and optionally domain (backend|frontend|data|testing|devops|custom). Example: "payments backend" or "shadcn-ui frontend"
output: .claude/skills/<name>/SKILL.md
---

## User Input

```text
$ARGUMENTS
```

## Goal

Generate a `SKILL.md` that captures project-specific patterns beyond the generic skill template.
The result must be actionable without re-reading the full project context — every line must be
specific to this project's actual stack, not generic advice.

## Steps

1. Parse skill name and domain from arguments.
   - Examples: `payments backend`, `shadcn-ui frontend`, `auth-flow backend`, `e2e-checkout testing`
   - If domain is omitted, infer it from the skill name or ask.
2. Check if `.claude/skills/<name>/SKILL.md` already exists:
   - **Exists** → read it, diff against current project context, update stale or missing fields.
   - **New** → start from `_shared/templates/skill-template.md` structure.
3. Read `[context.<domain>]` from `.ai/project-context.md`.
4. Read 2-3 representative source files in the domain to extract actual patterns:
   - naming conventions, error handling style, auth guards, test structure, etc.
5. Write the skill with:
   - **Purpose**: one sentence, specific to this project's use of the domain
   - **When to use**: 3-5 concrete triggers (not generic)
   - **Context loading**: exact section to read from `.ai/project-context.md`
   - **Workflow**: project-specific steps (reference real file paths, patterns, or modules found in step 4)
   - **Constraints**: pulled from engineering standards + domain context
   - **Example**: one real or realistic input/output pair from this codebase
6. Save to `.claude/skills/<name>/SKILL.md`.
7. If the new skill domain is not already listed in `CLAUDE.md`, add it to the skills block.

## Output

- Path of created/updated file
- Summary of project-specific patterns captured
- Any fields left as `NEEDS CLARIFICATION` if evidence was insufficient

## Rules

- Every line must be specific to this project — remove any generic placeholder text
- If `[context.<domain>]` is empty or `NEEDS CLARIFICATION`, run `/scan` first and ask
- Keep the skill under ~400 words — remove anything a competent engineer already knows
- One skill per concern — do not merge multiple domains into one file
- Custom skills (outside the 5 standard domains) are valid — name them clearly
