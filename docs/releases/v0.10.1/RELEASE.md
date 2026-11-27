# v0.10.1

Released 2026-11-27.

`implement` now leaves a known, committed state after every ticket-mode run, and picks answered `needs-info` tickets safely.
`to-spec` and `to-tickets` commit the diagrams `shape` drew, and `release` writes an exact date line.

## Tickets

None. This release ships commits made without tickets.

## Commits

### fix

- 9bb9001 fix(implement): leave a known state for every ticket-mode outcome
- 7f9697e fix(implement): tighten the bare pick and the second-review notes
- c78fa7f fix(implement): write review findings to Notes before any stop
- 740b3e3 fix(release): write an exact date line in RELEASE.md
- 18cbee7 fix(skills): commit shape's diagrams with specs or tickets, list setup as a status setter
- 4f3d3cf fix(implement): set an answered needs-info ticket in-progress before building
- b5eb7a0 fix(implement): drop the unwritten ready-for-agent from the needs-info pick
