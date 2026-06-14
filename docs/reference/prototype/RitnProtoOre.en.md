---
title: RitnProtoOre
type: reference
lang: en
---

# `RitnProtoOre`


**Data-stage** manipulator for `data.raw["resource"][<name>]` (ore patches). Inherits from [`RitnPrototype`](RitnPrototype.md). Provides `:remove()` (full ore purge) and the **static** `.active(...)` helper to register ores from `lualib/vanilla/ores.lua`.

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0 (the `resource()` template notably uses `hr_version`). Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Ore.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.ore)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoOre"` |

---

## Constructor

#### `RitnProtoOre(resource)` → [`RitnProtoOre`](RitnProtoOre.md)

Deep-copies `data.raw["resource"][resource]` into `prototype`. No-op if the resource isn't found.

**Parameters**
- `resource` :: `string` — resource name (`"iron-ore"`, `"copper-ore"`…).

---

## Methods

#### `:remove()` → [`RitnProtoOre`](RitnProtoOre.md)
Full purge: removes the `resource` prototype, the `autoplace-control`, the entry in every map-gen-preset's `autoplace_controls`, and the `"infinite-<name>"` companion if it exists.

#### `RitnProtoOre.active(resource, bStart, bStandard)`
**Static** helper (dot, not `:`). Initializes the patch set and registers the autoplace-control + resource via `data:extend`, from `lualib/vanilla/ores.lua`.

**Parameters**
- `resource` :: `string` — ore key in `lualib/vanilla/ores.lua`.
- `bStart` :: `boolean` — seed the patch set near the starting area.
- `bStandard` :: `boolean` — if `true`, build the resource via the internal template; otherwise use `ores[resource].resource` as-is.

```lua
local RitnProtoOre = require(ritnlib.defines.class.prototype.ore)
RitnProtoOre.active("silica-sand", true, false)
```

> The generic mutators (`:changePrototype`…) are inherited from [`RitnPrototype`](RitnPrototype.md).

---

## Usage example

**Register a vanilla-template ore** (`RitnGlass/data.lua`):

```lua
RitnProtoOre.active("silica-sand", true, false)
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Class map](../overview.md) · [2.0 migration](../../migration-2.0.md)
