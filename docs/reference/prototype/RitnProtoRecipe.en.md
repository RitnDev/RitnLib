---
title: RitnProtoRecipe
type: reference
lang: en
---

# `RitnProtoRecipe`


**Data-stage** manipulator for `data.raw["recipe"][<name>]`. A fluent toolkit to mutate a recipe: enable/disable, hide/show, add/remove/replace ingredients, propagate the science-pack tint and the subgroup to the matching item. Every setter writes back to `data.raw` (via `:update()`) and returns `self` (chainable).

> **Note — difficulty variants**: methods also walk the legacy `normal` / `expensive` branches (1.x API) in addition to `ingredients` / `results`. If those branches don't exist, they are simply no-ops. See [Factorio 2.0 migration](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Recipe.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.recipe)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoRecipe"` |

```lua
-- my-mod/data.lua
require("__RitnLib__.defines")
local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)
```

---

## Constructor

#### `RitnProtoRecipe(recipe_name)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)

Sets the basics via `RitnPrototype.init` then **deep-copies** `data.raw["recipe"][recipe_name]` into [`prototype`](#prototype-table-read). If the recipe doesn't exist, `prototype` stays `nil` (all setters become no-ops).

**Parameters**
- `recipe_name` :: `string` — recipe name in `data.raw`.

---

## Attributes

#### `name` :: `string` `[Read]`
Recipe name (inherited from [`RitnPrototype`](RitnPrototype.md)).

#### `type` :: `string` `[Read]`
Resolved type (`"recipe"`).

#### `prototype` :: `table?` `[Read]`
Working copy of `data.raw["recipe"][name]`. All mutations apply to it, then `:update()` writes it back to `data.raw`. `nil` if the recipe doesn't exist.

#### `object_name` :: `"RitnProtoRecipe"` `[Read]`
Type sentinel.

#### `listTint` :: `string[]` `[Read]`
Ordered list of tint keys (`"red"`, `"automation"`, `"logistic"`…), from `core/constants.lua`.

#### `tint` :: `table<string, table>` `[Read]`
Tint palette (`{primary, secondary, tertiary, quaternary}` per key), from `core/constants.lua`.

---

## Ingredient format

The ingredient methods accept (via [`RitnIngredient`](RitnIngredient.md)):

- array form: `{ "advanced-circuit", 2 }`
- table form: `{ type = "item", name = "steel-plate", amount = 4 }`
- bare string: `"steel-plate"` (for lookups/removals)

---

## Methods — enable & visibility

#### `:setEnabled(value?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Sets the `enabled` flag on the prototype **and** on the legacy `normal` / `expensive` branches if present. `value` defaults to `true`.

```lua
RitnProtoRecipe('logistic-science-pack'):setEnabled()
RitnProtoRecipe('light-armor'):setEnabled(false)
```

#### `:disable()` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Disables **and** hides the recipe, then sets `hidden = true` on the result item (via `RitnProtoItem`).

#### `:setHidden(value, crafting?, stats?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Sets `hidden` on the prototype and its difficulty branches. If `crafting` is non-nil, also sets `hide_from_player_crafting`; if `stats` is non-nil, `hide_from_player_stats`.

**Parameters**
- `value` :: `boolean` — flag value.
- `crafting` :: `any?` — if non-nil, also applies to `hide_from_player_crafting`.
- `stats` :: `any?` — if non-nil, also applies to `hide_from_player_stats`.

> ⚠ `hide_from_player_stats` does not exist in the Factorio schema (the correct key is `hide_from_stats`): the `stats` parameter has no effect. See [1.x API leftovers](../../debt/api-1.x-leftover.md).

---

## Methods — ingredients

#### `:addIngredient(ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Adds the ingredient; **combines** (sums amounts) if an ingredient with the same name already exists.

#### `:addNewIngredient(ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Adds the ingredient; **ignores** if an ingredient with the same name already exists.

#### `:setIngredient(ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Replaces in place every entry matching the ingredient's name.

#### `:removeIngredient(ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Removes the ingredient from every branch.

#### `:removeAllIngredient()` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Empties every ingredient list.

#### `:replaceIngredient(old_name, new_ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Replaces the ingredient named `old_name` by `new_ingredient` in each existing branch. If `new_ingredient` is a string, the old entry's amount is kept and the type is detected from the new name (fluid or item). If the new ingredient already exists, amounts are combined. No-op on branches that don't contain `old_name`.

**Parameters**
- `old_name` :: `string` — name of the ingredient to replace.
- `new_ingredient` :: `table|string` — new ingredient (table or string shorthand).

#### `:getIngredient(ingredient)` → `table?`
Returns the normalized `item` payload of the first ingredient with the given name, or `nil`.

**Parameters**: `ingredient` :: `string` — name to look up.

#### `:ingredientExiste(ingredient)` → `boolean`
`true` if an ingredient with the given name exists in the recipe.

---

## Methods — results

#### `:addResult(result)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Adds `result` to `prototype.results` — **combines** (sums amounts, averages `independent_probability`) if a result with the same name already exists. Creates `results` if missing.

#### `:removeResult(result)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Removes every result matching `result`'s name from `prototype.results`.

#### `:setResult(result)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Replaces in place every result matching `result`'s name in `prototype.results` (no combine).

**Parameters** (shared by result methods): `result` :: `table|string` — product payload (`{type=, name=, amount=, independent_probability=}` or string shorthand).

---

## Methods — categories (Factorio 2.1+)

#### `:setCategories(categories)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Replaces `prototype.categories` (Factorio 2.1+, replaces the removed `category` / `additional_categories` keys). Accepts a single name or a list. Also clears the legacy keys if present.

**Parameters**
- `categories` :: `string|string[]` — crafting category or categories.

#### `:addCategory(category)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Appends a category to `prototype.categories` if not already present. If the recipe has no `categories`, starts from `{"crafting"}` (the engine default).

**Parameters**
- `category` :: `string` — category to add.

---

## Methods — tint & subgroup

#### `:changeTint(parameter, tint)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Assigns a color from [`tint`](#tint-tablestring-table-read) (by key: `"red"`, `"automation"`…) to the prototype's `parameter` field (typically `"crafting_machine_tint"`). No-op if the key is unknown.

#### `:updatePackTint()` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Auto-detects science packs (name ending in `-science-pack`) and applies the matching tint to `crafting_machine_tint`.

#### `:changeSubgroup(subgroup, order?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Sets `subgroup` (and `order`) on the recipe **and** propagates it to the matching item (via `RitnProtoItem`). Overrides the inherited version to handle item propagation.

#### `:setProductivity(value?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Sets `prototype.allow_productivity` (Factorio 2.0+, replaces the removed module `limitation` lists). `value` defaults to `true`.

---

## Methods inherited from `RitnPrototype`

Available on any instance — see [`RitnPrototype`](RitnPrototype.md) for details:

| Method | Role |
|---|---|
| `:changePrototype(parameter, value)` | writes `prototype[parameter] = value` then `:update()`. |
| `:setPrototype(parameter, value)` | same, without log. |
| `:changeSubPrototype(parameter, sub, value)` | writes `prototype[parameter][sub] = value`. |
| `:getProperties(propertie)` | reads a property from `prototype`. |
| `:update()` | writes `prototype` back to `data.raw[type][name]` (called by every setter). |

---

## Usage examples

**Fully recompose a module recipe** (`RitnElectronic/prototypes/update-recipes.lua`):

```lua
local recipeModule = RitnProtoRecipe("speed-module"):removeAllIngredient()
recipeModule:addIngredient({ "advanced-circuit-module", 1 })
recipeModule:addIngredient({ "electronic-circuit-module", 1 })
```

**Conditional add via `pcall`** (`RitnElectronic/prototypes/update-recipes.lua`):

```lua
local ok = pcall(function()
    RitnProtoRecipe("electric-furnace"):addIngredient({ type = "item", name = "steel-furnace", amount = 1 })
end)
if not ok then
    RitnProtoRecipe("electric-furnace"):addNewIngredient({ type = "item", name = "steel-furnace", amount = 1 })
end
RitnProtoRecipe("electric-furnace"):setIngredient({ type = "item", name = "steel-plate", amount = 4 })
```

**Move a recipe to another subgroup** (`RitnDemo/data.lua`):

```lua
RitnProtoRecipe("wooden-chest"):changeSubgroup("belt")
```

---

## Remarks

- **Data stage only** — use from `data.lua` / `data-updates.lua` / `data-final-fixes.lua`, never at runtime.
- **Copy + write-back** — mutations apply to a copy (`prototype`); each setter calls `:update()` which writes back to `data.raw`. No need to call `data:extend` yourself.
- **`normal` / `expensive` branches** — leftovers from Factorio 1.x recipe difficulty variants. The methods walk them in addition to `ingredients` / `results` (the 2.0+ canonical); if they don't exist on the loaded prototype, those branches are simply no-ops. See [Factorio 2.0 migration](../../migration-2.0.md).
- **`independent_probability`** — result methods use `independent_probability` (Factorio 2.1+). The legacy `probability` key is accepted as input but never written.

## See also

- [Class map](../overview.md)
- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnIngredient`](RitnIngredient.md) · [`RitnProtoTech`](RitnProtoTech.md)
- [Factorio 2.0 migration](../../migration-2.0.md)
