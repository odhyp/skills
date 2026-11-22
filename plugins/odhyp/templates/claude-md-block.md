<!-- odhyp:start -->
## odhyp skills
- Specs: `{{specs}}`
- Tickets: `{{tickets}}`
- Diagrams: `{{diagrams}}`
- Releases: `{{releases}}`
- Version files: {{version_files}}
- Changelog: `{{changelog}}`
- Ticket and spec format: locked frontmatter, free Markdown body (loaded by the odhyp skills)
- Test: {{test}} · Lint: {{lint}}
- Commits: Conventional Commits, enforced by .githooks/commit-msg
  (activate per clone: git config core.hooksPath .githooks)
  Format: type(scope)!: subject, footer `Refs: T-NNNN`
- Never push. Commit locally; the user pushes.
- Versioning: SemVer, starts at 0.1.0. Bumps are computed by /odhyp:release.
<!-- odhyp:end -->
