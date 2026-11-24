---
id: S-0003
title: Confirm and commit tickets, and name the way out of a blocked ticket
status: draft
tickets: []
---

## Problem

`to-spec` confirms its spec with the user and commits it. `to-tickets` and `diagnose` write ticket files without either step. Uncommitted tickets pile up, and `/release` then refuses to run because the working tree isn't clean. Today these tickets are committed by hand.

`implement` refuses `ready-for-human` and `needs-info` tickets but doesn't say what unblocks them. The ticket format says a person sets those statuses, and `wontfix`, by editing the ticket, but nothing tells the user that at the moment they're stuck.

In direct mode, a must-fix review is reported only in chat. A `/clear` loses the findings.

## Goals / Non-goals

- Goal: every ticket a skill writes is approved by the user and committed by that skill.
- Goal: every `implement` refusal says what edit unblocks the ticket.
- Goal: direct-mode must-fix findings survive a `/clear` if the user wants them to.
- Non-goal: amending an accepted spec.
- Non-goal: a ticket overview or board. That belongs to Polaris, which reads these files on its own side (ADR 0008).
- Non-goal: new commit-hook tests. The hook checks only the `type(scope): subject` line and never requires `Refs:`, so the new messages already pass.
- Non-goal: diagram changes. Neither diagram draws commits or confirmation loops.

## Design

1. **`to-tickets` confirms and commits.** The breakdown step stays as it is. After the user agrees to the breakdown, the skill shows every ticket in full (frontmatter and body) and writes nothing. Each revision request is applied and all the tickets are shown again. Only an explicit approval ends the loop, and a reply that approves but also asks for a change counts as a revision. On approval, it writes the tickets and the updated spec (`tickets:` and `status: accepted`), then commits only those files: `git commit -m "docs(tickets): add T-NNNN to T-MMMM" -- <files>`, with no `Refs:` footer. It never pushes. This mirrors `to-spec`, and committing only the listed files leaves anything the user had staged out of the commit.
   - Exception: an odhyp-skill finding outside the odhyp repo still prints the ticket and writes nothing, so it has nothing to commit.
2. **`diagnose` confirms and commits.** After the root cause, it shows the full ticket draft and writes nothing. It runs the same approval loop as `to-spec`. On approval, it writes the ticket and commits only that file as `docs(tickets): add T-NNNN <slug>`, with no `Refs:` footer. Its working-tree rule becomes "as you found it, plus the committed ticket." Temporary logging is still reverted before the draft is shown.
3. **`implement` refusals name the unblocking edit.**
   - `ready-for-human`: say what the person has to do, then to set `status: resolved` (done by hand) or `ready-for-agent` (an agent builds it) in the ticket's path, and commit.
   - `needs-info` with unanswered questions: show them, and say to answer them under `## Questions`.
   - Wherever a ticket is refused or blocks others, add one line on dropping it: set `status: wontfix` with the reason in `## Notes`.
   - The person still sets these statuses, as the ticket format says. `implement` only names the edit.
4. **Direct-mode must-fix warns before a `/clear`.** On a MUST-FIX verdict in direct mode, `implement` still commits nothing and reports the findings. It also says the findings exist only in this session and offers `/to-tickets N` before `/clear`. It still creates no ticket unless the user asks.
5. **Delivery.** There is one ticket per design item (1–4). Each is type `feat` and not breaking, so the next release is a minor bump. Each is checked by the lint command and by reading the changed skill, since skill text has no red/green test. A ticket that changes a skill's behaviour also updates that skill's row in the README table.

## Decisions
