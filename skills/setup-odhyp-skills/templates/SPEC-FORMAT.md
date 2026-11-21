# Spec format

A spec records an agreed feature design. Tickets carry everything needed to build it; the spec is the background and the place where decisions changed during implementation are logged.

- **One file per spec**, flat in the specs folder: `NNNN-short-slug.md`.
- **IDs:** `S-NNNN`, zero-padded, never reused. The next ID is the highest existing `S-` ID (including the releases archive) plus one. Tickets count separately (`T-NNNN`).
- **Link by ID, never by path.**

## Frontmatter

```yaml
---
id: S-0005
title: Build dashboard
status: draft             # draft | accepted | done
tickets: [T-0018, T-0019] # filled by to-tickets
---
```

| status | Meaning |
|---|---|
| `draft` | Written, not yet split into tickets |
| `accepted` | Split into tickets; work in progress |
| `done` | Every ticket is `resolved` or `wontfix` |

## Body

```markdown
## Problem
## Goals / Non-goals
## Design
## Diagrams affected
- architecture.mmd (what changes)      # empty → the diagram skill is skipped
## Decisions
<!-- added during implementation: date · ticket ID · what changed and why -->
```

## Example

```markdown
---
id: S-0005
title: Build dashboard
status: accepted
tickets: [T-0018, T-0019]
---

## Problem
Logged-in users land on an empty page and have to know URLs to find anything.

## Goals / Non-goals
- Goal: one page that shows the three things users check daily (open orders, low stock, recent messages).
- Goal: works on a phone.
- Non-goal: user-configurable widgets.
- Non-goal: real-time updates; a page refresh is fine.

## Design
A `/dashboard` route renders a grid layout: header, collapsible sidebar, main area.
The main area holds three widgets, each fed by one existing query. No new tables.
`/` redirects to `/dashboard` for logged-in users.

## Diagrams affected
- architecture.mmd (new dashboard module, depends on auth and orders)

## Decisions
- 2026-11-20 · T-0018 · Sidebar collapses at 768px, not 640px: the nav labels wrap below that.
```
