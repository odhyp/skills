# implement leaves a known state after every run

In ticket mode, every `implement` run ends in one of three states. The ticket is committed. Or the tree is clean, because a stop committed its ticket files as a `chore` and discarded the code. Or the ticket is `in-progress` and the uncommitted code is its own. Every finding and every reason for stopping is written to the ticket, never only to chat. To keep that true, `implement` refuses, before changing anything, to start a ticket that isn't `in-progress` while the tree is dirty or the test and lint commands are already red. It also refuses an `in-progress` ticket whose `## Notes` holds two failed runs (`Must-fix (review):` or `Blocked:`). That refusal names three ways out, and each one ends in a commit or a retry. Before this, a stop left uncommitted changes behind. The next ticket's review then judged them as part of its own diff. Non-blocking findings were lost on `/clear`, red tests had no way out, and nothing capped a ticket that kept failing review. A dirty tree or a red baseline also makes it impossible to tell what this run broke. A known state after every run lets a fresh session, or a loop of bare `/implement` runs, pick up from the files and git alone.

## Considered options

- Commit whatever is dirty and carry on: it would commit changes nobody reviewed, from work that isn't this ticket's.
- Discard the code when the tests stay red: it throws away work that is nearly done; the ticket stays `in-progress` with a `Blocked:` entry instead.
- A new status for a ticket that failed twice: `ready-for-human` means work for a person, not half-built work, and a new status would change the locked ticket format; a refusal based on `## Notes` needs neither.

## Consequences

- A skill or person changing a ticket file (answering `## Questions`, setting `wontfix` or `resolved`) commits it, or the next bare `/implement` refuses on the dirty tree.
- Any loop over `implement` (such as a future autopilot) stops when a run adds no commit. It must not retry a refused ticket or clear its `## Notes` entries itself.
- The baseline test and lint run costs one extra run per new ticket, and the cost is accepted.
