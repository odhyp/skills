---
id: T-0013
title: to-spec confirmation loop, then commit
type: feat
breaking: false
scope: to-spec
status: ready-for-agent
spec: S-0002
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in:
---

## Context
`plugins/odhyp/skills/to-spec/SKILL.md` writes the spec file straight away and never commits it, so an unreviewed spec can land on disk and an approved one may never reach git. The spec should be confirmed in a loop, then written and committed.

## Decisions that apply
1. Show the full draft spec (frontmatter and body) in chat; write nothing to disk yet.
2. Each revision request: apply it and show the whole spec again. Only an explicit approval ends the loop; a reply that approves and also asks for a change is a revision and needs another round. Never skip the loop.
3. On approval: write `<specs>/NNNN-slug.md` with `status: draft` (unchanged meaning: written, not yet split into tickets). If the specs folder has a `.gitkeep`, remove it. Commit only those paths (`git add` the spec, `git rm` the `.gitkeep` if any; never `git add -A`) as `docs(spec): add S-NNNN <slug>`, with no `Refs:` footer.
4. Report the ID, path and commit hash, and the next step `/to-tickets S-NNNN`. Never continue to tickets or implementation.
- Never push.

## Files
- plugins/odhyp/skills/to-spec/SKILL.md (change)

## Acceptance criteria
- [ ] `to-spec/SKILL.md` shows the draft in chat and writes nothing before explicit approval.
- [ ] The revision loop and the "approval plus change is a revision" rule are stated.
- [ ] On approval it writes, removes the folder's `.gitkeep`, and commits only the spec's paths with the message above.
- [ ] It reports the commit hash and stops at `/to-tickets S-NNNN`.
- [ ] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- Commit-on-approval for `to-tickets`.
- The general `.gitkeep` rule in the config block (T-0014).

## Questions

## Notes
