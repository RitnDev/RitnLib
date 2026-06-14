---
title: RitnLibSurface
type: reference
lang: en
---

# `RitnLibSurface`


A short view over a [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html). Exposes name/index, an `isNauvis` flag, and entity lookup by position + `unit_number`.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnSurface.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **Extended by** | consumer subclasses, e.g. `RitnCoreSurface` |
| **`object_name`** | `"RitnLibSurface"` |

---

## Constructor

#### `RitnLibSurface(surface)` → [`RitnLibSurface`](RitnLibSurface.md)

Validates the input then freezes the fields. Rejects an input that is not a valid `LuaSurface`.

**Parameters**
- `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) — the surface to wrap.

**Return value** → [`RitnLibSurface`](RitnLibSurface.md). On invalid input, [`isPresent`](#ispresent--boolean-read) is `false`.

> **Note** — Most often obtained via [`RitnLibEvent:getSurface()`](RitnLibEvent.md#getsurface--ritnlibsurface) or [`RitnLibPlayer:getSurface()`](RitnLibPlayer.md#getsurface--ritnlibsurface).

---

## Attributes

All read-only (`[Read]`), frozen at construction.

#### `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) `[Read]`
The wrapped `LuaSurface` (live reference).

#### `name` :: `string` `[Read]`
Surface name (`"nauvis"`, `"vulcanus"`…).

#### `index` :: `uint` `[Read]`
Surface index.

#### `isNauvis` :: `boolean` `[Read]`
`true` if `name == "nauvis"` at instantiation. `false` on Space Age planets and space platforms.

#### `isPresent` :: `boolean` `[Read]`
`false` if the constructor rejected its input. Test it as a guard.

---

## Methods

#### `:print(text)` → [`RitnLibSurface`](RitnLibSurface.md)
Broadcasts a message to **every** player on the surface. `table` values are serialized via `serpent.block`; non-string/non-table values fall back to `tostring` (inside a `pcall`). Chainable.

**Parameters**
- `text` :: `string`|`table` — text or [`LocalisedString`](https://lua-api.factorio.com/latest/concepts/LocalisedString.html).

#### `:getEntity(position, unit_number, name?, entityType?)` → [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?`
Finds a specific entity by position + `unit_number`. Strategy: `find_entities_filtered{position, name?, type?}` → look up `unit_number` in the list → fall back to the first match → fall back to `find_entity(name, position)`.

**Parameters**
- `position` :: [`MapPosition`](https://lua-api.factorio.com/latest/concepts/MapPosition.html) — search center (must have `.x`/`.y`).
- `unit_number` :: `uint` — unit number to find.
- `name` :: `string?` — optional entity-name filter.
- `entityType` :: `string?` — optional type filter (must exist in `lualib.vanilla.types_entity`).

```lua
local entity = RitnLibSurface(game.get_surface(surface_name))
    :getEntity(portal.position, id_portal, "ritn-portal", portal.entity_type)
```

> **Warning** — This method also writes its result to the **global** variable `LuaEntity` (side effect to be aware of). On 2.0, if you already have the `unit_number`, `game.get_entity_by_unit_number(n)` is O(1). See [Factorio 2.0 migration](../../migration-2.0.md).

---

## Usage example

**Find an entity by unit_number** (`RitnPortal/classes/RitnSurface.lua`):

```lua
local LuaEntity = RitnLibSurface(game.get_surface(surface_name))
    :getEntity(portal.position, id_portal, ritnlib.defines.portal.names.entity.portal, portal.entity_type)
```

---

## Remarks

- **Temporary wrapper** — never store the instance in `storage`; rebuild it in each handler. See [Temporary wrappers](../../concepts/temporary-wrappers.md).
- **`isNauvis` and Space Age** — checks the exact name `'nauvis'`; `false` elsewhere (planets, platforms).

## See also

- [Class map](../overview.md)
- [`RitnLibEvent`](RitnLibEvent.md) · [`RitnLibPlayer`](RitnLibPlayer.md) · [`RitnLibEntity`](RitnLibEntity.md)
- [Temporary wrappers (golden rule)](../../concepts/temporary-wrappers.md)
