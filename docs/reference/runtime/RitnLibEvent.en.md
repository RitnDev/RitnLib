---
title: RitnLibEvent
type: reference
lang: en
---

# `RitnLibEvent`


A uniform view over any Factorio [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html). Instead of hand-inspecting a different payload for every event (`event.player_index` here, `event.entity` there, `event.destination` for force merges…), you build **one** `RitnLibEvent` and read `player`, `surface`, `force`, `entity`, `position`… directly — always in the same place, whatever the event. Missing values are `nil`.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnEvent.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **Extended by** | consumer subclasses, e.g. `RitnCoreEvent` (see [ADR-0001](../../adr/0001-class-factory.md)) |
| **`object_name`** | `"RitnLibEvent"` |

---

## Constructor

#### `RitnLibEvent(event, mod_name?)` → [`RitnLibEvent`](RitnLibEvent.md)

Builds the wrapper and extracts every field from the payload **at construction time** (reference copies taken once, not lazy accessors).

**Parameters**
- `event` :: [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) — the payload your handler receives.
- `mod_name` :: `string?` — consuming mod name, used by derived classes (GUI in particular). Default: `"RitnLib"`.

**Return value** → [`RitnLibEvent`](RitnLibEvent.md). If `event` is `nil`, the instance is returned with [`isPresent`](#ispresent--boolean-read) set to `false` and no other field populated.

```lua
script.on_event(defines.events.on_player_created, function(event)
    local rEvent = RitnLibEvent(event)
    if not rEvent.isPresent then return end
    game.print(rEvent.name .. " → " .. rEvent.player.name)
end)
```

> **Note** — In practice Ritn mods don't build `RitnLibEvent` directly: they derive a subclass (`RitnCoreEvent`) whose `:getPlayer()` / `:getSurface()` / `:getForce()` return their own specialized wrappers. The extension pattern is described in [ADR-0001](../../adr/0001-class-factory.md).

---

## Attributes

All read-only (`[Read]`) and frozen at construction. A field is `nil` when the event doesn't carry it.

#### `isPresent` :: `boolean` `[Read]`
`false` if the constructor received a `nil` `event`, `true` otherwise. Test it as a guard at the start of the handler before reading the other fields.

#### `name` :: `string` `[Read]`
Symbolic event name, resolved from `defines.events` (e.g. `"on_player_created"`). Special case: `"on_tick"` when `event.name == 0`.

#### `index` :: `uint` `[Read]`
Numeric event id (alias of `event.name`).

#### `mod_name` :: `string` `[Read]`
Consuming mod name passed to the constructor (`"RitnLib"` by default).

#### `event` :: [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) `[Read]`
The original payload, kept verbatim — useful to reach a rare field the class doesn't normalize.

#### `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html)`?` `[Read]`
Extracted via `event.player_index` (`game.get_player(...)`).

#### `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html)`?` `[Read]`
Extracted via `event.surface_index` (`game.get_surface(...)`), otherwise via `event.surface`.

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html)`?` `[Read]`
Extracted via `event.force`. Special case `on_forces_merging`: yields `event.destination` (the surviving force).

#### `recipe` :: [`LuaRecipe`](https://lua-api.factorio.com/latest/classes/LuaRecipe.html)`?` `[Read]`
`event.recipe` if present.

#### `technology` :: [`LuaTechnology`](https://lua-api.factorio.com/latest/classes/LuaTechnology.html)`?` `[Read]`
`event.research` if present (research events).

#### `entity` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
First available among `created_entity` (1.x), `vehicle`, then `entity`. **2.0 note**: `event.created_entity` no longer exists in 2.0 (dead branch); trigger-created entities now arrive through the `on_trigger_created_entity` event. See [2.0 migration](../../migration-2.0.md).

#### `robot` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
`event.robot` if present (robot build/mine events).

#### `rocket` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
`event.rocket` if present. Still valid in 2.0; for **full** launch completion, listen to `on_cargo_pod_finished_ascending` instead (see [2.0 migration](../../migration-2.0.md)).

#### `inventory` :: [`LuaInventory`](https://lua-api.factorio.com/latest/classes/LuaInventory.html)`?` `[Read]`
First available among `buffer`, `loot`, `items`, `inventory`.

#### `cause` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
`event.cause` (death events: the originating entity).

#### `reason` :: [`defines.disconnect_reason`](https://lua-api.factorio.com/latest/defines.html#defines.disconnect_reason)`?` `[Read]`
`event.reason` (disconnect events). See [`:getReason()`](#getreason--string) for the symbolic name.

#### `queued_count` :: `number?` `[Read]`
`event.queued_count` (chunk requests).

#### `gui_type` :: `string?` `[Read]`
Symbolic name resolved from `event.gui_type` (`defines.gui_type`).

#### `source` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html)`?` `[Read]`
`event.source` (source force of a merge).

#### `source_name` :: `string?` `[Read]`
`event.source_name` (source force name after a merge).

#### `area` :: [`BoundingBox`](https://lua-api.factorio.com/latest/concepts/BoundingBox.html)`?` `[Read]`
`event.area` (area-selection events).

#### `element` :: [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html)`?` `[Read]`
`event.element` (GUI events).

#### `setting_name` :: `string?` `[Read]`
`event.setting` — name of the changed mod setting (`on_runtime_mod_setting_changed`).

#### `setting_type` :: `string?` `[Read]`
`event.setting_type` — `"startup"`, `"runtime-global"` or `"runtime-per-user"`.

#### `position` :: [`MapPosition`](https://lua-api.factorio.com/latest/concepts/MapPosition.html)`?` `[Read]`
`event.cursor_position` first, otherwise `event.position`. Returns `nil` for chunk events (`on_chunk_charted`, `on_chunk_generated`) where `position` isn't the player-relevant one.

---

## Methods

#### `:getPlayer()` → [`RitnLibPlayer`](RitnLibPlayer.md)
Wraps [`player`](#player--luaplayer-read) in a [`RitnLibPlayer`](RitnLibPlayer.md) (fast force/surface/character access…).

```lua
local rPlayer = RitnLibEvent(event):getPlayer()
```

#### `:getSurface()` → [`RitnLibSurface`](RitnLibSurface.md)
Wraps [`surface`](#surface--luasurface-read) in a [`RitnLibSurface`](RitnLibSurface.md).

#### `:getForce()` → [`RitnLibForce`](RitnLibForce.md)
Wraps [`force`](#force--luaforce-read) in a [`RitnLibForce`](RitnLibForce.md).

#### `:getTechnology()` → [`RitnLibTechnology`](RitnLibTechnology.md)
Wraps [`technology`](#technology--luatechnology-read) in a [`RitnLibTechnology`](RitnLibTechnology.md).

#### `:getReason()` → `string?`
Translates [`reason`](#reason--definesdisconnect_reason-read) (a `defines.disconnect_reason`) into a symbolic name, for disconnect events.

**Return value** → `string?` — one of `"quit"`, `"dropped"`, `"reconnect"`, `"wrong_input"`, `"desync_limit_reached"`, `"cannot_keep_up"`, `"afk"`, `"kicked"`, `"kicked_and_deleted"`, `"banned"`, `"switching_servers"`; `nil` if unmatched.

```lua
script.on_event(defines.events.on_player_left_game, function(event)
    local rEvent = RitnLibEvent(event)
    log("player left: " .. tostring(rEvent:getReason()))
end)
```

#### `RitnLibEvent.setIngredientColor(ingredient, color)`
**Static** helper (call with a dot, not `:`). Relays to the DiscoScience mod if it is loaded and exposes the `setIngredientColor` interface; no-op otherwise.

**Parameters**
- `ingredient` :: `string` — item name passed to DiscoScience.
- `color` :: [`Color`](https://lua-api.factorio.com/latest/concepts/Color.html) — color table `{r, g, b, a}`.

```lua
RitnLibEvent.setIngredientColor("automation-science-pack", { r = 1, g = 0.2, b = 0.2 })
```

> **Warning** — Static method: `RitnLibEvent.setIngredientColor(...)`, **not** `instance:setIngredientColor(...)`.

---

## Usage examples

**Minimal handler** — react to a player being created:

```lua
script.on_event(defines.events.on_player_created, function(event)
    local rEvent = RitnLibEvent(event)
    if not rEvent.isPresent then return end
    rEvent.player.print({ "", "Welcome to ", rEvent.surface.name })
end)
```

**React to a runtime mod setting** (`RitnLobbyGame/modules/lobby.lua`):

```lua
local rEvent = RitnCoreEvent(e)
if rEvent.setting_type == "runtime-global" then
    if rEvent.setting_name == ritnlib.defines.lobby.names.settings.surfaceMax then
        local value = settings.global[rEvent.setting_name].value
        -- … apply the new limit
    end
end
```

**Surface + area of a selection event** (`RitnEnemy/modules/player.lua`):

```lua
local rEvent = RitnCoreEvent(e)
RitnEnemySurface(rEvent.surface):changeForceEnemy(rEvent.area)
```

---

## Remarks

- **Temporary wrapper** — never store the instance in `storage`; rebuild it in each handler. See [Temporary wrappers](../../concepts/temporary-wrappers.md).
- **Frozen extraction** — fields are read once at construction. If game state changes during the handler, rebuild a `RitnLibEvent`.
- **2.0 compatibility** — `created_entity` is inert, `rocket` still valid (see [2.0 migration](../../migration-2.0.md)). Space Age events (`on_space_platform_*`, `on_player_changed_planet`, `on_segment_*`, `on_object_destroyed`) are not normalized yet.

## See also

- [Class map](../overview.md)
- [`RitnLibPlayer`](RitnLibPlayer.md) · [`RitnLibSurface`](RitnLibSurface.md) · [`RitnLibForce`](RitnLibForce.md) · [`RitnLibTechnology`](RitnLibTechnology.md)
- [Temporary wrappers (golden rule)](../../concepts/temporary-wrappers.md)
- [ADR-0001 — Class factory](../../adr/0001-class-factory.md)
