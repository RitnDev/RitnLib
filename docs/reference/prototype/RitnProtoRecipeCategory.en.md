---
title: RitnProtoRecipeCategory
type: reference
lang: en
---

# `RitnProtoRecipeCategory`


**Data-stage** manipulator for `data.raw["recipe-category"][<name>]`. Mostly used to declare a new recipe category.

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../migration-2.0.md).

> ⚠ **No inheritance** — unlike the other `RitnProto*`, this class is declared **without** passing `RitnPrototype` as the parent. The generic mutators (`:changePrototype`, `:setPrototype`, `:update`…) are therefore **not available** on instances; only the methods defined here are.

| | |
|---|---|
| **Source** | `classes/prototypes/RecipeCategory.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.category)` |
| **Inherits from** | — (none; see the warning) |
| **`object_name`** | `"RitnProtoRecipeCategory"` |

---

## Constructor

#### `RitnProtoRecipeCategory(category_name)` → [`RitnProtoRecipeCategory`](RitnProtoRecipeCategory.md)

Calls `RitnProtoBase.init` to set the basics (`object_name`, `name`, `type`, `prototype`) and deep-copies `data.raw["recipe-category"][category_name]` if it exists.

**Parameters**
- `category_name` :: `string` — category name.

---

## Attributes

#### `name` :: `string` `[Read]`
Category name.

#### `type` :: `"recipe-category"` `[Read]`
Prototype type.

#### `prototype` :: `table?` `[Read]`
Copy of `data.raw["recipe-category"][name]` (or `nil`).

---

## Methods

#### `:extend(name, order)` → [`RitnProtoRecipeCategory`](RitnProtoRecipeCategory.md)
Declares a **new** recipe-category via `data:extend({...})`.

**Parameters**: `name` :: `string` · `order` :: `string`.

---

## Usage example

**Declare a category** (`RitnElectronic/prototypes/category.lua`):

```lua
local RitnProtoCategory = require(ritnlib.defines.class.prototype.category)
RitnProtoCategory:extend("ritn-electronics")
```

## See also

- [Class map](../overview.md) · [`RitnProtoRecipe`](RitnProtoRecipe.md) · [2.0 migration](../../migration-2.0.md)
