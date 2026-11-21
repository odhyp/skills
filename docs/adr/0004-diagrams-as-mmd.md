# Diagrams are plain .mmd files

Diagrams are standalone Mermaid `.mmd` files, each opening with a `%%` comment saying what it covers. Polaris renders them, and a plain file is simpler to generate and diff than Mermaid wrapped in Markdown. GitHub does not render `.mmd`, and that is accepted. The diagrams folder starts empty: diagrams are drawn on request or when `shape` settles structural work, then kept current by `implement` and `code-review`.
