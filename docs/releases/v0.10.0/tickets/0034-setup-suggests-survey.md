---
id: T-0034
title: Setup suggests survey for existing code
type: feat
breaking: false
scope: setup
status: resolved
spec: S-0006
depends_on: [T-0033]
source: to-tickets
parent: none
diagrams: []
released_in: v0.10.0
---

## Context

T-0033 adds `/odhyp:survey`, which drafts a glossary, diagrams and ADRs for an existing codebase. `setup` should point brownfield projects to it. Today `setup`'s report (step 4 of `plugins/odhyp/skills/setup/SKILL.md`) ends with the next step: `/shape` for planned work, or `diagnose` for a bug of unknown cause.

## Decisions that apply

- `setup` only suggests; it never runs `survey`. `setup` stays quick, idempotent and the same for every project.
- Suggest `/odhyp:survey` when the project has source code and at least one of these is missing: the glossary file (the `Glossary:` path), any `.mmd` in the diagrams folder, any ADR in the decisions folder. Both checks come from files; no commit-count threshold, since a young repo with real code still needs a vocabulary.
- When the suggestion applies, it comes before `/shape` in the next step, naming what is missing.

## Files

- `plugins/odhyp/skills/setup/SKILL.md` (change: step 1 notes source code, step 4 checks the docs and reports the suggestion)

## Acceptance criteria

- [x] Step 1 notes whether the project has source code outside the odhyp folders; step 4 checks which of glossary, diagrams and ADRs exist, at the paths step 3 wrote.
- [x] Step 4 suggests `/odhyp:survey` and names what is missing when the rule applies, and says nothing about it otherwise (greenfield with no code, or all three present).
- [x] `setup` still writes nothing new and stays safe to re-run.
- [x] `docs/diagrams/workflow.mmd` still matches (its `/setup` → `/survey` branch came with T-0033).
- [x] `claude plugin validate .` and `claude plugin validate plugins/odhyp` pass.

## Out of scope

- Running `survey` from `setup`, or asking about it in step 2.
- Any change to `survey` itself.

## Questions

## Notes
Step 1 of `setup/SKILL.md` gains one bullet: whether there is source code outside the odhyp folders. The glossary, `.mmd` diagrams and ADRs are checked only in step 4, at the paths step 3 wrote into the block, since step 2 can change the base path. Step 4's next step starts with `/odhyp:survey`, naming what is missing, only when code exists and something is missing; otherwise it says nothing about survey. Read-only checks, so setup still writes nothing new. `workflow.mmd` already had the `/setup` → `/survey` branch; unchanged.
