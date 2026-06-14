---
title: RitnLibInventory
type: reference
lang: en
---

# `RitnLibInventory`

🇫🇷 [Version française](../../../fr/reference/runtime/RitnLibInventory.md)

Player inventory **snapshot / restore** helper, backed by `game.create_inventory`. RitnLib provides the logic; **persistence belongs to the consumer mod**: you pass an external table (typically a `storage.X`) where snapshots are stored. Handy to save an inventory before a character/surface change and restore it exactly (cursor included).

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnInventory.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **`object_name`** | `"RitnLibInventory"` |

---

## Constructor

#### `RitnLibInventory(player, inventoryGlobal)` → [`RitnLibInventory`](RitnLibInventory.md)

Validates the player (must be a valid `LuaPlayer` **with a `character`**) and requires a non-nil `inventoryGlobal` table. Stores the reference to that table in [`data`](#data--tablestring-table-read).

**Parameters**
- `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html) — player whose inventory is managed.
- `inventoryGlobal` :: `table` — consumer-provided persistence table (snapshots are written there, keyed by player name).

> **Warning** — Temporary wrapper: **never** store the `RitnLibInventory` instance in `storage`. Only the `inventoryGlobal` table is persistent.

---

## Expected persistence shape

Under the player's key, `init()` creates:

```lua
inventoryGlobal["<player_name>"] = {
    [defines.inventory.character_main]  = LuaInventory,
    [defines.inventory.character_guns]  = LuaInventory,
    [defines.inventory.character_ammo]  = LuaInventory,
    [defines.inventory.character_armor] = LuaInventory,
    [defines.inventory.character_trash] = LuaInventory,
    ["cursor"]          = LuaInventory,   -- 1 slot
    ["logistic_param"]  = { … },
}
```

---

## Attributes

#### `data` :: `table<string, table>` `[Read]`
Reference to the consumer's `inventoryGlobal` table (persistent).

#### `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html) `[Read]`
Wrapped player (live reference).

#### `name` :: `string` `[Read]`
Player name — used as the key in [`data`](#data--tablestring-table-read).

#### `INVENTORY_SIZE_MAX` :: `65535` `[Read]`
Maximum size passed to `game.create_inventory`.

#### `inventory_size` :: `integer` `[Read]`
Effective size used by [`:init()`](#init--ritnlibinventory) (defaults to `INVENTORY_SIZE_MAX`).

---

## Methods — master (common use)

#### `:save(cursor?)` → [`RitnLibInventory`](RitnLibInventory.md)
Snapshots the 5 character inventories. If `cursor == true`, also saves the cursor. Auto-inits if needed.

#### `:load(cursor?)` → [`RitnLibInventory`](RitnLibInventory.md)
Restores the 5 character inventories (armor first, intentional). If `cursor == true`, also restores the cursor (via `swap_stack` symmetry). No-op if no snapshot.

#### `:insert()` → [`RitnLibInventory`](RitnLibInventory.md)
Re-injects the snapshot into the live player via `LuaPlayer.insert` (armor/main/guns/ammo, **no** trash). Doesn't clear the snapshot.

#### `:delete()` → [`RitnLibInventory`](RitnLibInventory.md)
Clears the 5 character inventories **and** the cursor on the live player.

#### `:init()` → [`RitnLibInventory`](RitnLibInventory.md)
Creates the player's snapshot dict if absent. Auto-called by `:save`/`:saveCursor`/`:saveInventory`.

---

## Methods — batch

| Method | Effect |
|---|---|
| `:save_all_inventory()` | snapshots the 5 character inventories |
| `:load_all_inventory()` | restores the 5 (armor first) |
| `:insert_all_inventory()` | inserts armor/main/guns/ammo (no trash) |
| `:delete_all_inventory()` | clears the 5 character inventories |

---

## Methods — per slot

Each takes a `define :: defines.inventory` and returns `self`.

| Method | Effect |
|---|---|
| `:saveInventory(define)` | snapshots the slot via `swap_stack` (auto-init) |
| `:loadInventory(define)` | restores the slot from the snapshot |
| `:insertInventory(define)` | `LuaPlayer.insert` each stack from the snapshot |
| `:deleteInventory(define)` | clears the slot on the player |

---

## Methods — cursor

| Method | Effect |
|---|---|
| `:saveCursor()` | swaps `cursor_stack` ↔ `["cursor"]` snapshot (`swap_stack`) |
| `:loadCursor()` | restores the cursor from the snapshot |
| `:deleteCursor()` | clears the player's `cursor_stack` |

> **Note** — `swap_stack` is symmetric (its own inverse): that's what lets the `:save(true)` / `:load(true)` pair restore the cursor correctly.

---

## Usage example

**Save then restore around a character change** (`RitnCharacters/classes/RitnCharacter.lua`):

```lua
local inventories = {}
local rInventory = RitnLibInventory(self.player, inventories)
rInventory:save(true)        -- snapshot inventories + cursor

-- … destroy and recreate the character …

rInventory:load(true)        -- restore exactly
```

> Here the persistence table is local to the operation (snapshot then restore in the same call). For cross-tick persistence, pass a `storage.X`.

---

## Remarks

- **Delegated persistence** — RitnLib doesn't own the snapshot table; you provide yours. See [Delegated persistence](../../concepts/delegated-persistence.md).
- **Temporary wrapper** — never store the instance in `storage`; only `inventoryGlobal` is.
- **`character` required** — the constructor returns early if the player has no `character` (god/editor controllers).

## See also

- [Class map](../overview.md)
- [`RitnLibPlayer`](RitnLibPlayer.md)
- [Delegated persistence](../../concepts/delegated-persistence.md) · [Temporary wrappers](../../concepts/temporary-wrappers.md)
