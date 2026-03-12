#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_SRC="$REPO_DIR/bin/devloop-rules"
CLI_DST="$HOME/.local/bin/devloop-rules"

info() { echo "  [ .. ] $1"; }
ok() { echo "  [ ok ] $1"; }
warn() { echo "  [warn] $1"; }

echo ""
echo "Installing devloop-rules"
echo "────────────────────────────────────────"

# ── Symlink CLI ──────────────────────────────────────────────────────────────
info "Linking CLI..."
mkdir -p "$HOME/.local/bin"

if [ -L "$CLI_DST" ] && [ "$(readlink "$CLI_DST")" = "$CLI_SRC" ]; then
  ok "Already linked: $CLI_DST"
else
  [ -L "$CLI_DST" ] && rm "$CLI_DST"
  ln -sf "$CLI_SRC" "$CLI_DST"
  chmod +x "$CLI_SRC"
  ok "Linked: $CLI_DST → $CLI_SRC"
fi

# ── Clean up old symlinks if present ─────────────────────────────────────────
for old_name in devenv-conventions devenv-rules; do
  OLD_DST="$HOME/.local/bin/$old_name"
  if [ -L "$OLD_DST" ]; then
    rm "$OLD_DST"
    warn "Removed old symlink: $OLD_DST"
  fi
done

# ── Run install subcommand ───────────────────────────────────────────────────
info "Registering repo and setting up directories..."
"$CLI_SRC" install

echo ""
echo "────────────────────────────────────────"
echo "  Done! Run 'devloop-rules list' to see available packs."
echo "  Then 'devloop-rules enable <pack>' to activate one."
echo ""
