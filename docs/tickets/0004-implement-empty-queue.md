---
id: T-0004
title: implement explains an empty or blocked queue
type: feat
breaking: false
scope: implement
status: resolved
spec: S-0001
depends_on: [T-0001]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
`/implement` with no argument picks an `in-progress` ticket, else the lowest-numbered `ready-for-agent` one whose `depends_on` are all `resolved`. When none qualifies, the skill says nothing about what to do.

## Decisions that apply
- With no argument and no eligible ticket, `implement` changes nothing and stops:
  - no open tickets (none other than `resolved`/`wontfix`): say so and point to `/shape` for new work;
  - open tickets, all blocked: list each with its reason, reusing step 1's refusal reasons: `needs-info` (its unanswered questions), `ready-for-human` (what the person has to do), unresolved `depends_on` (which tickets).
- Every change still needs a ticket (ADR 0001); no path into `implement` without one.

## Files
- plugins/odhyp/skills/implement/SKILL.md (change: step 1)

## Acceptance criteria
- [x] Step 1 covers "no eligible ticket" with both cases above, and says nothing is changed.
- [x] The blocked case reuses the existing refusal reasons rather than restating them differently.
- [x] `claude plugin validate plugins/odhyp` passes.

## Out of scope
- Any change to how a ticket is picked when one is eligible.
- A ticketless path into `implement`.

## Questions

## Notes
Added a "no argument and no eligible ticket" paragraph to step 1 of `plugins/odhyp/skills/implement/SKILL.md`, after the refusal list. The blocked case points back to that list ("the refusal reason above") instead of restating the reasons. No test fits a prose change; `claude plugin validate` passes (icon warning predates this).
