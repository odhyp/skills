---
id: T-0014
title: Drop .gitkeep and state the next-ID rule
type: fix
breaking: false
scope: setup
status: resolved
spec: S-0002
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in: v0.3.0
---

## Context
`setup` creates the odhyp folders with a `.gitkeep` "while empty", and `to-spec` removes the specs one on its first spec. Keeping `.gitkeep` only in empty folders means skills add and remove the same file, which is churn and an easy step to get wrong. This repo has `docs/releases/.gitkeep` sitting next to `v0.2.0/`. No skill needs a folder to exist beforehand: writing a file creates its folder.

Separately, the config block never says how the next `T-`/`S-` ID is chosen. Once `release` archives a folder's files, or the folder doesn't exist, an agent can restart at 0001 and clash with an archived ID.

## Decisions that apply
- No `.gitkeep` anywhere. A skill creates its folder when it first writes a file there.
- `setup` step 3: the `<specs>`, `<tickets>`, `<diagrams>`, `<releases>` row creates no folders and no `.gitkeep`. The paths are only written into the config block. On re-run, `setup` deletes any `.gitkeep` in those four folders (`git rm` if tracked) and lists that in its report.
- `setup`'s opening promise "never touches the project's tickets, specs or diagrams" gains: "except deleting `.gitkeep` files there".
- `setup`'s frontmatter `description` drops "docs folders"; README's `setup` row drops "and the empty docs folders"; GLOSSARY's setup line drops "and folders".
- `to-spec` step 4: remove the `.gitkeep` step and `[<.gitkeep>]` from the commit command (`git commit -m "docs(spec): add S-NNNN <slug>" -- <spec file>`), and renumber the list.
- `release` is unchanged. Creating `<releases>/vX.Y.Z/` is part of its move.
- Add one line to the config block, in substance: *Next ID: one above the highest `NNNN` in the folder and in `<releases>/*/`; start at 0001 when there is none.* Put it in `plugins/odhyp/templates/claude-md-block.md` and, by hand, in this repo's `CLAUDE.md` odhyp block (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`).
- Delete `docs/releases/.gitkeep` and `docs/diagrams/.gitkeep` in this repo.
- S-0002: replace the `.gitkeep` goal (line 39), the `### .gitkeep rule` section (lines 128–132) and the check (line 148) with the decisions above, and add a `## Decisions` entry: `2026-11-22 · T-0014 · Dropped .gitkeep entirely instead of keeping it only in empty folders, to stop skills adding and removing it; added the next-ID rule to the config block.`

## Files
- plugins/odhyp/skills/setup/SKILL.md (change)
- plugins/odhyp/skills/to-spec/SKILL.md (change)
- plugins/odhyp/templates/claude-md-block.md (change)
- CLAUDE.md (change)
- README.md (change)
- GLOSSARY.md (change)
- docs/specs/0002-findings-without-tickets.md (change)
- docs/releases/.gitkeep (delete)
- docs/diagrams/.gitkeep (delete)

## Acceptance criteria
- [x] `grep -rn gitkeep plugins/ README.md GLOSSARY.md CLAUDE.md` finds only `setup`'s cleanup instruction.
- [x] `setup` creates no folders and deletes `.gitkeep` from the four odhyp folders on re-run.
- [x] `to-spec` step 4 commits only the spec file and has no `.gitkeep` step.
- [x] `claude-md-block.md` and this repo's `CLAUDE.md` odhyp block both have the next-ID line.
- [x] `git ls-files | grep gitkeep` is empty.
- [x] S-0002 matches the decisions above and has the `## Decisions` entry.
- [x] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- Any change to `release`.
- A script or helper that computes IDs.
- `TICKET-FORMAT.md`: it already states the `T-` rule.

## Questions

## Notes
- Removed `.gitkeep` from `setup` (step 3 now creates no folders and deletes `.gitkeep` from the four odhyp folders; the report lists deletions) and `to-spec` step 4 (now three items, commits only the spec file). Deleted `docs/releases/.gitkeep` and `docs/diagrams/.gitkeep`.
- Added the next-ID line to `templates/claude-md-block.md` and this repo's `CLAUDE.md` block (with the concrete `docs/releases/*/` path).
- S-0002: also reworded Design `to-spec` item 3, which referred to the removed `.gitkeep` rule. The Problem bullet about `.gitkeep` was left as history.
- `grep gitkeep` in plugins/ now hits only `setup`, in three places, all about the cleanup: the opening promise, step 3, and the report.
