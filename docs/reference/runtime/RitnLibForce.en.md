---
title: RitnLibForce
type: reference
lang: en
---

# `RitnLibForce`


A short view over a [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html). Gives access to the force's recipes and technologies (as chainable wrappers), production statistics, per-surface chart visibility and chart tags.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnForce.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **Extended by** | consumer subclasses, e.g. `RitnCoreForce` (see [ADR-0001](../../adr/0001-class-factory.md)) |
| **`object_name`** | `"RitnLibForce"` |

---

## Constructor

#### `RitnLibForce(force)` → [`RitnLibForce`](RitnLibForce.md)

Validates the input then freezes the fields. Rejects an input that is not a valid `LuaForce`.

**Parameters**
- `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) — the force to wrap.

**Return value** → [`RitnLibForce`](RitnLibForce.md). On invalid input, [`isPresent`](#ispresent--boolean-read) is `false`.

```lua
local rForce = RitnLibForce(game.forces["player"])
```

> **Note** — Most often obtained via [`RitnLibPlayer:getForce()`](RitnLibPlayer.md#getforce--ritnlibforce) or [`RitnLibEvent:getForce()`](RitnLibEvent.md#getforce--ritnlibforce).

---

## Attributes

All read-only (`[Read]`), frozen at construction.

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) `[Read]`
The wrapped `LuaForce` (live reference).

#### `name` :: `string` `[Read]`
Force name (`"player"`, `"enemy"`…).

#### `index` :: `uint` `[Read]`
Force index.

#### `items_launched` :: `table<string, uint>?` `[Read]`
Items launched in rockets (item→count dictionary). Still available in Factorio 2.0.

#### `rockets_launched` :: `uint?` `[Read]`
Number of rockets launched.

#### `FORCE_ENEMY_NAME` :: `"enemy"` `[Read]`
Enemy force name constant.

#### `FORCE_PLAYER_NAME` :: `"player"` `[Read]`
Player force name constant.

#### `FORCE_NEUTRAL_NAME` :: `"neutral"` `[Read]`
Neutral force name constant.

#### `isPresent` :: `boolean` `[Read]`
`false` if the constructor rejected its input. Test it as a guard.

---

## Methods

#### `:getRecipe(recipe_name)` → [`RitnLibRecipe`](RitnLibRecipe.md)
Returns a [`RitnLibRecipe`](RitnLibRecipe.md) wrapping the named recipe of this force.

**Parameters**
- `recipe_name` :: `string` — recipe name.

> **Warning** — Raises an error (`error`) if the recipe doesn't exist for this force. Make sure of the name beforehand.

```lua
RitnLibEvent(e):getPlayer():getForce():getRecipe("electronic-circuit"):setEnabled(false)
```

#### `:getTechnology(tech_name)` → [`RitnLibTechnology`](RitnLibTechnology.md)
Returns a [`RitnLibTechnology`](RitnLibTechnology.md) wrapping the named technology.

**Parameters**
- `tech_name` :: `string` — technology name.

> **Warning** — Raises an error if the technology doesn't exist for this force.

```lua
RitnLibEvent(e):getPlayer():getForce():getTechnology("ritn-tech-lumberjack").technology.researched = true
```

#### `:setHiddenSurface(surfaceIdentification, value?)` → [`RitnLibForce`](RitnLibForce.md)
Hides or shows a surface for this force on the chart. Chainable.

**Parameters**
- `surfaceIdentification` :: [`SurfaceIdentification`](https://lua-api.factorio.com/latest/concepts/SurfaceIdentification.html) — the target surface.
- `value` :: `boolean?` — `true` to hide (default), `false` to show.

```lua
rForce:setHiddenSurface(rSurface.name, true)
```

#### `:countPlayers()` → `integer`
Number of players in this force (`#self.force.players`).

#### `:getChartTag(tag_number, surface_name, position)` → [`LuaCustomChartTag`](https://lua-api.factorio.com/latest/classes/LuaCustomChartTag.html)`?`
Looks up a chart tag by its `tag_number` at a given position.

**Parameters**
- `tag_number` :: `uint` — id of the tag to find.
- `surface_name` :: `string`|[`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) — the surface.
- `position` :: [`MapPosition`](https://lua-api.factorio.com/latest/concepts/MapPosition.html) — the position (must have `.x` and `.y`).

> **Warning** — Builds a degenerate area `{position, position}` for `find_chart_tags`; may miss a tag due to float rounding.

#### Production statistics — `:getStatsProduction` · `:getStatsProductionItem` · `:getStatsProductionFluid` · `:getStatsCount` · `:getStatsCountKill` · `:getStatsCountBuild`

Return production / kill / build counts (`integer?`).

> **Warning** — These methods depend on `self.stats`, **currently disabled**: its constructor block reads the Factorio **1.x** statistics API, removed in 2.0. On a base instance they raise; a subclass must populate `self.stats`. Details and migration plan: [Factorio 2.0 migration](../../migration-2.0.md).

---

## Usage examples

**Disable recipes for a force** (`RitnElectronic/modules/electronic.lua`):

```lua
RitnLibEvent(e):getPlayer():getForce():getRecipe("radar"):setEnabled(false)
RitnLibEvent(e):getPlayer():getForce():getRecipe("inserter"):setEnabled(false)
```

**Force a technology as researched** (`RitnLumberjack/modules/lumberjack.lua`):

```lua
RitnLibEvent(e):getPlayer():getForce():getTechnology("ritn-tech-lumberjack").technology.researched = true
```

**Hide a surface on the chart** (`RitnCoreGame/modules/force.lua`):

```lua
local rForce = RitnCoreForce(rEvent.force)
rForce:setHiddenSurface(rSurface.name, true)
```

---

## Remarks

- **Temporary wrapper** — never store the instance in `storage`; rebuild it in each handler. See [Temporary wrappers](../../concepts/temporary-wrappers.md).
- **`getRecipe` / `getTechnology` raise** — they `error()` if the name doesn't exist. Prefer a name you're sure of, or guard the call.
- **`getStats*` pending 2.0 migration** — see the warning above and [Factorio 2.0 migration](../../migration-2.0.md).

## See also

- [Class map](../overview.md)
- [`RitnLibRecipe`](RitnLibRecipe.md) · [`RitnLibTechnology`](RitnLibTechnology.md) · [`RitnLibPlayer`](RitnLibPlayer.md)
- [Temporary wrappers (golden rule)](../../concepts/temporary-wrappers.md)
- [Factorio 2.0 migration](../../migration-2.0.md)
