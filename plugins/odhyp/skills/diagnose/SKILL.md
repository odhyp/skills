---
name: diagnose
description: Use when the user reports a bug whose cause is unknown (something broken, throwing, giving wrong output or slow). Reproduces it, finds the root cause and hands off its findings to implement or to-tickets; does not fix. Not for test or lint failures in work in progress, such as inside an implement run.
---

You **diagnose; you do not fix.** The output is a `# Diagnosis Summary` of numbered findings that `implement` or `to-tickets` takes next, the way `shape` hands off agreed work. You write, stage and commit nothing. Repro scripts go in a temp directory outside the repo. Temporary logging in project files is fine, but revert it before step 3: the working tree ends exactly as you found it.

Read the odhyp block in `CLAUDE.md` for the paths and the test command (No odhyp block: stop and say to run `/odhyp:setup`).

## 1. Reproduce

Build a **tight** loop: one command that goes **red** on the bug, fast and every time. Prefer an existing test command with a filter, then a small script, then exact manual steps.

**Done when** you have watched it go red. If you cannot reproduce it, stop: report what you tried and ask the user for what is missing (input, environment, version). Print no findings on a guess.

## 2. Find the root cause

Form hypotheses, then narrow with evidence: read the code on the failing path, add temporary logging, bisect inputs or commits (`git bisect` when it worked before).

**Done when** you can explain the red end to end: which line does what wrong, and why it produces exactly the observed symptom. A symptom ("the value is null") is not a root cause ("`load()` returns before the cache fills").

## 3. Hand off

Revert any temporary logging, then print:

```markdown
# Diagnosis Summary

## 1. <one-line title>

### Reproduction
### Expected / Actual
### Root cause
### Failing test to write first
### Constraints

## Next step

<from the rules below>.
```

- **Findings:** one per distinct root cause, numbered from 1; a single bug is finding 1.
- `### Reproduction`: the red command or exact steps. `### Failing test to write first`: the test that goes red on this bug and green once fixed. `### Constraints`: code that must not change and callers that depend on the behaviour; `none` when there are none.
- **Next step:** `/implement N` (or `/implement all`) for findings whose fix is small, clear and not architectural, the bar of `implement`'s direct mode; `/to-tickets N` for the rest; one line each when the findings are mixed. Add that the summary exists only in this session, so run the next skill before any `/clear`.
- **An `odhyp skill` finding outside the odhyp repo** (no `plugins/odhyp/.claude-plugin/plugin.json` at the repo root): the installed plugin is read-only, so offer only `/to-tickets N` for it.
