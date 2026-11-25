---
id: T-0035
title: Try survey on a brownfield and a greenfield repo
type: test
breaking: false
scope: survey
status: ready-for-human
spec: S-0006
depends_on: [T-0034]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context

S-0006 tests `survey` by hand, not with an automated test: its output is too open-ended to assert on, and a headless run like `tests/review-smoke.sh` costs API money every time. This ticket is that manual trial, run by a person after T-0033 (the skill) and T-0034 (`setup` suggesting it).

## Decisions that apply

- Test by one run on a brownfield repo and one on a greenfield repo, plus both `claude plugin validate` commands. No new automated test.
- Expected: brownfield gets drafted glossary entries, diagrams, stated-reason ADRs and a candidates list; greenfield gets little or nothing.

## Files

- none (findings go to `## Notes`, and into new tickets via `/odhyp:to-tickets` if needed)

## Acceptance criteria

- [ ] Brownfield: `setup` suggests `survey`; `survey` drafts files, shows the table, flags synonym picks, lists ADR candidates in chat only, and commits one `docs(survey):` commit on approval.
- [ ] Brownfield re-run: nothing existing is rewritten; any drift appears as numbered findings.
- [ ] A rejection deletes only that run's files.
- [ ] Greenfield: `setup` does not suggest `survey`, or `survey` drafts little or nothing.
- [ ] Each finding is noted here, and the worthwhile ones become follow-ups.

## Out of scope

- Fixing what the trial finds (follow-up tickets).

## Questions

## Notes
