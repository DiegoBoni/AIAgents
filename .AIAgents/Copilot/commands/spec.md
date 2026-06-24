---
description: Create a feature or bug spec structured for cross-agent handoff.
arguments: Feature or bug description. Prefix with "bug:" for bug specs.
output: specs/features/<slug>/spec.md  (or specs/bugs/<slug>/spec.md)
usage: Paste this prompt into Copilot Chat, replacing <DESCRIPTION> with your feature or bug
---

## Prompt

Create a spec for: <DESCRIPTION>

Steps:
1. Determine type: if description starts with "bug:" create in `specs/bugs/`, otherwise `specs/features/`.
2. Create a slug (2-4 words, kebab-case) and the directory.
3. Write `spec.md` with: summary, actors, user journeys, acceptance criteria, edge cases, assumptions, open questions.
4. Mark unknowns as `NEEDS CLARIFICATION` (max 3).
5. Add a Handoff block at the end:
   ```
   ## Handoff
   - Plan agent: <recommended>
   - Implementation agent: <recommended>
   - Spec confidence: <high|medium|low>
   - Blocking questions: <list or "none">
   - Ready for plan: yes|no
   ```
6. Save `spec.md` and write the spec directory path to `.ai/current` (one line).
7. Return the spec path and any open questions.

Rules:
- Always update `.ai/current` — downstream steps depend on it.
- No implementation details — requirements only.
- Every acceptance criterion must be independently testable.
