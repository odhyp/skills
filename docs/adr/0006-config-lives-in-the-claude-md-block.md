# The project config lives in the CLAUDE.md block

Supersedes ADR-0005.

The odhyp block in `CLAUDE.md` (between `<!-- odhyp:start -->` and `<!-- odhyp:end -->`) names the specs, tickets, diagrams and releases folders, the version files and the changelog, one `Label: value` line each, so an agent or a parser can read them. Every skill reads paths from it, and a skill that finds no block stops and says to run `/odhyp:setup`. There is no fallback to `polaris.json`: two sources of the same paths drift. Reasons: agents load `CLAUDE.md` anyway, nothing in the project names Polaris, and the block is the single place paths live. Polaris is an optional helper and keeps its own config in its app data, not in the repo; a leftover `polaris.json` belongs to Polaris and odhyp neither reads nor deletes it.
