---
keywords: [paths, config, resolution, rules, layers, install]
scope: all
---
# Cross-Repo Sync

> The devloop plugin and devloop-rules repo share path conventions. Changes to one must be reflected in the other.

## Rules
- When resolution paths or config paths change in the devloop plugin's `skills/resolve-rules/SKILL.md`, the following in devloop-rules must also be updated:
  - `bin/devloop` CLI script (path constants, enable/disable/list logic)
  - `install.sh` (directory creation, symlink targets)
  - `README.md` and `docs/install.md` (documented paths and examples)
- The devloop-rules repo location is registered at `~/devloop/rule-packs/devloop-rules` (symlink to the repo)
- The four-tier precedence table must stay consistent across both repos' documentation
