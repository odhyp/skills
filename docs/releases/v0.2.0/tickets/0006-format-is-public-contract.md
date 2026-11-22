---
id: T-0006
title: Mark the format files as the public contract and add a README section
type: docs
breaking: false
scope: templates
status: resolved
spec: S-0001
depends_on: [T-0001]
source: to-tickets
parent: none
diagrams: []
released_in: v0.2.0
---

## Context
Polaris should work for people with their own skills, not only odhyp users. What it really depends on is the ticket and spec format, so that format needs to read as a contract anyone can write to.

## Decisions that apply
- `TICKET-FORMAT.md` and `SPEC-FORMAT.md` each open with one line: this format is the contract any skills can write to so that Polaris can read their output.
- The README gets a short section saying the same and linking both files; it states that odhyp has no runtime dependency on Polaris and that Polaris keeps its own config outside the repo.
- odhyp comes first; Polaris only reads.

## Files
- plugins/odhyp/templates/TICKET-FORMAT.md (change)
- plugins/odhyp/templates/SPEC-FORMAT.md (change)
- README.md (change)

## Acceptance criteria
- [x] Both format files open with the contract line.
- [x] The README has a section linking both format files for people using their own skills.
- [x] `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- Changing any field or section of the format.
- Polaris's own docs.

## Questions

## Notes
- Contract line added under the title of `TICKET-FORMAT.md` and `SPEC-FORMAT.md`.
- README: new "Using your own skills" subsection under "Polaris contract".
- Both validations and the hook test pass.
