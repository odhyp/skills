# Spec format

A spec records an agreed feature design. Tickets carry everything needed to build it; the spec is the background and the place where decisions changed during implementation are logged.

**The frontmatter is locked:** exactly the fields below, and no skill adds its own. Polaris parses it, so changing it is a breaking change for both repos. The body is free Markdown; the sections under Body are the recommended structure. Blank template: `spec.md`.

- **One file per spec**, flat in the specs folder (path in the odhyp block in `CLAUDE.md`): `NNNN-short-slug.md`.
- **Link by ID, never by path.**

## IDs

`S-NNNN`, zero-padded, never reused. The next ID is the highest existing `S-` ID in the specs folder and in the releases archive, plus one; the first is `S-0001`. Tickets count separately (`T-NNNN`).

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

## Decisions
- 2026-11-20 · T-0018 · Sidebar collapses at 768px, not 640px: the nav labels wrap below that.
```
