#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_SRC="$REPO_DIR/bin/devenv-conventions"
CLI_DST="$HOME/.local/bin/devenv-conventions"

info() { echo "  [ .. ] $1"; }
ok() { echo "  [ ok ] $1"; }
warn() { echo "  [warn] $1"; }

echo ""
echo "Installing devenv-conventions"
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

# ── Run install subcommand ───────────────────────────────────────────────────
info "Registering repo and setting up directories..."
"$CLI_SRC" install

echo ""
echo "────────────────────────────────────────"
echo "  Done! Run 'devenv-conventions list' to see available packs."
echo "  Then 'devenv-conventions enable <pack>' to activate one."
echo ""
