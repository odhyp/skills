---
id: T-0020
title: to-tickets confirms the full drafts, then commits them
type: feat
breaking: false
scope: to-tickets
status: resolved
spec: S-0003
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in: v0.7.0
---

## Context
`to-spec` shows its full draft, loops until the user approves it, then commits only the spec file. `to-tickets` agrees only the breakdown (title, type, depends on), then writes the ticket files and updates the spec without committing anything. Those uncommitted files make `/release` stop, because its first precondition is a clean working tree. Today the user commits tickets by hand (e.g. `cd90840 docs(tickets): add T-0009 to T-0015`). This ticket makes `to-tickets` confirm the full drafts and commit its own output, like `to-spec`.

## Decisions that apply
- Keep the breakdown step (step 1) as it is.
- After the breakdown is agreed, show every ticket in full (frontmatter and body) in chat and write nothing yet.
- Apply each revision request and show all the tickets again. Only an explicit approval ends the loop. A reply that approves but also asks for a change is a revision and needs another round. Never skip the loop. Reuse `to-spec`'s wording for this loop (`plugins/odhyp/skills/to-spec/SKILL.md`, step 3).
- On approval: write the tickets and, if there is a spec, update its `tickets:` and `status: accepted`. Then `git add` only those files and commit only them: `git commit -m "docs(tickets): add T-NNNN to T-MMMM" -- <files>` (one ticket: `docs(tickets): add T-NNNN <slug>`). No `Refs:` footer. Never `git add -A`. Never push.
- An odhyp-skill finding outside the odhyp repo still prints the ticket with `id: T-XXXX` and writes nothing, so it has nothing to commit.
- Commit messages need no hook change: `.githooks/commit-msg` checks only the `type(scope)!: subject` line.

## Files
- plugins/odhyp/skills/to-tickets/SKILL.md (change)
- README.md (change: the `to-tickets` row in the Skills table)

## Acceptance criteria
- [x] `to-tickets` has a confirmation step after the breakdown that shows every ticket in full, writes nothing, and loops until explicit approval, with the same approve-and-change rule as `to-spec`.
- [x] On approval it writes the tickets and the spec update, and commits only those files with `docs(tickets): add T-NNNN to T-MMMM` (or `add T-NNNN <slug>` for one ticket), with no `Refs:` footer and no push.
- [x] The outside-the-odhyp-repo case still writes and commits nothing.
- [x] The report gives the commit hash along with the ticket list.
- [x] The README `to-tickets` row says it confirms the tickets with you and then commits them.
- [x] `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- `diagnose` (T-0021) and `implement` (T-0022, T-0023).
- Diagram changes: neither diagram draws commits or confirmation loops.
- New commit-hook tests.

## Questions

## Notes
- Split `to-tickets` step 2 into draft (show all tickets in full, write nothing), step 3 confirm (wording reused from `to-spec` step 3), step 4 write, spec update and path-limited commit, step 5 report with the commit hash. The old "Update the spec" step moved into step 4.
- The outside-the-odhyp-repo case is pointed back to step 2 in step 4: write and commit nothing.
- No red/green: skill text only. Lint and `tests/commit-msg.test.sh` pass.
