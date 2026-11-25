# Spec and ticket drafts go to disk; chat shows only a table

`to-spec` and `to-tickets` write their drafts to disk, uncommitted, and show in chat only a table (ID, title, path, and for tickets type and depends on), with one line per draft for anything it adds beyond the agreed design. The user reads the files themselves. A full draft printed in chat was too long to review, and two specs or a set of tickets at once ran to screens of text. Files are also easier to read and edit in the user's editor. One rule covers every run, even with one draft, so there is no threshold to remember. One agreed design may split into several specs, as it already could into several tickets, with consecutive IDs and one commit for the set. A revision edits the files and reports one line per changed draft. A rejection deletes the files this run wrote.

## Consequences

- When a revision drops or merges drafts, the unused files are deleted, and the rest of this run's files are renumbered (file name, `id` and every mention), so the IDs stay consecutive. Committed specs and tickets are never renumbered, because IDs are never reused.
- Uncommitted drafts can be left behind if a session ends before approval.
- `to-adr` still prints its draft in full: an ADR is one short file.
