<!-- odhyp:start -->
## odhyp skills
- Paths (specs, tickets, diagrams, releases): see polaris.json
- Ticket and spec format: locked frontmatter, free Markdown body (loaded by the odhyp skills)
- Test: {{test}} · Lint: {{lint}}
- Commits: Conventional Commits, enforced by .githooks/commit-msg
  (activate per clone: git config core.hooksPath .githooks)
  Format: type(scope)!: subject, footer `Refs: T-NNNN`
- Versioning: SemVer, starts at 0.1.0. Bumps are computed by /odhyp:release.
<!-- odhyp:end -->
