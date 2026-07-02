---
title: My first runtime handler
type: guide
lang: en
---

# My first runtime handler

This guide shows how to write Factorio event handlers at the **runtime stage** using RitnLib classes.

## Principle

At the runtime stage, all `RitnLib*` classes are injected into `_G` by RitnLib's `control.lua`. No `require` needed. You use them directly in your handlers.

**RitnLib registers no handlers of its own.** All `script.on_event(...)` calls come from your mod.

## Minimal example

```lua
-- my-mod/control.lua

script.on_event(defines.events.on_player_joined_game, function(event)
    local e      = RitnLibEvent(event)
    local player = e:getPlayer()
    if not player then return end

    player:print("Welcome to the game!")
end)
```

`RitnLibEvent` normalises the raw event payload. `e:getPlayer()` returns a `RitnLibPlayer` or `nil` if `player_index` is absent — without ever throwing.

## `RitnLibEvent` — payload normalisation

```lua
script.on_event(defines.events.on_built_entity, function(event)
    local e       = RitnLibEvent(event)
    local player  = e:getPlayer()   -- RitnLibPlayer or nil
    local entity  = e:getEntity()   -- LuaEntity or nil
    local surface = e:getSurface()  -- RitnLibSurface or nil

    if player and entity then
        player:print("You built: " .. entity.name)
    end
end)
```

## `RitnLibPlayer` — player interactions

`RitnLibPlayer` wraps a `LuaPlayer`. It exposes common methods:

```lua
script.on_event(defines.events.on_player_created, function(event)
    local player = RitnLibPlayer(game.get_player(event.player_index))

    -- Print a message
    player:print("Welcome!")

    -- Get the force
    local force = player:getForce()   -- RitnLibForce

    -- Access the underlying LuaPlayer
    local lp = player.player
    log("Name: " .. lp.name)
end)
```

> `RitnLibPlayer` is a temporary wrapper — do not store it in `storage`. Re-instantiate it in each handler. See [Temporary wrappers](../concepts/temporary-wrappers.md).

## `RitnLibForce` — force operations

```lua
script.on_event(defines.events.on_research_finished, function(event)
    local e     = RitnLibEvent(event)
    local force = e:getForce()   -- RitnLibForce or nil
    if not force then return end

    -- Enable a technology
    force:setTechnology("advanced-electronics", true)
end)
```

## `RitnLibTechnology` — technology management

```lua
local function unlock_starting_tech(player)
    local tech = RitnLibTechnology(player:getForce(), "automation")
    tech:research()   -- unlocks the technology immediately
end
```

## Initialising `storage`

```lua
script.on_init(function()
    -- Initialise your storage tables here
    storage.my_data = {}
end)

script.on_configuration_changed(function(data)
    -- Migration when the mod is updated
    storage.my_data = storage.my_data or {}
end)
```

`on_init` runs when a new game is created. `on_configuration_changed` runs when mods change (added, updated, removed) in an existing game.

## Multiple handlers on the same event

```lua
-- Both run, in registration order
script.on_event(defines.events.on_player_joined_game, function(event)
    local e = RitnLibEvent(event)
    local player = e:getPlayer()
    if player then player:print("Welcome!") end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    log("Player joined: " .. event.player_index)
end)
```

## Important rules

| ✅ Do | ❌ Avoid |
|---|---|
| Re-instantiate `RitnLibPlayer(...)` in each handler | Storing a `RitnLibPlayer` in `storage` |
| Guard with `if not player then return end` | Assuming `e:getPlayer()` is never nil |
| Use `on_init` to initialise `storage` | Accessing `storage` without prior initialisation |

## See also

- [Event model](../concepts/event-model.md)
- [Temporary wrappers](../concepts/temporary-wrappers.md)
- [Full GUI pattern](gui-pattern.en.md)
- [Reference: RitnLibEvent](../reference/runtime/RitnLibEvent.md)
- [Reference: RitnLibPlayer](../reference/runtime/RitnLibPlayer.md)
