---
id: T-0014
title: Keep .gitkeep only in empty folders
type: fix
breaking: false
scope: release
status: ready-for-agent
spec: S-0002
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
`.gitkeep` files stay after their folder gets real files: `release` moved `v0.2.0/` into `docs/releases/` and left `docs/releases/.gitkeep` behind. No skill or rule says when to remove or restore one.

## Decisions that apply
- One general rule in the Project config, so every agent reads it for every file it creates or moves, not only docs. Add a line to `plugins/odhyp/templates/claude-md-block.md`, in substance: *`.gitkeep` only in an otherwise-empty folder: remove it when you add a file there, add it back when you empty a folder that must stay.* Re-running `setup` installs it in existing projects.
- Update this repo's own odhyp block in `CLAUDE.md` (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`) to match the template, by hand.
- `release` step 6 (Archive), the only skill that empties folders: remove `<releases>/.gitkeep` if present, and leave a `.gitkeep` in the tickets and specs folders when the archive empties them.
- Delete `docs/releases/.gitkeep` in this repo.

## Files
- plugins/odhyp/templates/claude-md-block.md (change)
- CLAUDE.md (change)
- plugins/odhyp/skills/release/SKILL.md (change)
- docs/releases/.gitkeep (delete)

## Acceptance criteria
- [ ] `claude-md-block.md` has the `.gitkeep` rule line.
- [ ] This repo's `CLAUDE.md` odhyp block has the same line.
- [ ] `release/SKILL.md` step 6 removes `<releases>/.gitkeep` and keeps one in emptied tickets and specs folders.
- [ ] `docs/releases/.gitkeep` is gone from the repo.
- [ ] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- `to-spec` removing the specs `.gitkeep` (T-0013).
- Changing `setup`'s folder creation (it already adds `.gitkeep` only to empty folders).

## Questions

## Notes
