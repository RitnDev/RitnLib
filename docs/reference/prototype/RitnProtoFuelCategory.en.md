---
title: RitnProtoFuelCategory
type: reference
lang: en
---

# `RitnProtoFuelCategory`


**Data-stage** manipulator for `data.raw["fuel-category"][<name>]`. Inherits from [`RitnPrototype`](RitnPrototype.md). Mostly used to declare a new fuel category.

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/FuelCategory.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.fuelCategory)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoFuelCategory"` |

---

## Constructor

#### `RitnProtoFuelCategory(category_name)` → [`RitnProtoFuelCategory`](RitnProtoFuelCategory.md)

Deep-copies `data.raw["fuel-category"][category_name]` into `prototype` if it exists.

**Parameters**
- `category_name` :: `string` — category name.

---

## Methods

#### `:extend(name, order)` → [`RitnProtoFuelCategory`](RitnProtoFuelCategory.md)
Declares a **new** fuel-category via `data:extend({...})`.

**Parameters**: `name` :: `string` · `order` :: `string`.

> The generic mutators are inherited from [`RitnPrototype`](RitnPrototype.md).

---

## Usage example

```lua
local RitnProtoFuelCategory = require(ritnlib.defines.class.prototype.fuelCategory)
RitnProtoFuelCategory:extend("ritn-fuel", "a")
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Class map](../overview.md) · [2.0 migration](../../migration-2.0.md)
