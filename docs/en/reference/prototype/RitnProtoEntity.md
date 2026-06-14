---
title: RitnProtoEntity
type: reference
lang: en
---

# `RitnProtoEntity`

🇫🇷 [Version française](../../../fr/reference/prototype/RitnProtoEntity.md)

**Data-stage** manipulator for `data.raw[<entity-type>][<name>]`. The constructor **auto-detects** the entity type (via `getEntityType()`) and deep-copies the prototype. Inherits all generic mutators from [`RitnPrototype`](RitnPrototype.md).

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable at data stage, but **not validated for 2.0** — see [Factorio 2.0 migration](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Entity.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.entity)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoEntity"` |

---

## Constructor

#### `RitnProtoEntity(entity_name)` → [`RitnProtoEntity`](RitnProtoEntity.md)

Resolves the type via `:getEntityType()` (iterates `lualib.vanilla.types_entity`) then deep-copies `data.raw[type][entity_name]` into `prototype`. No-op if the type or entity isn't found.

**Parameters**
- `entity_name` :: `string` — entity name.

---

## Attributes

#### `prototype` :: `table?` `[Read]`
Working copy of `data.raw[type][name]`.

#### `lua_prototype` :: `table?` `[Read]`
**Direct** reference to `data.raw[type][name]` (not the copy).

#### `object_name` :: `"RitnProtoEntity"` `[Read]`
Type sentinel. (See also `name`/`type` inherited from [`RitnPrototype`](RitnPrototype.md).)

---

## Methods

#### `:addCraftingCategories(category)` → [`RitnProtoEntity`](RitnProtoEntity.md)
Appends `category` to the entity's `crafting_categories` (first normalizes the field to a table if it was a single string).

**Parameters**: `category` :: `string`.

> The generic mutators (`:changePrototype`, `:setPrototype`, `:changeSubgroup`, `:update`…) are inherited from [`RitnPrototype`](RitnPrototype.md).

---

## Usage example

```lua
local RitnProtoEntity = require(ritnlib.defines.class.prototype.entity)
RitnProtoEntity("assembling-machine-2"):addCraftingCategories("ritn-electronics")
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Class map](../overview.md) · [2.0 migration](../../../migration-2.0.md)
