# Creating a Convention Pack

A convention pack is a directory of markdown files that guide Claude Code skills during planning, design, and implementation.

## Quick start

1. Copy this `_template/` directory and rename it (e.g., `my-stack/`).
2. Edit `stack.md` — this is the anchor convention. Define your language, framework, build tool, and project structure.
3. Add more conventions as needed — one file per concern (e.g., `service.md`, `testing.md`, `api.md`).
4. Each convention file needs YAML frontmatter with at least a `keywords` array.

## Convention file format

```markdown
---
keywords: [service, business logic, validation]   # Required — terms for discovery
scope: all                                         # Optional — bootstrap | feature | all (default: all)
extends: false                                     # Optional — append to higher-precedence version (default: false)
---
# Convention Title

> One-line description.

## Rules

- Pattern or constraint to follow.

## Bootstrap

What to generate when scaffolding a new project.
Omit this section if the convention only applies during feature work.

## Example

Concrete code showing the convention in practice.
```

## Frontmatter fields

| Field | Required | Values | Description |
|---|---|---|---|
| `keywords` | Yes | Array of strings | Skills match task descriptions against these to find relevant conventions. |
| `scope` | No | `bootstrap`, `feature`, `all` | When this convention applies. `bootstrap` = only during scaffolding. `feature` = only during feature work. `all` = both. Default: `all`. |
| `extends` | No | `true`, `false` | When layering, if true this convention appends to a higher-precedence version with the same filename instead of being overridden. Default: `false`. |

## Tips

- Start with `stack.md` — `/bootstrap` requires it to scaffold a project.
- Keep conventions focused — one concern per file.
- The `## Rules` section is what skills follow most closely. Be specific.
- The `## Bootstrap` section tells `/bootstrap` what files to generate. Omit it for conventions that only matter during feature work.
- Use `## Example` to show the pattern concretely — this helps the model understand intent.

## Naming conventions

Name files after the concern they cover: `entity.md`, `controller.md`, `testing.md`, `api.md`, `deployment.md`. The filename is used for deduplication when layering — if two layers both have `service.md`, the higher-precedence one wins (unless the lower one sets `extends: true`).
