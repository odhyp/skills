# Glossary format

This format is the contract the odhyp skills write and read.

A glossary fixes the project's own words, so every fresh session uses the same term for the same thing and specs and tickets stay consistent. One file per project, path in the `Glossary:` line of the odhyp block in `CLAUDE.md`. The line and the file are both optional: with either missing, skills skip the glossary silently.

A glossary has no frontmatter.

## Layout

- A `#` H1 (`# Glossary` when a skill creates the file), optionally followed by one line saying what the project is.
- Entries sit in `###` groups of related terms (e.g. `### Work items`).
- An optional `## Relationships` section at the end: one bullet per rule linking terms (`A **Spec** has one or more **Tickets**`).

## Entries

```markdown
**Term**:
One-line definition, using other **Terms** in bold.
_Avoid_: synonym, synonym
```

- `**Term**:` on its own line, the definition on the next, one line only.
- `_Avoid_:` lists rejected synonyms, comma-separated. Leave the line out when there are none.
- One blank line between entries.

## Rules

- **Project-specific terms only.** Add a word only when this project gives it a meaning of its own or picked it over synonyms. Nothing the model already knows (`API`, `database`, `commit`).
- **Delete, don't mark stale.** When a term goes away, delete its entry and every mention of it. A stale entry misleads agents worse than no entry.
- **One meaning per term.** When a term changes meaning, rewrite its entry; never keep both.

## Example

```markdown
# Glossary

A shop for second-hand bikes.

### Catalogue

**Listing**:
One bike offered for sale, with its photos and asking price.
_Avoid_: product, item, ad

**Seller**:
The person who created a **Listing**; not necessarily the bike's owner.
_Avoid_: vendor, merchant

### Orders

**Hold**:
A 24-hour reservation of a **Listing** by one buyer, before payment.

## Relationships

- A **Seller** has one or more **Listings**; a **Listing** has one **Seller**
- A **Listing** has at most one active **Hold**
```
