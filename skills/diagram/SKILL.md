---
name: diagram
description: Use to create or update the project's Mermaid .mmd diagrams when the user asks for diagrams, when shape finalizes work that changes the structure, or when a change makes an existing diagram wrong (services, infrastructure, data flow or module boundaries added, removed or rewired).
---

Read `polaris.json` for the diagrams folder. Edit only `.mmd` files in that folder; start a new one from `${CLAUDE_PLUGIN_ROOT}/templates/diagram.mmd`.

The folder starts empty. Create a diagram only when the user asks or `shape` calls for one; otherwise update only diagrams that already exist. A diagram drawn from `shape` shows the agreed design.

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

Report which files changed and what changed in each. Polaris shows them.
