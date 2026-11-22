# v0.2.0

2026-11-22

Project config moves from `polaris.json` into the odhyp block in `CLAUDE.md` (breaking).
Also fixes gaps in `implement`, `session-review` and `release`, and marks the format files as the public contract.

## Tickets

### feat
- T-0001 Move project config from polaris.json into the CLAUDE.md block (breaking)
- T-0004 implement explains an empty or blocked queue
- T-0005 session-review writes its ticket in the odhyp repo, with source session-review

### fix
- T-0002 release updates every version file and lists them in the confirmation
- T-0008 Format each version file in its own code span in the CLAUDE.md block template

### refactor
- T-0003 State the next-ID rule once in the format files

### docs
- T-0006 Mark the format files as the public contract and add a README section

### chore (wontfix)
- T-0007 Polaris: read paths from the odhyp block, keep its own config in app data, accept source session-review

## Specs
- S-0001 Fix skill gaps and move project config into the CLAUDE.md block
