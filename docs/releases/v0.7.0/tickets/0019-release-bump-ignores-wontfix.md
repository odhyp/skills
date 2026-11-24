---
id: T-0019
title: Release counts wontfix tickets in the bump and changelog
type: fix
breaking: false
scope: release
status: resolved
spec: none
depends_on: []
source: diagnose
parent: none
diagrams: []
released_in: v0.7.0
---

## Context
`wontfix` means dropped work (TICKET-FORMAT.md, Statuses). But `/odhyp:release`
uses the same ticket list to archive tickets and to decide the version, so a
dropped ticket can bump the version and appear in the CHANGELOG as if it shipped.

## Reproduction
Trace `plugins/odhyp/skills/release/SKILL.md` with this state:
1. `docs/tickets/` holds one ticket, `type: feat`, `status: wontfix` (dropped).
2. Since the last tag there are only `docs:` commits.
3. Step 2 ("Collect", line 19) puts it in **Tickets**: "every `resolved` ticket … and every `wontfix` ticket".
4. Step 3 (line 24) computes the bump "From the tickets and commits together". Rule 2 ("any `feat`") matches the wontfix ticket → **minor** bump.
5. Step 5 (line 38) writes "the release's entries grouped as Added / …", and that ticket is one of them → the dropped feature is listed under Added.

## Expected / Actual
- Expected: wontfix tickets are archived (and listed as dropped in RELEASE.md) but never decide the bump or appear as shipped CHANGELOG entries. With only `docs:` commits, step 3 rule 4 applies: "nothing is releasable".
- Actual: a minor release is proposed, and its CHANGELOG lists work that was never built. With `breaking: true` on the dropped ticket, it would even take the breaking path.

## Root cause
`release/SKILL.md` step 2 builds one **Tickets** set for two jobs: archiving (it must include `wontfix`) and the bump/changelog (it must not). Steps 3 and 5 read "the tickets" without excluding `wontfix`.

## Failing test to write first
Skill text has no automated test (implement skips red/green for it). Do this check before and after the edit instead: trace the Reproduction scenario through the edited step 2 → 3 → 5. Before: a minor bump. After: "nothing is releasable".

## Decisions that apply
- Keep archiving `wontfix` tickets (step 6), stamping them with `released_in` (step 5), and the spec `done` rule (step 5, SPEC-FORMAT.md `done`). Those rules depend on the wontfix tickets being in the set.
- TICKET-FORMAT.md frontmatter is locked. Add no field.
- Keep the change to the text in `release/SKILL.md`.

## Files
- plugins/odhyp/skills/release/SKILL.md (change)

## Acceptance criteria
- [x] Step 3 computes the bump from `resolved` tickets and commits only; `wontfix` tickets are named as excluded.
- [x] The CHANGELOG entry (step 5) takes entries from `resolved` tickets and commits only.
- [x] `wontfix` tickets are still archived, stamped with `released_in`, and listed in RELEASE.md, marked as dropped.
- [x] The Reproduction trace now ends in "nothing is releasable".

## Out of scope
Other contradictions found in the same pass. Raise these separately if wanted:
- TICKET-FORMAT.md Statuses table: `ready-for-agent` "Set by" leaves out `implement`, which sets it on a split and when it clears `needs-info`.
- implement step 1: a `needs-info` ticket whose questions are all answered is set to `ready-for-agent` and work continues, but nothing sets it to `in-progress`, so crash recovery does not cover it.
- The CLAUDE.md block's Next ID line points to `releases/*/`, but archived tickets live in `releases/*/tickets/`.

## Questions

## Notes
Split the ticket set in release step 2 into shipped (`resolved`) and dropped (`wontfix`). Steps 3 (bump) and 5 (CHANGELOG) now read only the shipped tickets and the commits. Step 6 RELEASE.md lists `wontfix` tickets under **Dropped**. Archiving, `released_in` and the spec `done` rule still cover both. Trace of the Reproduction: before, a minor bump; after, step 3 rule 4, "nothing is releasable".
