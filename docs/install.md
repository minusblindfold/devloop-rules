# Installation

## Prerequisites

- **macOS / Linux** — works natively
- **Windows** — use [Git Bash](https://git-scm.com/downloads) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/install). The CLI and install script require a Unix-like shell.
- [Claude Code](https://claude.ai/claude-code) installed
- The [devloop](https://github.com/minusblindfold/devloop) plugin installed:
  ```bash
  claude plugin marketplace add minusblindfold/devloop
  claude plugin install dl
  ```
- `~/.local/bin` on your `PATH` (the CLI is symlinked there)

To check if `~/.local/bin` is on your PATH:

```bash
echo $PATH | tr ':' '\n' | grep local/bin
```

If nothing shows, add this to your shell config (`~/.zshrc` or `~/.bashrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Install

```bash
git clone https://github.com/minusblindfold/devloop-rules.git
cd devloop-rules
./install.sh
```

The installer does three things:

1. **Symlinks the CLI** — `~/.local/bin/devloop` -> `<repo>/bin/devloop`
2. **Registers the repo** — creates a symlink in `~/devloop/rule-packs/` so the CLI knows where packs live
3. **Creates directories** — `~/devloop/rules/` for active pack symlinks, `~/devloop/rule-packs/` for repo registrations

Running `./install.sh` again is safe — it detects existing symlinks and skips them.

## Enable a pack

```bash
devloop rules list                      # see available packs
devloop rules enable git-conventions    # enable one
devloop rules enable spring-boot-web    # enable another
```

Enabled packs are symlinked into `~/devloop/rules/`. devloop's skills scan this directory at runtime and surface matching rules based on keyword frontmatter.

Verify with:

```bash
devloop rules list
```

```
Active packs:
  1. git-conventions   (/path/to/devloop-rules/packs/git-conventions)
  2. spring-boot-web   (/path/to/devloop-rules/packs/spring-boot-web)
```

## Disable a pack

```bash
devloop rules disable spring-boot-web
```

## Rule resolution — four-tier precedence

devloop resolves rules from four layers. When rules conflict, the higher-precedence layer wins.

| Precedence | Layer | Path | Description |
|---|---|---|---|
| 1 (highest) | User | `~/.claude/rules/` | Claude Code native, personal overrides |
| 2 | Project | `{cwd}/devloop/rules/` | Project-specific rules |
| 3 | Shared/org | `~/devloop/rules/` | Rule packs managed by devloop CLI |
| 4 (lowest) | Plugin-bundled | `${CLAUDE_PLUGIN_ROOT}/rules/` | Defaults shipped with devloop |

## What gets created where

| Path | Purpose |
|------|---------|
| `~/.local/bin/devloop` | CLI symlink |
| `~/devloop/rule-packs/<repo-name>` | Repo registration symlink |
| `~/devloop/rules/<pack-name>` | Symlink to an active pack directory |

## Migration from old format

If you previously used the old path layout (`~/.config/devenv/rule-layers` and `~/.claude/rule-packs/`), running `./install.sh` or `devloop rules install` will automatically migrate:

- Pack repos in `~/.claude/rule-packs/` are re-registered in `~/devloop/rule-packs/`
- Active packs listed in `~/.config/devenv/rule-layers` are converted to symlinks in `~/devloop/rules/`
- Old files and directories are cleaned up after successful migration

No manual steps needed.

## Updating

Pull the latest and the CLI picks up changes immediately — packs are read from the repo directory, not copied.

```bash
cd devloop-rules
git pull
```

Or use the CLI to update all cloned rule repos at once:

```bash
devloop rules update
```

## Uninstall

Remove the symlinks:

```bash
devloop rules disable <pack>          # for each enabled pack
rm ~/.local/bin/devloop
rm ~/devloop/rule-packs/devloop-rules
```

## Troubleshooting

**`command not found: devloop`** — `~/.local/bin` is not on your PATH. Add it to your shell config and restart your terminal.

**`Could not detect repo root`** — The CLI couldn't find a `.git` directory walking up from its location. This usually means the symlink is broken. Re-run `./install.sh` from the repo directory.

**Packs show as `(missing)` in list** — The symlink in `~/devloop/rules/` points to a directory that doesn't exist. This happens after renaming or moving the repo. Fix by disabling and re-enabling the affected packs:

```bash
devloop rules disable <pack>
devloop rules enable <pack>
```
