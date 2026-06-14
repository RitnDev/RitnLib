---
title: RitnProtoItemSubgroup
type: reference
lang: en
---

# `RitnProtoItemSubgroup`

🇫🇷 [Version française](../../../fr/reference/prototype/RitnProtoItemSubgroup.md)

**Data-stage** manipulator for `data.raw["item-subgroup"][<name>]` (crafting rows). Inherits from [`RitnPrototype`](RitnPrototype.md). Lets you declare a new subgroup and reassign it.

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/ItemSubgroup.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.subgroup)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoItemSubgroup"` |

---

## Constructor

#### `RitnProtoItemSubgroup(subgroup_name)` → [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md)

Deep-copies `data.raw["item-subgroup"][subgroup_name]` into `prototype` if it exists.

**Parameters**
- `subgroup_name` :: `string` — subgroup name.

---

## Methods

#### `:extend(name, group, order)` → [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md)
Declares a **new** item-subgroup via `data:extend({...})`.

**Parameters**: `name` :: `string` · `group` :: `string` (parent item-group) · `order` :: `string`.

#### `:changeGroup(group, order?)` → [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md)
Reassigns the subgroup to a different parent `group` (and optional `order`).

#### `:changeOrder(order)` → [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md)
Updates the `order` field.

> The generic mutators are inherited from [`RitnPrototype`](RitnPrototype.md).

---

## Usage example

**Declare subgroups** (`RitnElectronic/prototypes/category.lua`):

```lua
local RitnProtoSubgroup = require(ritnlib.defines.class.prototype.subgroup)
RitnProtoSubgroup:extend("electronic-product", "ritn-electronic", "c")
RitnProtoSubgroup:extend("ritn-module", "ritn-electronic", "h")
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoItemGroup`](RitnProtoItemGroup.md) · [Class map](../overview.md) · [2.0 migration](../../../migration-2.0.md)
