# Creating a Rule Pack

A rule pack is a directory of markdown files that guide Claude Code skills during planning, design, and implementation.

## Quick start

1. Copy this `_template/` directory and rename it (e.g., `my-stack/`).
2. Edit `stack.md` — this is the anchor rule. Define your language, framework, build tool, and project structure.
3. Add more rules as needed — one file per concern (e.g., `service.md`, `testing.md`, `api.md`).
4. Each rule file needs YAML frontmatter with at least a `keywords` array.

## Rule file format

```markdown
---
keywords: [service, business logic, validation]   # Required — terms for discovery
scope: all                                         # Optional — bootstrap | feature | all (default: all)
extends: false                                     # Optional — append to higher-precedence version (default: false)
---
# Rule Title

> One-line description.

## Rules

- Pattern or constraint to follow.

## Bootstrap

What to generate when scaffolding a new project.
Omit this section if the rule only applies during feature work.

## Example

Concrete code showing the rule in practice.
```

## Frontmatter fields

| Field | Required | Values | Description |
|---|---|---|---|
| `keywords` | Yes | Array of strings | Skills match task descriptions against these to find relevant rules. |
| `scope` | No | `bootstrap`, `feature`, `all` | When this rule applies. `bootstrap` = only during scaffolding. `feature` = only during feature work. `all` = both. Default: `all`. |
| `extends` | No | `true`, `false` | When layering, if true this rule appends to a higher-precedence version with the same filename instead of being overridden. Default: `false`. |

## Tips

- Start with `stack.md` — `/bootstrap` requires it to scaffold a project.
- Keep rules focused — one concern per file.
- The `## Rules` section is what skills follow most closely. Be specific.
- The `## Bootstrap` section tells `/bootstrap` what files to generate. Omit it for rules that only matter during feature work.
- Use `## Example` to show the pattern concretely — this helps the model understand intent.

## Naming rules

Name files after the concern they cover: `entity.md`, `controller.md`, `testing.md`, `api.md`, `deployment.md`. The filename is used for deduplication when layering — if two layers both have `service.md`, the higher-precedence one wins (unless the lower one sets `extends: true`).
