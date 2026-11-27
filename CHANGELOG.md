# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.10.1] - 2026-11-27

### Fixed

- `implement` leaves a known state after every ticket-mode run (ADR-0016):
  - It refuses on a dirty tree, a red baseline or two failed runs.
  - It commits the ticket files when it stops because a ticket is unclear or needs splitting.
  - It records `Blocked:` when it is stuck on red.
  - It writes review findings to `## Notes` before any stop, and only a PASS commits.
- `implement` picks an answered `needs-info` ticket only when its `depends_on` tickets are resolved, and sets it `in-progress` before building.
- `to-spec` and `to-tickets` commit the diagrams `shape` drew, so `implement` in ticket mode no longer refuses on a dirty tree. TICKET-FORMAT lists `setup` as a status setter.
- `release` writes an exact date line in RELEASE.md.

Release notes: [docs/releases/v0.10.1](docs/releases/v0.10.1/RELEASE.md)

## [0.10.0] - 2026-11-26

### Added

- `survey` reads an existing codebase and drafts the missing glossary, diagrams and ADRs. It writes ADRs only from reasons it finds stated (T-0033).
- `setup` suggests `/odhyp:survey` for projects that already have code (T-0034).

### Changed

- `diagnose` ends like `shape`: a `# Diagnosis Summary` of numbered findings and a next step of `/implement N` or `/to-tickets N`, instead of writing and committing a ticket itself. `to-tickets`, `implement` and TICKET-FORMAT accept those findings (T-0037).

### Fixed

- Eight rules that contradicted each other across the odhyp skills and formats now agree, which fixes the survey → to-adr and implement → code-review handoffs (T-0036).
- `survey` renumbers dropped ADR drafts and reads PR merge commits (T-0033).

Release notes: [docs/releases/v0.10.0](docs/releases/v0.10.0/RELEASE.md)

## [0.9.0] - 2026-11-25

### Added

- A project glossary: `templates/GLOSSARY-FORMAT.md`, an optional `Glossary:` line in the CLAUDE.md odhyp block that `setup` fills, and this repo's `GLOSSARY.md` (T-0029).
- `shape`, `to-spec` and `to-tickets` read the glossary and use its terms and `_Avoid_` lists (T-0030).
- Glossary changes travel with the work: from the shape summary to the spec and the ticket, then `implement` writes them in the same commit as the code (T-0031).
- `to-spec` can split one design into several consecutive specs.
- `implement` applies the findings marked fix now after a review PASS, reruns test and lint, and reviews once more.

### Changed

- `to-spec` writes its drafts to disk and shows only a table. Rejecting deletes the files, and approving commits them in one commit.

### Fixed

- `to-spec` and `to-tickets` keep IDs consecutive when a revision drops one, and renumber only the specs or tickets from the current run.
- `shape` asks about edge cases when a small change copies a pattern or adds a loop, adapts that rule to any codebase, keeps the agreed cases in the brief, and doesn't count them toward the summary's line cap.
- `code-review` keeps its findings inside the diff and the brief.
- `implement` keeps the ticket findings from the first review when the second review blocks, and numbers the findings from both reviews as one list.

Release notes: [docs/releases/v0.9.0](docs/releases/v0.9.0/RELEASE.md)

## [0.8.0] - 2026-11-24

### Added

- `to-adr` writes an Architecture Decision Record into the decisions folder, from its template, and links it to the ADRs it supersedes or amends (T-0025).
- `implement` offers `/odhyp:to-adr` after it commits, and `shape` offers it when it ends with nothing to build (T-0026).

### Changed

- `setup` adds a `Decisions:` path to the CLAUDE.md odhyp block (default `<base>/adr`). Re-run `/odhyp:setup` to add it to your block (T-0024).
- `to-tickets` writes the drafts to disk and shows only a summary table.
- This repo's ADRs use one format for their supersede and amend link lines (T-0027).

### Fixed

- `setup` moves the decisions path when the base path changes (T-0024).
- `to-adr` links several old ADRs at once, guards their uncommitted edits, and puts back-links of one kind on one line below all link lines (T-0025).
- `to-tickets` applies the outside-repo exception per ticket, prints in full only the findings from odhyp skills, and handles runs where the tickets are only printed.
- The ticket and spec templates require plain-text titles, so a title that YAML would read as a keyword, a number or a date can no longer break the frontmatter.

Release notes: [docs/releases/v0.8.0](docs/releases/v0.8.0/RELEASE.md)

## [0.7.0] - 2026-11-24

### Changed

- `to-tickets` shows the full ticket drafts, waits for your approval, then writes and commits them (T-0020).
- `diagnose` shows the ticket draft, waits for your approval, then writes and commits it (T-0021).
- `implement` refusals name the ticket edit that unblocks the ticket, and say how to drop a ticket that blocks (T-0022).
- `implement` direct mode warns that must-fix findings exist only in this session and offers `/to-tickets` before `/clear` (T-0023).
- `shape` suggests `/implement this` for small in-session changes, and `implement` direct mode uses the shape summary's Done when and Tested by as its brief.

### Fixed

- `release` keeps `wontfix` tickets out of the bump and changelog (T-0019).
- `setup` reuses the files that already hold the version instead of creating `VERSION`, warns when a target folder is git-ignored, and offers to import an existing tracker.

Release notes: [docs/releases/v0.7.0](docs/releases/v0.7.0/RELEASE.md)

## [0.6.0] - 2026-11-23

### Changed

- `release` pushes the release commit and tag to the upstream after your OK. Re-run `/odhyp:setup` so your `CLAUDE.md` block allows it.

Release notes: [docs/releases/v0.6.0](docs/releases/v0.6.0/RELEASE.md)

## [0.5.0] - 2026-11-23

### Added

- `shape` explores a vague idea before sizing it, then exits to grilling or back to the user.

### Changed

- The workflow chart moved to `docs/diagrams/` (with a new data-flow diagram); the README links to it, merges its two Skills tables and drops the Roadmap (T-0017).
- The skills and templates no longer name Polaris or any outside reader of their files (ADR-0008, T-0018).

### Fixed

- `shape` prints the summary size line only once the work is sized, and states where it prints.
- `code-review` words suggested actions as suggestions in every mode.
- `implement` leaves fix-now findings to the user on a review pass.

Release notes: [docs/releases/v0.5.0](docs/releases/v0.5.0/RELEASE.md)

## [0.4.0] - 2026-11-23

### Changed

- `shape` sizes the work before grilling, asks at most 3 questions per round, and gives small changes a short checklist and summary with a direct `/implement` option.
- `code-review` opens its report with a title, a bold verdict (✅ PASS or ⛔ MUST-FIX) and a Findings heading.

### Fixed

- `shape` keeps the agreed test approach in the small-change summary.
- `session-review` and `code-review` put each finding under its own heading, so findings no longer run together in the terminal.

Release notes: [docs/releases/v0.4.0](docs/releases/v0.4.0/RELEASE.md)

## [0.3.0] - 2026-11-23

### Added

- `implement` has a direct mode for review findings and small requests, with no ticket needed (T-0011).

### Changed

- Tickets track work; they are not a prerequisite for it (ADR-0007, T-0009).
- `session-review` returns ranked findings and writes nothing; `to-tickets` accepts findings as input (T-0010).
- `code-review` grades findings by severity and writes no tickets (T-0012).
- `to-spec` confirms the spec in a loop, then commits it (T-0013).
- The README gives the one question each skill answers (T-0015).
- `implement` states what direct mode records and how it stages the commit (T-0016).

### Fixed

- `setup` drops `.gitkeep` and states the next-ID rule (T-0014).

Release notes: [docs/releases/v0.3.0](docs/releases/v0.3.0/RELEASE.md)

## [0.2.0] - 2026-11-22

### Added

- `implement` explains why the queue is empty or blocked (T-0004).
- `session-review` writes its skill ticket in the odhyp repo, with `source: session-review` (T-0005).

### Changed

- **Breaking:** project config moved from `polaris.json` into the odhyp block in `CLAUDE.md` (T-0001).
- The next-ID rule is stated once, in the format files (T-0003).
- The format files are marked as the public contract, with a README section (T-0006).

### Fixed

- `release` writes every version file and lists them in the confirmation (T-0002).
- The CLAUDE.md block template puts each version file in its own code span (T-0008).

Release notes: [docs/releases/v0.2.0](docs/releases/v0.2.0/RELEASE.md)

## [0.1.1] - 2026-11-21

### Changed

- Version bump so existing installs pick up the `plugins/odhyp/` layout; no skill changes.

## [0.1.0] - 2026-11-21

### Added

- Plugin and marketplace manifests, README, VERSION.
- Skills: setup, shape, to-spec, to-tickets, diagnose, diagram, implement, code-review, release, session-review.
- `plugins/odhyp/templates/`: ticket and spec formats with blank templates, `diagram.mmd`, `polaris.json`, the CLAUDE.md block and the commit-msg hook, shared with Polaris.
- ADRs 0001-0005 and the glossary.
- CI (hook test, plugin validation) and a manual `code-review` smoke test.
