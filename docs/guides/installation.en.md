---
title: Installation guide
type: guide
lang: en
---

# Installation guide

## 1. Install RitnLib

### Via the Mod Portal (recommended)

In Factorio: **Mods → Browse online → search "RitnLib"** → Download.

RitnLib will be automatically active for any game that depends on it.

### Manual / development install

Clone the repository into Factorio's `mods/` folder:

```
Factorio/
└─ mods/
   └─ RitnLib/          ← folder name must be EXACTLY this (not RitnLib-main, not RitnLib-0.10.1)
      ├─ info.json
      ├─ control.lua
      └─ ...
```

> The folder name must be **exactly** `RitnLib`. Factorio identifies mods by folder name.

## 2. Declare the dependency

In your mod's `info.json`:

```json
{
  "name": "my-mod",
  "version": "0.1.0",
  "factorio_version": "2.0",
  "title": "My mod",
  "author": "me",
  "dependencies": [
    "base",
    "RitnLib"
  ]
}
```

Factorio loads RitnLib **before** your mod at all three stages (settings, data, runtime).

## 3. Verify the installation

Start Factorio and load a game. Add to your `control.lua` as a quick test:

```lua
script.on_event(defines.events.on_player_created, function(event)
    local player = RitnLibPlayer(game.get_player(event.player_index))
    player:print("RitnLib is working!")
end)
```

If you see the message in-game, the installation is good. If `RitnLibPlayer` is `nil`, double-check the dependency in `info.json`.

## 4. IDE autocomplete (LuaLS / VS Code)

RitnLib ships LuaLS annotations in its `types/` folder. They are included in the mod zip for consumer developers.

**Prerequisite**: [Lua Language Server](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) extension in VS Code.

### `.luarc.json` configuration

At the root of **your** mod, create `.luarc.json`:

```json
{
  "workspace.library": [
    "C:/Users/YOURNAME/AppData/Roaming/Factorio/mods/RitnLib/types"
  ],
  "runtime.version": "Lua 5.2"
}
```

Adjust the path to RitnLib's `types/` folder on your system. After that, you get autocomplete on `RitnLibPlayer`, `RitnLibEvent`, `RitnProtoRecipe`, etc. directly in VS Code.

## 5. Minimal consumer mod structure

```
my-mod/
├─ info.json          ← RitnLib dependency declared
├─ settings.lua       ← (optional) RitnLibSetting
├─ data.lua           ← require("__RitnLib__.defines") + RitnProto*
├─ control.lua        ← handlers with RitnLib* available in _G
└─ .luarc.json        ← (dev) path to RitnLib types/
```

## See also

- [Getting started with RitnLib](../getting-started.md)
- [My first prototype](first-prototype.md)
- [My first runtime handler](first-handler.md)
