#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_SRC="$REPO_DIR/bin/devloop"
CLI_DST="$HOME/.local/bin/devloop"

info() { echo "  [ .. ] $1"; }
ok() { echo "  [ ok ] $1"; }
warn() { echo "  [warn] $1"; }

echo ""
echo "Installing devloop"
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
for old_name in devenv-conventions devenv-rules devloop-rules; do
  OLD_DST="$HOME/.local/bin/$old_name"
  if [ -L "$OLD_DST" ]; then
    rm "$OLD_DST"
    warn "Removed old symlink: $OLD_DST"
  fi
done

# ── Create directories ──────────────────────────────────────────────────────
info "Setting up directories..."
mkdir -p "$HOME/devloop/rules"
mkdir -p "$HOME/devloop/rule-packs"

# ── Migrate old paths if present ────────────────────────────────────────────
OLD_LAYERS="${XDG_CONFIG_HOME:-$HOME/.config}/devenv/rule-layers"
OLD_PACKS="$HOME/.claude/rule-packs"
MIGRATED=false

if [ -d "$OLD_PACKS" ]; then
  for entry in "$OLD_PACKS"/*/; do
    [ -e "$entry" ] || continue
    name="$(basename "${entry%/}")"
    dst="$HOME/devloop/rule-packs/$name"
    if [ -L "${entry%/}" ]; then
      target="$(readlink "${entry%/}")"
      if [ ! -e "$dst" ]; then
        ln -sfn "$target" "$dst"
        ok "Migrated pack repo: $name → $target"
        MIGRATED=true
      fi
    elif [ -d "$entry" ]; then
      if [ ! -e "$dst" ]; then
        cp -R "${entry%/}" "$dst"
        ok "Migrated pack repo (copy): $name"
        MIGRATED=true
      fi
    fi
  done
fi

if [ -f "$OLD_LAYERS" ]; then
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    name="$(basename "$line")"
    dst="$HOME/devloop/rules/$name"
    if [ -d "$line" ] && [ ! -e "$dst" ]; then
      ln -sfn "$line" "$dst"
      ok "Migrated active pack: $name → $line"
      MIGRATED=true
    fi
  done <"$OLD_LAYERS"
fi

if [ "$MIGRATED" = true ]; then
  if [ -f "$OLD_LAYERS" ]; then
    rm "$OLD_LAYERS"
    ok "Removed old layers file: $OLD_LAYERS"
    rmdir "${XDG_CONFIG_HOME:-$HOME/.config}/devenv" 2>/dev/null || true
  fi
  if [ -d "$OLD_PACKS" ]; then
    rm -rf "$OLD_PACKS"
    ok "Removed old packs dir: $OLD_PACKS"
  fi
  echo ""
  echo "  Migration complete. Old paths have been cleaned up."
  echo ""
fi

# ── Run install subcommand ───────────────────────────────────────────────────
info "Registering repo and setting up directories..."
"$CLI_SRC" rules install

echo ""
echo "────────────────────────────────────────"
echo "  Done! Run 'devloop rules list' to see available packs."
echo "  Then 'devloop rules enable <pack>' to activate one."
echo ""
