---
name: release
description: Cut a release. Computes the SemVer bump from resolved tickets and commits, updates the version and CHANGELOG, archives tickets and specs, then commits, tags and pushes after confirmation.
disable-model-invocation: true
---

Read the odhyp block in `CLAUDE.md` for the paths, the version files, the changelog and the test and lint commands (No odhyp block: stop and say to run `/odhyp:setup`), and `${CLAUDE_PLUGIN_ROOT}/templates/TICKET-FORMAT.md` and `${CLAUDE_PLUGIN_ROOT}/templates/SPEC-FORMAT.md`.

## 1. Preconditions

Stop and report if any fails:
- the working tree is clean;
- the test and lint commands pass;
- no ticket is `in-progress`.

## 2. Collect

- **Last tag:** `git describe --tags --abbrev=0` (none → everything since the first commit). Current version: the primary version file (the first under `Version files:`).
- **Tickets:** every `resolved` ticket in the tickets folder (they have no `released_in` yet), and every `wontfix` ticket.
- **Commits** since the last tag: their type, `!`, and any `BREAKING CHANGE:` footer. Commits catch work done without a ticket.

## 3. Compute the bump

From the tickets and commits together:

1. Anything breaking (`breaking: true`, `!`, `BREAKING CHANGE:`): **major**, but **minor** while the version is below 1.0.0.
2. Otherwise any `feat`: **minor**.
3. Otherwise any `fix` or `perf`: **patch**.
4. Otherwise nothing is releasable: say so and stop.

## 4. Confirm

Show the proposed version, the bump reason (which ticket or commit decided it), every file whose version will change (each one under `Version files:`, plus `package.json`/`pyproject.toml` when present), the full CHANGELOG entry, and the remote and branch the release will be pushed to (no upstream: say it will not be pushed). **Wait for the user's OK**; it covers the commit, the tag and the push. Write, commit, tag and push nothing before it; apply any change they ask for and show it again.

## 5. Write

- The new version into every file under `Version files:` (replace the version string in each), and the version field in `package.json` or `pyproject.toml` when present.
- The changelog: a `## [X.Y.Z] - YYYY-MM-DD` section below `## [Unreleased]`, with the release's entries grouped as Added / Changed / Fixed / Removed, plus a line linking to the release folder. Move any hand-written `[Unreleased]` entries into it.
- `released_in: vX.Y.Z` on every ticket being archived.
- A spec whose tickets are now all `resolved` or `wontfix`: `status: done`.

## 6. Archive

Move into `<releases>/vX.Y.Z/`:
- `tickets/`: the `resolved` and `wontfix` tickets;
- `specs/`: the `done` specs.

Write `<releases>/vX.Y.Z/RELEASE.md`: the version, the date, a two-line summary, and the tickets by type (ID and title) and the specs archived.

## 7. Commit, tag and push

Commit everything as `chore(release): vX.Y.Z`, then `git tag vX.Y.Z`, then push both at once to the current branch's upstream. Read it with `git rev-parse --abbrev-ref --symbolic-full-name @{u}` (prints `<remote>/<branch>`; the remote is the part before the first `/`), and push with `git push --atomic <remote> HEAD:<branch> vX.Y.Z`. Report the commit, the tag and the push.

No upstream (that command fails), or the push is rejected: keep the local commit and tag, report the error and the push command to run, and stop. Never force-push or retry.
