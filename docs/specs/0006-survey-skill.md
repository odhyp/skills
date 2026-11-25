---
id: S-0006
title: Survey skill for existing codebases
status: draft
tickets: []
---

## Problem

`setup` wires an existing codebase into the workflow but leaves it with no glossary, diagrams or ADRs. The first `/shape` in a brownfield project then has no shared terms and no map, so the skills serve greenfield projects much better than existing ones.

## Goals / Non-goals

- Goal: one manual skill, `survey`, that reads an existing codebase and drafts its missing glossary entries, diagrams and ADRs, so a brownfield project starts the workflow with shared terms.
- Goal: `setup` points brownfield projects to it, without getting slower or less idempotent.
- Goal: re-running `survey` is safe: it only adds, never rewrites.
- Non-goal: rewriting or reconciling existing glossary entries, diagrams or ADRs; drift is reported, not fixed.
- Non-goal: importing trackers; `setup` already does that.
- Non-goal: automated tests of survey output.
- Non-goal: `autopilot` (running tickets unattended), kept for later.

## Design

**The skill.** New manual skill `plugins/odhyp/skills/survey/SKILL.md` (`disable-model-invocation: true`, since it writes and commits). It reads the code, git history, README and docs, and drafts what is missing: glossary entries, diagrams and ADRs. No odhyp block: stop and say to run `/odhyp:setup`, as `diagram` does.

**Separate from `setup`.** `setup` stays quick, idempotent and the same for every project; `survey` is slow, costs tokens, and may be re-run later. `setup`'s report suggests `/odhyp:survey` when the project has source code and at least one of the glossary file, diagrams or ADRs is missing. Both checks come from files; no commit-count threshold, since a young repo with real code still needs a vocabulary.

**Scope.** Optional folder arguments (`/odhyp:survey src/api src/core`), default the whole repo. When the scope is too large to read well in one pass, stop and ask which folders to survey: a glossary drafted from skimmed code gives every later session wrong words.

**Glossary.** Read per ADR-0009 (a term-writing skill; skip silently when the line or file is missing; create the file when the first term arrives). Entries follow `GLOSSARY-FORMAT.md`: project-specific terms only. When the code uses two names for one thing, the most common becomes the term, the others go under `_Avoid_`, and the entry is flagged in the table for the user to confirm.

**Diagrams.** Drawn through the `diagram` skill. Its description and its "create a diagram only when the user asks or `shape` calls for one" rule add `survey` as a caller.

**ADRs.** Written only where a commit, PR or code comment states the reason. An ADR records the why; one guessed from code invents reasons later sessions will trust. Every other decision goes in the chat report as a one-line candidate (the decision and where it shows) for `/odhyp:to-adr`. No candidates file: a candidate has no reason, so it is not a record and must not sit in the decisions folder looking like one.

**Review and commit.** Per ADR-0011: drafts on disk, uncommitted; chat shows a table (file, kind, what it adds); revisions in a loop; one `docs(survey):` commit for the set on explicit approval, staging only this run's files. A rejection deletes this run's files.

**Re-runs only add.** Missing terms, diagrams and ADRs are drafted; existing entries are never rewritten, because they hold decisions a person made. Where the code contradicts the glossary, a diagram or an ADR, the report lists it as a finding for `/implement N`.

**Docs.** README skills row; `survey` in `docs/diagrams/workflow.mmd` (suggested by `setup`) and `data-flow.mmd` (already drawn in shape); the `Survey` glossary entry; an ADR recording the split from `setup` and the stated-reason-only ADR rule.

**Testing.** One run on a brownfield repo, one on a greenfield repo (expect little or nothing drafted), plus `claude plugin validate .` and `claude plugin validate plugins/odhyp`.

Glossary:

**Survey**:
The **Manual skill** that reads an existing codebase and drafts its missing **Glossary** entries, **Diagrams** and decisions, so a brownfield project starts the workflow with shared terms.
_Avoid_: adopt, onboard, backfill

## Decisions
