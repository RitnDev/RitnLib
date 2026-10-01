---
title: RitnProtoTile
type: reference
lang: en
---

# `RitnProtoTile`


**Data-stage** manipulator for `data.raw["tile"][<name>]` (floor tiles: concrete, landfill, paths…). Inherits from [`RitnPrototype`](RitnPrototype.md). Added in **0.10.5**.

| | |
|---|---|
| **Source** | `classes/prototypes/Tile.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.tile)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoTile"` |

```lua
-- my-mod/data.lua
require("__RitnLib__.defines")
local RitnProtoTile = require(ritnlib.defines.class.prototype.tile)
```

---

## Constructor

#### `RitnProtoTile(tile_name)` → [`RitnProtoTile`](RitnProtoTile.md)

Sets the basics via `RitnPrototype.init` then **deep-copies** `data.raw["tile"][tile_name]` into `prototype`. If the tile doesn't exist, `prototype` stays `nil` (setters become no-ops).

**Parameters**
- `tile_name` :: `string` — tile name in `data.raw`.

---

## Attributes

#### `name` :: `string` `[Read]`
Tile name (inherited from [`RitnPrototype`](RitnPrototype.md)).

#### `type` :: `string` `[Read]`
Resolved type (`"tile"`).

#### `prototype` :: `table?` `[Read]`
Working copy of `data.raw["tile"][name]`. `nil` if the tile doesn't exist.

#### `object_name` :: `"RitnProtoTile"` `[Read]`
Type sentinel.

---

## Methods

#### `:setBlueprintable(value?)` → [`RitnProtoTile`](RitnProtoTile.md)
Sets `prototype.can_be_part_of_blueprint`. `value` defaults to `true`; pass `false` to keep the tile out of blueprints.

**Parameters**
- `value` :: `boolean?` — `true` (default) or `false`.

> The generic mutators (`:changePrototype`, `:setPrototype`, `:getProperties`…) are inherited from [`RitnPrototype`](RitnPrototype.md).

---

## Usage example

```lua
local RitnProtoTile = require(ritnlib.defines.class.prototype.tile)

RitnProtoTile("landfill"):setBlueprintable(false)          -- out of blueprints
RitnProtoTile("refined-concrete"):changePrototype("walking_speed_modifier", 1.6)
```

---

## Remarks

- **Data stage only** — use from `data.lua` / `data-updates.lua` / `data-final-fixes.lua`.
- **Copy + write-back** — each setter calls `:update()` which writes back to `data.raw`. No manual `data:extend`.

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Class map](../overview.md)
