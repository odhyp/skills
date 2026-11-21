## This repo

- Commits: Conventional Commits (`type(scope)!: subject`).
- Releases: bump `VERSION` and `plugins/odhyp/.claude-plugin/plugin.json` together, and add a CHANGELOG entry.
- The plugin is `plugins/odhyp/`; everything else at the root is dev-only and never installed.
- Vocabulary: `GLOSSARY.md`. Decisions and their reasons: `docs/adr/`.

<!-- odhyp:start -->
## odhyp skills
- Paths (specs, tickets, diagrams, releases): see polaris.json
- Ticket and spec format: locked frontmatter, free Markdown body (loaded by the odhyp skills)
- Test: `sh tests/commit-msg.test.sh` · Lint: `claude plugin validate . && claude plugin validate plugins/odhyp`
- Commits: Conventional Commits, enforced by .githooks/commit-msg
  (activate per clone: git config core.hooksPath .githooks)
  Format: type(scope)!: subject, footer `Refs: T-NNNN`
- Never push. Commit locally; the user pushes.
- Versioning: SemVer, starts at 0.1.0. Bumps are computed by /odhyp:release.
<!-- odhyp:end -->
