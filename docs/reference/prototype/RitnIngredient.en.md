---
title: RitnIngredient
type: reference
lang: en
---

# `RitnIngredient`


Normalizes a recipe entry (ingredient or product, item or fluid) into a uniform `{name, type, amount, amount_min, amount_max, independent_probability}` shape, and provides list operations (`:add`, `:addNew`, `:set`, `:remove`, `:combine`). It's the engine used internally by [`RitnProtoRecipe`](RitnProtoRecipe.md) for its ingredient and result methods, also usable directly.

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnIngredient.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.ritnClass.ingredient)` |
| **Inherits from** | — (base class) |
| **`object_name`** | `"RitnIngredient"` |

---

## Constructor

#### `RitnIngredient(ingredient)` → [`RitnIngredient`](RitnIngredient.md)

Normalizes the input. The `type` is auto-detected (`"fluid"` if `data.raw.fluid[name]` exists, otherwise `"item"`). For items, an `amount` in `(0, 1)` is bumped to 1, otherwise floored.

**Parameters**
- `ingredient` :: `table`|`string` — accepts three shapes:
  - array: `{ "iron-plate", 2 }` (1.x legacy)
  - table: `{ name = "iron-plate", amount = 2, type = "item" }` (2.0 canonical)
  - string: `"iron-plate"` (sugar for `{ name = "iron-plate" }`)

---

## Attributes

#### `name` :: `string` `[Read]`
Resolved entry name.

#### `type` :: `"item"`|`"fluid"`|`nil` `[Read]`
Resolved type (auto-detected if absent).

#### `amount` · `amount_min` · `amount_max` :: `number?` `[Read]`
Amount (floored for items) and range bounds.

#### `independent_probability` :: `number?` `[Read]`
Probability factor (Factorio 2.1+, renamed from `probability`). Read from `independent_probability`, or from the legacy `probability` key if only that one is present.

#### `item` :: `table` `[Read]`
Normalized `{name, type, amount, amount_min, amount_max, independent_probability}` payload **plus every other field of the original entry** (`temperature`, `ignored_by_productivity`, `extra_count_fraction`, `percent_spoiled`…). This is what gets inserted into lists. The array form (`[1]`, `[2]`) and the `probability` key are never copied into it.

#### `object_name` :: `"RitnIngredient"` `[Read]`
Type sentinel.

---

## Methods

> The list operations take `listIngredients :: table[]` (a recipe's `ingredients` or `results` list) and modify it **in place**.

#### `:add(listIngredients)`
Inserts `self`; **combines** (sums amounts, averages `independent_probability`) if an entry with the same name already exists.

#### `:addNew(listIngredients)`
Inserts `self` **only if** no entry with the same name already exists.

#### `:set(listIngredients)`
Replaces in place every entry with the same name by `self.item` (overwrite, no combine).

#### `:remove(listIngredients)`
Removes every entry with the same name (by `[1]` or `.name`).

#### `:combine(ingredient)` → `table`
Combines `self` with `ingredient` (same name): sums amounts, averages `independent_probability`. Extra fields (`temperature`…) come from `ingredient`, i.e. the entry already present in the recipe. Updates `self.item` and returns the combined payload.

**Parameters**: `ingredient` :: `table`.

---

## Usage example

**Directly on an ingredient list**:

```lua
local RitnIngredient = require(ritnlib.defines.class.ritnClass.ingredient)

RitnIngredient({ "iron-plate", 2 }):add(recipe.ingredients)   -- add or combine
RitnIngredient("copper-plate"):remove(recipe.ingredients)     -- remove by name
```

**A product with a probability and a temperature**:

```lua
RitnIngredient({ type = "fluid", name = "steam", amount = 10, temperature = 165,
                 independent_probability = 0.5 }):add(recipe.results)
```

In practice you usually go through [`RitnProtoRecipe`](RitnProtoRecipe.md) (`:addIngredient`, `:addResult`…), which delegates to `RitnIngredient`.

---

## Remarks

- **Data stage** — operates on `data.raw` ingredient / product tables.
- **`probability` → `independent_probability`** — Factorio 2.1 removed `probability` from products; the legacy key is still accepted as input but only `independent_probability` is written. See [Factorio 2.1 migration](../../migration-2.1.md).
- **Input shapes** — both array (1.x) and table (2.0) forms are accepted. An item entry defined with `amount_min` / `amount_max` only is handled.

## See also

- [Class map](../overview.md)
- [`RitnProtoRecipe`](RitnProtoRecipe.md) · [`RitnPrototype`](RitnPrototype.md)
- [Factorio 2.1 migration](../../migration-2.1.md)
