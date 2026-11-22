---
id: T-0009
title: "ADR-0007: tickets track work, not a prerequisite for it"
type: docs
breaking: false
scope: adr
status: resolved
spec: S-0002
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in: v0.3.0
---

## Context
ADR-0001 (`docs/adr/0001-tickets-are-the-handoff.md`) says every unit of work, down to a one-line fix, becomes a ticket. This makes small fixes found during a session (by `session-review`, `code-review` or the user) go through `shape` → `to-tickets` first. The new model: a ticket tracks work; it is not a prerequisite for it. This ticket records that decision and updates the two texts that restate the old rule: `shape`'s opening line and the GLOSSARY entry for **Ticket**. The skill behaviour changes come in T-0010 to T-0014.

## Decisions that apply
- New ADR `docs/adr/0007-tickets-track-work.md`, titled *Tickets track work; they are not a prerequisite for it*. Same style as the existing ADRs (a heading and a short paragraph; a `## Considered options` section only if useful). It states:
  - Tickets remain the handoff **between contexts**: work that is deferred, large, or meant for a fresh session.
  - Work done **in the current session** may go straight to `implement` with no ticket when its scope is clear and the user authorises it.
  - Only `implement` writes code; this half of ADR-0001 survives, so the review gate of ADR-0002 covers direct work too.
  - Reason: ADR-0001 existed because long sessions drift, so context must be written down before a handoff; a finding fixed now, in the session that found it, has no handoff.
- ADR-0001 is kept and marked superseded: add a line under its heading, `Superseded by ADR-0007.`
- `shape`'s first paragraph becomes, in substance: planned work (features and changes the user decides to make) starts here; findings from `session-review` or `code-review`, and small explicit requests, may go straight to `/implement`, whose direct mode sends ambiguous or architectural requests back to `/shape`. The sentence about `diagnose` stays.
- GLOSSARY **Ticket**: "the only handoff between contexts" → "the handoff between contexts".

## Files
- docs/adr/0007-tickets-track-work.md (new)
- docs/adr/0001-tickets-are-the-handoff.md (change)
- plugins/odhyp/skills/shape/SKILL.md (change)
- GLOSSARY.md (change)

## Acceptance criteria
- [x] ADR-0007 exists and states all four points above.
- [x] ADR-0001 says it is superseded by ADR-0007; its text is otherwise unchanged.
- [x] `shape/SKILL.md` no longer says every one-line fix goes through it, and names direct `/implement` for review findings and small explicit requests.
- [x] GLOSSARY **Ticket** no longer says "the only handoff".
- [x] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- Any change to `implement`, `session-review`, `code-review`, `to-tickets` (T-0010 to T-0012).
- GLOSSARY **Follow-up** (T-0012).
- README (T-0015).

## Questions

## Notes
- Added ADR-0007 (four points), marked ADR-0001 superseded, rewrote the opening of `shape/SKILL.md` (the `diagnose` sentence is kept), and dropped "only" from GLOSSARY **Ticket**.
- `shape` now refers to `/implement` direct mode, which does not exist until T-0011.
