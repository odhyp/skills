# v0.7.0

Released 2026-11-24.

`to-tickets` and `diagnose` now confirm their ticket drafts and commit them, and `implement` names the edit that unblocks a refused ticket.
`release` keeps wontfix tickets out of the bump, and `setup` reuses the existing version files and can import a tracker.

## Tickets

### feat

- T-0020 to-tickets confirms the full drafts, then commits them
- T-0021 diagnose confirms the ticket draft, then commits it
- T-0022 implement refusals name the edit that unblocks the ticket
- T-0023 implement direct-mode must-fix warns before /clear

### fix

- T-0019 Release counts wontfix tickets in the bump and changelog

## Specs

- S-0003 Confirm and commit tickets, and name the way out of a blocked ticket
