---
title: Temporary wrappers (golden rule)
type: concept
lang: en
applies_to: runtime
---

# Temporary wrappers — the golden rule

> **`RitnLib*` runtime classes are views, not entities. Create one in your handler, use it, throw it away.**

This is **the** rule to know before touching `RitnLibPlayer`, `RitnLibEntity`, `RitnLibSurface`, `RitnLibForce`, `RitnLibEvent`, `RitnLibRecipe`, `RitnLibTechnology`, `RitnLibGui`. Ignore it and you'll run into strange, intermittent bugs that survive across saves.

## Why

When you instantiate a wrapper, its constructor takes a **static snapshot** of the Factorio properties. Example with `RitnLibPlayer`:

```lua
RitnLibPlayer = ritnlib.classFactory.newclass(function(self, LuaPlayer)
    self.player = LuaPlayer
    self.index = LuaPlayer.index
    self.surface = LuaPlayer.surface            -- ← snapshot
    self.force = LuaPlayer.force                -- ← snapshot
    self.controller_type = LuaPlayer.controller_type  -- ← snapshot
    self.controller_name = getControllerName(LuaPlayer)
    self.character = LuaPlayer.character        -- ← snapshot
    self.driving = LuaPlayer.driving            -- ← snapshot
    self.vehicle = LuaPlayer.vehicle            -- ← snapshot
    self.connected = LuaPlayer.connected        -- ← snapshot
    -- ...
end)
```

All of these properties **change during play**: a player switches surface, enters editor mode (`controller_type` changes), boards a vehicle, disconnects. The wrapper keeps its initial values.

If you reuse the wrapper later, you'll read stale values — without any error being raised. `self.player` stays valid (it's a `LuaPlayer` reference) but `self.surface`, `self.driving`, etc. no longer reflect reality.

## Good practice

Instantiate the wrapper **inside the handler that needs it**, just before you use it:

```lua
script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = RitnLibPlayer(game.get_player(event.player_index))
    if player.isPresent then
        player:print("You're now on " .. player.surface.name)
    end
end)
```

The wrapper dies at end-of-function. At the next event, you create a fresh one reflecting the current state.

## What not to do

### ❌ Storing the wrapper in `storage`

```lua
-- DON'T DO THIS
script.on_init(function()
    storage.player_wrapper = RitnLibPlayer(game.get_player(1))
end)
```

Why it's broken:
1. At save time, Factorio knows how to serialize the inner `LuaPlayer` (managed userdata). But the scalar copies (`self.surface`, `self.controller_type`…) are serialized as values **frozen at init time**.
2. At load time, Factorio restores those scalars as-is — even if the player has changed surface ten times since.
3. You end up with an object whose `self.surface` points at a `LuaSurface` that's no longer the player's current surface.

### ❌ Keeping the wrapper between two events

```lua
-- DON'T DO THIS
local cached_wrapper

script.on_event(defines.events.on_player_created, function(event)
    cached_wrapper = RitnLibPlayer(game.get_player(event.player_index))
end)

script.on_event(defines.events.on_player_changed_surface, function(event)
    cached_wrapper:print("New surface: " .. cached_wrapper.surface.name)
    -- ⚠ cached_wrapper.surface is the OLD surface, not the new one
end)
```

The `cached_wrapper` variable survives between events (it lives in `control.lua`'s upvalue), but its scalar fields are frozen at instantiation time.

### ❌ Reusing a `RitnLibEvent` past its event

```lua
-- DON'T DO THIS
local last_event

script.on_event(defines.events.on_built_entity, function(event)
    last_event = RitnLibEvent(event)
end)

script.on_event(defines.events.on_tick, function()
    if last_event then
        log("Last entity: " .. last_event.entity.name)
        -- ⚠ last_event.entity may have been destroyed since
    end
end)
```

The inner `LuaEntity` may have been invalidated (`entity.valid == false`) — any operation on the wrapper will raise.

## When caching is OK

You can store **primitive values extracted** from the wrapper in `storage`, never the wrapper itself:

```lua
-- ✅ OK
script.on_event(defines.events.on_player_created, function(event)
    local p = RitnLibPlayer(game.get_player(event.player_index))
    storage.player_names = storage.player_names or {}
    storage.player_names[p.index] = p.name  -- storing the string, not the wrapper
end)
```

Or store the raw `LuaPlayer` (Factorio knows how to persist it) and re-wrap as needed:

```lua
-- ✅ Also OK
script.on_event(defines.events.on_player_created, function(event)
    storage.tracked_players = storage.tracked_players or {}
    table.insert(storage.tracked_players, game.get_player(event.player_index))
end)

script.on_event(defines.events.on_tick, function()
    for _, raw_player in pairs(storage.tracked_players or {}) do
        if raw_player.valid then
            local p = RitnLibPlayer(raw_player)  -- fresh wrapper every tick
            -- ...
        end
    end
end)
```

## Summary

| ✅ Do | ❌ Avoid |
|---|---|
| `RitnLibPlayer(player)` inside the handler | `storage.wrapper = RitnLibPlayer(...)` |
| Re-instantiate on demand | Reuse a wrapper across events |
| Store the raw `LuaPlayer` | Store the wrapper |
| Store extracted primitives (string, index, position) | Store the wrapper object |

## Classes covered by this rule

Every class under `classes/LuaClass/`:
- [`RitnLibEvent`](../reference/runtime/RitnLibEvent.md)
- [`RitnLibPlayer`](../reference/runtime/RitnLibPlayer.md)
- [`RitnLibSurface`](../reference/runtime/RitnLibSurface.md)
- [`RitnLibForce`](../reference/runtime/RitnLibForce.md)
- [`RitnLibEntity`](../reference/runtime/RitnLibEntity.md)
- [`RitnLibRecipe`](../reference/runtime/RitnLibRecipe.md)
- [`RitnLibTechnology`](../reference/runtime/RitnLibTechnology.md)
- [`RitnLibGui`](../reference/runtime/RitnLibGui.md)
- [`RitnLibInformatron`](../reference/runtime/RitnLibInformatron.md)

**Exception**: `RitnLibInventory` is a special case — the *table* it receives as second argument **is** persistent (that's the whole point). See [Delegated persistence](delegated-persistence.md) for details.

## See also

- [4-layer architecture](architecture-layers.md)
- [Event model](event-model.md)
- [Delegated persistence](delegated-persistence.md)
