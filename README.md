# Valheim MMORPG Server & Client Mod Pack

A unified Git repository to manage, configure, and synchronize mods between your **Linux Dedicated Server** and **Client players** (macOS, Windows, Linux).

---

## Architecture Overview

```
TBMRPG-server-mods/
├── mods/
│   ├── shared/            # Required by BOTH Linux Server and Clients
│   │   ├── plugins/       # EpicLoot, Jotunn, Equipment & Quick Slots, etc.
│   │   └── config/        # Configs (.cfg) and data tables (EpicLoot JSONs)
│   ├── client/            # CLIENT-ONLY (not installed on server)
│   │   ├── plugins/       # ShaderHelperForMac, HUD/graphics tweaks
│   │   └── config/        # Shader lists, client-only configs
│   └── server/            # SERVER-ONLY (not installed on clients)
│       ├── plugins/       # Admin tools, ServerCharacters, Discord bots
│       └── config/        # Server-only settings
├── scripts/
│   ├── sync_client_mac.sh      # One-click install/update for macOS client
│   ├── sync_server_linux.sh    # One-click install/update for Linux Dedicated Server
│   ├── sync_client_windows.ps1 # One-click install/update for Windows clients
│   └── export_from_mac.sh      # Copies local test changes from Mac back to repo
├── .gitattributes         # Enforces binary integrity for .dll and assets
├── .gitignore             # Filters logs, saves, caches, and runtime state
└── README.md
```

---

## Quick Start: Syncing Mods

### 1. On macOS Client
From the repository folder, run:
```bash
./scripts/sync_client_mac.sh
```
*Auto-detects `~/Library/Application Support/Steam/steamapps/common/Valheim`. Copies shared and client mods into place.*

---

### 2. On Linux Dedicated Server
On your Linux machine (where your Valheim dedicated server runs):

1. **Clone this repository** (or `git pull` if already cloned):
   ```bash
   git clone <YOUR_GITHUB_REPO_URL> ~/tbmrpg-mods
   cd ~/tbmrpg-mods
   ```
2. **Run the server sync script**:
   ```bash
   ./scripts/sync_server_linux.sh /path/to/valheim-server
   ```
   *(If you run the script without a path, it checks standard server locations automatically).*
3. **Restart your Valheim server service**:
   ```bash
   systemctl restart valheim-server  # (or your server restart command)
   ```

> **Why this matters**: Client-only mods like `ShaderHelperForMac` are automatically excluded from the Linux server, preventing headless Unity crashes and log spam.

---

### 3. On Windows Client (For friends / other players)
From PowerShell in the repo folder:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync_client_windows.ps1
```
*Auto-detects default Steam install paths or accepts a custom `-GamePath` parameter.*

---

## Developer Workflow: Adding Mods & Changing Configs

1. **Test on Mac**:
   Add new mods to your local Valheim `BepInEx/plugins` or tweak values in `BepInEx/config/`.
2. **Export to Repo**:
   Run:
   ```bash
   ./scripts/export_from_mac.sh
   ```
   Or place new plugins directly into:
   - `mods/shared/plugins/<ModName>/` (if needed by both server & client)
   - `mods/server/plugins/<ModName>/` (if server-only)
   - `mods/client/plugins/<ModName>/` (if client-only)
3. **Commit & Push to GitHub**:
   ```bash
   git add .
   git commit -m "Update: Added new RPG mod and balanced drop rates"
   git push origin main
   ```
4. **Deploy to Linux Server**:
   ```bash
   cd ~/tbmrpg-mods
   git pull
   ./scripts/sync_server_linux.sh /path/to/valheim-server
   # Restart Valheim server
   ```

---

## Current Installed Mod List

| Mod | Type | Role |
| :--- | :--- | :--- |
| **EpicLoot** | Shared | Diablo/WoW-style rarity (Magic, Rare, Epic, Legendary), enchanting altar, bounties |
| **CreatureLevelAndLootControl (CLLC)** | Shared | Multi-star enemies, elemental infusions, configurable creature scaling |
| **Marketplace and Server NPCs Revamped** | Shared | NPC merchants, quests, territory systems, teleporters, MMO currency |
| **ServerCharacters** | Shared | Server-authoritative character saving, inventory protection, anti-cheat |
| **Equipment & Quick Slots** | Shared | Dedicated equipment slots (Armor, Cape) and hotbar slots for food & potions |
| **Jötunn (the Valheim Library)** | Shared | Core modding library & ServerSync |
| **JsonDotNET** | Shared | JSON dependency required for mod serialization |
| **ShaderHelperForMac** | Client (Mac) | Restores custom mod shaders and textures on macOS Metal graphics |

---

## Config Syncing & ServerSync Note
Most modern Valheim mods built on **Jötunn** or **ServerSync** automatically enforce configs from the server to clients when players connect. However, having clients pre-configured via this repository ensures:
- Keybindings and UI layouts match.
- Asset files, localization files, and custom recipes load properly before joining.
- Zero mismatch errors during server handshake.
