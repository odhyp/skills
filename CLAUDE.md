## This repo

- Commits: Conventional Commits (`type(scope)!: subject`).
- On Windows/Git Bash, make literal text edits with the Edit tool; sed, perl and heredoc escaping mangled `/` and `\n` here.
- Releases: bump `VERSION` and `plugins/odhyp/.claude-plugin/plugin.json` together, and add a CHANGELOG entry.
- Shell commands written into skills must run in both sh and PowerShell 5.1 (quote `@{...}`; no `&&`, `||` or `VAR=x cmd`); run each in both before committing.
- The plugin is `plugins/odhyp/`; everything else at the root is dev-only and never installed.
- Vocabulary: `GLOSSARY.md`. Decisions and their reasons: `docs/adr/`.

<!-- odhyp:start -->
## odhyp skills
- Specs: `docs/specs`
- Tickets: `docs/tickets`
- Diagrams: `docs/diagrams`
- Releases: `docs/releases`
- Decisions: `docs/adr`
- Version files: `VERSION`, `plugins/odhyp/.claude-plugin/plugin.json`
- Changelog: `CHANGELOG.md`
- Ticket and spec format: locked frontmatter, free Markdown body (loaded by the odhyp skills)
- Next ID: one above the highest `NNNN` in the folder and in `docs/releases/*/`; start at 0001 when there is none.
- Test: `sh tests/commit-msg.test.sh` · Lint: `claude plugin validate . && claude plugin validate plugins/odhyp`
- Commits: Conventional Commits, enforced by .githooks/commit-msg
  (activate per clone: git config core.hooksPath .githooks)
  Format: type(scope)!: subject, footer `Refs: T-NNNN`
- Commit locally. Push nothing yourself; only the user, or /odhyp:release after the user's OK.
- Versioning: SemVer. The current version is in the first file under Version files; /odhyp:release computes the bumps.
<!-- odhyp:end -->
