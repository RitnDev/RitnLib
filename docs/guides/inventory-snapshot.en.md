---
title: Inventory snapshot and restore
type: guide
lang: en
---

# Inventory snapshot and restore

This guide shows how to save a player's inventory on death and restore it on respawn, using `RitnLibInventory` and [delegated persistence](../concepts/delegated-persistence.md).

## Principle

`RitnLibInventory` never touches `storage` directly. You pass it the sub-table where it should write. This is the delegated persistence pattern.

## Initialise storage

```lua
-- my-mod/control.lua

script.on_init(function()
    storage.inventories = {}
end)

script.on_configuration_changed(function()
    storage.inventories = storage.inventories or {}
end)
```

## Save on death

```lua
script.on_event(defines.events.on_player_died, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    -- Prepare the sub-table for this player
    storage.inventories[event.player_index] = {}

    -- Delegate saving to RitnLibInventory
    local inv = RitnLibInventory(player, storage.inventories[event.player_index])
    inv:save(true)
end)
```

`inv:save(true)` saves the main inventory and clears it. The `true` flag tells it to empty the source inventory after saving (to prevent Factorio from dropping items on the ground).

## Restore on respawn

```lua
script.on_event(defines.events.on_player_respawned, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local snapshot = storage.inventories[event.player_index]
    if not snapshot then return end

    local inv = RitnLibInventory(player, snapshot)
    inv:load(true)

    -- Clean up the snapshot once restored
    storage.inventories[event.player_index] = nil
end)
```

`inv:load(true)` restores the inventory from the passed sub-table. After that, clean up the storage entry to prevent double-restoration.

## Full pattern

```lua
-- my-mod/control.lua

script.on_init(function()
    storage.inventories = {}
end)

script.on_configuration_changed(function()
    storage.inventories = storage.inventories or {}
end)

script.on_event(defines.events.on_player_died, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    storage.inventories[event.player_index] = {}
    local inv = RitnLibInventory(player, storage.inventories[event.player_index])
    inv:save(true)
end)

script.on_event(defines.events.on_player_respawned, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local snapshot = storage.inventories[event.player_index]
    if not snapshot then return end

    local inv = RitnLibInventory(player, snapshot)
    inv:load(true)
    storage.inventories[event.player_index] = nil
end)
```

## What `RitnLibInventory` does under the hood

It reads and writes to the table you pass — never to `storage` directly:

```lua
-- During save():
self.storage["main"] = {}
for i = 1, #player.get_main_inventory() do
    self.storage["main"][i] = player.get_main_inventory()[i]
end

-- During load():
for i, stack in pairs(self.storage["main"] or {}) do
    player.get_main_inventory()[i].set_stack(stack)
end
```

## Important rules

| ✅ Do | ❌ Avoid |
|---|---|
| Initialise `storage.inventories[index] = {}` **before** `RitnLibInventory(...)` | Passing `nil` as storage_table (silent failure) |
| Clean up `storage.inventories[index] = nil` after `load()` | Leaving old snapshots around |
| Re-instantiate `RitnLibInventory` in each handler | Storing the instance between handlers |

## See also

- [Delegated persistence](../concepts/delegated-persistence.md)
- [Temporary wrappers](../concepts/temporary-wrappers.md)
- [Reference: RitnLibInventory](../reference/runtime/RitnLibInventory.md)
