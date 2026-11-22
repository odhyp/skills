---
name: to-tickets
description: Split a spec (S-NNNN), review findings from this conversation, or a small change agreed in it, into self-contained tickets in the project's tickets folder.
disable-model-invocation: true
argument-hint: "[S-NNNN | finding numbers]"
---

Read the odhyp block in `CLAUDE.md` for the paths (No odhyp block: stop and say to run `/odhyp:setup`), then `${CLAUDE_PLUGIN_ROOT}/templates/TICKET-FORMAT.md`: the single source for fields, statuses, sections and both examples. Start each file from `${CLAUDE_PLUGIN_ROOT}/templates/ticket.md`.

**Input:** one of
- the spec `$ARGUMENTS` (S-NNNN);
- findings selected from this conversation, from `session-review` or `code-review` (e.g. `$ARGUMENTS` = `2` or `1,3`);
- otherwise the small change agreed earlier in this conversation.

Without a spec, every ticket gets `spec: none`.

## 1. Break it down

Split into **vertical slices**: each ticket delivers something testable end to end and fits one fresh session. Order them and set `depends_on`. Work that needs a person (credentials, DNS, a design call, a manual test) becomes its own `ready-for-human` ticket.

Show the breakdown as a short list (title, type, depends on) and adjust it until the user agrees.

## 2. Write each ticket

- **IDs:** next `T-` ID (see the ticket format), then onward in order.
- `source: to-tickets`, `parent: none`, `status: ready-for-agent` unless it needs a person.
- **From a finding:** `source: session-review` or `source: code-review`; `parent:` the reviewed ticket if there is one, else `none`. `## Context` quotes the finding's evidence from this session.
- **An `odhyp skill` finding outside the odhyp repo** (no `plugins/odhyp/.claude-plugin/plugin.json` at the repo root): the installed plugin is read-only, so print the ticket with `id: T-XXXX` for the user to number and copy into the odhyp repo; write nothing.
- **Self-contained:** a fresh agent with only this ticket must be able to finish it. Copy into `## Decisions that apply` every spec decision the ticket depends on; never write "see spec". Name the files, write checkable acceptance criteria, and fence the scope in `## Out of scope`.
- `diagrams` lists each existing diagram file whose code the ticket changes, or `[]`.
- A trivial-bug `fix` states its known cause in one line in `## Context` and skips the root-cause sections.

**Done when** every part of the spec (or the agreed change) is covered by exactly one ticket.

## 3. Update the spec

If there is a spec: set its `tickets:` to the new IDs and `status: accepted`.

## 4. Report

List the tickets (ID, title, status, depends on). Next step: `/clear`, then `/implement @<tickets>/NNNN-slug.md` for the first ticket.
