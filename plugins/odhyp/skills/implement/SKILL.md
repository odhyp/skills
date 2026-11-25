---
name: implement
description: Build one ticket, or a direct request such as a review finding or a small refactor, test-first; get it reviewed and commit it. The only odhyp skill that writes code.
disable-model-invocation: true
argument-hint: "@<tickets>/NNNN-slug.md | T-NNNN | finding 1 | 1,3 | all | <request>"
---

Read the odhyp block in `CLAUDE.md` for the paths and the test and lint commands (No odhyp block: stop and say to run `/odhyp:setup`), and `${CLAUDE_PLUGIN_ROOT}/templates/TICKET-FORMAT.md`.

**Mode** comes from `$ARGUMENTS`:
- starts with `T-` or `@<tickets>/`, or is empty: **ticket mode**;
- anything else (`finding 1`, `1`, `1,3`, `all`, free text): **direct mode**, for small, well-understood work found in this session.

Each step below says what differs in direct mode.

## 1. Pick the work

### Ticket mode

The ticket is `$ARGUMENTS`. With no argument, pick the next eligible one: an `in-progress` ticket first, otherwise the lowest-numbered `ready-for-agent` ticket whose `depends_on` are all `resolved`. State its ID and title.

- `needs-info` with every item under `## Questions` answered: set `status: ready-for-agent` and continue.
- `in-progress`: resume. Check `git status` and `## Notes`; must-fix findings from an earlier review are listed there, and fixing them comes first.
- Otherwise set `status: in-progress`.

Refuse, change no ticket, and stop when:
- it is `resolved` or `wontfix`: say so;
- it is `needs-info` with unanswered questions: show them, and say to answer them inline under `## Questions` in the ticket's file path; the next `/implement` then sets `ready-for-agent`;
- it is `ready-for-human`: say what the person has to do, then to set `status: resolved` (done by hand) or `status: ready-for-agent` (an agent should build it) in the ticket's file path, and commit;
- any `depends_on` ticket is not `resolved`: list them.

With no argument and no eligible ticket, change nothing and stop:
- no open tickets (every ticket is `resolved` or `wontfix`): say so and point to `/shape` for new work;
- otherwise: list each open ticket with the refusal reason above that blocks it.

After a `needs-info`, `ready-for-human` or `depends_on` refusal, or the open-ticket list, add one line: to drop a blocking ticket instead, set `status: wontfix` in its file with the reason under `## Notes`.

### Direct mode

Restate the selected finding(s) from this session, or the request, as one or two lines of expected outcome: the **brief**. A request like `this` means the session's last `# Shape Summary`; its `## Done when` and `## Tested by` are the brief. State it before building. Keep the scope to what was asked.

Ask instead of building when the request is ambiguous; when it has significant architectural implications, send the user to `/shape`.

## 2. Build, test-first

In ticket mode, the ticket is the whole brief: build exactly its acceptance criteria, inside its `## Decisions that apply` and `## Out of scope`. Read the spec only as background. In direct mode, build exactly the brief.

For each acceptance criterion (direct mode: each expected outcome): write the test, run it and watch it go **red**, write the code that turns it **green**, refactor. A `fix` ticket starts with its `## Failing test to write first`. Changes with no testable behaviour (docs, skill text) skip red/green.

Then run the full test and lint commands, in both modes. **Done when** both are clean.

**Never guess.** When the ticket turns out to be:
- **unclear**: set `status: needs-info`, write the questions under `## Questions`, and stop;
- **too big** for one session: narrow this ticket to a first slice that fits, write the rest as new self-contained tickets (`parent:` this ticket, `source: implement`, depending on it), note the split in `## Notes`, set this ticket back to `ready-for-agent`, and stop.

In direct mode: unclear → ask the user and stop; too big → stop and suggest `/to-tickets`. Direct mode never creates a ticket unless the user asks.

## 3. Keep the records true

- If `diagrams` is not empty, update those diagrams using the **diagram** skill.
- **Glossary:** when the brief (ticket, or in direct mode the shape summary's `## Glossary`) lists glossary entries and the odhyp block has a `Glossary:` line, read `${CLAUDE_PLUGIN_ROOT}/templates/GLOSSARY-FORMAT.md` and apply them to that file: add new terms, rewrite changed ones, and delete removed ones with every mention of them. A missing file is created with a `# Glossary` H1 when the first term arrives. No `Glossary:` line: write nothing and say nothing. The glossary file is committed with the code in step 5. Do not otherwise read the glossary.
- If the work proved the spec wrong, add an entry under the spec's `## Decisions`: `date · T-NNNN · what changed and why`.
- Check off the acceptance criteria and append to `## Notes` what was done and anything a later reader needs.

In direct mode there is no ticket to update; still update any diagram the work makes wrong, and add an entry under the `## Decisions` of any spec the work proves wrong: `date · what changed and why` (put `T-NNNN ·` after the date only when the findings came from a review of that ticket).

## 4. Review

Run the odhyp **code-review** skill (`odhyp:code-review`) with the ticket ID as its argument (direct mode: the brief). It reviews the uncommitted diff in a fresh context and returns a verdict and ranked findings; it changes nothing.

- **MUST-FIX:** commit nothing. Add the Critical and High findings under `## Notes` as `Must-fix (review):` with each `path:line` and required change, keep `status: in-progress`, and stop. Tell the user the findings and that the next step is `/implement` on this ticket again. In direct mode: commit nothing, report the findings, say they exist only in this session and a `/clear` loses them, offer `/to-tickets N` (N = the finding numbers) to keep them or `/implement N` to fix them now, and stop.
- **PASS:** if there are Medium or Low findings marked `fix now`, apply them (ticket mode: note them under `## Notes`), get the test and lint commands clean as in step 2, and run code-review once more on the new diff; its verdict decides as above, but a second PASS changes nothing further, and a second MUST-FIX also reports the first review's `ticket` findings to the user (ticket mode: also under `## Notes`). Then continue to step 5 and commit the diff as reviewed.

## 5. Commit

Set `status: resolved`. Stage the code, the tests, the ticket file and any diagram, spec or glossary files, and commit them together:

```
type(scope)!: subject

Refs: T-NNNN
```

`type`, `scope` and `!` (only when `breaking: true`) come from the ticket. Commit to the current branch.

In direct mode there is no ticket status to set; stage the code, the tests and any diagram, spec or glossary files. Pick `type` and `scope` from the change and commit `type(scope): subject` with no `Refs:` footer, unless the findings came from a review of ticket T-NNNN: then add `Refs: T-NNNN`. Findings that share type and scope share one commit; otherwise one commit each.

## 6. Stop

Report the commit hash(es), then one line per `fix now` finding applied, then the open non-blocking findings: the first review's `ticket` findings and every finding of the second review, as returned. In both modes, when the ticket, its spec (read `## Design` and `## Decisions` both: `## Decisions` holds only changes made during implementation) or the direct brief settled a decision worth keeping that no ADR in the decisions folder (`Decisions:` in the odhyp block) covers, offer `/odhyp:to-adr` in one line; never run it yourself. Then end. The user decides what comes next: `/implement N` or `/to-tickets N` on a finding, `/session-review`, or `/clear`.
