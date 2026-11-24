<!-- odhyp:start -->
## odhyp skills
- Specs: `{{specs}}`
- Tickets: `{{tickets}}`
- Diagrams: `{{diagrams}}`
- Releases: `{{releases}}`
- Version files: {{version_files}}
- Changelog: `{{changelog}}`
- Ticket and spec format: locked frontmatter, free Markdown body (loaded by the odhyp skills)
- Next ID: one above the highest `NNNN` in the folder and in `{{releases}}/*/`; start at 0001 when there is none.
- Test: {{test}} · Lint: {{lint}}
- Commits: Conventional Commits, enforced by .githooks/commit-msg
  (activate per clone: git config core.hooksPath .githooks)
  Format: type(scope)!: subject, footer `Refs: T-NNNN`
- Commit locally. Push nothing yourself; only the user, or /odhyp:release after the user's OK.
- Versioning: SemVer. The current version is in the first file under Version files; /odhyp:release computes the bumps.
<!-- odhyp:end -->
