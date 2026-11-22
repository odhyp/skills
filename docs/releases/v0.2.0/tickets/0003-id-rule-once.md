---
id: T-0003
title: State the next-ID rule once in the format files
type: refactor
breaking: false
scope: templates
status: resolved
spec: S-0001
depends_on: [T-0001]
source: to-tickets
parent: none
diagrams: []
released_in: v0.2.0
---

## Context
"Highest existing ID in the folder and the releases archive, plus one" is written out in `to-spec`, `to-tickets`, `diagnose` and `code-review`, and again in the format files. It should live once, in the format files that every one of those skills already loads.

## Decisions that apply
- `TICKET-FORMAT.md` and `SPEC-FORMAT.md` each get an `## IDs` section: the next ID is the highest existing ID of that kind in its folder and in the releases archive, plus one; zero-padded `T-NNNN` / `S-NNNN`; never reused; tickets and specs count separately; the first is `0001`.
- The existing IDs bullet at the top of each format file moves into that section (no duplicate left behind).
- Skills say "next `T-` ID (see the ticket format)" or "next `S-` ID (see the spec format)" and nothing more about how it is computed.
- Wording only; no behaviour change.

## Files
- plugins/odhyp/templates/TICKET-FORMAT.md (change)
- plugins/odhyp/templates/SPEC-FORMAT.md (change)
- plugins/odhyp/skills/to-spec/SKILL.md (change)
- plugins/odhyp/skills/to-tickets/SKILL.md (change)
- plugins/odhyp/skills/diagnose/SKILL.md (change)
- plugins/odhyp/skills/code-review/SKILL.md (change)
- plugins/odhyp/skills/implement/SKILL.md (change, only if it describes computing an ID)

## Acceptance criteria
- [x] Both format files have an `## IDs` section with the rule.
- [x] `grep -rn "plus one" plugins/odhyp/skills` finds nothing.
- [x] Each of the four skills points to the format for the next ID.
- [x] `claude plugin validate plugins/odhyp` passes.

## Out of scope
- `session-review` ticket writing (T-0005).
- Changing how IDs are numbered.

## Questions

## Notes
- Moved the IDs bullet in `TICKET-FORMAT.md` and `SPEC-FORMAT.md` into a new `## IDs` section (folder + releases archive, plus one; first is `0001`; never reused; counted separately).
- `to-spec`, `to-tickets`, `diagnose` and `code-review` now say "next `T-`/`S-` ID (see the ticket/spec format)"; each already loads that format file.
- `implement` did not describe computing an ID; unchanged.
