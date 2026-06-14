---
title: RitnProtoUtilityConst
type: reference
lang: en
---

# `RitnProtoUtilityConst`


**Data-stage** manipulator for `data.raw["utility-constants"].default[<key>]`. Special case: these constants are nested under `.default` (unlike other prototypes at `data.raw[type][name]`), so the class overrides `:update()`. Inherits from [`RitnPrototype`](RitnPrototype.md).

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/UtilityConstants.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.utility.constants)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoUtilityConst"` |

---

## Constructor

#### `RitnProtoUtilityConst(constant_name)` → [`RitnProtoUtilityConst`](RitnProtoUtilityConst.md)

Deep-copies `data.raw["utility-constants"].default[constant_name]` into `prototype` if it exists.

**Parameters**
- `constant_name` :: `string` — constant key under `default`.

---

## Methods

#### `:setValue(value)` → [`RitnProtoUtilityConst`](RitnProtoUtilityConst.md)
Replaces the constant's value **entirely** with `value` (overwrites `prototype`), then `:update()`.

**Parameters**: `value` :: `any`.

#### `:update()`
Override: writes back to `data.raw["utility-constants"].default[<name>]` (the `.default[]` indirection vs the base `RitnPrototype:update`).

> The other generic mutators are inherited from [`RitnPrototype`](RitnPrototype.md).

---

## Usage example

```lua
local RitnProtoUtilityConst = require(ritnlib.defines.class.prototype.utility.constants)
RitnProtoUtilityConst("chart"):setValue(myChartConstants)
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Class map](../overview.md) · [2.0 migration](../../migration-2.0.md)
