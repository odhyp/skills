---
id: T-0022
title: implement refusals name the edit that unblocks the ticket
type: feat
breaking: false
scope: implement
status: resolved
spec: S-0003
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
In ticket mode, `implement` step 1 refuses `ready-for-human` tickets ("say what the person has to do") and `needs-info` tickets that still have unanswered questions ("show them"). It doesn't say which file edit unblocks the ticket. The ticket format (`plugins/odhyp/templates/TICKET-FORMAT.md`, Statuses) says a person moves `ready-for-human` to `resolved` or `ready-for-agent`, answers `needs-info` questions, and sets `wontfix`, but nothing tells the user that when they're stuck. A `ready-for-human` ticket blocks every ticket that depends on it until someone edits it.

## Decisions that apply
- `ready-for-human`: say what the person has to do, then to set `status: resolved` (they did it by hand) or `status: ready-for-agent` (an agent should build it) in that ticket's file path, and commit.
- `needs-info` with unanswered questions: show them, and say to answer them inline under `## Questions` in that ticket's file path. The next `/implement` then sets `ready-for-agent`.
- Wherever a ticket is refused or blocks others (the refusals above, unresolved `depends_on`, and the no-argument "list each open ticket" case), add one line on dropping it: set `status: wontfix` with the reason in `## Notes`.
- The person still sets these statuses, as the ticket format says. `implement` only names the edit and changes no ticket.
- Keep the wording short: one line per refusal reason.

## Files
- plugins/odhyp/skills/implement/SKILL.md (change: step 1, ticket mode refusals)

## Acceptance criteria
- [x] The `ready-for-human` refusal names the file path and the two status values to set, and says to commit.
- [x] The `needs-info` refusal shows the questions and says to answer them under `## Questions` in the named file.
- [x] The refusals and the no-eligible-ticket list say once how to drop a ticket (`status: wontfix`, reason in `## Notes`).
- [x] `implement` still changes no ticket when it refuses.
- [x] `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- Direct-mode must-fix warning (T-0023).
- Letting `implement` set `resolved`, `ready-for-agent` or `wontfix` itself.
- TICKET-FORMAT.md, the README and the diagrams.

## Questions

## Notes
- Step 1 refusals now name the edit: `needs-info` says to answer under `## Questions` in the ticket's file; `ready-for-human` says to set `resolved` or `ready-for-agent` there and commit. One trailing line after any refusal or open-ticket list says how to drop a ticket (`wontfix`, reason in `## Notes`). The refusal header now says "change no ticket".
