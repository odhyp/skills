---
id: T-0016
title: implement direct mode wording in records and commit steps
type: docs
breaking: false
scope: implement
status: ready-for-agent
spec: S-0002
depends_on: [T-0011]
source: code-review
parent: T-0011
diagrams: []
released_in:
---

## Context
`plugins/odhyp/skills/implement/SKILL.md` gained a direct mode in T-0011 (argument other than `T-…` or `@<tickets>/…`: build a restated brief with no ticket). Two ticket-only sentences still read as if they apply to direct mode too:
- Step 3 tells the agent to add a spec `## Decisions` entry as `date · T-NNNN · what changed and why`, and the direct-mode line says to still add such entries, but direct mode has no `T-NNNN`.
- Step 5 opens with "Set `status: resolved`. Stage the code, the tests, the ticket file …" unqualified; the direct-mode line after it gives the commit format but not what to stage, and there is no ticket to resolve.

## Decisions that apply
- Ticket mode text stays as it is; add or adjust only the direct-mode lines.
- Direct-mode spec `## Decisions` entry: `date · what changed and why` (use `T-NNNN` only when the findings came from a review of that ticket, matching the `Refs:` rule).
- Direct-mode commit: stage the code, the tests and any diagram or spec files; no ticket status to set.

## Files
- plugins/odhyp/skills/implement/SKILL.md (change)

## Acceptance criteria
- [ ] Step 3's direct-mode line gives the spec `## Decisions` entry format without a ticket ID (except a reviewed ticket's).
- [ ] Step 5's direct-mode line says what to stage and that no ticket status is set.
- [ ] Ticket-mode text in steps 3 and 5 is unchanged.
- [ ] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- Review-step and follow-up-ticket wording in steps 4 and 6 (T-0012).
- README (T-0015).

## Questions

## Notes
