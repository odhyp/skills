# Code review runs before the commit, in a forked subagent

Amended by ADR-0012.

`implement` calls `code-review` on the uncommitted diff. The review runs with `context: fork` and `background: false`, so it sees only the brief and the diff, not the implementer's reasoning, and `implement` waits for its verdict. A pass is committed together with the resolved ticket; a must-fix commits nothing, is written into the ticket's Notes, and the user re-runs `/implement`.

## Considered options

- **Review in the same context:** simplest, but the reviewer shares the implementer's blind spots.
- **Review after the commit, as its own session:** honest, but broken code lands in history and every must-fix costs a `/clear` and a new `/implement`. Kept only as an on-request mode.
- **Automatic fix loop inside `implement`:** rejected; the user decides when `implement` runs again, since it is a manual skill.
