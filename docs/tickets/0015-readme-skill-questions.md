---
id: T-0015
title: "README: one question per skill"
type: docs
breaking: false
scope: readme
status: ready-for-agent
spec: S-0002
depends_on: [T-0010, T-0011, T-0012, T-0013, T-0014]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
T-0010 to T-0014 change what `session-review`, `code-review`, `implement`, `to-tickets` and `to-spec` do. The README still says `code-review` writes follow-up tickets and `session-review` proposes fixes to CLAUDE.md, and its workflow diagram has a "Follow-ups" edge from review to tickets.

## Decisions that apply
- Add this table to the README's skills section:

  | Skill | Answers |
  |---|---|
  | `setup` | How is this project wired for the workflow? |
  | `shape` | What exactly are we building, and why? |
  | `diagnose` | Why is it broken? |
  | `to-spec` | What did we agree to build? |
  | `to-tickets` | What work should we track? |
  | `implement` | How do we fix it? |
  | `code-review` | What is wrong with this code? |
  | `session-review` | What should we improve? |
  | `diagram` | What does the system look like? |
  | `release` | What changed since the last version? |

- Update the existing skill table rows to match the skills as changed: `code-review` grades findings by severity and writes no tickets; `session-review` lists ranked findings and writes nothing; `implement` builds a ticket or a direct request; `to-tickets` also takes findings; `to-spec` confirms, then commits.
- Workflow diagram: replace the review → tickets "Follow-ups" edge with findings going to `/implement` or `/to-tickets` at the user's choice; show direct `/implement` from review findings.
- A ticket tracks work; it is not a prerequisite for it (ADR-0007). Any README sentence saying every change needs a ticket is updated.

## Files
- README.md (change)

## Acceptance criteria
- [ ] The question table is in the README.
- [ ] The `code-review`, `session-review`, `implement`, `to-tickets` and `to-spec` rows match their skills.
- [ ] The diagram has no automatic review → tickets edge and shows findings → `/implement` or `/to-tickets`.
- [ ] No README text says every change needs a ticket.
- [ ] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- CHANGELOG and version bump (`/odhyp:release`).
- Any skill text.

## Questions

## Notes
