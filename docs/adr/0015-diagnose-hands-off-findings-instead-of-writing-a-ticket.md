# Diagnose hands off its findings instead of writing a ticket

Amends ADR-0001.

`diagnose` writes and commits nothing. It ends with a `# Diagnosis Summary` of numbered findings, each with its reproduction, expected and actual behaviour, root cause, failing test to write first, and constraints. A `## Next step` sends small, clear fixes that aren't architectural to `/implement N` and everything else to `/to-tickets N`. `to-tickets` then writes a `fix` ticket with `source: diagnose`. `diagnose` is the same kind of skill as `shape`: both settle what the work is before any ticket exists. `shape` gets the answers from the user and `diagnose` gets them from the code. Only `shape` handed off, so the two ended differently for no reason, and a small fix found by `diagnose` could not go straight to `/implement` as ADR-0007 allows. The confirm loop moves to `to-tickets`, which already has one.

## Consequences

- The summary exists only in the session, so the user must run the next skill before `/clear`.
- An `odhyp skill` finding outside the odhyp repo gets only `/to-tickets N`, because the installed plugin is read-only.
- `this` in `/implement` still means only the last `# Shape Summary`; a diagnosis is picked by finding number.
