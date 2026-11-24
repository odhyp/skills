# Templates live once at the repo root, so the skills install only as a plugin

Amended by ADR-0008.

The ticket, spec and diagram formats, the CLAUDE.md block and the commit hook live in `plugins/odhyp/templates/`. It is the single source of truth for both the skills and Polaris, which parses the same frontmatter. Skills reach it through `${CLAUDE_PLUGIN_ROOT}/templates/`, which Claude Code fills in only for plugin skills. So the skills are installed globally as a Claude Code plugin, and `npx skills add` is not supported.

## Consequences

The ticket and spec frontmatter is locked: changing a field is a breaking change for this repo and Polaris together.
