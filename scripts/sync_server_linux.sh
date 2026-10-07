#!/bin/bash
set -e

# ==============================================================================
# sync_server_linux.sh
# Syncs BepInEx plugins & configs to Linux Valheim Dedicated Server
# Automatically omits Mac-specific client mods like ShaderHelperForMac
# ==============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DEFAULT_PATHS=(
    "$HOME/valheim-server"
    "$HOME/.steam/steam/steamapps/common/Valheim dedicated server"
    "$HOME/.local/share/Steam/steamapps/common/Valheim dedicated server"
    "/opt/valheim-server"
    "/opt/valheim"
    "$(pwd)"
)

TARGET_DIR="$1"

if [ -z "$TARGET_DIR" ]; then
    for path in "${DEFAULT_PATHS[@]}"; do
        if [ -d "$path/BepInEx" ]; then
            TARGET_DIR="$path"
            break
        fi
    done
fi

if [ -z "$TARGET_DIR" ] || [ ! -d "$TARGET_DIR/BepInEx" ]; then
    echo "ERROR: Could not automatically detect Valheim server BepInEx directory."
    echo ""
    echo "Usage: ./scripts/sync_server_linux.sh /path/to/valheim_server_directory"
    echo "Example: ./scripts/sync_server_linux.sh /home/steam/valheim-server"
    exit 1
fi

BEPINEX_DIR="$TARGET_DIR/BepInEx"

echo "=== Syncing Mods to Linux Valheim Server ==="
echo "Repo root:        $REPO_ROOT"
echo "Server directory: $TARGET_DIR"
echo ""

mkdir -p "$BEPINEX_DIR/plugins" "$BEPINEX_DIR/config"

echo "-> Copying plugins..."
for plugin_path in "$REPO_ROOT/BepInEx/plugins/"*; do
    plugin_name=$(basename "$plugin_path")
    # Skip Mac-only client mods on headless Linux server
    if [ "$plugin_name" == "ShaderHelperForMac" ]; then
        echo "   [Skipping $plugin_name - client/Mac only]"
        continue
    fi
    echo "   + Installing $plugin_name"
    cp -R "$plugin_path" "$BEPINEX_DIR/plugins/"
done

# Ensure ShaderHelper is not left behind on the server if it was previously copied
rm -rf "$BEPINEX_DIR/plugins/ShaderHelperForMac"

echo ""
echo "-> Copying configs..."
for config_path in "$REPO_ROOT/BepInEx/config/"*; do
    config_name=$(basename "$config_path")
    if [[ "$config_name" == *"shaderhelper"* ]] || [ "$config_name" == "ShaderHelperForMac" ]; then
        continue
    fi
    cp -R "$config_path" "$BEPINEX_DIR/config/"
done

echo ""
echo " Successfully synced mods and configs to Linux server!"
echo "REMINDER: Restart your Valheim server to apply changes."
