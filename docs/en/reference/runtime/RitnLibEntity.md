---
title: RitnLibEntity
type: reference
lang: en
---

# `RitnLibEntity`

🇫🇷 [Version française](../../../fr/reference/runtime/RitnLibEntity.md)

A short view over a [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html). Exposes the most-accessed entity info (type, surface, force, position…), category flags (character/car/spider-vehicle), and driver/passenger helpers for vehicles.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnEntity.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **Extended by** | consumer subclasses, e.g. `RitnPortalPortal` |
| **`object_name`** | `"RitnLibEntity"` |

---

## Constructor

#### `RitnLibEntity(entity)` → [`RitnLibEntity`](RitnLibEntity.md)

Validates the input then freezes the fields. Rejects an input that is not a valid `LuaEntity`.

**Parameters**
- `entity` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html) — the entity to wrap.

**Return value** → [`RitnLibEntity`](RitnLibEntity.md). On invalid input, [`isPresent`](#ispresent--boolean-read) is `false`.

---

## Attributes

All read-only (`[Read]`), frozen at construction.

#### `entity` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html) `[Read]`
The wrapped `LuaEntity` (live reference).

#### `name` :: `string` `[Read]`
Entity prototype name.

#### `id` · `unit_number` :: `uint?` `[Read]`
Entity `unit_number` (`id` is an alias). `nil` for entities without one.

#### `type` :: `string` `[Read]`
Entity type (`"character"`, `"car"`, `"assembling-machine"`…).

#### `prototype` :: [`LuaEntityPrototype`](https://lua-api.factorio.com/latest/classes/LuaEntityPrototype.html) `[Read]`
Live prototype reference.

#### `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) `[Read]`
Surface at instantiation (snapshot).

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) `[Read]`
Force at instantiation (snapshot).

#### `position` :: [`MapPosition`](https://lua-api.factorio.com/latest/concepts/MapPosition.html) `[Read]`
Position at instantiation (snapshot).

#### `backer_name` :: `string?` `[Read]`
Backer name if applicable.

#### `isCharacter` · `isCar` · `isSpiderVehicle` :: `boolean` `[Read]`
Category flags based on `type`.

#### `allowsPassenger` :: `boolean` `[Read]`
`true` if the entity can carry a passenger (car or spider-vehicle).

#### `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html)`?` `[Read]`
Player controlling the entity if it is a character.

#### `drive` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`|`[`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html)`|nil` `[Read]`
Driver if `isCar`.

#### `passenger` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`|`[`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html)`|nil` `[Read]`
Passenger if `allowsPassenger`.

#### `isPresent` :: `boolean` `[Read]`
`false` if the constructor rejected its input. Test it as a guard.

---

## Methods — identity

#### `:existByName(name)` → `boolean`
`true` if the entity is present and named exactly `name`.

**Parameters**: `name` :: `string`.

---

## Methods — vehicle (driver / passenger)

#### `:isDriver()` → `boolean`
`true` if the vehicle has a driver (entity or player).

#### `:isPassenger()` → `boolean`
`true` if the vehicle has a passenger.

#### `:playerIsDriver(player)` → `boolean`
`true` if the given `player` is this entity's driver.

**Parameters**: `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html).

#### `:playerIsPassenger(player)` → `boolean`
`true` if the given `player` is this entity's passenger.

**Parameters**: `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html).

#### `:setPassenger(player)`
Sets `player` as the passenger if the entity allows it (`allowsPassenger`). No-op otherwise.

**Parameters**: `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html).

---

## Methods — flags & destruction

#### `:setMinable(value?)`
Sets the entity's `minable` flag (`value` defaults to `true`).

#### `:setDestructible(value?)`
Sets the entity's `destructible` flag (`value` defaults to `true`).

#### `:destroy()`
Destroys the entity.

> **Note** — `:destroy()` calls `:setMinable()` / `:setDestructible()` before destruction; those calls are **redundant** (`destroy()` ignores both flags), a leftover from a previous use case.

---

## Methods — wrappers (⚠ avoid as-is)

#### `:getSurface()` → [`RitnLibSurface`](RitnLibSurface.md) · `:getForce()` → [`RitnLibForce`](RitnLibForce.md)

> **Warning** — Both methods call `RitnlibSurface(...)` / `RitnlibForce(...)` (wrong casing, lowercase `lib`) — undefined globals → **they crash if called**. Known (latent, uncorrected) defect. In the meantime, wrap them yourself: `RitnLibSurface(rEntity.surface)` / `RitnLibForce(rEntity.force)`. See [known bugs](../../debt/known-bugs.md).

---

## Usage examples

**Check the name + handle a passenger** (`RitnPortal/classes/RitnPortal.lua`):

```lua
if self:existByName(ritnlib.defines.portal.names.entity.portal) then
    -- …
end

if self:playerIsDriver(LuaPlayer) and self:isLinked() then
    rPortalDestination:setPassenger(LuaPlayer)
end
```

**Destroy the wrapped entity** (`RitnPortal/classes/RitnGuiPortal.lua`):

```lua
rPortal:destroy()
```

---

## Remarks

- **Temporary wrapper** — never store the instance in `storage`; rebuild it in each handler. See [Temporary wrappers](../../concepts/temporary-wrappers.md).
- **Snapshot fields** — `surface`, `force`, `position`, `drive`, `passenger` are frozen at construction.
- **`getSurface` / `getForce` broken** — see the warning above.

## See also

- [Class map](../overview.md)
- [`RitnLibSurface`](RitnLibSurface.md) · [`RitnLibForce`](RitnLibForce.md) · [`RitnLibPlayer`](RitnLibPlayer.md)
- [Known bugs](../../debt/known-bugs.md) · [Temporary wrappers](../../concepts/temporary-wrappers.md)
