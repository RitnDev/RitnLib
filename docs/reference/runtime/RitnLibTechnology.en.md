---
title: RitnLibTechnology
type: reference
lang: en
---

# `RitnLibTechnology`


A runtime view over a [`LuaTechnology`](https://lua-api.factorio.com/latest/classes/LuaTechnology.html) — the **per-force** instance, at control stage. Its main use: on research finish, disable a set of recipes and reassign the machines that were using them to a replacement recipe.

> To **mutate a technology at data stage** (packs, prerequisites, unlocked recipes), use [`RitnProtoTech`](../prototype/RitnProtoTech.md) instead.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnTechnology.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **`object_name`** | `"RitnLibTechnology"` |

---

## Constructor

#### `RitnLibTechnology(technology)` → [`RitnLibTechnology`](RitnLibTechnology.md)

Validates the input then freezes the fields. Rejects an input that is not a valid `LuaTechnology`.

**Parameters**
- `technology` :: [`LuaTechnology`](https://lua-api.factorio.com/latest/classes/LuaTechnology.html) — the runtime technology (e.g. `event.research`).

**Return value** → [`RitnLibTechnology`](RitnLibTechnology.md). On invalid input, [`isPresent`](#ispresent--boolean-read) is `false`.

> **Note** — Most often obtained via [`RitnLibForce:getTechnology(name)`](RitnLibForce.md#gettechnologytech_name--ritnlibtechnology) or directly from `event.research`.

---

## Attributes

#### `technology` :: [`LuaTechnology`](https://lua-api.factorio.com/latest/classes/LuaTechnology.html) `[Read]`
The wrapped `LuaTechnology` (live reference).

#### `name` :: `string` `[Read]`
Technology name (snapshot).

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) `[Read]`
Force the technology belongs to (snapshot).

#### `entity_type` :: `string` `[Read]`
Default entity type targeted by [`:updateRecipe`](#updaterecipetechfinished-disabletabrecipes-setrecipe-entitytype--ritnlibtechnology) (default `"assembling-machine"`).

#### `isPresent` :: `boolean` `[Read]`
`false` if the constructor rejected its input. Test it as a guard.

---

## Methods

#### `:updateRecipe(techFinished, disableTabRecipes, setRecipe, entityType?)` → [`RitnLibTechnology`](RitnLibTechnology.md)

On research finish: if `self.name == techFinished`, disables each recipe in `disableTabRecipes` for the force, then walks every surface and reassigns the machines (`entity_type`) that were using one of those recipes to `setRecipe`. No-op if `self.name ~= techFinished`.

**Parameters**
- `techFinished` :: `string` — technology name matched against `self.name`.
- `disableTabRecipes` :: `string[]` — recipes to disable.
- `setRecipe` :: `string` — replacement recipe to set on the matching machines.
- `entityType` :: `string?` — overrides `entity_type` (default `"assembling-machine"`).

```lua
script.on_event(defines.events.on_research_finished, function(event)
    RitnLibTechnology(event.research):updateRecipe(
        "automation-2",
        { "assembling-machine-1" },
        "assembling-machine-2"
    )
end)
```

> **Warning — performance** — walks every surface and every entity of the target type: O(surfaces × entities). On Space Age (multiple planets), it iterates across all of them. Scope by surface if needed.

> **2.0 note** — `LuaEntity.set_recipe` now accepts a quality parameter, which this method doesn't pass through yet. See [Factorio 2.0 migration](../../migration-2.0.md).

---

## Usage example

**Reassignment driven by a config table** (`RitnMiner/modules/miner.lua`):

```lua
RitnTech:updateRecipe(iTech.name, iTech.disableTabRecipes, iTech.setRecipeName)
```

---

## Remarks

- **Runtime vs data stage** — to change the technology definition (packs, prerequisites), use [`RitnProtoTech`](../prototype/RitnProtoTech.md) at data stage.
- **Temporary wrapper** — never store the instance in `storage`. See [Temporary wrappers](../../concepts/temporary-wrappers.md).

## See also

- [Class map](../overview.md)
- [`RitnLibForce`](RitnLibForce.md) · [`RitnProtoTech`](../prototype/RitnProtoTech.md)
- [Factorio 2.0 migration](../../migration-2.0.md)
