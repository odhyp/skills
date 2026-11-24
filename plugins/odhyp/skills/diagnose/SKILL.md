---
name: diagnose
description: Use when the user reports a bug whose cause is unknown (something broken, throwing, giving wrong output or slow). Reproduces it, finds the root cause, writes a fix ticket; does not fix. Not for test or lint failures in work in progress, such as inside an implement run.
---

You **diagnose; you do not fix.** The output is one `fix` ticket that a fresh agent can implement. Repro scripts go in a temp directory outside the repo. Temporary logging in project files is fine, but revert it before step 3, before the draft is shown: the working tree ends exactly as you found it, plus the committed ticket.

Read the odhyp block in `CLAUDE.md` for the paths and the test command (No odhyp block: stop and say to run `/odhyp:setup`), and `${CLAUDE_PLUGIN_ROOT}/templates/TICKET-FORMAT.md`, including its `fix` example.

## 1. Reproduce

Build a **tight** loop: one command that goes **red** on the bug, fast and every time. Prefer an existing test command with a filter, then a small script, then exact manual steps.

**Done when** you have watched it go red. If you cannot reproduce it, stop: report what you tried and ask the user for what is missing (input, environment, version). Write no ticket on a guess.

## 2. Find the root cause

Form hypotheses, then narrow with evidence: read the code on the failing path, add temporary logging, bisect inputs or commits (`git bisect` when it worked before).

**Done when** you can explain the red end to end: which line does what wrong, and why it produces exactly the observed symptom. A symptom ("the value is null") is not a root cause ("`load()` returns before the cache fills").

## 3. Draft the ticket

- Next `T-` ID (see the ticket format); file `<tickets>/NNNN-short-slug.md`.
- `type: fix` (or `perf` for slowness), `source: diagnose`, `spec: none`, `status: ready-for-agent`.
- All sections, including `## Reproduction`, `## Expected / Actual`, `## Root cause` and `## Failing test to write first`: the test that goes red on this bug and green once fixed.
- Fill `## Decisions that apply` with any constraint on the fix you found (code that must not change, callers that depend on the behaviour).

Show the full draft (frontmatter and body) in chat. Write nothing to disk yet.

## 4. Confirm

Ask the user to approve the draft or ask for changes. For each revision request, apply it and show the whole ticket again. Only an explicit approval ends the loop; a reply that approves and also asks for a change is a revision and needs another round. Never skip the loop.

## 5. Write and commit

On approval:

1. Write the ticket to `<tickets>/NNNN-short-slug.md`.
2. Stage only that file: `git add` the ticket file. Never `git add -A`.
3. Commit only that file, so anything the user already had staged stays out: `git commit -m "docs(tickets): add T-NNNN <slug>" -- <ticket file>`, with no `Refs:` footer. Never push.

## 6. Report

The root cause in two lines, the ticket's ID, path and commit hash, and the next step: `/clear`, then `/implement @<path>`.
