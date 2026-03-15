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

Then enable a pack:

```bash
devloop rules enable git-conventions
```

Skills will now apply those rules when planning, designing, and implementing features. See [docs/install.md](docs/install.md) for prerequisites, what gets created where, and troubleshooting.

## Available packs

| Pack | Description |
|------|-------------|
| `git-conventions` | Git workflow preferences — feature branching, commit message format, squash before push, auto PR creation. |
| `spring-boot-web` | Spring Boot + Thymeleaf + Liquibase + PostgreSQL + Docker. Covers entities, services, controllers, security, migrations, templates, and testing. |
| `_template` | Skeleton for creating your own pack. Copy and customize. |

## CLI

| Command | What it does |
|---------|-------------|
| `devloop rules install` | First-time setup (called by `install.sh`) |
| `devloop rules enable <pack>` | Activate a pack (symlinks into `~/devloop/rules/`) |
| `devloop rules disable <pack>` | Deactivate a pack (removes symlink) |
| `devloop rules list` | Show active and available packs |
| `devloop rules clone <repo-url>` | Clone another rules repo |
| `devloop rules update` | Pull latest for all cloned repos |

## Rule resolution — four-tier precedence

devloop resolves rules from four layers. When rules conflict, the higher-precedence layer wins.

| Precedence | Layer | Path | Description |
|---|---|---|---|
| 1 (highest) | User | `~/.claude/rules/` | Claude Code native, personal overrides |
| 2 | Project | `{cwd}/devloop/rules/` | Project-specific rules |
| 3 | Shared/org | `~/devloop/rules/` | Rule packs managed by devloop CLI |
| 4 (lowest) | Plugin-bundled | `${CLAUDE_PLUGIN_ROOT}/rules/` | Defaults shipped with devloop |

Packs managed by this CLI live at layer 3. When you run `devloop rules enable <pack>`, a symlink is created in `~/devloop/rules/` pointing to the pack directory. devloop's `/resolve-rules` skill walks all four layers and surfaces matching rules based on keyword frontmatter.

Flat files in `~/.claude/rules/` (layer 1) always win — use them for personal overrides you want in every session.

## How enabling/disabling works

When you enable a pack, the CLI creates a symlink:

```
~/devloop/rules/<pack-name> → <repo>/packs/<pack-name>
```

When you disable a pack, the symlink is removed. No files are moved or copied — the pack's source stays in the repo.

## Migration from old format

If you previously used devloop-rules with the old path layout (`~/.config/devenv/rule-layers` and `~/.claude/rule-packs/`), running `./install.sh` or `devloop rules install` will automatically migrate:

- Pack repos in `~/.claude/rule-packs/` are re-registered in `~/devloop/rule-packs/`
- Active packs listed in `~/.config/devenv/rule-layers` are converted to symlinks in `~/devloop/rules/`
- Old files are cleaned up after successful migration

No manual steps needed — the migration is automatic and idempotent.

## Creating your own pack

1. Copy `packs/_template/` to `packs/my-stack/`
2. Edit `stack.md` with your tech stack and project structure
3. Add rule files for each concern (e.g., `entity.md`, `service.md`, `testing.md`)

Each rule file has YAML frontmatter and markdown content:

```yaml
---
keywords: [service, business logic, validation]
scope: all        # bootstrap | feature | all | always
extends: false    # true to append to a higher-precedence version
---
# Service Rules

> One-line description.

## Rules
- Patterns to follow

## Bootstrap
- What gets scaffolded during /dl:bootstrap

## Example
- Concrete code showing the pattern
```

The `keywords` field is how skills find relevant rules — `/dl:implement` matches task descriptions against these terms. `scope` controls when the rule applies: during bootstrapping, feature work, both, or `always` (included in every skill invocation regardless of keyword matching).

See `packs/_template/README.md` for the full format spec.

### Extending rules

If you have a `service.md` in a higher-precedence pack and want to add rules rather than replace it, set `extends: true` in the lower-precedence version's frontmatter. Both files are read — the higher-precedence version first, then the extension appends. This is useful when a base pack covers general patterns and a specialized pack adds stack-specific rules.

## License

[MIT](LICENSE)
