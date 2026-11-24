---
id: T-0026
title: implement and shape offer to-adr
type: feat
breaking: false
scope: adr
status: resolved
spec: S-0004
depends_on: [T-0025]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
T-0025 added the `to-adr` skill. It is user-invocable, and two skills should offer it at the
moments a decision becomes settled: after `implement` commits, and when `shape` ends with
nothing to build. Both only offer it, in one line; neither writes an ADR.

## Decisions that apply
- `implement`, step 6 (Stop): after reporting the commit, offer `/odhyp:to-adr` in one line
  when the ticket, its spec or the direct brief settled a decision worth keeping that no ADR
  in the decisions folder covers. Read the spec's `## Design` and `## Decisions` both:
  `## Decisions` holds only changes made during implementation. No offer on a MUST-FIX stop
  (nothing shipped).
- `shape`, the Explore "nothing should be built" exit: under `## Next step`, offer
  `/odhyp:to-adr` when the reason for not building is worth keeping ("we decided not to do X,
  because Y"). A trivial "already exists" answer stays a plain stop.
- Whether a decision deserves an ADR is the user's call; the offer never runs `to-adr` itself.
- `workflow.mmd` already shows both offer edges (committed in T-0025); nothing to redraw.

## Files
- plugins/odhyp/skills/implement/SKILL.md (change)
- plugins/odhyp/skills/shape/SKILL.md (change)

## Acceptance criteria
- [x] `implement` step 6 has the conditional one-line offer, in both ticket and direct mode, not on MUST-FIX.
- [x] `shape`'s nothing-to-build exit has the conditional offer under `## Next step`.
- [x] Neither skill writes to the decisions folder.
- [x] `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- Offers from shape's feature and small-change exits, `to-spec` or `release`.
- Changes to the `to-adr` skill.

## Questions

## Notes
- implement step 6: one-line conditional `/odhyp:to-adr` offer, both modes; MUST-FIX stops in step 4 so never reach it.
- shape Explore nothing-to-build exit: conditional offer under `## Next step`; plain "already exists" gets none.
