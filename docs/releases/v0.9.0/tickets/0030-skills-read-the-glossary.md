---
id: T-0030
title: Term-writing skills read the glossary
type: feat
breaking: false
scope: glossary
status: resolved
spec: S-0005
depends_on: [T-0029]
source: to-tickets
parent: none
diagrams: []
released_in: v0.9.0
---

## Context
Agents drift into synonyms a project rejected because nothing tells a fresh session the project's vocabulary. T-0029 added `templates/GLOSSARY-FORMAT.md` and an optional `- Glossary: \`<path>\`` line in the odhyp block of `CLAUDE.md`. This ticket makes the three skills that coin and write terms read it and use its terms and `_Avoid_` lists in their questions, specs and tickets.

## Decisions that apply
- Readers are only `shape`, `to-spec` and `to-tickets`: they coin and write terms. `implement` and `code-review` do **not** read the glossary; they work from tickets that already use the terms.
- Each reader takes the path from the `Glossary:` line, reads `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md`, then the glossary file when it exists, and uses its terms (never an `_Avoid_` word) in what it writes.
- Optional: when the `Glossary:` line or the file is missing, skip the glossary silently. No warning, no stop, no suggestion to re-run `setup`.
- `shape` reads the odhyp block for the first time, and only for the `Glossary:` line. A missing block does **not** stop `shape` (it does not stop today, and the glossary must not change that).
- `to-spec` and `to-tickets` already read the block and already stop without one; keep that, and add the glossary read next to their existing block read.

## Files
- plugins/odhyp/skills/shape/SKILL.md (change)
- plugins/odhyp/skills/to-spec/SKILL.md (change)
- plugins/odhyp/skills/to-tickets/SKILL.md (change)

## Acceptance criteria
- [x] Each of the three skills says to read the `Glossary:` path, the format and the file, and to use its terms and avoid its `_Avoid_` words.
- [x] Each says to skip silently when the line or file is missing.
- [x] `shape` reads the block only for that line and still runs with no odhyp block.
- [x] `implement` and `code-review` are unchanged.
- [x] `claude plugin validate .` and `claude plugin validate plugins/odhyp` pass.

## Out of scope
- Writing glossary changes (`## Glossary` in the shape summary, `implement` writing the file): T-0031.
- `code-review` flagging `_Avoid_` words.

## Questions

## Notes
- Added a `**Glossary:**` paragraph to shape, to-spec and to-tickets, after their existing block/format read. shape reads the block only for that line and keeps running without it. implement and code-review untouched.
