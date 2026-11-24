---
id: T-0028
title: Manual test of the three to-adr entry points
type: test
breaking: false
scope: adr
status: ready-for-human
spec: S-0004
depends_on: [T-0026]
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
`to-adr` and its offers are prompt instructions, so only real runs can test them. The
installed plugin is the cached 0.7.0, so the new skill exists only after reinstalling from
this repo's working copy. That needs a person.

## Decisions that apply
- One run per entry point: the `implement` offer, the `shape` "nothing to build" offer, and
  a direct `/odhyp:to-adr`.
- Each run checks the next ID, the format, the back-link on the old ADR (when one is
  linked), and that the commit holds only the ADR files.

## Files
- none (throwaway test project or branch)

## Acceptance criteria
- [ ] Plugin reloaded from this repo; `/odhyp:to-adr` is listed.
- [ ] `implement` on a ticket whose spec settles a decision offers `/odhyp:to-adr` after its commit, and on a MUST-FIX stop doesn't.
- [ ] `shape` ending "nothing to build" with a reason worth keeping offers `/odhyp:to-adr`.
- [ ] Direct `/odhyp:to-adr` with an `Amends` link: draft loop shown, new ADR has the right ID and format, the old ADR gets only the back-link line, the commit is `docs(adr): …` with only those files.
- [ ] Failures are written here under `## Notes` as follow-ups.

## Out of scope
- Fixing anything found; that becomes new tickets.

## Questions

## Notes
