---
id: T-0013
title: to-spec confirmation loop, then commit
type: feat
breaking: false
scope: to-spec
status: resolved
spec: S-0002
depends_on: []
source: to-tickets
parent: none
diagrams: []
released_in: v0.3.0
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
- [x] `to-spec/SKILL.md` shows the draft in chat and writes nothing before explicit approval.
- [x] The revision loop and the "approval plus change is a revision" rule are stated.
- [x] On approval it writes, removes the folder's `.gitkeep`, and commits only the spec's paths with the message above.
- [x] It reports the commit hash and stops at `/to-tickets S-NNNN`.
- [x] `sh tests/commit-msg.test.sh` and `claude plugin validate . && claude plugin validate plugins/odhyp` pass.

## Out of scope
- Commit-on-approval for `to-tickets`.
- The general `.gitkeep` rule in the config block (T-0014).

## Questions

## Notes
- Split `to-spec/SKILL.md` step 2 "Write" into 2 Draft (show in chat, nothing on disk), 3 Confirm (revision loop), 4 Write and commit (spec + `.gitkeep` removal, scoped staging, `docs(spec): add S-NNNN <slug>`), 5 Report (hash, stop at `/to-tickets`).
- Prose-only change: no automated test covers skill text; checked by tests + plugin validate.
- Must-fix (review): `plugins/odhyp/skills/to-spec/SKILL.md:31-32` — a plain `git commit` would also take anything the user already had staged. Limit the commit to the spec's paths, e.g. `git commit -m "docs(spec): add S-NNNN <slug>" -- <spec file> [<.gitkeep>]`, or stop and tell the user when the index already holds other changes.
- Fixed: step 4 item 4 now commits with `-- <spec file> [<.gitkeep>]`. Checked in a throwaway repo that a path-limited commit includes a `git rm`'d `.gitkeep` and leaves other staged files out.
