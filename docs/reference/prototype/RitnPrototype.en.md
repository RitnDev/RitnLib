---
title: RitnPrototype
type: reference
lang: en
---

# `RitnPrototype`


The **base** class of every `RitnProto*` prototype manipulator (data stage). It wraps a `data.raw[<type>][<name>]` entry into `self.prototype` and provides the generic *mutate-and-write* setters (`:changePrototype`, `:setPrototype`, `:update`…). You usually don't instantiate it directly — use a subclass ([`RitnProtoRecipe`](RitnProtoRecipe.md), [`RitnProtoTech`](RitnProtoTech.md)…).

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnPrototype.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.ritnClass.prototype)` |
| **Inherits from** | — (base class) |
| **Extended by** | all `RitnProto*` (except `RitnProtoRecipeCategory`, declared without inheritance) |
| **`object_name`** | `"RitnProtoBase"` |

---

## Constructor

#### `RitnPrototype(name, type)` → [`RitnPrototype`](RitnPrototype.md)

Sets `object_name`, `name`, `type`, and leaves `prototype` as `nil`. Subclasses call `RitnPrototype.init(base, name, type)` then **deep-copy** `data.raw[type][name]` into `prototype`.

**Parameters**
- `name` :: `string` — prototype name.
- `type` :: `string` — resolved type (`"recipe"`, `"item"`, `"assembling-machine"`…).

---

## Attributes

#### `name` :: `string` `[Read]`
Prototype name.

#### `type` :: `string` `[Read]`
Resolved type. May be updated by [`:getItemType()`](#getitemtype--string) / [`:getEntityType()`](#getentitytype--string).

#### `prototype` :: `table?` `[Read]`
Working copy of `data.raw[type][name]` (set by the subclass). `nil` if the entry doesn't exist.

#### `object_name` :: `"RitnProtoBase"` `[Read]`
Type sentinel.

---

## Methods — type resolution

#### `:getItemType()` → `string?`
Iterates over `lualib.vanilla.types_item` and returns the first item-type for which `data.raw[type][name]` exists. Updates `self.type` as a side effect. `nil` if no match.

#### `:getEntityType()` → `string?`
Same for entity types (`lualib.vanilla.types_entity`).

---

## Methods — mutate & write

#### `:changePrototype(parameter, value)` → [`RitnPrototype`](RitnPrototype.md)
Writes `prototype[parameter] = value`, then `:update()`.

#### `:setPrototype(parameter, value)` → [`RitnPrototype`](RitnPrototype.md)
Same as `:changePrototype` without the logging branch.

#### `:changeSubPrototype(parameter, subParameter, value)` → [`RitnPrototype`](RitnPrototype.md)
Writes `prototype[parameter][subParameter] = value`. No-op if `parameter` doesn't already exist.

#### `:changeSubgroup(subgroup, order?)` → [`RitnPrototype`](RitnPrototype.md)
Sets `prototype.subgroup` (and optional `order`), then `:update()`.

#### `:getProperties(propertie)` → `any`
Reads a property directly from `self.prototype` (no `data.raw` round-trip).

#### `:update()`
Writes `self.prototype` back into `data.raw[type][name]`. **Auto-called by every setter.** No-op if the target slot or `self.prototype` is nil.

---

## Usage example

The generic setters are used through subclasses, e.g.:

```lua
-- via a subclass (RitnProtoItem inherits from RitnPrototype)
RitnProtoItem("wooden-chest"):changeSubgroup("belt")
```

---

## Remarks

- **Data stage only** — `data.raw` access.
- **Copy + write-back** — the subclass deep-copies `data.raw[type][name]`; mutations apply to the copy and `:update()` writes it back. No manual `data:extend`.
- **Subclasses** — the `RitnProto*` add their own methods on top. See the [class map](../overview.md).

## See also

- [Class map](../overview.md)
- [`RitnProtoRecipe`](RitnProtoRecipe.md) · [`RitnProtoTech`](RitnProtoTech.md) · [`RitnIngredient`](RitnIngredient.md)
- [ADR-0001 — Class factory](../../adr/0001-class-factory.md)
