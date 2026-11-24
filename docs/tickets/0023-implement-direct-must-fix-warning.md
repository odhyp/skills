---
id: T-0023
title: implement direct-mode must-fix warns before /clear
type: feat
breaking: false
scope: implement
status: resolved
spec: S-0003
depends_on: [T-0022]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
In ticket mode, a MUST-FIX review is saved under the ticket's `## Notes` as `Must-fix (review):`, so it survives a `/clear`. In direct mode there is no ticket, so `implement` step 4 only reports the findings in chat ("commit nothing, report the findings, and stop"). A `/clear` then loses them. This ticket depends on T-0022 only because both edit the same file.

## Decisions that apply
- On a MUST-FIX verdict in direct mode, `implement` still commits nothing and reports the findings.
- It also says the findings exist only in this session, and offers `/to-tickets N` (N = the finding numbers) as a way to keep them before `/clear`. Fixing them now with `/implement N` stays an option.
- Direct mode still creates no ticket unless the user asks. That rule in step 2 stays unchanged.

## Files
- plugins/odhyp/skills/implement/SKILL.md (change: step 4, direct-mode MUST-FIX)

## Acceptance criteria
- [x] The direct-mode MUST-FIX branch says the findings exist only in this session and offers `/to-tickets N` before `/clear`.
- [x] Direct mode still commits nothing on MUST-FIX and creates no ticket by itself.
- [x] Ticket-mode MUST-FIX handling is unchanged.
- [x] `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- Refusal messages (T-0022).
- Writing direct-mode findings to any file.
- The README and the diagrams.

## Questions

## Notes
- Step 4's direct-mode MUST-FIX sentence now warns the findings live only in this session (lost on `/clear`) and offers `/to-tickets N` or `/implement N`. Only that sentence changed; step 2's no-ticket rule and the ticket-mode branch are untouched. Skill text, so no red/green.
