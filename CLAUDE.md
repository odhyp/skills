## This repo

- Commits: Conventional Commits (`type(scope)!: subject`).
- On Windows/Git Bash, make literal text edits with the Edit tool; sed, perl and heredoc escaping mangled `/` and `\n` here.
- Releases: bump `VERSION` and `plugins/odhyp/.claude-plugin/plugin.json` together, and add a CHANGELOG entry.
- The plugin is `plugins/odhyp/`; everything else at the root is dev-only and never installed.
- Vocabulary: `GLOSSARY.md`. Decisions and their reasons: `docs/adr/`.

<!-- odhyp:start -->
## odhyp skills
- Specs: `docs/specs`
- Tickets: `docs/tickets`
- Diagrams: `docs/diagrams`
- Releases: `docs/releases`
- Version files: `VERSION`, `plugins/odhyp/.claude-plugin/plugin.json`
- Changelog: `CHANGELOG.md`
- Ticket and spec format: locked frontmatter, free Markdown body (loaded by the odhyp skills)
- Next ID: one above the highest `NNNN` in the folder and in `docs/releases/*/`; start at 0001 when there is none.
- Test: `sh tests/commit-msg.test.sh` · Lint: `claude plugin validate . && claude plugin validate plugins/odhyp`
- Commits: Conventional Commits, enforced by .githooks/commit-msg
  (activate per clone: git config core.hooksPath .githooks)
  Format: type(scope)!: subject, footer `Refs: T-NNNN`
- Never push. Commit locally; only the user and /odhyp:release (after the user's OK) push.
- Versioning: SemVer, starts at 0.1.0. Bumps are computed by /odhyp:release.
<!-- odhyp:end -->
