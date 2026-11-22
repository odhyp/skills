---
id: T-0008
title: Format each version file in its own code span in the CLAUDE.md block template
type: fix
breaking: false
scope: config
status: ready-for-agent
spec: S-0001
depends_on: [T-0001]
source: code-review
parent: T-0001
diagrams: []
released_in:
---

## Context
The odhyp block in `CLAUDE.md` has a `- Version files:` line listing the primary version file first, then any other file that carries the version, comma-separated. The template `plugins/odhyp/templates/claude-md-block.md` writes it as ``- Version files: `{{version_files}}` ``, so a project with two files gets one code span around both: `` `VERSION, package.json` ``. This repo's own block (hand-written in T-0001) uses one span per file: `` `VERSION`, `plugins/odhyp/.claude-plugin/plugin.json` ``. Two spellings of the same line make `release` (T-0002) and Polaris parse it two ways. Cause: `setup/SKILL.md` step 3 does not say how to render a list into `{{version_files}}`.

## Decisions that apply
- One code span per file, separated by `, `: `` - Version files: `VERSION`, `package.json` ``. This repo's block already matches.
- The template line becomes `- Version files: {{version_files}}` (no surrounding backticks), and `setup` fills it with each file in its own backticks, primary first.

## Files
- plugins/odhyp/templates/claude-md-block.md (change)
- plugins/odhyp/skills/setup/SKILL.md (change: the `CLAUDE.md` row of step 3 says how `{{version_files}}` is rendered)

## Acceptance criteria
- [ ] `claude-md-block.md` has `- Version files: {{version_files}}` with no backticks around the placeholder.
- [ ] `setup` step 3 says each version file goes in its own backticks, comma-separated, primary first.
- [ ] `sh tests/commit-msg.test.sh` passes; `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- `release` writing every version file (T-0002).
- Polaris's parser (T-0007).

## Questions

## Notes
