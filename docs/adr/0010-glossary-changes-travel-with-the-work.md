# Glossary changes travel with the work and land in the code's commit

Amends ADR-0009.

Terms are coined while shaping, so glossary changes move along the existing pipeline instead of through a skill of their own. `shape` lists new, changed and removed terms in a `## Glossary` section of its summary, for features and small changes alike, and only when there are some. `to-spec` copies that list into the spec's `## Design`. `to-tickets` copies each entry into the one ticket that introduces, changes or removes the term. `implement` applies the entries from its brief to the glossary file in the same commit as the code: it adds new terms, rewrites changed ones, and deletes removed ones along with every mention of them. It creates the file with a `# Glossary` H1 when the first term arrives. When the odhyp block has no `Glossary:` line, it writes nothing and says nothing. Each ticket carries its own entries, so a fresh `implement` needs nothing beyond the ticket, and a term lands in the same commit as the code that gives it meaning. `implement` opens the glossary only to apply these entries and otherwise never reads it.

## Considered options

- A separate `/to-glossary` skill: rejected. It would be one more manual step, and people would forget it.

## Consequences

- A skill that creates terms passes them along in its output; only `implement` writes the glossary file.
- A removed term is deleted, never marked stale.
- `code-review` does not check that the listed terms reached the glossary.
