---
id: T-0031
title: Glossary changes travel with the work
type: feat
breaking: false
scope: glossary
status: resolved
spec: S-0005
depends_on: [T-0030]
source: to-tickets
parent: none
diagrams: []
released_in: v0.9.0
---

## Context
After T-0030, `shape`, `to-spec` and `to-tickets` read the project glossary (path from the optional `Glossary:` line in the odhyp block; format in `templates/GLOSSARY-FORMAT.md`). Nothing yet writes it. Terms are coined while shaping, so this ticket carries glossary changes along the existing pipeline: shape summary, then spec, then ticket, then `implement` writing the file in the same commit as the code. No separate `/to-glossary` skill: one more manual step would be forgotten.

## Decisions that apply
- `shape`'s summary gets a `## Glossary` section listing new, changed and removed terms, **only when there are some**, for both features and small changes. Add it to the summary shape in `## Output` (feature and small-change variants), placed before `## Next step`. Entries follow `GLOSSARY-FORMAT.md`; a removed term is listed as removed.
- `to-spec` copies that list into the spec's `## Design`.
- `to-tickets` carries the entries each ticket needs into that ticket (under `## Decisions that apply`), so a fresh `implement` gets them from the ticket alone.
- `implement` reads `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md` and applies the glossary entries from its brief (ticket, spec, or the shape summary in direct mode) to the glossary file **in the same commit as the code**. Removed terms are deleted, not marked stale.
- When the file does not exist yet, `implement` creates it with a `# Glossary` H1 when the first term arrives. When the block has no `Glossary:` line, `implement` writes nothing to a glossary and says nothing.
- `implement` does not otherwise read the glossary (T-0030 decision).

## Files
- plugins/odhyp/skills/shape/SKILL.md (change)
- plugins/odhyp/skills/to-spec/SKILL.md (change)
- plugins/odhyp/skills/to-tickets/SKILL.md (change)
- plugins/odhyp/skills/implement/SKILL.md (change)

## Acceptance criteria
- [x] `shape`'s Output section shows `## Glossary` in the summary, marked as present only when terms changed.
- [x] `to-spec` says to copy the list into `## Design`; `to-tickets` says to carry the needed entries into each ticket.
- [x] `implement` says to apply the brief's glossary entries in the same commit as the code, create the file with `# Glossary` when missing, and do nothing when the block has no `Glossary:` line.
- [x] `claude plugin validate .` and `claude plugin validate plugins/odhyp` pass.

## Out of scope
- `code-review` checking that listed terms reached the glossary.
- Changing `TICKET-FORMAT.md` or `SPEC-FORMAT.md` sections: the entries go into existing sections.

## Questions

## Notes
- shape: `## Glossary` added to the summary template before `## Next step`, with a rule that it appears for both sizes only when terms change; removed terms read `**Term**: removed`.
- to-spec copies the list into `## Design` under a `Glossary:` line; to-tickets copies each needed entry into one ticket's `## Decisions that apply` under a `Glossary:` line.
- implement step 3 applies the entries (add, rewrite, delete with mentions), creates the file with `# Glossary` when missing, is silent without a `Glossary:` line; step 5 stages glossary files with the code.
