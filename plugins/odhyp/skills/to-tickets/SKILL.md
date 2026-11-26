---
name: to-tickets
description: Split a spec (S-NNNN), review findings from this conversation, or a small change agreed in it, into self-contained tickets in the project's tickets folder.
disable-model-invocation: true
argument-hint: "[S-NNNN | finding numbers]"
---

Read the odhyp block in `CLAUDE.md` for the paths (No odhyp block: stop and say to run `/odhyp:setup`), then `${CLAUDE_PLUGIN_ROOT}/templates/TICKET-FORMAT.md`: the single source for fields, statuses, sections and both examples. Start each file from `${CLAUDE_PLUGIN_ROOT}/templates/ticket.md`.

**Glossary:** when the odhyp block has a `Glossary:` line and its file exists, read `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md`, then the file, and use its terms, never an `_Avoid_` word, in the breakdown and the tickets. When the line or the file is missing, skip the glossary silently.

**Input:** one of
- the spec `$ARGUMENTS` (S-NNNN);
- findings selected from this conversation, from `session-review`, `code-review` or `diagnose` (e.g. `$ARGUMENTS` = `2` or `1,3`);
- otherwise the small change agreed earlier in this conversation.

Without a spec, every ticket gets `spec: none`.

## 1. Break it down

Split into **vertical slices**: each ticket delivers something testable end to end and fits one fresh session. Order them and set `depends_on`. Work that needs a person (credentials, DNS, a design call, a manual test) becomes its own `ready-for-human` ticket.

Show the breakdown as a short list (title, type, depends on) and adjust it until the user agrees.

## 2. Draft each ticket

- **IDs:** next `T-` ID (see the ticket format), then onward in order.
- `source: to-tickets`, `parent: none`, `status: ready-for-agent` unless it needs a person.
- **From a finding:** `source: session-review` or `source: code-review`; `parent:` the reviewed ticket if there is one, else `none`. `## Context` quotes the finding's evidence from this session.
- **From a diagnose finding:** `type: fix` (or `perf` for slowness), `source: diagnose`, `parent: none`. Copy its `### Reproduction`, `### Expected / Actual`, `### Root cause` and `### Failing test to write first` into the `##` sections of the same names right after `## Context`, and its `### Constraints` into `## Decisions that apply`.
- **An `odhyp skill` finding outside the odhyp repo** (no `plugins/odhyp/.claude-plugin/plugin.json` at the repo root): the installed plugin is read-only, so print the ticket with `id: T-XXXX` for the user to number and copy into the odhyp repo; write nothing.
- **Self-contained:** a fresh agent with only this ticket must be able to finish it. Copy into `## Decisions that apply` every spec decision the ticket depends on; never write "see spec". Copy the glossary entries (from the spec's `## Design` or the shape summary's `## Glossary`) whose terms the ticket introduces, changes or removes into its `## Decisions that apply` under a `Glossary:` line, so each entry lands in exactly one ticket. Name the files, write checkable acceptance criteria, and fence the scope in `## Out of scope`.
- `diagrams` lists each existing diagram file whose code the ticket changes, or `[]`.
- A trivial-bug `fix` states its known cause in one line in `## Context` and skips the root-cause sections.

**Done when** every part of the spec (or the agreed change) is covered by exactly one ticket.

Write each ticket to `<tickets>/NNNN-short-slug.md`, uncommitted. In chat, show only a table (ID, title, type, depends on, path) and, under it, one line per ticket for anything it adds beyond the spec or the agreed change. The user reads the files themselves. For an `odhyp skill` finding outside the odhyp repo (see above) there are no files, so print those tickets in full; the rest are written as above.

## 3. Confirm

Ask the user to approve the tickets or ask for changes. For each revision request, edit the files and report one line per changed ticket saying what changed; reprint a printed ticket in full. When a revision drops or merges tickets, delete the files no longer used and renumber the rest of this run's files (file name, `id`, and every `depends_on` or mention that names them) so the IDs stay consecutive. Only an explicit approval ends the loop; a reply that approves and also asks for a change is a revision and needs another round. Never skip the loop. If the user rejects or drops the tickets, delete the files this run wrote, and nothing else.

## 4. Commit

On approval, commit the written tickets (an `odhyp skill` finding outside the odhyp repo has none, see step 2). No written tickets: skip this step.

1. If there is a spec: set its `tickets:` to the new IDs and `status: accepted`.
2. Stage only those files: `git add` the ticket files and the spec file. Never `git add -A`.
3. Commit only those files, so anything the user already had staged stays out: `git commit -m "docs(tickets): add T-NNNN to T-MMMM" -- <files>` (one ticket: `docs(tickets): add T-NNNN <slug>`), with no `Refs:` footer. Never push.

## 5. Report

List the tickets (ID, title, status, depends on) and give the commit hash, if any. Next step: `/clear`, then `/implement @<tickets>/NNNN-slug.md` for the first written ticket.
