---
title: RitnProtoItemGroup
type: reference
lang: en
---

# `RitnProtoItemGroup`


**Data-stage** manipulator for `data.raw["item-group"][<name>]` (crafting tabs). Inherits from [`RitnPrototype`](RitnPrototype.md). Lets you declare a new group and adjust its icon.

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/ItemGroup.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.group)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoItemGroup"` |

---

## Constructor

#### `RitnProtoItemGroup(group_name)` → [`RitnProtoItemGroup`](RitnProtoItemGroup.md)

Deep-copies `data.raw["item-group"][group_name]` into `prototype` if it exists.

**Parameters**
- `group_name` :: `string` — group name.

---

## Methods

#### `:extend(name, order, icon, icon_size)` → [`RitnProtoItemGroup`](RitnProtoItemGroup.md)
Declares a **new** item-group via `data:extend({...})`. No existing instance required.

**Parameters**: `name` :: `string` · `order` :: `string` · `icon` :: `string` (path) · `icon_size` :: `integer`.

#### `:setIcon(pathIcon, size)` → [`RitnProtoItemGroup`](RitnProtoItemGroup.md)
Sets the existing group's `icon` and `icon_size` in one call.

**Parameters**: `pathIcon` :: `string` · `size` :: `integer`.

> The generic mutators (`:changePrototype`…) are inherited from [`RitnPrototype`](RitnPrototype.md).

---

## Usage example

**Reorder, re-icon, declare** (`RitnElectronic/prototypes/category.lua`):

```lua
local RitnProtoGroup = require(ritnlib.defines.class.prototype.group)
RitnProtoGroup("combat"):changePrototype("order", "w-c")
RitnProtoGroup("production"):setIcon("__RitnElectronic__/graphics/item-group/production.png", 385)
RitnProtoGroup:extend("ritn-electronic", "c-a", "__RitnElectronic__/graphics/item-group/electronic.png", 385)
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md) · [Class map](../overview.md) · [2.0 migration](../../migration-2.0.md)
