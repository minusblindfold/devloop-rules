# devloop-rules

Rule packs are collections of markdown files that describe how to build things in a specific stack — coding patterns, project structure, naming rules, architectural decisions. Claude Code reads them at runtime while planning, designing, and implementing features.

This repo provides packs and a CLI for managing them. It extends [devloop](https://github.com/minusblindfold/devloop).

## How it connects to devloop

[devloop](https://github.com/minusblindfold/devloop) is a Claude Code plugin that provides workflow skills (`/dl:plan`, `/dl:design`, `/dl:implement`, `/dl:bootstrap`). Those skills call `/resolve-rules` at runtime to find relevant rules. This repo provides organized rule packs that get discovered through that resolution.

Without this repo, devloop works fine — skills operate from codebase context alone. This repo adds stack-specific guidance so the agent follows consistent patterns.

## Why packs instead of flat rules

Flat rules in `~/.claude/rules/` are simple — Claude Code loads all of them into every session. That works when you have a handful of files, but as rules grow the context window fills with guidance that isn't relevant to the current task. Agent output degrades when context is crowded with noise.

Packs solve this with keyword-based discovery. Rules live outside `~/.claude/rules/` and are only surfaced by skills when the task description matches a rule's `keywords` frontmatter. A task about entities pulls in `entity.md` — not `security.md`, `migration.md`, or `testing.md`. This keeps the agent's context in the sweet spot: enough guidance to follow your patterns, not so much that it loses focus.

The tradeoff is that packs aren't auto-loaded by Claude Code itself — they only work through devloop's skills. For rules you want available everywhere (not just during skill workflows), keep them as flat files in `~/.claude/rules/`.

## Quickstart

Requires the [devloop](https://github.com/minusblindfold/devloop) plugin installed first.

```bash
git clone https://github.com/minusblindfold/devloop-rules.git
cd devloop-rules
./install.sh
```

This symlinks the CLI to `~/.local/bin/`, registers the repo, and creates the layers file at `~/.config/devenv/rule-layers`.

Then enable a pack:

```bash
devloop-rules enable spring-boot-web
```

Skills will now apply those rules when planning, designing, and implementing features in that stack.

## Available packs

| Pack | Description |
|------|-------------|
| `spring-boot-web` | Spring Boot + Thymeleaf + Liquibase + PostgreSQL + Docker. Covers entities, services, controllers, security, migrations, templates, and testing. |
| `_template` | Skeleton for creating your own pack. Copy and customize. |

## CLI

| Command | What it does |
|---------|-------------|
| `devloop-rules install` | First-time setup (called by `install.sh`) |
| `devloop-rules enable <pack>` | Activate a pack |
| `devloop-rules disable <pack>` | Deactivate a pack |
| `devloop-rules list` | Show active layers and available packs |
| `devloop-rules clone <repo-url>` | Clone another rules repo |
| `devloop-rules update` | Pull latest for all cloned repos |
| `devloop-rules reorder <pack> <pos>` | Change a pack's precedence position |

## How layering works

When you enable a pack, its path is added to `~/.config/devenv/rule-layers`. devloop's `/resolve-rules` skill reads this file and walks layer paths in order — first line is highest precedence.

Flat files in `~/.claude/rules/` always serve as the lowest-precedence fallback. This means you can:

- **Use packs alone** — enable what you need
- **Use flat files alone** — drop `.md` files in `~/.claude/rules/`
- **Mix both** — flat files act as the base layer, packs override them

If two packs have a file with the same name, the higher-precedence pack wins. The lower-precedence version is skipped unless it sets `extends: true` in its frontmatter — in that case, both are read (higher-precedence first, then the extension appends).

## Creating your own pack

1. Copy `packs/_template/` to `packs/my-stack/`
2. Edit `stack.md` with your tech stack and project structure
3. Add rule files for each concern (e.g., `entity.md`, `service.md`, `testing.md`)

Each rule file has YAML frontmatter and markdown content:

```yaml
---
keywords: [service, business logic, validation]
scope: all        # bootstrap | feature | all
extends: false    # true to append to a higher-precedence version
---
# Service Rules

> One-line description.

## Rules
- Patterns to follow

## Bootstrap
- What gets scaffolded during /bootstrap

## Example
- Concrete code showing the pattern
```

The `keywords` field is how skills find relevant rules — `/implement` matches task descriptions against these terms. `scope` controls when the rule applies: during bootstrapping, feature work, or both.

See `packs/_template/README.md` for the full format spec.

### Extending rules

If you have a `service.md` in a higher-precedence pack and want to add rules rather than replace it, set `extends: true` in the lower-precedence version's frontmatter. Both files are read — the higher-precedence version first, then the extension appends. This is useful when a base pack covers general patterns and a specialized pack adds stack-specific rules.

## License

[MIT](LICENSE)
