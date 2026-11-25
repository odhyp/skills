---
id: T-0032
title: Manual glossary run-through on a scratch repo
type: test
breaking: false
scope: glossary
status: resolved
spec: S-0005
depends_on: [T-0031]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
The skills are prose with no automated tests, so S-0005 is checked by one manual pass with the plugin built from T-0029 to T-0031 loaded in a throwaway git repo.

## Decisions that apply
- The glossary is optional; a project without the `Glossary:` line must keep working.
- `setup` fills the path without asking and creates no file.
- Glossary changes go shape summary → spec → ticket → `implement`, landing in the same commit as the code.

## Files
- none in this repo (scratch repo only)

## Acceptance criteria
- [x] `/odhyp:setup` on a scratch repo writes `- Glossary: \`GLOSSARY.md\`` into the block, creates no glossary file, and shows the path in its report.
- [x] A re-run of `setup` keeps the line unchanged; with an existing `CONTEXT.md`, a fresh setup picks it.
- [x] Removing the `Glossary:` line: `shape`, `to-spec`, `to-tickets` and `implement` run without warnings.
- [x] `/odhyp:shape` on a small change that coins a term prints `## Glossary` in its summary; a change coining none prints no such section.
- [x] `/odhyp:implement this` creates `GLOSSARY.md` with `# Glossary` and the term, in the same commit as the code.

## Out of scope
- Fixing anything found: file follow-up tickets.

## Questions

## Notes
- 2026-11-25: Run through by hand on the Polaris repo; all acceptance criteria passed, nothing to follow up.
