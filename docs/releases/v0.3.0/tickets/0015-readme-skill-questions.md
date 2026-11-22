---
id: T-0015
title: "README: one question per skill"
type: docs
breaking: false
scope: readme
status: resolved
spec: S-0002
depends_on: [T-0010, T-0011, T-0012, T-0013, T-0014]
source: to-tickets
parent: none
diagrams: []
released_in: v0.3.0
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
  | `implement` | How do we build it? |
  | `code-review` | What is wrong with this code? |
  | `session-review` | What should we improve? |
  | `diagram` | What does the system look like? |
  | `release` | What changed since the last version? |

- Update the existing skill table rows to match the skills as changed: `code-review` grades findings by severity and writes no tickets; `session-review` lists ranked findings and writes nothing; `implement` builds a ticket or a direct request; `to-tickets` also takes findings; `to-spec` confirms, then commits.
- Intro: replace the sentence "Planning, diagnosing and reviewing write tickets." with "Planning and diagnosing write tickets; review findings go straight to `/implement` or become tickets, your choice." Keep the bold "Tickets are the handoff between fresh contexts." and the rest of the paragraph.
- Workflow diagram:
  - Rename the "Per ticket (fresh context)" subgraph to "Build (ticket or direct)". The `/implement` node reads "ticket or direct · test-first → code".
  - Two ways in: `T -->|"/implement @ticket"| C1` (as today) and `S1 -->|"/implement N"| C1` (direct mode from `session-review` findings).
  - Commit node: "ticket: status resolved · direct: no Refs". Stop node: "ticket: must-fix in Notes · direct: report only".
  - Remove the `D1 -.->|"Follow-ups"| T` edge. Add a decision node "You choose", fed by `C2 -.->|"non-blocking findings"|` and `S1 -.->|"findings"|`, with edges `-->|"/implement N"| C1` and `-->|"/to-tickets N"| B3`.
  - `diagnose` and the rest of the diagram are unchanged.
- A ticket tracks work; it is not a prerequisite for it (ADR-0007). Any README sentence saying every change needs a ticket is updated.

## Files
- README.md (change)

## Acceptance criteria
- [x] The question table is in the README.
- [x] The `code-review`, `session-review`, `implement`, `to-tickets` and `to-spec` rows match their skills.
- [x] The intro no longer says reviewing writes tickets, and uses the sentence above.
- [x] The diagram has no automatic review → tickets edge and shows findings → "You choose" → `/implement` or `/to-tickets`.
- [x] The diagram's build subgraph is entered from tickets and from `/implement N`, and its commit and stop nodes name both modes.
- [x] The README's Mermaid block still renders (paste into mermaid.live or GitHub preview).
- [x] No README text says every change needs a ticket.
- [x] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- CHANGELOG and version bump (`/odhyp:release`).
- Any skill text.
- Renaming skills (names stay; renames would break `/odhyp:<name>` commands).
- `diagnose` writing its own fix ticket (S-0002 non-goal).

## Questions

## Notes
- README: question table added above the existing skill table (kept separate so the wide table stays readable); five rows, intro sentence and workflow diagram updated per the decisions. New "You choose" node is `X4`, outside both subgraphs.
- No README sentence said every change needs a ticket; nothing to change there.
- Mermaid render: mermaid-cli via npx was denied in this session; the user rendered the block by hand and confirmed it renders. This resolves the review's one must-fix (the unverified render criterion).
