---
id: T-0029
title: Glossary format and config line
type: feat
breaking: false
scope: glossary
status: ready-for-agent
spec: S-0005
depends_on: []
source: to-tickets
parent: none
diagrams: [data-flow]
released_in:
---

## Context
Agents start every session fresh and drift into synonyms a project rejected, so specs and tickets come out inconsistent. S-0005 gives the plugin a glossary that the term-writing skills read. This ticket lays the ground: the format, the config line in the odhyp block, `setup` filling it, and this repo becoming the first user. No skill reads or writes the glossary yet (T-0030, T-0031).

## Decisions that apply
- `plugins/odhyp/templates/claude-md-block.md` gains the line `- Glossary: \`{{glossary}}\``, placed after `- Decisions: \`{{decisions}}\``.
- The line is optional: projects set up before this change have no such line and must keep working without re-running `setup` (readers skip silently; that is T-0030's job, but nothing here may make the line required).
- `setup` fills `{{glossary}}` **without asking** a new question. Order: the existing block's `Glossary:` value; else a glossary file found in step 1 (`GLOSSARY.md`, `CONTEXT.md`, `docs/glossary.md`, first match); else `GLOSSARY.md`. Reason: `setup` asks one base path for folders, and the glossary is a single file outside it.
- `setup` creates **no** glossary file (an empty glossary is noise). Its step 4 report shows the glossary path so the user can change it in the block.
- New `plugins/odhyp/templates/GLOSSARY-FORMAT.md` is the single source for the format, written in the style of `TICKET-FORMAT.md`/`SPEC-FORMAT.md` (but no frontmatter, since a glossary has none):
  - `# Glossary` H1, then `###` groups; each entry is `**Term**:` on one line, a one-line definition on the next, then `_Avoid_: word, word` when there are rejected synonyms. Match this repo's `GLOSSARY.md` layout.
  - Project-specific terms only, nothing the model already knows.
  - A removed term is deleted, not marked stale: a stale entry misleads agents worse than none.
- This repo's `CLAUDE.md` odhyp block gains `- Glossary: \`GLOSSARY.md\``.
- Add a **Glossary** entry to this repo's `GLOSSARY.md` (under `### Project`), in the format above.

## Files
- plugins/odhyp/templates/GLOSSARY-FORMAT.md (new)
- plugins/odhyp/templates/claude-md-block.md (change)
- plugins/odhyp/skills/setup/SKILL.md (change: step 1 notes a glossary file; step 3 `CLAUDE.md` row fills `{{glossary}}`; step 4 report shows the path)
- CLAUDE.md (change: this repo's block)
- GLOSSARY.md (change)
- docs/diagrams/data-flow.mmd (change: already edited in the working tree during shape; review it against this ticket and commit it with this work)

## Acceptance criteria
- [ ] `GLOSSARY-FORMAT.md` states the entry format, the project-specific-only rule and the delete-don't-stale rule, with a short example.
- [ ] The block template has the `Glossary:` line, and `setup` step 3 says how `{{glossary}}` is filled, in the order above.
- [ ] `setup` asks no new question and creates no glossary file; its report lists the glossary path.
- [ ] This repo's `CLAUDE.md` block has `- Glossary: \`GLOSSARY.md\``, and `GLOSSARY.md` defines **Glossary**.
- [ ] `data-flow.mmd` shows `GLOSSARY-FORMAT.md` and `GLOSSARY.md` with the read/write edges of S-0005, and is committed.
- [ ] `claude plugin validate .` and `claude plugin validate plugins/odhyp` pass.

## Out of scope
- Any skill reading the glossary (T-0030) or writing it (T-0031).
- `code-review` checking glossary use; a `/to-glossary` skill.
- Version bump and CHANGELOG (done at release).

## Questions

## Notes
