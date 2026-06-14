---
title: RitnIngredient
type: reference
lang: en
---

# `RitnIngredient`

🇫🇷 [Version française](../../../fr/reference/prototype/RitnIngredient.md)

Normalizes a recipe ingredient (item or fluid) into a uniform `{name, type, amount, amount_min, amount_max, probability}` shape, and provides list operations (`:add`, `:addNew`, `:set`, `:remove`, `:combine`). It's the engine used internally by [`RitnProtoRecipe`](RitnProtoRecipe.md) for its ingredient methods, also usable directly.

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
Resolved ingredient name.

#### `type` :: `"item"`|`"fluid"`|`nil` `[Read]`
Resolved type (auto-detected if absent).

#### `amount` · `amount_min` · `amount_max` · `probability` :: `number?` `[Read]`
Amount (floored for items), range bounds, and probability factor.

#### `item` :: `table` `[Read]`
Normalized `{name, type, amount, amount_min, amount_max, probability}` payload — this is what gets inserted into lists.

#### `object_name` :: `"RitnIngredient"` `[Read]`
Type sentinel.

---

## Methods

> The list operations take `listIngredients :: table[]` (a recipe's ingredient list) and modify it **in place**.

#### `:add(listIngredients)`
Inserts `self`; **combines** (sums amounts, averages probabilities) if an ingredient with the same name already exists.

#### `:addNew(listIngredients)`
Inserts `self` **only if** no ingredient with the same name already exists.

#### `:set(listIngredients)`
Replaces in place every entry with the same name by `self.item` (overwrite, no combine).

#### `:remove(listIngredients)`
Removes every entry with the same name (by `[1]` or `.name`).

#### `:combine(ingredient)` → `table`
Combines `self` with `ingredient` (same name): sums amounts, averages probabilities. Updates `self.item` and returns the combined payload.

**Parameters**: `ingredient` :: `table`.

---

## Usage example

**Directly on an ingredient list**:

```lua
local RitnIngredient = require(ritnlib.defines.class.ritnClass.ingredient)

RitnIngredient({ "iron-plate", 2 }):add(recipe.ingredients)   -- add or combine
RitnIngredient("copper-plate"):remove(recipe.ingredients)     -- remove by name
```

In practice you usually go through [`RitnProtoRecipe`](RitnProtoRecipe.md) (`:addIngredient`, `:setIngredient`…), which delegates to `RitnIngredient`.

---

## Remarks

- **Data stage** — operates on `data.raw` ingredient tables.
- ⚠ **Known bug (`getItem`)** — on the probability branch, the internal helper reads `ingredient.inputs.probability` (nonexistent sub-table) → "attempt to index a nil value" if an ingredient carries a `probability`. Latent (few ingredients have one). See [known bugs](../../debt/known-bugs.md).
- **Input shapes** — both array (1.x) and table (2.0) forms are accepted.

## See also

- [Class map](../overview.md)
- [`RitnProtoRecipe`](RitnProtoRecipe.md) · [`RitnPrototype`](RitnPrototype.md)
- [Known bugs](../../debt/known-bugs.md)
