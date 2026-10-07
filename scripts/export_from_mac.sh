#!/bin/bash
set -e

# ==============================================================================
# export_from_mac.sh
# Copies plugins and configs from local Mac Valheim BepInEx into this Git repository.
# ==============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VALHEIM_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Valheim"
BEPINEX_DIR="$VALHEIM_DIR/BepInEx"

echo "=== Exporting Plugins & Configs from Mac to Git Repo ==="
echo "Source: $BEPINEX_DIR"
echo "Target: $REPO_ROOT/BepInEx"

if [ ! -d "$BEPINEX_DIR" ]; then
    echo "ERROR: Mac Valheim BepInEx directory not found at $BEPINEX_DIR"
    exit 1
fi

mkdir -p "$REPO_ROOT/BepInEx/plugins" "$REPO_ROOT/BepInEx/config"

echo "-> Exporting plugins..."
cp -R "$BEPINEX_DIR/plugins/"* "$REPO_ROOT/BepInEx/plugins/"

echo "-> Exporting configs..."
cp -R "$BEPINEX_DIR/config/"* "$REPO_ROOT/BepInEx/config/"

# Clean cache and player save data
rm -rf "$REPO_ROOT/BepInEx/config/EpicLoot/BountySaves"
rm -f "$REPO_ROOT/BepInEx/config/ShaderHelperForMac/"*.cache 2>/dev/null || true

echo ""
echo " Export complete!"
echo "Run 'git status' or 'git diff' to review changes before committing."
