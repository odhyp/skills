---
name: to-adr
description: Record a settled decision from this conversation as an ADR (ADR-NNNN) in the project's decisions folder.
disable-model-invocation: true
---

Read `${CLAUDE_PLUGIN_ROOT}/templates/adr.md`: the single source for the ADR format. Start the file from it.

Record a decision only once it is settled: `implement` shipped it, or `shape` agreed on it with nothing to build. A feature decision that is still being shaped stays in its spec; say so and stop.

## 1. Find the folder

Read the odhyp block in `CLAUDE.md` for `Decisions:`, the decisions folder.
- No odhyp block: stop and say to run `/odhyp:setup`.
- Block without `Decisions:`: stop and say to re-run `/odhyp:setup`.

## 2. Take the decision

Take the decision and its reasons from this conversation. When `implement` made the offer, also read the spec and the ticket it names. If the reason is missing or would be guesswork, ask only for that.

## 3. Pick the ID and file

- **ID:** one above the highest `NNNN` in the decisions folder; `0001` when there is none. Scan only that folder: ADRs are never archived.
- **File:** `<decisions>/NNNN-<kebab-title>.md`.

## 4. Link an overridden ADR

Read the existing ADRs. If the new decision overrides one or more of them, in full or in part, name each (`ADR-NNNN`) and say whether the new ADR supersedes (in full) or amends (in part) it. List several in one line, comma-separated: `Amends ADR-0003, ADR-0004.`; when the kinds differ, use one line per kind. The user confirms each link; without a confirmed link, write none.

## 5. Draft and confirm

Show the full draft in chat, plus the back-link line for each old ADR. Write nothing to disk yet.

Ask the user to approve the draft or ask for changes. For each revision request, apply it and show the whole ADR again. Only an explicit approval ends the loop; a reply that approves and also asks for a change is a revision and needs another round. Never skip the loop.

## 6. Write

On approval:

1. For each old ADR it links to, run `git status --porcelain -- <old ADR file>`. Any output means the user has uncommitted changes there, which the commit would sweep in: write nothing, name the file, say to commit or stash those changes and run `/to-adr` again, and stop.
2. Write the new ADR to its file.
3. In each old ADR it links to, add `Superseded by ADR-NNNN.` or `Amended by ADR-NNNN.` as the line right after its H1, with a blank line around it. That line is the only change this skill makes to an existing ADR.

## 7. Commit

Stage only the files written in step 6, and commit only them, so anything the user already had staged stays out:

```
git add <files>
git commit -m "docs(adr): add ADR-NNNN <slug>" -- <files>
```

No `Refs:` footer. Never `git add -A`. Never amend the `implement` commit: code-review already checked it. Never push.

Then give the ADR's ID, path and commit hash, and stop.
