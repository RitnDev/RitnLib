---
title: lualib/entity-info
type: reference
lang: en
---

# `lualib/entity-info`


Reads **what an entity can do**, without a list of types: inventories sorted by role, game state (text and colour),
progress, health, fluids, accepted recipes. An entity of another mod thus works without dedicated code.

| | |
|---|---|
| **Source** | `lualib/entity-info.lua` |
| **Type** | function module (returned table), control stage |
| **Access** | `local entityInfo = require(ritnlib.defines.entity_info)` |

---

## Constants

#### `ROLES` :: `string[]` `[Read]`
Roles of the inventories, in display order: `fuel`, `burnt`, `input`, `output`, `modules`, `ammo`, `main`, `trash`.

#### `COLORS` :: `table<string, Color>` `[Read]`
Colour of each status level: `ok`, `warning`, `alert`.

---

## Functions

#### `role(name)` → `string`
Role of an inventory from its name in `defines.inventory` (e.g. `crafter_input` → `input`); `main` if nothing matches.

#### `inventories(entity)` → `RitnLibEntityInventory[]`
Inventories of the entity with at least one slot, sorted by role then by index: `{ id, name, role, inventory }`.

#### `status(entity)` → `RitnLibEntityStatus?`
Game state, or `nil` if the entity has none: `{ name, caption, level, color }`. `caption` is the game text
(`entity-status.*`).

#### `progress(entity)` → `number?`
Progress in `[0, 1]` of a crafting machine or a mining drill, otherwise `nil`.

#### `health(entity)` → `number?`
Health in `[0, 1]`, or `nil` for an entity without health.

#### `fluids(entity)` → `RitnLibEntityFluid[]`
Fluid storages that have a capacity: `{ index, name?, amount, capacity }`. A crafting machine has some only for its
recipe.

#### `hasRecipeChoice(entity)` → `boolean`
True for an assembling machine without a fixed recipe. The game chooses the recipe of a furnace.

#### `acceptsRecipe(entity, recipe)` → `boolean`
True if the entity prototype has a crafting category in common with the recipe (`LuaRecipePrototype`).

#### `recipes(entity, force)` → `LuaRecipePrototype[]`
Recipes already unlocked by the force, accepted by the entity, not hidden.
