---
description: Create or update a domain skill for code generation, tailored to this project's patterns.
arguments: Skill name and domain. Example: "api-endpoints backend"
output: .codex/skills/<name>/SKILL.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Parse skill name and domain from arguments.
2. Check if `.codex/skills/<name>/SKILL.md` exists — update if so, create if not.
3. Read `[context.<domain>]` from `.ai/project-context.md`.
4. Read representative source files to extract naming, patterns, and conventions.
5. Write the skill focused on code generation:
   - File naming and location conventions
   - Boilerplate patterns (function signatures, imports, error handling)
   - Test file structure if applicable
   - Anti-patterns to avoid in this codebase
6. Save to `.codex/skills/<name>/SKILL.md`.

## Rules

- Code-generation focused — emphasize patterns, not reasoning steps.
- No generic advice — every field must reference this project's actual stack.
- If context is missing, run `/scan` first.
