---
id: S-0005
title: Glossary for agents
status: accepted
tickets: [T-0029, T-0030, T-0031, T-0032]
---

## Problem
Agents start every session fresh, so they drift into synonyms the project rejected ("task" for Ticket) and specs and tickets come out inconsistent. The plugin has no glossary concept: no skill reads one, and this repo's `GLOSSARY.md` is dev-only and edited by hand.

## Goals / Non-goals
- Goal: the skills that coin and write terms (`shape`, `to-spec`, `to-tickets`) read the project's glossary and use its terms and `_Avoid_` lists.
- Goal: glossary changes travel with the work and land in the same commit as the code.
- Goal: projects set up before this change keep working without re-running `setup`.
- Non-goal: a separate `/to-glossary` skill. Terms are coined while shaping, so recording them there is cheaper than one more manual step.
- Non-goal: `code-review` checking glossary use or flagging `_Avoid_` words. It would be noisy, and the glossary edit is already in the diff like any other file.
- Non-goal: `implement` and `code-review` reading the glossary. They work from tickets that already use the terms.
- Non-goal: `setup` creating an empty glossary file. An empty glossary is noise.

## Design

**Config.** `templates/claude-md-block.md` gains `- Glossary: \`{{glossary}}\``. Every reader treats the line as optional: when the line or the file is missing, it skips the glossary silently.

**Setup.** `setup` fills `{{glossary}}` without asking. It uses the existing block's `Glossary:` line, otherwise a glossary file found in step 1 (`GLOSSARY.md`, `CONTEXT.md`, `docs/glossary.md`), otherwise `GLOSSARY.md`. It creates no file, and the report shows the path so the user can edit it in the block. There's no new question because `setup` asks for one base path for its folders, and the glossary is a file outside it.

**Format.** A new `templates/GLOSSARY-FORMAT.md` is the single source for the format, the same way `TICKET-FORMAT.md` is for tickets:
- `###` groups, each entry `**Term**:` with a one-line definition, then an `_Avoid_:` line;
- project-specific terms only, nothing the model already knows;
- a removed term is deleted, not marked stale, because a stale entry misleads agents worse than none.

**Readers.** `shape`, `to-spec` and `to-tickets` read the `Glossary:` path and the format, then the file when it exists, and use its terms in their questions, specs and tickets. `shape` reads the odhyp block for the first time, and only for this line. A missing block does not stop `shape`.

**Writers.**
- The `shape` summary gets a `## Glossary` section listing new, changed and removed terms, only when there are some, for both features and small changes.
- `to-spec` copies that list into the spec's `## Design`.
- `to-tickets` carries the entries a ticket needs into that ticket.
- `implement` reads the format and applies the entries from its brief (ticket, spec or the shape summary) to the glossary in the same commit as the code. It creates the file with a `# Glossary` H1 when the first term arrives.

**This repo.** The block in `CLAUDE.md` gains `- Glossary: \`GLOSSARY.md\``, so this repo is the first user. `docs/diagrams/data-flow.mmd` is already updated with the new template and file and their read and write edges.

**Testing.** No skill prose has automated tests and `commit-msg` is untouched. The checks are `claude plugin validate .` and `claude plugin validate plugins/odhyp`, plus one manual pass on a scratch repo:
- `setup` writes the line, and a re-run keeps it;
- a shaped change that coins a term produces a `## Glossary` list;
- `implement` commits the term together with the code.

## Decisions
<!-- added during implementation: date · ticket ID · what changed and why -->
