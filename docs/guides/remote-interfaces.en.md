---
title: Remote interfaces
type: guide
lang: en
---

# Remote interfaces

This guide covers the `remote.add_interface` patterns used in RitnLib mods: GUI dispatch, cross-mod communication, and naming conventions.

## Why `remote`

Factorio uses `remote.add_interface` / `remote.call` for communication between mods. It's the only clean way for mod A to call a function from mod B without tight coupling.

In RitnLib, remote interfaces are primarily used for **GUI dispatch**: `RitnLibGui` calls `remote.call(mod_name, "gui_action_<gui_name>", ...)` to route clicks.

## Interface structure

```lua
-- my-mod/control.lua
remote.add_interface("my-mod", {
    my_function = function(arg1, arg2)
        -- logic
        return result
    end,

    another_function = function()
        -- ...
    end
})
```

`remote.add_interface` takes a name (the interface name, typically the mod name) and a table of functions. It registers at the moment the file runs.

## GUI interface — click dispatch

The `gui_action_<gui_name>` pattern is a RitnLib convention. `RitnLibGui` looks for exactly this name:

```lua
remote.add_interface("my-mod", {
    -- gui_name = "my-gui" → gui_action_my_gui (hyphens → underscores)
    gui_action_my_gui = function(player_index, element_name)
        local player = game.get_player(player_index)

        if element_name == "btn-ok" then
            -- OK button clicked
        elseif element_name == "btn-close" then
            if player and player.gui.center["my-gui-root"] then
                player.gui.center["my-gui-root"].destroy()
            end
        end
    end,
})
```

`element_name` is the name of the clicked element **without** the `"gui_name-"` prefix.

## Multiple GUIs in the same mod

You can have multiple GUI interfaces in the same `remote.add_interface` table:

```lua
remote.add_interface("my-mod", {
    gui_action_inventory = function(player_index, element_name)
        -- dispatch for the "inventory" GUI
    end,

    gui_action_options = function(player_index, element_name)
        -- dispatch for the "options" GUI
    end,

    -- utility functions for other mods
    get_version = function()
        return "1.0.0"
    end,
})
```

## Calling another mod's interface

```lua
-- Check the interface exists before calling
if remote.interfaces["other-mod"] and remote.interfaces["other-mod"]["get_version"] then
    local version = remote.call("other-mod", "get_version")
    log("other-mod version: " .. version)
end
```

Always check `remote.interfaces["mod-name"]` before calling — the mod may be absent or disabled.

## Naming rule

| Case | Function name |
|---|---|
| GUI dispatch for `gui_name = "my-panel"` | `gui_action_my_panel` |
| GUI dispatch for `gui_name = "lobby-main"` | `gui_action_lobby_main` |
| Public API for other mods | any descriptive name |

The rule: replace hyphens with underscores in `gui_name` to get the function name.

## One interface per mod

`remote.add_interface` can only be called **once** per name. Calling it twice with the same name raises a Factorio error. Group all your functions in a single call.

```lua
-- ✅ One call with all functions
remote.add_interface("my-mod", {
    gui_action_panel   = function(...) ... end,
    gui_action_options = function(...) ... end,
    get_data           = function() ... end,
})

-- ❌ Two separate calls → Factorio error
remote.add_interface("my-mod", { gui_action_panel = ... })
remote.add_interface("my-mod", { gui_action_options = ... })  -- ERROR
```

## See also

- [Consumer remote contract](../concepts/remote-contract.md)
- [Full GUI pattern](gui-pattern.en.md)
- [Event model](../concepts/event-model.md)
- [Reference: RitnLibGui](../reference/runtime/RitnLibGui.md)
