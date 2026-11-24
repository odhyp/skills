# The skills know no outside reader

Amends ADR-0003, ADR-0004.

The skills and the formats in `plugins/odhyp/templates/` do not name or depend on any tool that reads their output. The frontmatter stays locked because the odhyp skills parse it, not because something else does. A tool that reads these files, such as Polaris, documents what it reads on its own side. Reasons: the skills never called Polaris, so naming it was noise that coupled this repo to another one and made each format change look like a change to both. Going forward this replaces the Polaris references in ADRs 0003 and 0004; those ADRs stay as written for the record.
