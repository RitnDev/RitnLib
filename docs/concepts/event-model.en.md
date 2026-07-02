---
title: Event model
type: concept
lang: en
---

# Event model

> **RitnLib registers no handlers. Your mod calls `script.on_event`. RitnLib just gives you `RitnLibEvent` to normalise the payload.**

## Principle

Factorio delivers events as raw tables with variable fields depending on the event (`event.player_index`, `event.entity`, `event.surface_index`…). `RitnLibEvent` normalises all of that into a single consistent object.

```lua
-- Without RitnLib
script.on_event(defines.events.on_built_entity, function(event)
    local player = game.get_player(event.player_index)  -- may be nil
    local entity = event.created_entity                  -- absent if not applicable
    -- ...
end)

-- With RitnLib
script.on_event(defines.events.on_built_entity, function(event)
    local e = RitnLibEvent(event)
    local player = e:getPlayer()   -- RitnLibPlayer or nil, never throws
    local entity = e:getEntity()   -- LuaEntity or nil
    -- ...
end)
```

## What `RitnLibEvent` does

The constructor receives the raw event table and extracts the common fields:

| Field | Source | Type |
|---|---|---|
| `e.player_index` | `event.player_index` | `uint?` |
| `e.surface_index` | `event.surface_index` | `uint?` |
| `e.entity` | `event.entity` | `LuaEntity?` |
| `e.name` | `event.name` | `uint` (defines.events.*) |
| `e.tick` | `event.tick` | `uint` |
| … | … | … |

The methods `:getPlayer()`, `:getSurface()`, `:getForce()`, `:getEntity()` return RitnLib wrappers or `nil`. They never throw if a field is absent.

## No own handlers

RitnLib does not call `script.on_event(...)`. It has no internal event loop. **Your mod is responsible for subscribing to Factorio events.**

```lua
-- YOUR control.lua does this:
script.on_event(defines.events.on_player_joined_game, function(event)
    local e = RitnLibEvent(event)
    -- your logic here
end)
```

## Multiple handlers on the same event

RitnLib does not interfere with Factorio's event dispatch. You can have multiple `script.on_event` calls for the same event and route to different parts of your logic.

```lua
local function handle_player_joined(event)
    local e = RitnLibEvent(event)
    local player = e:getPlayer()
    if not player then return end
    player:print("Welcome!")
end

local function log_player_joined(event)
    log("Player joined: " .. event.player_index)
end

script.on_event(defines.events.on_player_joined_game, handle_player_joined)
script.on_event(defines.events.on_player_joined_game, log_player_joined)
-- Both execute, in this order
```

## Events and `RitnLibGui`

`RitnLibGui` follows the same principle: your mod registers the `on_gui_click` handler and instantiates `RitnLibGui` inside it to dispatch the action.

```lua
script.on_event(defines.events.on_gui_click, function(event)
    local gui = RitnLibGui(event, "my-mod")
    gui:on_gui_click()  -- dispatches to remote.call("my-mod", "gui_action_<gui_name>", ...)
end)
```

See [Consumer remote contract](remote-contract.md) for the full GUI pattern.

## See also

- [Temporary wrappers](temporary-wrappers.md)
- [Consumer remote contract](remote-contract.md)
- [Reference: RitnLibEvent](../reference/runtime/RitnLibEvent.md)
- [Reference: RitnLibGui](../reference/runtime/RitnLibGui.md)
