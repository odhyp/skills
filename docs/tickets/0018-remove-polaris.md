---
id: T-0018
title: Remove Polaris from the live files and add ADR 0008
type: docs
breaking: false
scope: polaris
status: resolved
spec: none
depends_on: [T-0017]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
The skills and templates mention Polaris, a separate local interface that reads the
files odhyp writes. The skills never call it, so the mentions are noise and couple
this repo to another one. Decision: the skills are used as-is and know nothing about
any outside reader; Polaris explains on its own side what it reads.

## Decisions that apply
- Remove every Polaris mention from the live files below. Keep every format exactly as
  it is: no field, status, section or file name changes.
- The frontmatter stays locked. Its reason becomes that the odhyp skills parse it
  (e.g. "The odhyp skills parse it, so changing it is a breaking change."), not
  "Polaris parses it … for both repos".
- `TICKET-FORMAT.md` / `SPEC-FORMAT.md` line 3 ("the contract any skills can write to
  so that Polaris can read their output") is reworded without Polaris, e.g. "This
  format is the contract the odhyp skills write and read."
- `TICKET-FORMAT.md` statuses table, `needs-info` row: "human or Polaris (clears)"
  becomes "human (clears)".
- `plugins/odhyp/skills/diagram/SKILL.md:31`: drop "Polaris shows them."
- `plugins/odhyp/skills/setup/SKILL.md:17`: delete the "Ignore any Polaris config file"
  bullet. Setup never deletes files it does not know, so behaviour is unchanged.
- README: delete `## Polaris contract` and its `### Using your own skills` subsection.
  If something there is still true without Polaris (formats live in
  `plugins/odhyp/templates/`), keep it in at most one line elsewhere; otherwise drop it.
- Keep history: do not edit `CHANGELOG.md`, `docs/releases/**`, or ADRs 0003–0006.
- New ADR `docs/adr/0008-skills-know-no-outside-reader.md`, in the style of the
  existing ADRs (a `#` title, then a short paragraph): the skills and formats do not
  name or depend on any tool that reads their output; such a tool documents what it
  reads on its own side. Note that it replaces the Polaris references in ADRs
  0003–0004 going forward.

## Files
- plugins/odhyp/templates/TICKET-FORMAT.md (change)
- plugins/odhyp/templates/SPEC-FORMAT.md (change)
- plugins/odhyp/skills/diagram/SKILL.md (change)
- plugins/odhyp/skills/setup/SKILL.md (change)
- README.md (change)
- docs/adr/0008-skills-know-no-outside-reader.md (new)

## Acceptance criteria
- [x] `grep -rni polaris . --exclude-dir=.git` matches only `CHANGELOG.md`,
      `docs/releases/**`, `docs/adr/0003`–`0006`, ADR 0008, this ticket, and resolved tickets awaiting archive (T-0017).
- [x] The frontmatter blocks, field lists, statuses and sections in both FORMAT files
      are unchanged apart from the reworded sentences above (check with `git diff`).
- [x] ADR 0008 exists and records the decision and why.
- [x] `claude plugin validate .` and `claude plugin validate plugins/odhyp` pass.

## Out of scope
- Changing any format field, status or template.
- Rewriting old ADRs or the CHANGELOG.
- Any change in the Polaris repo.

## Questions

## Notes
- Removed Polaris from both FORMAT files (line 3 and the locked-frontmatter reason),
  the `needs-info` row, diagram and setup skills, and the README section. The only
  still-true README fact (formats live in `plugins/odhyp/templates/`) went into the
  Development "Layout" bullet. ADR 0008 added.
- The grep also matches the resolved ticket T-0017 (`docs/tickets/0017-…`). It is a
  history record awaiting archive by `/release`, so it was left as written; once
  archived it falls under `docs/releases/**`.
