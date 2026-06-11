---
title: Getting started with RitnLib
audience: consumer
lang: en
---

# Getting started with RitnLib

This guide walks you through wiring RitnLib into a Factorio mod (new or existing). By the end, your mod consumes RitnLib at all three stages: **data**, **settings**, and **control**.

## 1. Install the mod

Two options:

- **In-game**: subscribe to [RitnLib on the Mod Portal](https://mods.factorio.com/mod/RitnLib).
- **Manual**: clone or download this repo into `Factorio/mods/RitnLib/`. The folder name must be **exactly** `RitnLib` — not `RitnLib-main` after a GitHub download.

Confirm that `Factorio/mods/RitnLib/info.json` exists and that its `factorio_version` matches yours (currently `2.0`).

## 2. Declare the dependency

In your own mod's `info.json`, add `"RitnLib"` to `dependencies`:

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

Factorio will load RitnLib **before** your mod at all three stages.

## 3. First use — data stage

At the data stage, RitnLib doesn't run anything automatically, but it exposes its manipulators through the `ritnlib.defines` registry.

Create `my-mod/data.lua`:

```lua
require("__RitnLib__.defines")

local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)

-- Add a copper-cable ingredient to automation-science-pack
RitnProtoRecipe("automation-science-pack")
    :addIngredient({"copper-cable", 1})
```

**Notes**:
- `require("__RitnLib__.defines")` populates the `ritnlib` global. Do it once at the top of the file; further requires are idempotent.
- `ritnlib.defines.class.prototype.recipe` is an **abstract path** — RitnLib resolves it to the current source file. You don't hard-code `__RitnLib__/classes/prototypes/Recipe`.
- Prototype classes (`RitnProto*`) are used as `local … = require(...)` — they don't pollute `_G`.

Going further (recipes, technologies, items, ores, …): [Your first prototype](guides/first-prototype.md).

## 4. First use — control stage

At the control stage, RitnLib's runtime classes are **already in `_G`** (RitnLib does that during its own load). Use them directly.

Create `my-mod/control.lua`:

```lua
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    RitnLibPlayer(player):print("Welcome! You're playing with my-mod.")
end)

script.on_event(defines.events.on_research_finished, function(event)
    local tech = RitnLibTechnology(event.research)
    log("Research finished: " .. tech.name)
end)
```

**Notes**:
- No `require` for runtime classes — they're globals (`RitnLibPlayer`, `RitnLibTechnology`, `RitnLibEvent`, `RitnLibSurface`, etc.).
- These are **temporary views**: you make a new one in each event handler. **Never** store them in `storage`. See [Temporary wrappers](concepts/temporary-wrappers.md) for the rationale.

For advanced patterns (inventory snapshot, GUI, cascade-disable of recipes): [Your first runtime handler](guides/first-handler.md).

## 5. First use — settings stage

Create `my-mod/settings.lua`:

```lua
require("__RitnLib__.defines")

local RitnLibSetting = require(ritnlib.defines.class.ritnClass.setting)

RitnLibSetting("my-mod-enable-feature-x")
    :setSettingStartup()
    :setDefaultValueBool(true)
    :new()
```

The trailing `:new()` fires the `data:extend({...})` that registers the setting. You'll see the toggle show up under **Settings → Mods → Startup** with key `my-mod-enable-feature-x`.

> ⚠ **0.9.8 — known limitation**: the `:setTypeBoolean()` setter is broken (see [BUG-009](debt/known-bugs.md)). Fortunately the constructor initialises `dataType = "bool"` by default, so the chain above produces a valid `bool-setting`. For other types (`int`, `double`, `string`, `color`), wait for version `0.10.0-fix`, or set `self.data_setting.type` manually.

## 6. Verify it works

Launch Factorio. Open **Settings → Mods → Startup** and confirm `my-mod-enable-feature-x` is there.

Load a test game. The "Welcome!" message should appear right after the player spawns.

If it doesn't, open `factorio-current.log` (Windows: `%appdata%\Factorio\`, Linux: `~/.factorio/`) and look for errors. Messages prefixed with `RitnLib` or `RitnProto*` come from this library.

## Next steps

- 🧩 [4-layer architecture](concepts/architecture-layers.md) — understand how RitnLib is organized.
- ⚠ [Temporary wrappers](concepts/temporary-wrappers.md) — the **golden rule** to know before touching runtime classes.
- 🗺 [Class map](reference/overview.md) — see what's available.
- 📖 The [guides](guides/installation.md) cover advanced patterns (inventory snapshot, full GUI, cascade-disable, …).
