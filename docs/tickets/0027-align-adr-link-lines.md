---
id: T-0027
title: Align existing ADR link lines
type: docs
breaking: false
scope: adr
status: ready-for-agent
spec: S-0004
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
This repo's ADRs place supersession notes inconsistently and write references both as
`ADR-0007` and `0006`. Partial overrides aren't marked on the older ADR, and 0001 claims to
be fully superseded although 0007 keeps half of it. Agents copy the files they read, so the
ADRs must match the new format.

## Decisions that apply
- A link is one line right after the H1, separated by blank lines. The new ADR says
  `Supersedes ADR-NNNN.` or `Amends ADR-NNNN.`; the old says `Superseded by ADR-NNNN.` or
  `Amended by ADR-NNNN.`. References are always `ADR-NNNN`.
- Only link lines change; every ADR's wording otherwise stays as is. ADR-0008's "stay as
  written for the record" is kept, since a pointer line doesn't change their wording.
- Changes:
  - 0001: `Superseded by ADR-0007.` → `Amended by ADR-0007.`
  - 0003, 0004: add `Amended by ADR-0008.`
  - 0005: move `Superseded by 0006.` below the H1 as `Superseded by ADR-0006.`
  - 0006: take `Supersedes 0005.` out of the paragraph onto its own line as `Supersedes ADR-0005.`
  - 0007: add `Amends ADR-0001.`
  - 0008: add `Amends ADR-0003, ADR-0004.`

## Files
- docs/adr/0001-tickets-are-the-handoff.md (change)
- docs/adr/0003-shared-templates-plugin-only.md (change)
- docs/adr/0004-diagrams-as-mmd.md (change)
- docs/adr/0005-polaris-json-holds-paths.md (change)
- docs/adr/0006-config-lives-in-the-claude-md-block.md (change)
- docs/adr/0007-tickets-track-work.md (change)
- docs/adr/0008-skills-know-no-outside-reader.md (change)

## Acceptance criteria
- [ ] Each file has exactly the link line above, right after its H1.
- [ ] `git diff --word-diff docs/adr` shows no change other than those lines (0006's paragraph loses only its opening `Supersedes 0005.`).
- [ ] `grep -rnE "\b000[0-9]\b" docs/adr` shows no bare `000N` reference outside an `ADR-` prefix in the link lines.

## Out of scope
- Rewording any ADR, adding sections, or removing `Reasons:` labels from bodies.
- ADR 0002 (no links).

## Questions

## Notes
