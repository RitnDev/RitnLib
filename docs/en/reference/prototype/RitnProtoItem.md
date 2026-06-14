---
title: RitnProtoItem
type: reference
lang: en
---

# `RitnProtoItem`

🇫🇷 [Version française](../../../fr/reference/prototype/RitnProtoItem.md)

**Data-stage** manipulator for `data.raw[<item-type>][<name>]`. The constructor **auto-detects** the item type (via `getItemType()`) and deep-copies the prototype. **No methods of its own**: use the generic mutators from [`RitnPrototype`](RitnPrototype.md).

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable at data stage, but **not validated for 2.0** — see [Factorio 2.0 migration](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Item.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.item)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoItem"` |

---

## Constructor

#### `RitnProtoItem(item_name)` → [`RitnProtoItem`](RitnProtoItem.md)

Resolves the type via `:getItemType()` (iterates `lualib.vanilla.types_item`) then deep-copies `data.raw[type][item_name]` into `prototype`. No-op if the type or item isn't found.

**Parameters**
- `item_name` :: `string` — item name.

---

## Methods

No specific methods. Use the inherited mutators from [`RitnPrototype`](RitnPrototype.md): `:changePrototype`, `:setPrototype`, `:changeSubPrototype`, `:changeSubgroup`, `:getProperties`, `:update`.

---

## Usage example

```lua
local RitnProtoItem = require(ritnlib.defines.class.prototype.item)
RitnProtoItem("wooden-chest"):changeSubgroup("belt")
RitnProtoItem("iron-plate"):changePrototype("stack_size", 200)
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoEntity`](RitnProtoEntity.md) · [Class map](../overview.md) · [2.0 migration](../../../migration-2.0.md)
