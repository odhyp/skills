---
name: implement
description: Build one ticket test-first, get it reviewed, and commit it. The only odhyp skill that writes code.
disable-model-invocation: true
argument-hint: "@<tickets>/NNNN-slug.md"
---

Read the odhyp block in `CLAUDE.md` for the paths and the test and lint commands, then read `TICKET-FORMAT.md`.

## 1. Pick the ticket

The ticket is `$ARGUMENTS`. With no argument, pick the next eligible one: an `in-progress` ticket first, otherwise the lowest-numbered `ready-for-agent` ticket whose `depends_on` are all `resolved`. State its ID and title.

Refuse and stop when:
- it is `resolved` or `wontfix`: say so;
- it is `needs-info`: show its `## Questions`;
- it is `ready-for-human`: say what the person has to do;
- any `depends_on` ticket is not `resolved`: list them.

If it is `in-progress`, check `git status` and the ticket's `## Notes`, and resume from where the work stopped. Otherwise set `status: in-progress`.

## 2. Build, test-first

The ticket is the whole brief: build exactly its acceptance criteria, inside its `## Decisions that apply` and `## Out of scope`. Read the spec only as background.

For each acceptance criterion: write the test, run it and watch it go **red**, write the code that turns it **green**, refactor. A `fix` ticket starts with its `## Failing test to write first`.

Then run the full test and lint commands from the odhyp block. **Done when** both are clean.

**Never guess.** When the ticket turns out to be:
- **unclear**: set `status: needs-info`, write the questions under `## Questions`, and stop;
- **too big** for one session: narrow this ticket to a first slice that fits, write the rest as new self-contained tickets (`from:` this ticket, `source: implement`, depending on it), note the split in `## Notes`, set this ticket back to `ready-for-agent`, and stop. The narrowed ticket starts in a fresh session.

## 3. Keep the records true

- If `diagrams` is not empty, update those diagrams using the **diagram** skill.
- If the work proved the spec wrong, add an entry under the spec's `## Decisions`: `date · T-NNNN · what changed and why`.

## 4. Review

Run the odhyp **code-review** skill (`odhyp:code-review` when installed as a plugin) with the ticket ID as its argument. It reviews the uncommitted diff in a fresh context.

- **MUST-FIX:** fix every finding, re-run tests and lint, and run the review again.
- **PASS:** continue. Its follow-up tickets are already written; leave them for later.

## 5. Commit

**Definition of done:** review passes, tests pass, lint is clean, every acceptance criterion is checked off, `## Notes` says what was done (and anything a later reader needs), and `status: resolved`.

Stage the code, the tests, the ticket file and any diagram, spec or follow-up ticket files, and commit them together:

```
type(scope)!: subject

Refs: T-NNNN
```

`type`, `scope` and `!` (only when `breaking: true`) come from the ticket. Commit to the current branch.

Report the commit hash and any follow-up tickets. Next step: `/clear` (optionally `/session-review` first), then the next ticket.

A must-fix found after this commit goes back through the ticket: it returns to `ready-for-agent` with the findings in `## Notes`, and its fix is a further commit with the same `Refs:` line.
