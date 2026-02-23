---
description: Produce a complete repository context document to align implementation and design decisions.
arguments: Optional domain focus (api, ui, platform, data)
output: .AIAgents/project-context.md and updated CLAUDE.md notes
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Analyze repository structure, tooling, and documentation.
2. Extract languages, frameworks, architecture patterns, and integrations.
3. Record standards for coding, testing, reviews, and deployment.
4. Generate `.AIAgents/project-context.md` from shared template.
5. Update `CLAUDE.md` with practical project constraints and best practices.
6. Return confidence level and explicit open questions.

## Rules

- Prefer repository evidence and explicit references.
- Keep assumptions visible and limited.
- Focus on guidance that improves execution quality.
