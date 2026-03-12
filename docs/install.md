# Installation

## Prerequisites

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

1. **Symlinks the CLI** — `~/.local/bin/devloop-rules` → `<repo>/bin/devloop-rules`
2. **Registers the repo** — creates a symlink in `~/.claude/rule-packs/` so the CLI knows where packs live
3. **Creates the layers file** — `~/.config/devenv/rule-layers` tracks which packs are active

Running `./install.sh` again is safe — it detects existing symlinks and skips them.

## Enable a pack

```bash
devloop-rules list                      # see available packs
devloop-rules enable git-conventions    # enable one
devloop-rules enable spring-boot-web    # enable another
```

Enabled packs are added to `~/.config/devenv/rule-layers`. devloop's skills read this file at runtime and surface matching rules based on keyword frontmatter.

Verify with:

```bash
devloop-rules list
```

```
Active layers (highest precedence first):
  1. git-conventions   (/path/to/devloop-rules/packs/git-conventions)
  2. spring-boot-web   (/path/to/devloop-rules/packs/spring-boot-web)
```

## Disable a pack

```bash
devloop-rules disable spring-boot-web
```

## What gets created where

| Path | Purpose |
|------|---------|
| `~/.local/bin/devloop-rules` | CLI symlink |
| `~/.claude/rule-packs/<repo-name>` | Repo registration symlink |
| `~/.config/devenv/rule-layers` | Active pack list (one path per line, first = highest precedence) |

## Updating

Pull the latest and the CLI picks up changes immediately — packs are read from the repo directory, not copied.

```bash
cd devloop-rules
git pull
```

Or use the CLI to update all cloned rule repos at once:

```bash
devloop-rules update
```

## Uninstall

Remove the symlinks and clean the layers file:

```bash
devloop-rules disable <pack>          # for each enabled pack
rm ~/.local/bin/devloop-rules
rm ~/.claude/rule-packs/devloop-rules
```

## Troubleshooting

**`command not found: devloop-rules`** — `~/.local/bin` is not on your PATH. Add it to your shell config and restart your terminal.

**`Could not detect repo root`** — The CLI couldn't find a `.git` directory walking up from its location. This usually means the symlink is broken. Re-run `./install.sh` from the repo directory.

**Packs show as `(missing)` in list** — The paths in `~/.config/devenv/rule-layers` point to a directory that doesn't exist. This happens after renaming or moving the repo. Fix by disabling and re-enabling the affected packs:

```bash
devloop-rules disable <pack>
devloop-rules enable <pack>
```
