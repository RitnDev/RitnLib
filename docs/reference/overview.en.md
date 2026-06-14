---
title: Class map
type: reference
lang: en
---

# Class map


This page lists **every public RitnLib class**, with for each one: its source file, access mode, inheritance and a short description. To understand how these classes stack up, see [The 4-layer architecture](../concepts/architecture-layers.md).

## How to access a class

Two access modes depending on the family:

| Family | Access mode | Example |
|---|---|---|
| Runtime classes (`RitnLib*`) | **Globals** — injected into `_G` by `core/setup-classes.lua`, no `require` | `local rPlayer = RitnLibPlayer(player)` |
| Data / settings classes (`RitnProto*`, `RitnIngredient`, `RitnLibSetting`) | **`require`** through the `ritnlib.defines` registry | `local Recipe = require(ritnlib.defines.class.prototype.recipe)` |

```lua
-- at the top of a data-stage file:
require("__RitnLib__.defines")          -- creates the ritnlib global (idempotent)
local Recipe = require(ritnlib.defines.class.prototype.recipe)
```

⚠ Runtime classes produce **temporary wrappers**: never store them in `storage`. See the [golden rule](../concepts/temporary-wrappers.md).

## Inheritance tree

```
RitnPrototype ──► every RitnProto* (except RitnProtoRecipeCategory, no inheritance)

RitnLibPlayer ──► RitnLibGui ──► RitnLibInformatron
```

Every class is built by the in-house factory [`ritnlib.classFactory`](../adr/0001-class-factory.md) (`core/class.lua`).

## Runtime classes (control stage) — globals

| Class | File | Wraps | Description |
|---|---|---|---|
| [`RitnLibEvent`](runtime/RitnLibEvent.md) | `classes/LuaClass/RitnEvent.lua` | any event | Normalizes an event payload into ready-to-use fields (`player`, `surface`, `force`, `entity`, `recipe`…). |
| [`RitnLibPlayer`](runtime/RitnLibPlayer.md) | `classes/LuaClass/RitnPlayer.lua` | `LuaPlayer` | Fast access to player info: force, surface, character, driving, admin status. |
| [`RitnLibSurface`](runtime/RitnLibSurface.md) | `classes/LuaClass/RitnSurface.lua` | `LuaSurface` | Entity search on a surface. |
| [`RitnLibForce`](runtime/RitnLibForce.md) | `classes/LuaClass/RitnForce.lua` | `LuaForce` | A force's recipes, technologies, statistics and rocket launches. |
| [`RitnLibEntity`](runtime/RitnLibEntity.md) | `classes/LuaClass/RitnEntity.lua` | `LuaEntity` | Entity manipulation: vehicle driver/passenger, destruction. |
| [`RitnLibRecipe`](runtime/RitnLibRecipe.md) | `classes/LuaClass/RitnRecipe.lua` | `LuaRecipe` | Enable/disable a recipe at runtime. |
| [`RitnLibTechnology`](runtime/RitnLibTechnology.md) | `classes/LuaClass/RitnTechnology.lua` | `LuaTechnology` | Research-finished hook for a technology. |
| [`RitnLibGui`](runtime/RitnLibGui.md) | `classes/LuaClass/RitnGui.lua` | GUI event | GUI event dispatcher by element-naming convention. Inherits from `RitnLibPlayer`. |
| [`RitnLibInformatron`](runtime/RitnLibInformatron.md) | `classes/RitnClass/RitnInformatron.lua` | Informatron event | Informatron page integration. Inherits from `RitnLibGui`. Marked `-- beta` in `defines.lua`. |
| [`RitnLibInventory`](runtime/RitnLibInventory.md) | `classes/RitnClass/RitnInventory.lua` | `LuaPlayer` + supplied table | Player inventory snapshot & restore (the consumer mod supplies the storage table). |
| [`RitnLibGuiElement`](runtime/RitnLibGuiElement.md) | `classes/RitnClass/gui/RitnGuiElement.lua` | `add{...}` payload | Fluent builder for a `LuaGuiElement` creation payload. |
| [`RitnLibStyle`](runtime/RitnLibStyle.md) | `classes/RitnClass/gui/RitnStyle.lua` | `LuaStyle` | Style presets: stretch, alignment, visibility, colors. |

These classes are also reachable via `require` (keys `ritnlib.defines.class.luaClass.*`, `ritnClass.*`, `gui.*`), but that is the internal loading path — in practice you use the globals.

## Data classes (data stage) — via `require`

`defines` key = prefix with `ritnlib.defines.class.` in the `require`.

| Class | `defines` key | Manipulates | Description |
|---|---|---|---|
| [`RitnPrototype`](prototype/RitnPrototype.md) | `ritnClass.prototype` | `data.raw[type][name]` | Base class of all manipulators: prototype copy + generic mutators (`:changePrototype`, `:setPrototype`, `:update`…). |
| [`RitnProtoEntity`](prototype/RitnProtoEntity.md) | `prototype.entity` | `data.raw[<entity-type>]` | Entities, auto-detected type. |
| [`RitnProtoItem`](prototype/RitnProtoItem.md) | `prototype.item` | `data.raw[<item-type>]` | Items, auto-detected type. |
| [`RitnProtoRecipe`](prototype/RitnProtoRecipe.md) | `prototype.recipe` | `data.raw.recipe` | Recipes: ingredients, results, activation. |
| [`RitnProtoTech`](prototype/RitnProtoTech.md) | `prototype.tech` (alias `technology`) | `data.raw.technology` | Technologies: costs, science packs, prerequisites, recipe unlocks, cascade disable. |
| [`RitnProtoOre`](prototype/RitnProtoOre.md) | `prototype.ore` | `data.raw.resource` + autoplace | Ores and their autoplace control. |
| [`RitnProtoSprite`](prototype/RitnProtoSprite.md) | `prototype.sprite` | `data.raw.sprite` + utility-sprites | Sprites. |
| [`RitnProtoStyle`](prototype/RitnProtoStyle.md) | `prototype.style` | `data.raw["gui-style"].default` | Prototyped GUI styles. |
| [`RitnProtoItemGroup`](prototype/RitnProtoItemGroup.md) | `prototype.group` | `data.raw["item-group"]` | Item groups (crafting tabs). |
| [`RitnProtoItemSubgroup`](prototype/RitnProtoItemSubgroup.md) | `prototype.subgroup` | `data.raw["item-subgroup"]` | Item subgroups (crafting rows). |
| [`RitnProtoRecipeCategory`](prototype/RitnProtoRecipeCategory.md) | `prototype.category` | `data.raw["recipe-category"]` | Recipe categories. ⚠ Declared **without** inheriting `RitnPrototype`: generic mutators are not available. |
| [`RitnProtoFuelCategory`](prototype/RitnProtoFuelCategory.md) | `prototype.fuelCategory` | `data.raw["fuel-category"]` | Fuel categories. |
| [`RitnProtoCustomInput`](prototype/RitnProtoCustomInput.md) | `prototype.customInput` | `data.raw["custom-input"]` | Custom keyboard shortcuts. |
| [`RitnProtoUtilityConst`](prototype/RitnProtoUtilityConst.md) | `prototype.utility.constants` | `data.raw["utility-constants"].default` | Engine UI constants. |
| [`RitnIngredient`](prototype/RitnIngredient.md) | `ritnClass.ingredient` | ingredient table | Recipe-ingredient normalization. |

> Note: the actual class name is **`RitnProtoTech`** (not `RitnProtoTechnology`) — that is what appears in `object_name` and in the LuaLS annotations.

## Settings stage — via `require`

| Class | `defines` key | Description |
|---|---|---|
| [`RitnLibSetting`](settings/RitnLibSetting.md) | `ritnClass.setting` | Fluent builder for a mod-setting prototype, registered via `data:extend`. ⚠ As it stands, only **bool** settings work (see [known bugs](../debt/known-bugs.md)). |

## Utility libraries (`lualib/`) — via `require`

Not classes, but function modules. Direct keys in `ritnlib.defines`:

| Module | `defines` key | Description |
|---|---|---|
| [`other-functions`](lualib/other-functions.md) | `other` | Custom `type()` (recognizes `LuaPlayer`, `LuaEntity`…), `ifElse`, `tryCatch`, `uuid`, freeplay helpers. |
| [`table-functions`](lualib/table-functions.md) | `table` | Enriched `table` wrappers. |
| [`string-functions`](lualib/string-functions.md) | `string` | Enriched `string` wrappers. |
| [`json-functions`](lualib/json-functions.md) | `json` | JSON encode/decode — embeds [rxi/json.lua](https://github.com/rxi/json.lua) (MIT). |
| [`entity-functions`](lualib/entity-functions.md) | *(direct require)* | Entity-prototype helpers. |
| [`gui-functions`](lualib/gui-functions.md) | *(direct require)* | GUI-prototype helpers. |
| [`LuaStyle-functions`](lualib/LuaStyle-functions.md) | *(direct require)* | ⚠ Deprecated — superseded by `RitnLibStyle`. |

## Foundation layer (`core/`)

| File | Description |
|---|---|
| [`core/class.lua`](core/class-factory.md) | The `ritnlib.classFactory.newclass(super, init)` factory that builds every class above. See [ADR-0001](../adr/0001-class-factory.md). |
| [`core/constants.lua`](core/constants.md) | Science-pack tints, UI colors, string markers, enemy sizes. |
| [`core/eventListener.lua`](core/event-listener.md) | ⚠ Fork of `event_handler`, experimental status — not wired in by `control.lua`. |
| [`core/interfaces.lua`](core/interfaces.md) | `remote.add_interface("RitnLib", {})` — empty interface today, reserved. |

## See also

- [`ritnlib.defines` registry](defines.md)
- [The 4-layer architecture](../concepts/architecture-layers.md)
- [Temporary wrappers (golden rule)](../concepts/temporary-wrappers.md)
- [Known bugs](../debt/known-bugs.md)
