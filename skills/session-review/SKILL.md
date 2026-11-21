---
name: session-review
description: Review this session before /clear and suggest improvements to CLAUDE.md and to the odhyp skills.
disable-model-invocation: true
---

Run before `/clear`: the evidence is this session's history, and `/clear` erases it.

## 1. Find the friction

Go through the session and list each moment that cost time or went wrong:
- retries: a command, edit or approach that had to be repeated;
- wrong assumptions: about the code, the tools, the paths or the user's intent;
- corrections: anything the user had to say twice, or overrule;
- missing context: something the agent had to search for, ask, or guess that a line in a file would have given.

For each, name the cause in one line and where the fix belongs: the project's `CLAUDE.md`, or an odhyp skill.

## 2. Propose

- **CLAUDE.md:** show each proposed edit as a diff. Apply the ones the user approves; apply nothing unapproved.
- **odhyp skills:** the installed plugin is read-only, so print one ticket for the odhyp skills repo in the ticket format (`TICKET-FORMAT.md`), with `source: human` and `id: T-XXXX` for the user to number. Its `## Context` quotes the moment from this session; its acceptance criteria name the skill and the change.

If the session ran smoothly, say so in one line and propose nothing.

Write no other files.
