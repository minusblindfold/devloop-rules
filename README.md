# devenv-conventions

Convention packs for [devenv](https://github.com/minusblindfold/devenv) — reusable sets of convention docs that guide Claude Code skills during planning, design, and implementation.

## Prerequisites

This repo extends [devenv](https://github.com/minusblindfold/devenv) — a personal dev environment that provides Claude Code skills (`/plan`, `/design`, `/implement`, `/bootstrap`, `/research`) and the convention resolution system they rely on. Install devenv first, then use this repo to add convention packs.

## What are convention packs?

Convention packs are organized collections of markdown files that tell Claude Code *how* to build things: coding patterns, project structure, naming rules, architectural decisions. Each pack targets a specific technology stack or concern.

devenv ships with a simple `~/.claude/conventions/` directory where you can drop individual convention files. This repo extends that with:

- **Organized packs** — conventions grouped by stack (e.g., `spring-boot-web`)
- **A CLI** — `devenv-conventions` for enabling, disabling, and managing packs
- **Layered resolution** — multiple packs active simultaneously with precedence ordering

## Available packs

| Pack | Description |
|---|---|
| `spring-boot-web` | Spring Boot + Thymeleaf + Liquibase + PostgreSQL + Docker. Entity, service, controller, security, migration, and template conventions. |
| `_template` | Skeleton for creating your own pack. Copy and customize. |

## Install

```bash
git clone https://github.com/minusblindfold/devenv-conventions.git
cd devenv-conventions
./install.sh
```

This will:
- Symlink the `devenv-conventions` CLI to `~/.local/bin/`
- Register this repo in `~/.claude/convention-packs/`
- Create the layers file at `~/.config/devenv/convention-layers`

Then enable a pack:

```bash
devenv-conventions enable spring-boot-web
```

## CLI commands

| Command | Description |
|---|---|
| `devenv-conventions install` | First-time setup (called by `install.sh`) |
| `devenv-conventions enable <pack>` | Activate a pack (adds to layers) |
| `devenv-conventions disable <pack>` | Deactivate a pack (removes from layers) |
| `devenv-conventions list` | Show active layers and available packs |
| `devenv-conventions clone <repo-url>` | Clone another conventions repo |
| `devenv-conventions update` | Pull latest changes for all cloned repos |
| `devenv-conventions reorder <pack> <pos>` | Change a pack's precedence position |

## How it works

When you enable a pack, its path is added to `~/.config/devenv/convention-layers`. devenv's `/resolve-conventions` skill reads this file and walks the layer paths in order (first = highest precedence), falling back to `~/.claude/conventions/` for any flat-file conventions you've added directly.

This means you can:
- Use packs alone (enable what you need)
- Use flat files alone (drop `.md` files in `~/.claude/conventions/`)
- Mix both — flat files in `~/.claude/conventions/` act as the lowest-precedence layer, letting you override pack conventions per-project

## Creating your own pack

1. Copy `packs/_template/` to `packs/my-stack/`
2. Edit `stack.md` with your tech stack
3. Add convention files for your patterns
4. See `packs/_template/README.md` for the full format spec

## Convention format

Each convention file has YAML frontmatter and markdown content:

```yaml
---
keywords: [service, business logic, validation]
scope: all        # bootstrap | feature | all
extends: false    # true to append to higher-precedence version
---
```

Key sections: `## Rules` (patterns to follow), `## Bootstrap` (what to scaffold), `## Example` (concrete code).

See `packs/_template/README.md` for details.
