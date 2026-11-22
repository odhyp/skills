---
id: T-0012
title: code-review grades by severity and writes no tickets
type: feat
breaking: false
scope: code-review
status: resolved
spec: S-0002
depends_on: [T-0010, T-0011]
source: to-tickets
parent: none
diagrams: []
released_in: v0.3.0
---

## Context
`plugins/odhyp/skills/code-review/SKILL.md` sorts problems into must-fix and follow-up, and writes every follow-up as a new ticket by itself. In after-commit mode it also sets the ticket back to `ready-for-agent`. `code-review` should answer only *What is wrong with this code?*: grade findings, recommend an action, and change nothing. `implement` relays what is left; the user picks `/implement N` (T-0011) or `/to-tickets N` (T-0010).

## Decisions that apply
- Each finding gets a severity:

  | Severity | Action |
  |---|---|
  | Critical | Stop and address immediately |
  | High | Fix before merging |
  | Medium | Fix directly when appropriate, or track as a ticket |
  | Low | Optional; avoid unnecessary work |

- Verdict: any Critical or High finding → `MUST-FIX` (blocks the commit, per ADR-0002); otherwise `PASS`. The verdict line stays first so `implement` can read it.
- Findings return in priority order in the same numbered, ★-ranked format as `session-review` (number, ★ RECOMMENDED on finding 1, title, severity, `path:line`, one to two sentences). Each non-blocking finding carries a suggested action: `fix now` (small, well understood) or `ticket` (large, independent, or worth deferring).
- `code-review` writes no tickets and changes no ticket state, in every mode. The after-commit mode no longer sets the ticket back to `ready-for-agent` or edits its `## Notes`; it only reports.
- After-commit MUST-FIX: the ticket stays `resolved`; the user fixes the findings with direct `/implement N`, whose commit carries `Refs: T-NNNN` (T-0011).
- `implement` (ticket and direct mode): the review step no longer mentions follow-up tickets. On MUST-FIX in ticket mode, the blocking findings still go under `## Notes` as `Must-fix (review):`, as today. On PASS, after the commit, list the non-blocking findings and stop; the user picks `/implement N` or `/to-tickets N`. Step 6 no longer reports follow-up tickets.
- `TICKET-FORMAT.md` (body text only, not the frontmatter): drop `code-review` and `session-review` from the "Set by" column of `ready-for-agent`, and remove the `resolved --> ready_for_agent: must-fix found after commit` transition from the state diagram. `source:` keeps both values (`to-tickets` uses them for tickets from findings).
- GLOSSARY **Follow-up**: "A **Ticket** written from a review finding, at the user's request."
- Add to S-0002 `## Decisions`: `2026-11-22 · T-0012 · After-commit MUST-FIX no longer reopens the ticket: it stays resolved and the findings are fixed with direct /implement, Refs: T-NNNN.`

## Files
- plugins/odhyp/skills/code-review/SKILL.md (change)
- plugins/odhyp/skills/implement/SKILL.md (change)
- plugins/odhyp/templates/TICKET-FORMAT.md (change)
- GLOSSARY.md (change)
- docs/specs/0002-findings-without-tickets.md (change)

## Acceptance criteria
- [x] `code-review/SKILL.md` grades each finding Critical/High/Medium/Low and derives the verdict from it.
- [x] Findings come back ranked, ★ on finding 1, each non-blocking one with `fix now` or `ticket`.
- [x] `code-review/SKILL.md` contains no instruction to write a ticket or change a ticket's status or Notes.
- [x] `implement/SKILL.md` lists non-blocking findings after a PASS commit and stops; no follow-up-ticket wording remains.
- [x] `TICKET-FORMAT.md` "Set by" and state diagram updated; frontmatter block unchanged.
- [x] GLOSSARY **Follow-up** updated.
- [x] S-0002 has the `## Decisions` entry.
- [x] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- `session-review` (T-0010), `implement` direct mode itself (T-0011).
- The `.gitkeep` rule (T-0014), README (T-0015).

## Questions

## Notes
- code-review: severity table, verdict from Critical/High, ★-ranked numbered findings with `fix now`/`ticket` on Medium/Low; the "change nothing" rule covers every mode, and after-commit MUST-FIX now only reports (the ticket stays `resolved`, fixed with direct `/implement N`).
- implement: the review step and step 6 drop follow-up tickets; after a PASS commit it lists the non-blocking findings and stops.
- TICKET-FORMAT body, GLOSSARY Follow-up, S-0002 Decisions updated. README still says code-review "Writes follow-up tickets" (left for T-0015).
