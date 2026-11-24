---
id: T-0021
title: diagnose confirms the ticket draft, then commits it
type: feat
breaking: false
scope: diagnose
status: ready-for-agent
spec: S-0003
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
`diagnose` writes its `fix` ticket in step 3 without showing a draft and without committing it. Its rule is "the working tree ends exactly as you found it, plus the ticket," so the ticket stays uncommitted, and `/release` refuses to run while the working tree isn't clean. This ticket makes `diagnose` confirm the draft and commit the ticket, like `to-spec`.

## Decisions that apply
- After the root cause is found, show the full ticket draft (frontmatter and body) in chat and write nothing yet.
- Apply each revision request and show the whole ticket again. Only an explicit approval ends the loop. A reply that approves but also asks for a change is a revision and needs another round. Never skip the loop. Reuse `to-spec`'s wording for this loop (`plugins/odhyp/skills/to-spec/SKILL.md`, step 3).
- On approval: write the ticket, `git add` only that file, and commit only it: `git commit -m "docs(tickets): add T-NNNN <slug>" -- <ticket file>`. No `Refs:` footer. Never `git add -A`. Never push.
- Change the working-tree rule at the top of the skill to "the working tree ends exactly as you found it, plus the committed ticket". Temporary logging is still reverted before the draft is shown.
- Commit messages need no hook change: `.githooks/commit-msg` checks only the `type(scope)!: subject` line.

## Files
- plugins/odhyp/skills/diagnose/SKILL.md (change)
- README.md (change: the `diagnose` row in the Skills table)

## Acceptance criteria
- [ ] `diagnose` shows the full ticket draft, writes nothing, and loops until explicit approval, with the same approve-and-change rule as `to-spec`.
- [ ] On approval it writes the ticket and commits only that file with `docs(tickets): add T-NNNN <slug>`, with no `Refs:` footer and no push.
- [ ] The opening rule says the tree ends as found plus the committed ticket, and temporary logging is reverted before the draft is shown.
- [ ] The report gives the commit hash along with the ticket's ID and path.
- [ ] The README `diagnose` row says it confirms the fix ticket with you and then commits it.
- [ ] `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- `to-tickets` (T-0020) and `implement` (T-0022, T-0023).
- Changing how `diagnose` reproduces or finds the root cause.
- Diagram changes and new commit-hook tests.

## Questions

## Notes
