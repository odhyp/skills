---
name: to-tickets
description: Split a spec (S-NNNN), or a small change agreed in this conversation, into self-contained tickets in the project's tickets folder.
disable-model-invocation: true
argument-hint: "[S-NNNN]"
---

Read the odhyp block in `CLAUDE.md` for the paths, then read `TICKET-FORMAT.md`. It is the single source for fields, statuses, sections and both examples.

**Input:** the spec `$ARGUMENTS` if given, otherwise the small change agreed earlier in this conversation (then every ticket gets `spec: none`).

## 1. Break it down

Split into **vertical slices**: each ticket delivers something testable end to end and fits one fresh session. Order them and set `depends_on`. Work that needs a person (credentials, DNS, a design call, a manual test) becomes its own `ready-for-human` ticket.

Show the breakdown as a short list (title, type, depends on) and adjust it until the user agrees.

## 2. Write each ticket

- **IDs:** the highest existing `T-` ID in the tickets folder and the releases archive, plus one, then onward in order.
- `source: to-tickets`, `from: none`, `status: ready-for-agent` unless it needs a person.
- **Self-contained:** a fresh agent with only this ticket must be able to finish it. Copy into `## Decisions that apply` every spec decision the ticket depends on; never write "see spec". Name the files, write checkable acceptance criteria, and fence the scope in `## Out of scope`.
- `diagrams` lists each diagram file the ticket changes (from the spec's `## Diagrams affected`, or your own judgement for a small change).
- A trivial-bug `fix` states its known cause in one line in `## Context` and skips the root-cause sections.

**Done when** every part of the spec (or the agreed change) is covered by exactly one ticket.

## 3. Update the spec

If there is a spec: set its `tickets:` to the new IDs and `status: accepted`.

## 4. Diagrams

If any ticket's `diagrams` is not empty, use the **diagram** skill to update those diagrams to the design just agreed.

## 5. Report

List the tickets (ID, title, status, depends on). Next step: `/clear`, then `/implement @<tickets>/NNNN-slug.md` for the first ticket.
