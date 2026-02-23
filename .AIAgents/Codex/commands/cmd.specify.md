---
description: Create a feature spec from a natural-language request.
arguments: Feature description
output: specs/<feature>/spec.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Create a short feature slug (2-4 words).
2. Create folder `specs/<slug>/` if missing.
3. Generate `spec.md` from template with scenarios, requirements, and success criteria.
4. Mark unknowns as `NEEDS CLARIFICATION` (max 3).
5. Return spec path and open questions.
