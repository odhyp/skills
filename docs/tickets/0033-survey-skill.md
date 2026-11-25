---
id: T-0033
title: Survey skill drafts glossary, diagrams and ADRs
type: feat
breaking: false
scope: survey
status: resolved
spec: S-0006
depends_on: []
source: to-tickets
parent: none
diagrams: [workflow, data-flow]
released_in:
---

## Context

`setup` wires an existing codebase into the workflow but leaves it with no glossary, diagrams or ADRs, so the first `/shape` in a brownfield project has no shared terms or map. This ticket adds a new manual skill, `survey`, that reads an existing codebase and drafts what is missing. `setup` pointing to it is T-0034; the manual trial run is T-0035.

The two diagram edits for this skill are already in the working tree, uncommitted (`docs/diagrams/workflow.mmd`: a `/survey` node after `/setup`; `docs/diagrams/data-flow.mmd`: a `survey` node with its reads and writes). Check they match the skill as built and commit them with it.

## Decisions that apply

- **Manual skill**: `disable-model-invocation: true`, because it writes and commits. No odhyp block in `CLAUDE.md`: stop and say to run `/odhyp:setup`, as `diagram` does.
- **Inputs**: the code, git history, README and docs in scope.
- **Scope**: optional folder arguments (`/odhyp:survey src/api src/core`), default the whole repo. When the scope is too large to read well in one pass, stop and ask which folders to survey (a glossary drafted from skimmed code gives every later session wrong words).
- **Glossary**: read per ADR-0009 (skip silently when the `Glossary:` line or the file is missing; create the file at that path when the first term arrives). Entries follow `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md`, project-specific terms only. When the code uses two names for one thing, the most common becomes the term, the others go under `_Avoid_`, and the entry is flagged in the table for the user to confirm.
- **Diagrams**: drawn through the `diagram` skill (`odhyp:diagram`). Its description and its "create a diagram only when the user asks or `shape` calls for one" rule add `survey` as a caller.
- **ADRs**: written only where a commit, PR or code comment states the reason, from `${CLAUDE_PLUGIN_ROOT}/templates/adr.md`, numbered from the next free `ADR-NNNN`. Every other decision goes in the chat report as a one-line candidate (the decision and where it shows) for `/odhyp:to-adr`. No candidates file: a candidate has no reason, so it must not sit in the decisions folder looking like a record.
- **Review and commit** (ADR-0011): drafts on disk, uncommitted; chat shows only a table (file, kind, what it adds); revisions in a loop; only an explicit approval ends it. On approval, stage only this run's files and commit them in one `docs(survey): <subject>` commit (`git commit -- <files>`, never `git add -A`). A rejection deletes this run's files and nothing else. Never push.
- **Re-runs only add**: draft missing terms, diagrams and ADRs; never rewrite an existing entry, diagram or ADR. Where the code contradicts the glossary, a diagram or an ADR, list it in the report as a numbered finding for `/implement N`.
- **Testing**: no automated test of survey output; the trial run is T-0035.

Glossary:

**Survey**:
The **Manual skill** that reads an existing codebase and drafts its missing **Glossary** entries, **Diagrams** and decisions, so a brownfield project starts the workflow with shared terms.
_Avoid_: adopt, onboard, backfill

## Files

- `plugins/odhyp/skills/survey/SKILL.md` (new)
- `plugins/odhyp/skills/diagram/SKILL.md` (change: description and creation rule name `survey`)
- `README.md` (change: `survey` row in the skills table, Manual)
- `GLOSSARY.md` (change: `Survey` entry under `### Skills`)
- `docs/diagrams/workflow.mmd`, `docs/diagrams/data-flow.mmd` (change: already edited, verify and commit)

## Acceptance criteria

- [x] `survey/SKILL.md` covers every decision above: block check, scope arguments and the too-large stop, inputs, glossary rules incl. synonyms, diagrams via `diagram`, stated-reason ADRs, candidates in the report only, the ADR-0011 draft/table/loop/commit flow, add-only re-runs and drift findings.
- [x] Its description makes clear when to run it (an existing codebase without a glossary, diagrams or ADRs) and that only a person starts it.
- [x] `diagram/SKILL.md` lets `survey` create diagrams, in both the description and the body rule.
- [x] README row and `Survey` glossary entry added, using no `_Avoid_` word.
- [x] Both diagrams match the skill as built.
- [x] Every shell command in the skill runs in both sh and PowerShell 5.1.
- [x] `claude plugin validate .` and `claude plugin validate plugins/odhyp` pass.

## Out of scope

- `setup` suggesting `survey` (T-0034).
- Running it on real repos (T-0035).
- Rewriting or reconciling existing glossary entries, diagrams or ADRs.
- Importing trackers (`setup` does this).
- Writing the ADR for S-0006's decisions: on commit, `implement` offers `/odhyp:to-adr` for them.

## Questions

## Notes
Added `survey/SKILL.md` (block check, scope args with a too-large stop, inputs, glossary per ADR-0009 with flagged synonyms, diagrams via `diagram`, stated-reason ADRs, candidates in chat only, the ADR-0011 table/loop/commit, add-only re-runs, numbered drift findings). Beyond the ticket: before adding terms to an existing glossary it runs `git status --porcelain` on it and stops on uncommitted changes, as `to-adr` does, so `git commit -- <files>` does not sweep in the user's edits. A rejection also removes the terms it added to an existing glossary, since deleting that file would lose the user's entries. Shell commands (`git log --format="%h %s%n%b" -- <folders>`, `git status --porcelain -- <file>`) run in sh and PowerShell 5.1. Pre-edited diagrams checked against the skill, unchanged.
Fix now (review): a missing `Diagrams:` or `Decisions:` line now skips that kind and says to re-run `/odhyp:setup`.
Open (second review): 1. dropped or merged ADR drafts are not renumbered (ADR-0011), SKILL.md:47. 2. "PR" is named as a reason source but only `git log` is read, SKILL.md:31.
