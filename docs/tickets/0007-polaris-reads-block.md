---
id: T-0007
title: "Polaris: read paths from the odhyp block, keep its own config in app data, accept source session-review"
type: chore
breaking: false
scope: polaris
status: wontfix
spec: S-0001
depends_on: [T-0001, T-0005]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
After T-0001, odhyp no longer writes `polaris.json`; project paths live in the odhyp block in CLAUDE.md. Polaris (a separate repo, v2 still being designed) has to find projects and their folders on its own. This is work in the Polaris repo, so a person picks it up.

## Decisions that apply
- Polaris writes its own config when a project is added, stored in its app data (e.g. `%APPDATA%/polaris/`), keyed by repo path, not in the repo.
- Project with an odhyp block: read the paths from the block (`- Specs: ...`, `- Tickets: ...`, `- Diagrams: ...`, `- Releases: ...` lines) every time; keep no copy.
- Project without one: use the folders the user picks in Polaris (default `docs/specs` etc. if they exist).
- Accept `source: session-review` (added in T-0005).

## Files
- (Polaris repo)

## Acceptance criteria
- [x] Polaris lists an odhyp project's tickets, specs and diagrams with no `polaris.json` in the repo.
- [x] Polaris works for a project without an odhyp block once the user picks its folders.
- [ ] A ticket with `source: session-review` displays without error.

## Out of scope
- Any change in this repo.

## Questions
1. Context says "a person picks it up", and Out of scope says no change in this repo, yet status was `ready-for-agent`. Should this be `ready-for-human`, or should an agent build it in `D:/Project/polaris`?
2. If an agent builds it: Polaris (at b09d3ad) has no ticket display yet. Its own tracker has it as `.scratch/polaris-v2/issues/05-tickets-board.md` and 07. The third criterion ("`source: session-review` displays without error") can't be met or tested until those land. Should this ticket wait for them, or move into Polaris's tracker as a note on 05/07?
3. Polaris's `bin/polaris.js` reads `--diagrams/--specs/--tickets` flags with `docs/...` defaults and has no app-data config. That contradicts "keep no copy, config in `%APPDATA%/polaris/`" and the v2 spec ("Polaris has no state of its own"). Which one wins? The first two criteria are ticked, but nothing in Polaris reads the odhyp block today. Were they ticked on purpose?

## Notes
- 2026-11-22: Closed as `wontfix` for now (user decision). This is human work in the Polaris repo, and Polaris v2 isn't in development yet. Reopen as `ready-for-human` when Polaris v2 ticket display (its issues 05 and 07) starts, and settle the questions above then.
