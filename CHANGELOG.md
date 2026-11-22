# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

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
