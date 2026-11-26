---
id: T-0037
title: Diagnose hands off its findings like shape
type: fix
breaking: false
scope: diagnose
status: resolved
spec: S-0007
depends_on: [T-0036]
source: to-tickets
parent: none
diagrams: [workflow, data-flow]
released_in:
---

## Context

`diagnose` prints its whole `fix` ticket in chat, then writes and commits it itself. `shape`, the same kind of skill, ends with a summary and names the next skill instead. The only difference between them is where the answers come from: `shape` grills the user, `diagnose` reads the code (a repro that goes red, a root cause backed by evidence). This ticket makes `diagnose` end like `shape`: a `# Diagnosis Summary` of numbered findings and a next step of `/implement N` or `/to-tickets N`. It also teaches `to-tickets` and `implement` to take those findings, and updates TICKET-FORMAT to match.

## Decisions that apply

**diagnose** (`plugins/odhyp/skills/diagnose/SKILL.md`)
- Writes and commits nothing. It still reverts temporary logging before printing the summary, so the working tree ends exactly as it found it. Remove the draft, confirm, write-and-commit and report steps (3 to 6); the confirm loop lives in `to-tickets`, which already has one.
- Ends with a `# Diagnosis Summary` of numbered findings. Each finding has `## Reproduction`, `## Expected / Actual`, `## Root cause`, `## Failing test to write first` and `## Constraints` (code that must not change, callers that depend on the behaviour). A single bug is finding 1. Numbered findings reuse the existing `/implement 1,2`, `/implement all` and `/to-tickets 1,3` forms.
- `## Next step` follows `implement`'s direct-mode bar: `/implement N` (or `all`) for fixes that are small, clear and not architectural; `/to-tickets N` for the rest; both lines when the findings are mixed. It says to run the next skill before any `/clear`, since the summary exists only in this session.
- An `odhyp skill` finding outside the odhyp repo (no `plugins/odhyp/.claude-plugin/plugin.json` at the repo root) gets only `/to-tickets N`, as in `session-review`: the installed plugin is read-only.
- Cannot reproduce: unchanged. Stop, report what was tried, ask for what is missing, print no findings.
- The description drops "writes a fix ticket" and says it hands off its findings to `implement` or `to-tickets`. Keep "does not fix" and the "Not for test or lint failures in work in progress" line.

**to-tickets** (`plugins/odhyp/skills/to-tickets/SKILL.md`)
- Accepts findings from `diagnose` as input, alongside `session-review` and `code-review` findings. Each becomes a `fix` (or `perf`) ticket with the four diagnosis sections right after `## Context`, its `## Constraints` under `## Decisions that apply`, and `source: diagnose`.

**implement** (`plugins/odhyp/skills/implement/SKILL.md`)
- Direct mode starts a diagnose finding with its `## Failing test to write first`, as ticket mode does for a `fix` ticket.
- `this` keeps meaning only the session's last `# Shape Summary`; no `/implement this` for a diagnosis.

**TICKET-FORMAT** (`plugins/odhyp/templates/TICKET-FORMAT.md`)
- `diagnose` leaves the `Set by` list of `ready-for-agent`.
- "`fix` tickets from `diagnose`" becomes `fix` tickets that `to-tickets` writes from a diagnose finding; the `fix` example's heading follows.
- The trivial-bug line means a cause known without a diagnosis.
- `source: diagnose` stays in the frontmatter comment and the example. The frontmatter stays locked.

`shape` and `setup` mention `diagnose` only as the route for a bug of unknown cause; leave them unchanged.

Builds on T-0036, which also edits TICKET-FORMAT and `implement` step 3; read the files as T-0036 left them.

Glossary:

**Diagnose**:
The **Skill** that reproduces a bug of unknown cause and finds its root cause from the code, then hands its numbered findings to `implement` or `to-tickets` the way **Shape** hands off agreed work.
_Avoid_: debug, triage

## Files
- plugins/odhyp/skills/diagnose/SKILL.md (change)
- plugins/odhyp/skills/to-tickets/SKILL.md (change)
- plugins/odhyp/skills/implement/SKILL.md (change)
- plugins/odhyp/templates/TICKET-FORMAT.md (change)
- GLOSSARY.md (change)

## Acceptance criteria
- [x] `diagnose` has no step that writes, stages or commits a file, and says the working tree ends exactly as it found it.
- [x] `diagnose` prints a `# Diagnosis Summary` of numbered findings, each with the five sections above, and a `## Next step` that picks `/implement N` or `/to-tickets N` by the direct-mode bar, prints both when mixed, and says to run it before `/clear`.
- [x] `diagnose` offers only `/to-tickets N` for an `odhyp skill` finding outside the odhyp repo.
- [x] `diagnose`'s description no longer says it writes a ticket.
- [x] `to-tickets` takes diagnose findings and writes them as `fix`/`perf` tickets with the four sections, `## Constraints` under `## Decisions that apply`, and `source: diagnose`.
- [x] `implement` direct mode starts a diagnose finding with its failing test; `this` still means only the last `# Shape Summary`.
- [x] TICKET-FORMAT: `diagnose` is gone from `ready-for-agent`'s setters; the `fix` section rule, the trivial-bug line and the example heading name `to-tickets` writing from a diagnose finding; `source: diagnose` remains.
- [x] `GLOSSARY.md` has the **Diagnose** entry in the `### Skills` group.
- [x] `claude plugin validate . && claude plugin validate plugins/odhyp` passes.

## Out of scope
- `/implement this` for a diagnosis.
- Any change to `to-adr`, which keeps its full draft in chat.
- Changes to `shape` or `setup`.
- Version bump and CHANGELOG (done by /odhyp:release).

## Questions

## Notes
Rewrote `diagnose` steps 3 to 6 as one `## 3. Hand off` step that reverts logging and prints the `# Diagnosis Summary`; it no longer reads TICKET-FORMAT. Findings are `## N. <title>` with the five sections as `###` headings so several findings nest under one summary; `to-tickets` maps them to the ticket's `##` sections, and `implement` names the `###` failing test. TICKET-FORMAT's `ready-for-agent` setters drop `diagnose` (T-0036 had added `implement` there).

Must-fix (review):
- `docs/diagrams/workflow.mmd:27` (and `:39`), `docs/diagrams/data-flow.mmd:84-86`: diagrams still show diagnose writing a ticket (`Root cause → fix ticket`, `B5 --> CL0`, next-ID and tickets edges). Redraw diagnose handing off to `implement` (direct) or `to-tickets` before `/clear`, drop its next-ID and tickets edges, and add `workflow` and `data-flow` to this ticket's `diagrams`.

Resumed: fixed the must-fix by redrawing `workflow.mmd` (diagnose → `/implement N` or `/to-tickets N`, no `/clear` into tickets) and `data-flow.mmd` (diagnose reads only code; next-ID, TICKET-FORMAT and tickets edges removed), and set `diagrams: [workflow, data-flow]`. Also fixed README lines 5, 30 and 31 and added the `###` heading decision to S-0007 `## Decisions`.
