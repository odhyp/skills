---
name: diagram
description: Use to create or update the project's Mermaid .mmd diagrams when a change adds, removes or rewires services, infrastructure, data flow or module boundaries. Not for changes that stay inside one module.
---

Read the odhyp block in `CLAUDE.md` for the diagrams folder. Edit only `.mmd` files in that folder.

## Files

Stable names, one concern each. Create a file only when the project has something to show in it:

| File | Shows |
|---|---|
| `infrastructure.mmd` | Hosts, services, databases, queues, external APIs, and how they connect |
| `architecture.mmd` | Modules or packages and their dependencies |
| `data-flow.mmd` | How the main data moves from input to storage to output |

Add another file only for a view none of these covers, named for it (`auth-flow.mmd`).

## Writing a diagram

- Line 1 is a header comment saying what the diagram covers: `%% Architecture: modules under src/ and their imports`.
- Plain Mermaid (`flowchart`, `sequenceDiagram`, `erDiagram`, …), no HTML, no styling beyond `classDef`.
- Node labels use the names in the code (module, service, table), so a reader can grep for them.
- When updating, change only what the change touched; keep node IDs stable so diffs stay small.

**Done when** every service, module or flow the change added, removed or rewired appears correctly, and nothing that no longer exists remains.

Report which files changed and what changed in each. The user can view them with the command in the odhyp block.
