---
title: RitnLibPlayer
type: reference
lang: en
---

# `RitnLibPlayer`


A short view over a [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html). Exposes the most-accessed player info (`force`, `surface`, `character`, `admin`, `driving`…) as direct properties, and provides accessors that return other RitnLib wrappers — enabling the `:getForce():getRecipe(...)` chaining.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnPlayer.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **Extended by** | consumer subclasses, e.g. `RitnCorePlayer`, `RitnCharacter` (see [ADR-0001](../../adr/0001-class-factory.md)) |
| **`object_name`** | `"RitnLibPlayer"` |

---

## Constructor

#### `RitnLibPlayer(player)` → [`RitnLibPlayer`](RitnLibPlayer.md)

Validates the input then freezes the player fields. The input is rejected if it is not a `LuaPlayer`, if it is invalid (`valid == false`), or if `is_player()` is false.

**Parameters**
- `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html) — the player to wrap.

**Return value** → [`RitnLibPlayer`](RitnLibPlayer.md). On invalid input, the instance is returned with [`isPresent`](#ispresent--boolean-read) set to `false` and no other field populated.

```lua
local rPlayer = RitnLibPlayer(game.get_player(event.player_index))
if not rPlayer.isPresent then return end
```

> **Note** — Most of the time you get a `RitnLibPlayer` through [`RitnLibEvent:getPlayer()`](RitnLibEvent.md#getplayer--ritnlibplayer) rather than calling the constructor by hand.

---

## Attributes

All read-only (`[Read]`) and frozen at construction (snapshot).

#### `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html) `[Read]`
The wrapped `LuaPlayer` (live reference). An escape hatch to call any native method the wrapper doesn't expose.

#### `index` :: `uint` `[Read]`
Player index (snapshot).

#### `name` :: `string` `[Read]`
Player name (snapshot).

#### `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) `[Read]`
The player's surface **at instantiation time**. May become stale if the player later changes surface — rebuild the wrapper if needed.

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) `[Read]`
The player's force **at instantiation time**. Snapshot, may go stale.

#### `controller_type` :: [`defines.controllers`](https://lua-api.factorio.com/latest/defines.html#defines.controllers) `[Read]`
Controller type (integer, snapshot).

#### `controller_name` :: `string?` `[Read]`
Symbolic name resolved from `controller_type` (e.g. `"character"`, `"god"`, `"editor"`).

#### `character` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
The player's character entity; `nil` in god/editor controllers.

#### `admin` :: `boolean` `[Read]`
Whether the player is an admin (snapshot — may change at runtime).

#### `driving` :: `boolean` `[Read]`
Whether the player is driving (snapshot).

#### `vehicle` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
The vehicle being driven, `nil` otherwise.

#### `connected` :: `boolean` `[Read]`
Whether the player is connected (snapshot).

#### `isPresent` :: `boolean` `[Read]`
`false` if the constructor rejected its input, `true` otherwise. Test it as a guard before using the other fields.

---

## Methods

#### `:print(text)` → [`RitnLibPlayer`](RitnLibPlayer.md)
Prints a message to the player. `table` values are serialized via `serpent.block`; non-string/non-table values fall back to `tostring` (inside a `pcall`). Returns `self` (chainable).

**Parameters**
- `text` :: `string`|`table` — text or table to print (a [`LocalisedString`](https://lua-api.factorio.com/latest/concepts/LocalisedString.html) is a table).

```lua
RitnLibPlayer(player):print("Hello")
```

#### `:getForce()` → [`RitnLibForce`](RitnLibForce.md)
Wraps [`force`](#force--luaforce-read) in a [`RitnLibForce`](RitnLibForce.md).

#### `:getSurface()` → [`RitnLibSurface`](RitnLibSurface.md)
Wraps [`surface`](#surface--luasurface-read) in a [`RitnLibSurface`](RitnLibSurface.md).

#### `:cancel_all_crafting()`
Cancels every entry in the player's crafting queue. Wrapped in a `pcall` — errors are silently swallowed.

#### `:onNauvis()` → `boolean`
`true` if the player is on the `nauvis` surface.

> **Note** — Returns `false` on Space Age planets (vulcanus/fulgora/gleba/aquilo) and on space platforms: the check is exactly the surface name `'nauvis'`.

---

## Usage examples

**Fluent chaining** — disable a recipe for the player's force (`RitnElectronic/modules/electronic.lua`):

```lua
RitnLibEvent(e):getPlayer():getForce():getRecipe("radar"):setEnabled(false)
```

**Branch on admin status** (`RitnLobbyGame/modules/menu.lua`):

```lua
local rPlayer = RitnCoreEvent(e):getPlayer()
if rPlayer.admin then
    -- … admin-only menu
end
```

**Escape hatch to the native `LuaPlayer`** (`RitnLobbyGame/classes/RitnSurface.lua`):

```lua
local rPlayer = RitnCorePlayer(game.get_player(applicant))
rPlayer.player.print({ "msg.send-request", self.name }, { r = 1, g = 0, b = 0, a = 0.3 })
```

---

## Remarks

- **Temporary wrapper** — never store the instance in `storage`; rebuild it in each handler. See [Temporary wrappers](../../concepts/temporary-wrappers.md).
- **Snapshot fields** — `surface`, `force`, `admin`, `driving`, `connected`, `vehicle` are frozen at construction. For a fresh value, read from [`player`](#player--luaplayer-read) or rebuild the wrapper.
- **God / editor** — [`character`](#character--luaentity-read) is `nil` in those controllers.

## See also

- [Class map](../overview.md)
- [`RitnLibEvent`](RitnLibEvent.md) · [`RitnLibForce`](RitnLibForce.md) · [`RitnLibSurface`](RitnLibSurface.md)
- [Temporary wrappers (golden rule)](../../concepts/temporary-wrappers.md)
- [ADR-0001 — Class factory](../../adr/0001-class-factory.md)
