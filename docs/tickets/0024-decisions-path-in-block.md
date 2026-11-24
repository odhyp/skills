---
id: T-0024
title: Decisions path in the CLAUDE.md block
type: feat
breaking: false
scope: setup
status: ready-for-agent
spec: S-0004
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
S-0004 adds a `to-adr` skill that writes ADRs into a decisions folder. Per ADR-0006, every
odhyp path lives in the CLAUDE.md odhyp block, and the block has no decisions path yet.
This ticket adds the line to the block template, makes `setup` fill it, and adds it to
this repo's own block. The `to-adr` skill itself is T-0025.

## Decisions that apply
- The block line is `- Decisions: \`{{decisions}}\``, placed after `- Releases:`.
- `setup` fills `{{decisions}}` the way it fills the other folders: from the existing block
  when one has the line, else `<base path>/adr` (default `docs/adr`).
- `setup` creates no folder for it; a skill creates its folder when it first writes there.
- The folder must be tracked by git (`to-adr` commits into it), so `setup`'s
  `git check-ignore -v <folder>/x.md` check covers it too.
- `setup` deletes `.gitkeep` in the decisions folder too, the same as the other four.
- Projects set up earlier get the line when they re-run `setup`, which is safe to re-run.
- This repo's block value is `docs/adr`, where its ADRs already live.

## Files
- plugins/odhyp/templates/claude-md-block.md (change)
- plugins/odhyp/skills/setup/SKILL.md (change)
- CLAUDE.md (change: odhyp block only)

## Acceptance criteria
- [ ] `claude-md-block.md` has `- Decisions: \`{{decisions}}\`` after the Releases line.
- [ ] `setup/SKILL.md` names `<decisions>` wherever it lists the four odhyp folders (base path, git check-ignore, the folders row, the CLAUDE.md fill row), and says how `{{decisions}}` is filled.
- [ ] This repo's CLAUDE.md block has `- Decisions: \`docs/adr\``; nothing outside the block changes.
- [ ] `claude plugin validate . && claude plugin validate plugins/odhyp` passes; `sh tests/commit-msg.test.sh` passes.

## Out of scope
- The `to-adr` skill and template (T-0025).
- The "This repo" section of CLAUDE.md, which already mentions `docs/adr/`.
- Changing the `Next ID` line in the block; ADRs are never archived, so it already holds.

## Questions

## Notes
