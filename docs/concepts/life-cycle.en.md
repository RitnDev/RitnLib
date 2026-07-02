---
title: Life cycle (settings → data → runtime)
type: concept
lang: en
---

# Life cycle — settings → data → runtime

Factorio loads mods in **three sequential passes**. RitnLib exposes different tools at each pass. Knowing which pass is active tells you which `require` is valid, which Factorio APIs are available, and which RitnLib classes you can instantiate.

## Overview

```
Factorio starts
│
├─► SETTINGS STAGE  settings.lua / settings-updates.lua / settings-final-fixes.lua
│   Available : settings (write)
│   RitnLib  : RitnLibSetting (🚧 beta)
│
├─► DATA STAGE      data.lua / data-updates.lua / data-final-fixes.lua
│   Available : data, settings (read)
│   RitnLib  : RitnProto* + RitnIngredient (explicit require)
│              helpers lualib/entity, lualib/gui, lualib/LuaStyle
│
└─► RUNTIME STAGE   control.lua + script.on_event(...) handlers
    Available : game, storage, script, rendering, remote…
    RitnLib  : all LuaClass/* classes injected into _G automatically
               + RitnLibInventory, RitnLibGui, RitnLibInformatron
```

## Settings stage

The first to execute. Factorio settings (`mod-settings.dat`) are read and written here.

RitnLib provides `RitnLibSetting` as a fluent builder — see its reference page for current status (🚧 beta).

```lua
-- my-mod/settings.lua
require("__RitnLib__.defines")
local RitnSetting = require(ritnlib.defines.class.ritnClass.setting)

RitnSetting("my-mod-enable-feature")
    :setSettingStartup()
    :setDefaultValueBool(true)
    :new()
```

## Data stage

All `data.lua` files execute, building `data.raw` (the prototype registry). Settings are accessible in read mode.

RitnLib injects `ritnlib.defines` as soon as you do `require("__RitnLib__.defines")` in your `data.lua`. Then you can require proto classes:

```lua
-- my-mod/data.lua
require("__RitnLib__.defines")

local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)

RitnProtoRecipe("my-recipe")
    :setIngredients({ { "iron-plate", 5 } })
    :setResult("iron-gear-wheel", 2)
    :new()
```

**Limitation**: `game`, `storage`, `script` do not exist at the data stage. Never use them here.

## Runtime stage

This is the game stage. RitnLib loads `core/setup-classes.lua` in its `control.lua`, injecting all runtime classes into `_G`. You use them without `require`:

```lua
-- my-mod/control.lua
script.on_event(defines.events.on_player_created, function(event)
    local player = RitnLibPlayer(game.get_player(event.player_index))
    player:print("Welcome!")
end)
```

**RitnLib registers no handlers of its own.** It never calls `script.on_event` or accesses `storage`. All handlers come from your mod.

## Common mistakes

| Error | Cause | Fix |
|---|---|---|
| `attempt to index a nil value (global 'game')` at data stage | `game` doesn't exist at data stage | Remove the call, use `data.raw` instead |
| `RitnLibPlayer` is `nil` at data stage | LuaClass/* not loaded | These are only available at runtime stage |
| `data.raw` is `nil` at runtime stage | `data` only exists at settings/data stages | Read prototypes at the right stage |

## See also

- [Architecture in 4 layers](architecture-layers.md)
- [Temporary wrappers](temporary-wrappers.md)
- [Reference: RitnLibEvent](../reference/runtime/RitnLibEvent.md)
- [Reference: RitnPrototype](../reference/prototype/RitnPrototype.md)
