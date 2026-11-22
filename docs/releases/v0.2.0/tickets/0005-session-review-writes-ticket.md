---
id: T-0005
title: session-review writes its ticket in the odhyp repo, with source session-review
type: feat
breaking: false
scope: session-review
status: resolved
spec: S-0001
depends_on: [T-0003]
source: to-tickets
parent: none
diagrams: []
released_in: v0.2.0
---

## Context
`session-review` always prints its skill-improvement ticket with `id: T-XXXX` for the user to number and copy, even when it runs inside the odhyp skills repo, where it could write the ticket itself. It also marks that ticket `source: human`, though a skill wrote it.

## Decisions that apply
- Detection: the odhyp repo is the one where `plugins/odhyp/.claude-plugin/plugin.json` exists at the repo root.
- There, it shows the proposed ticket like a CLAUDE.md diff and, once the user approves, writes it into the tickets folder named in the odhyp CLAUDE.md block, with the next `T-` ID (see the ticket format) and `status: ready-for-agent`. Nothing unapproved is written.
- Elsewhere, unchanged: print the ticket with `id: T-XXXX`.
- `source: session-review` in both cases. Add `session-review` to the `source` enum in `TICKET-FORMAT.md`. Reason: every other value names the skill that wrote the ticket; `human` means a person wrote it.
- The format may change freely now (Polaris v2 is unfinished); T-0007 covers Polaris accepting the new value.
- "Write no other files" still holds outside the approved CLAUDE.md edits and this one ticket.

## Files
- plugins/odhyp/skills/session-review/SKILL.md (change)
- plugins/odhyp/templates/TICKET-FORMAT.md (change: `source` enum)

## Acceptance criteria
- [x] `session-review` writes the approved ticket when `plugins/odhyp/.claude-plugin/plugin.json` exists, and prints it otherwise.
- [x] The written ticket uses the next `T-` ID and `status: ready-for-agent`.
- [x] Both paths use `source: session-review`, and the enum in `TICKET-FORMAT.md` lists it.
- [x] `claude plugin validate plugins/odhyp` passes.

## Out of scope
- Writing tickets into any other repo.
- Changing how friction is found or how CLAUDE.md edits are proposed.

## Questions

## Notes
- session-review step 2 now branches on `plugins/odhyp/.claude-plugin/plugin.json`: in the odhyp repo it shows the ticket as a diff and writes it on approval with the next `T-` ID; elsewhere it prints it with `id: T-XXXX`. Both use `source: session-review` and `status: ready-for-agent`.
- TICKET-FORMAT.md: `session-review` added to the `source` enum and to the "Set by" list for `ready-for-agent`.
- `templates/ticket.md` keeps `source: human`: it is the blank template a person fills in.
- Prose-only change; red/green was a grep for the new text, plus test and lint clean.
