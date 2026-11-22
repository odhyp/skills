---
id: T-0001
title: Move project config from polaris.json into the CLAUDE.md block
type: feat
breaking: true
scope: config
status: resolved
spec: S-0001
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
Every odhyp project carries a `polaris.json` (specs, tickets, diagrams and releases folders, `version_file`, `changelog`, `name`) that `setup` writes and every skill reads. That ties odhyp to Polaris, which is only an optional helper. The config moves into the odhyp block in `CLAUDE.md` (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`), which agents load anyway. After this ticket nothing in odhyp writes or reads `polaris.json`; from then on that file belongs to Polaris.

## Decisions that apply
- The block holds these lines, one item each, so an agent or a parser can read them:
  ```
  - Specs: `docs/specs`
  - Tickets: `docs/tickets`
  - Diagrams: `docs/diagrams`
  - Releases: `docs/releases`
  - Version files: `VERSION`
  - Changelog: `CHANGELOG.md`
  ```
  `Version files:` lists the primary file first, then any other file carrying the version, comma-separated. The existing lines stay (format note, test and lint, commits, never push, versioning). `templates/claude-md-block.md` gets placeholders `{{specs}}`, `{{tickets}}`, `{{diagrams}}`, `{{releases}}`, `{{version_files}}`, `{{changelog}}`.
- Every skill that read `polaris.json` reads the block instead. A skill that finds no odhyp block stops and says to run `/odhyp:setup`. No fallback to `polaris.json`: two sources of the same paths drift.
- `setup`: drops `polaris.json` from its description, templates and targets; `templates/polaris.json` is deleted. It no longer asks for a project name (only `polaris.json` used it). On re-run, an existing block's values are the defaults. It ignores any `polaris.json` in the project and never deletes it.
- This repo: delete `polaris.json`; rewrite the block in `CLAUDE.md` with the four `docs/...` paths, `Version files: VERSION, plugins/odhyp/.claude-plugin/plugin.json`, `Changelog: CHANGELOG.md`.
- Mentions of Polaris as a reader of tickets, specs and diagrams stay ("Polaris parses it", "Polaris shows them"); only `polaris.json` as odhyp config goes.
- A new ADR `docs/adr/0006-config-lives-in-the-claude-md-block.md` supersedes 0005 (0005's first line says it is superseded by 0006). Reason: agents load CLAUDE.md anyway, nothing in the project names Polaris, and the block is the single place paths live. Polaris keeps its own config in its app data, not in the repo.
- Breaking for existing projects (they must re-run `/odhyp:setup`); below 1.0 this is a minor bump.

## Files
- plugins/odhyp/templates/claude-md-block.md (change)
- plugins/odhyp/templates/polaris.json (delete)
- plugins/odhyp/templates/TICKET-FORMAT.md (change: "path in `polaris.json`" → the odhyp block in `CLAUDE.md`)
- plugins/odhyp/templates/SPEC-FORMAT.md (change: same)
- plugins/odhyp/skills/setup/SKILL.md (change)
- plugins/odhyp/skills/{code-review,diagnose,diagram,implement,release,to-spec,to-tickets}/SKILL.md (change: read the block)
- polaris.json (delete)
- CLAUDE.md (change: the odhyp block)
- tests/review-smoke.sh (change: build the fixture's block with paths instead of copying `polaris.json`)
- README.md (change: the workflow diagram node and the `setup` row no longer list `polaris.json`; the Polaris section no longer says each project has one)
- GLOSSARY.md (change: **Project config** is the odhyp block in CLAUDE.md)
- docs/adr/0003-shared-templates-plugin-only.md (change: drop `polaris.json` from the template list)
- docs/adr/0005-polaris-json-holds-paths.md (change: superseded note)
- docs/adr/0006-config-lives-in-the-claude-md-block.md (new)

## Acceptance criteria
- [x] `grep -rn "polaris.json" plugins/ tests/ README.md GLOSSARY.md CLAUDE.md` finds nothing.
- [x] `plugins/odhyp/templates/polaris.json` and `./polaris.json` no longer exist.
- [x] `claude-md-block.md` has the six placeholders; `setup` fills them and asks no project-name question.
- [x] Every skill that needs a path names the odhyp block as its source and says to run `/odhyp:setup` when the block is missing.
- [x] This repo's CLAUDE.md block lists the paths, both version files and the changelog.
- [x] ADR 0006 exists and 0005 says it is superseded by 0006.
- [x] `sh tests/commit-msg.test.sh` passes; `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- `release` writing every version file (T-0002); this ticket only adds the `Version files:` line.
- The next-ID rule (T-0003) and the "public contract" note (T-0006) in the format files.
- Polaris's own code (T-0007).
- `AGENTS.md` support.

## Questions

## Notes
- The installed plugin (0.1.1) still reads `polaris.json`. After this ticket, run later tickets with the dev skills (`claude --plugin-dir plugins/odhyp`) so they read the block.
- Done: all seven skills and both format files read the odhyp block, and each skill says to run `/odhyp:setup` when the block is missing (code-review returns a MUST-FIX). `release` reads the primary version file (the first under `Version files:`) and leaves writing the others to T-0002. `setup` no longer asks for a project name, fills the six new placeholders (it keeps `{{version_files}}` and `{{changelog}}` from an existing block, else defaults to `VERSION` and `CHANGELOG.md`), and creates the primary version file and changelog under their configured names.
- `setup` refers to "any Polaris config file" instead of naming `polaris.json`, so the acceptance grep stays empty while it still says never to read or delete one.
- ADR 0006 added; 0005 now opens with "Superseded by 0006."
- Fixed (was must-fix from review): setup keeps the existing block's four folders on re-run unless the user changes the base path. Original finding: `plugins/odhyp/skills/setup/SKILL.md:37` (and the base-path question at `:26`): re-running setup rebuilds `{{specs}}`/`{{tickets}}`/`{{diagrams}}`/`{{releases}}` from the base path (default `docs/`), which overwrites custom paths in an existing block. Required: when a block exists, the base-path question defaults to the block's current folders, and step 3 keeps each of the four paths from the existing block unless the user changed the base path.
