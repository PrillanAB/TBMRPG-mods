#!/bin/bash
set -e

# ==============================================================================
# sync_client_mac.sh
# Syncs BepInEx plugins & configs directly to macOS Valheim client
# ==============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_VALHEIM_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Valheim"
TARGET_DIR="${1:-$DEFAULT_VALHEIM_DIR}"
BEPINEX_DIR="$TARGET_DIR/BepInEx"

echo "=== Syncing Mods to Mac Valheim Client ==="
echo "Repo root:       $REPO_ROOT"
echo "Game directory:  $TARGET_DIR"

if [ ! -d "$BEPINEX_DIR" ]; then
    echo "ERROR: BepInEx folder not found at: $BEPINEX_DIR"
    echo "Usage: ./scripts/sync_client_mac.sh [path/to/Valheim]"
    exit 1
fi

mkdir -p "$BEPINEX_DIR/plugins" "$BEPINEX_DIR/config"

echo "-> Copying plugins..."
cp -R "$REPO_ROOT/BepInEx/plugins/"* "$BEPINEX_DIR/plugins/"

echo "-> Copying configs..."
cp -R "$REPO_ROOT/BepInEx/config/"* "$BEPINEX_DIR/config/"

echo ""
echo " Successfully synced all mods and configs to your Mac Valheim client!"
