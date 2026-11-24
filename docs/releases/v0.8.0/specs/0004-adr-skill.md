---
id: S-0004
title: ADR skill
status: done
tickets: [T-0024, T-0025, T-0026, T-0027, T-0028]
---

## Problem

The odhyp workflow keeps decisions only in specs, and `release` archives specs with each version. No skill writes ADRs, so plugin users have none. This repo writes its ADRs by hand, and their format has drifted. The supersession line is placed in three different ways, references are written as both `ADR-0007` and `0006`, partial overrides aren't marked on the old ADR, and sections are ad hoc. Writing ADRs during `shape` would lock in decisions that aren't settled yet.

## Goals / Non-goals

- Goal: a `to-adr` skill that records a settled decision as an ADR file in the project's decisions folder.
- Goal: one ADR format, held in a plugin template, that the existing ADRs also follow.
- Goal: an old ADR always points to the newer one that overrides it.
- Non-goal: frontmatter or status fields on ADRs (`proposed`, `superseded`). A spec already holds unsettled decisions; a status that has to be flipped goes stale.
- Non-goal: changing any existing ADR's wording beyond its link line.
- Non-goal: `to-spec`, `release`, or shape's feature and small-change exits writing or offering ADRs.

## Design

### When an ADR is written

`to-adr` records a decision only once it is settled: either `implement` shipped it, or `shape` agreed on it with nothing to build. A half-shaped feature decision stays in its spec, which is allowed to change. This matches how ADRs 0007 and 0008 were written, which was after or alongside the change they record.

There are three entry points. All three invoke the same user-invocable skill.

- **`implement`** offers it, in one line, after a commit, when the ticket, its spec or the direct brief settled a decision worth keeping that no ADR covers. It only offers and never writes; whether a decision deserves an ADR is the user's call. (A spec's `## Decisions` holds only changes made during implementation, and the agreed design lives in `## Design`. So the check reads both, not `## Decisions` alone.)
- **`shape`'s "nothing to build" exit** offers it under `## Next step` when the reason for not building is worth keeping. "We decided not to do X, because Y" is settled as soon as it's agreed, and the ADR stops the idea from being re-shaped later. A trivial "already exists" answer is a plain stop.
- **The user** runs `/odhyp:to-adr` for a decision that shipped any other way, as ADR 0007 did.

### The skill

1. Read the odhyp block for `Decisions:`. If there's no block, stop and say to run `/odhyp:setup`. If the block has no `Decisions:` line, say to re-run `/odhyp:setup`.
2. Take the decision from the conversation, plus the spec and ticket when `implement` made the offer.
3. Next ID: one above the highest `NNNN` in the decisions folder, starting at 0001. ADRs are never archived, so only that one folder is scanned. File: `NNNN-<kebab-title>.md`.
4. If the decision overrides an existing ADR, in full or in part, name that ADR. The user confirms the link.
5. Show the draft and get explicit approval before writing, the same way `to-spec` does.
6. Write the new ADR. If it links to an old one, add the matching back-link line to the old ADR, right after its H1. That line is the only change `to-adr` makes to an existing ADR.
7. Stage only the files it wrote. Commit them as `docs(adr): add ADR-NNNN <slug>` with `-- <files>`, with no `Refs:` footer. It never amends the `implement` commit, which `code-review` already checked. It never pushes.

### Format (`plugins/odhyp/templates/adr.md`)

No frontmatter. Every ADR is written after its decision ships, so a status field would always read `accepted`.

```
# <the decision, as a statement>

Supersedes ADR-NNNN.        ← optional; or "Amends ADR-NNNN." One line, right after the H1.

<One paragraph: the decision, then why. No "Reasons:" label.>

## Considered options       ← optional: when a rejected option is worth keeping
## Consequences             ← optional: when the decision binds later work
```

- Links go both ways. The old ADR gets `Superseded by ADR-NNNN.` or `Amended by ADR-NNNN.` on the same line position.
- References are always written `ADR-NNNN`.
- Six of the eight existing ADRs are a single paragraph, and the two section names are the ones ADRs 0002 and 0003 already use.

### Config and setup

- `plugins/odhyp/templates/claude-md-block.md` gains `Decisions: docs/adr`, following ADR 0006: config lives in the block.
- `setup` writes it. Projects set up earlier get the line when they re-run `setup`, which is safe to re-run.
- This repo's own CLAUDE.md block gets the line too.

### Existing ADRs (one-off, this repo only)

Only the link lines change. Agents copy the files they read, so the existing ADRs must match the template.

- 0001: `Superseded by ADR-0007.` becomes `Amended by ADR-0007.`, since 0007 keeps half of 0001.
- 0003, 0004: add `Amended by ADR-0008.`
- 0005: move `Superseded by ADR-0006.` below its H1, and write it with `ADR-`.
- 0006: put `Supersedes ADR-0005.` on its own line after the H1.
- 0007: add `Amends ADR-0001.`
- 0008: add `Amends ADR-0003, ADR-0004.`

ADR 0008 says 0003 and 0004 "stay as written for the record". A pointer line keeps their wording.

### Diagrams

Already updated in this session and not yet committed:

- `workflow.mmd` adds the `/to-adr` node, with offers from "nothing to build" and from commit.
- `data-flow.mmd` adds the `to-adr` skill, the `adr.md` template and the `adr/` folder, plus the read and write edges.

### Testing

- `claude plugin validate . && claude plugin validate plugins/odhyp`.
- One manual run per entry point: `implement` offer, `shape` "nothing to build" offer, direct `/odhyp:to-adr`. Each run checks the ID, the format, the back-link and that the commit holds only the ADR files.
- Any shell command in the skill gets run in both sh and PowerShell 5.1.

## Decisions

- 2026-11-24 · Skill named `to-adr`, not `adr`, matching `to-spec`/`to-tickets`: it turns an agreed decision into a committed document. The template, folder, `docs(adr)` commit and `scope: adr` keep `adr`, since they name the document.
- 2026-11-24 · T-0025 · Links can name several old ADRs, not just one. Forward and back-links are one line per kind (supersedes or amends) right after the H1, with IDs comma-separated; a new back-link joins an existing line of its kind (`Superseded by ADR-0007, ADR-0009.`), so an ADR overridden twice keeps one line per kind. Before writing, `to-adr` stops if a linked old ADR has uncommitted changes, since `git commit -- <files>` would sweep them into the `docs(adr)` commit. Steps 4 and 6 and "Links go both ways" above are read with this.
