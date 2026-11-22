---
id: T-0002
title: release updates every version file and lists them in the confirmation
type: fix
breaking: false
scope: release
status: resolved
spec: S-0001
depends_on: [T-0001]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
`release` step 5 writes the version only to the primary version file and to `package.json`/`pyproject.toml` when present. This repo also carries it in `plugins/odhyp/.claude-plugin/plugin.json`, so `/odhyp:release` here would leave the plugin manifest on the old version.

## Decisions that apply
- The version files come from the odhyp block's `Version files:` line in CLAUDE.md (added by T-0001): the primary one first, then the others. The current version is read from the primary one.
- Step 5 writes the new version into every listed file, plus `package.json`/`pyproject.toml` when present (as today).
- Step 4's confirmation lists every file whose version will change, alongside the proposed version, the bump reason and the CHANGELOG entry, so a missed file shows before anything is written.

## Files
- plugins/odhyp/skills/release/SKILL.md (change)

## Acceptance criteria
- [x] Step 2 reads the current version from the first file on the `Version files:` line.
- [x] Step 4 lists every file whose version will change.
- [x] Step 5 writes the version into every file on the `Version files:` line, plus `package.json`/`pyproject.toml` when present.
- [x] `claude plugin validate plugins/odhyp` passes.

## Out of scope
- Parsing version formats beyond replacing the version string in each file.
- Any other `release` step.

## Questions

## Notes
- Step 2 already read the current version from the primary (first) `Version files:` entry since T-0001; unchanged.
- Step 4 now lists every file whose version will change; step 5 writes the new version into every `Version files:` entry plus `package.json`/`pyproject.toml` when present.
- Prose-only change to a skill: no unit test; checked with the repo test and lint commands (both pass; the ICON_MISSING warning predates this).
