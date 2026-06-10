---
name: spec-review
description: Validate that the current implementation satisfies the spec's acceptance criteria. Green/amber/red per criterion. Reads .ai/current automatically.
---

# Spec Review

## Arguments

Optional path to spec directory. If omitted, reads from `.ai/current`.

## Output

`specs/<type>/<slug>/review.md` — green / amber / red per acceptance criterion.

## Goal

Close the loop between spec and implementation: verify that every acceptance criterion
in `spec.md` is satisfied by the code that was written, using the same minimal-context
approach as the rest of the pipeline.

## Steps

1. Resolve spec directory: use arguments if given, otherwise read `.ai/current`.
   - If `.ai/current` is missing → stop, ask user to run `spec` first.
2. Read `spec.md` — extract the full **Acceptance Criteria** section.
3. Determine the domains touched by this feature (read `tasks.md` domain assignments).
4. For each domain, read only `[context.<domain>]` from `.ai/project-context.md`.
5. Get the list of changed files:
   - Run `git diff --name-only HEAD` to find uncommitted changes.
   - Or, if the spec has a `<!-- created: YYYY-MM-DD -->` header, run `git log --since` to find relevant commits.
6. Read only the changed files relevant to the spec's domains.
7. For each acceptance criterion:
   - Search the changed code for the behavior described.
   - Check test files for coverage of that criterion.
   - Assign: ✅ green (satisfied + tested), ⚠️ amber (implemented but not tested), ❌ red (not found).
8. Check quality gates from `plan.md` against actual test results if available.
9. Write the report to `specs/<type>/<slug>/review.md`.
10. Return the report inline + path to saved file.

## Output format (review.md)

```markdown
# Review: <Feature Name>
<!-- spec: <path> -->
<!-- reviewed: <YYYY-MM-DD> -->
<!-- verdict: green | amber | red -->

## Verdict: <overall>

## Acceptance Criteria

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| 1 | Given X When Y Then Z | ✅ green | src/api/checkout.ts:42 |
| 2 | Given X When Y Then Z | ⚠️ amber | implemented, no test found |
| 3 | Given X When Y Then Z | ❌ red  | not found in changed files |

## Quality Gates

| Gate | Status | Detail |
|------|--------|--------|
| All tests pass | ✅ | 48/48 passing |
| Coverage ≥ 80% | ⚠️ | 74% — needs 6% more |

## Gaps
- Criterion 3: <what's missing and where it should be added>

## Next steps
- [ ] <specific action to reach green>
```

## Rules

- Never load the full `project-context.md` — only the domains that the feature touches
- Do not run tests yourself — check test files for existence and coverage of criteria
- Amber is not failure — it means the feature works but needs a test added
- If git history is unclear, ask the user to specify which files to review
- Save `review.md` always — even if all green, the record is valuable
