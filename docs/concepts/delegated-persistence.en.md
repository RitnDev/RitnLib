---
title: Delegated persistence
type: concept
lang: en
---

# Delegated persistence

> **RitnLib never touches `storage` directly. Every class that needs to persist data does so through a table the consumer mod provides.**

This is the delegated persistence principle. It applies mainly to `RitnLibInventory`, but the pattern can be reused in your own classes.

## Why

`storage` is the only table Factorio serialises between saves. But RitnLib is a library — it doesn't know how your mod organises its `storage`. Rather than imposing a structure, RitnLib asks you to pass the sub-table where it should write.

Benefits:
- You keep full control of the `storage` structure
- Multiple mods can use RitnLib without conflicts
- Persistence logic is testable with any ordinary table

## Concrete example — `RitnLibInventory`

`RitnLibInventory` takes as its second argument the table where it should save the inventory:

```lua
script.on_event(defines.events.on_player_died, function(event)
    local player = game.get_player(event.player_index)

    -- Pass storage.inventories[index] as the "bucket" for saving
    storage.inventories = storage.inventories or {}
    storage.inventories[event.player_index] = storage.inventories[event.player_index] or {}

    local inv = RitnLibInventory(player, storage.inventories[event.player_index])
    inv:save(true)   -- writes into storage.inventories[index]
end)

script.on_event(defines.events.on_player_respawned, function(event)
    local player = game.get_player(event.player_index)

    if storage.inventories and storage.inventories[event.player_index] then
        local inv = RitnLibInventory(player, storage.inventories[event.player_index])
        inv:load(true)  -- restores from storage.inventories[index]
        storage.inventories[event.player_index] = nil
    end
end)
```

`RitnLibInventory` reads and writes in the table you pass — never in `storage` directly.

## What `RitnLibInventory` does under the hood

```lua
-- During save():
self.storage["main"] = {}
for i = 1, #self.player.get_main_inventory() do
    self.storage["main"][i] = self.player.get_main_inventory()[i]
end

-- During load():
for i, stack in pairs(self.storage["main"] or {}) do
    self.player.get_main_inventory()[i].set_stack(stack)
end
```

`self.storage` is the table you passed as the second argument. RitnLib never accesses the global `storage`.

## Reusable pattern

You can apply the same principle in your own classes:

```lua
local MySystem = ritnlib.classFactory.newclass(nil, function(self, storage_table)
    self.data = storage_table  -- no global, just a reference
end)

function MySystem:set(key, value)
    self.data[key] = value
end

-- Usage
script.on_init(function()
    storage.my_system = {}
end)

script.on_event(defines.events.on_player_created, function(event)
    local sys = MySystem(storage.my_system)
    sys:set("last_joined", event.player_index)
end)
```

## Golden rule

| ✅ Do | ❌ Avoid |
|---|---|
| Pass `storage.my_sub_table` to the class | Let the class write into `storage` directly |
| Initialise the sub-table before passing it | Passing `nil` (the class can't write into nil) |
| Re-instantiate the class in each handler | Storing the class instance between events |

## See also

- [Temporary wrappers](temporary-wrappers.md)
- [Life cycle](life-cycle.md)
- [Reference: RitnLibInventory](../reference/runtime/RitnLibInventory.md)
