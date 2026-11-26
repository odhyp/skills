---
id: S-0007
title: Diagnose hands off its findings like shape
status: accepted
tickets: [T-0037]
---

## Problem

`diagnose` prints its whole `fix` ticket in chat, then writes and commits it itself, while `to-spec` and `to-tickets` write their files and show only a table. More than that, `diagnose` is the same kind of skill as `shape`: both settle what the work is before any ticket exists. `shape` gets the answers by grilling the user, `diagnose` gets them from the code (a repro that goes red, a root cause backed by evidence). Only `shape` hands off its result to `implement` or `to-tickets`; `diagnose` writes the ticket itself, so the two skills end differently for no reason, and a small fix found by `diagnose` cannot go straight to `/implement`.

## Goals / Non-goals

- Goal: `diagnose` ends like `shape`: a summary in chat and a named next step, writing and committing nothing.
- Goal: a small, clear fix goes straight to `/implement N`; anything larger goes to `/to-tickets N`.
- Goal: a diagnose finding still becomes a `fix` ticket with its four diagnosis sections when it goes through `to-tickets`.
- Non-goal: `/implement this` for a diagnosis.
- Non-goal: any change to `to-adr`, which keeps its full draft in chat.
- Non-goal: changes to `shape` itself.

## Design

**diagnose**
- Writes and commits nothing. It still reverts temporary logging before printing the summary, so the working tree ends exactly as it found it. Its draft, confirm, write and commit steps are removed; the confirm loop now lives in `to-tickets`, which already has one.
- Ends with a `# Diagnosis Summary` of numbered findings. Each finding has `## Reproduction`, `## Expected / Actual`, `## Root cause`, `## Failing test to write first` and `## Constraints` (code that must not change, callers that depend on the behaviour). A single bug is finding 1. Numbered findings reuse the existing `/implement 1,2`, `/implement all` and `/to-tickets 1,3` forms, so `this` keeps meaning only the last `# Shape Summary`.
- `## Next step` follows `implement`'s direct-mode bar: `/implement N` (or `all`) for fixes that are small, clear and not architectural; `/to-tickets N` for the rest; both lines when the findings are mixed. It says to run the next skill before any `/clear`, since the summary exists only in this session.
- An `odhyp skill` finding outside the odhyp repo (no `plugins/odhyp/.claude-plugin/plugin.json` at the repo root) gets only `/to-tickets N`, as in `session-review`: the installed plugin is read-only.
- Cannot reproduce: unchanged. Stop, report what was tried, ask for what is missing, print no findings.
- The description drops "writes a fix ticket" and says it hands off findings to `implement` or `to-tickets`.

**to-tickets**
- Accepts findings from `diagnose` as a fourth input. Each becomes a `fix` (or `perf`) ticket with the four diagnosis sections, its `## Constraints` under `## Decisions that apply`, and `source: diagnose`. `source` names where the work came from, as `source: session-review` does for its findings.

**implement**
- Direct mode starts a diagnose finding with its `## Failing test to write first`, as ticket mode does for a `fix` ticket.

**TICKET-FORMAT**
- `diagnose` leaves the `Set by` list of `ready-for-agent`.
- "`fix` tickets from `diagnose`" becomes `fix` tickets that `to-tickets` writes from a diagnose finding; the example's heading follows.
- The trivial-bug line means a cause known without a diagnosis.
- `source: diagnose` stays.

`shape` and `setup` mention `diagnose` only as the route for a bug of unknown cause, so they need no change.

Tested by `claude plugin validate . && claude plugin validate plugins/odhyp`; no manual trial (ADR-0014).

Builds on T-0036, which also edits TICKET-FORMAT and `implement` step 3.

Glossary:

**Diagnose**:
The **Skill** that reproduces a bug of unknown cause and finds its root cause from the code, then hands its numbered findings to `implement` or `to-tickets` the way **Shape** hands off agreed work.
_Avoid_: debug, triage

## Decisions

2026-11-26 · T-0037 · Diagnosis findings use `###` section headings under `## N. <title>`, not `##`, so several findings nest under one `# Diagnosis Summary`; to-tickets maps them to the ticket's `##` sections.
