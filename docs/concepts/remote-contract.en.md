---
title: Consumer remote contract
type: concept
lang: en
---

# Consumer remote contract (`RitnLibGui` extension)

> **`RitnLibGui` is an abstract base class. It does nothing on its own. Your mod subclasses it, fills `self.gui[1]`, and registers the remote interface.**

This contract has been verified in several production mods (RitnMenuButton, RitnLobbyGame, RitnCharacters).

## Overview

`RitnLibGui` handles GUI click dispatch: when a player clicks, it identifies the clicked GUI element, walks the name chain up to the root GUI, and calls the associated remote interface. To do this, it needs three things the subclass must provide:

| Property | Provided by | Expected value |
|---|---|---|
| `self.gui[1]` | subclass | the root `LuaGuiElement` of the GUI |
| `self.gui_name` | subclass | logical GUI name (e.g. `"lobby"`) |
| `self.gui_action` | `RitnLibGui.init` | `"gui_action_" .. gui_name` |
| `self.content` | subclass | sub-element cache (can stay `{}`) |

## Implementing the contract

### 1. Define the subclass

```lua
-- my-mod/classes/MyGui.lua
local MyGui = ritnlib.classFactory.newclass(RitnLibGui, function(self, event, mod_name)
    -- Parent call is mandatory
    RitnLibGui.init(self, event, mod_name, "my-gui")

    self.object_name = "MyGui"
    self.gui_name    = "my-gui"

    -- Fill self.gui[1] with the GUI root element
    self.gui = { self.player.gui.center["my-gui-root"] }

    self.content = {}
end)
```

### 2. Register the remote interface

```lua
-- my-mod/control.lua
remote.add_interface("my-mod", {
    gui_action_my_gui = function(player_index, element_name)
        -- click handling logic
        if element_name == "btn-ok" then
            -- ...
        end
    end
})
```

### 3. Wire the handler

```lua
script.on_event(defines.events.on_gui_click, function(event)
    local gui = MyGui(event, "my-mod")
    gui:on_gui_click()
    -- RitnLibGui identifies the clicked element,
    -- then calls remote.call("my-mod", "gui_action_my-gui", player_index, element_name)
end)
```

## Why `self.gui[1]` and not `self.gui[gui_name]`

`RitnLibGui` accesses the root via `self.gui[1]` (integer index). This is intentional: at instantiation time, `gui_name` is not yet known by the base class, and the integer index is the simplest and most reliable form.

⚠ `RitnLibInformatron` has a known bug related to this convention: its `getElement` reads `self.gui[self.gui_name]` (string key) instead of `self.gui[1]`. See the [reference page](../reference/runtime/RitnLibInformatron.md).

## GUI element naming

`RitnLibGui` reconstructs the path to the clicked element by walking up the name hierarchy. `LuaGuiElement` names must follow the `"<gui_name>-<element_name>"` convention (prefixed by gui_name).

```lua
-- When building the GUI
player.gui.center.add({
    type = "frame",
    name = "my-gui-root",
    direction = "vertical",
    children = {
        { type = "button", name = "my-gui-btn-ok" },
        { type = "button", name = "my-gui-btn-cancel" },
    }
})
```

When the player clicks `my-gui-btn-ok`, `on_gui_click` receives `element_name = "btn-ok"` in the remote interface.

## Complete example — RitnMenuButton

RitnMenuButton is the reference mod for this pattern. It exposes a button in the menu bar (Factorio 2.0). Its structure:

```
RitnMenuButton (mod)
└─ classes/RitnMenuButton.lua
   └─ RitnMenuButton = newclass(RitnLibGui, function(self, event, mod_name)
         RitnLibGui.init(self, event, mod_name, "menu-button")
         self.gui_name = "menu-button"
         self.gui = { self.player.gui.top["menu-button-root"] }
      end)

control.lua
├─ remote.add_interface("RitnMenuButton", {
│     gui_action_menu_button = function(player_index, element_name)
│         -- handles clicks
│     end
│  })
└─ script.on_event(on_gui_click, function(event)
       local btn = RitnMenuButton(event, "RitnMenuButton")
       btn:on_gui_click()
   end)
```

## See also

- [Event model](event-model.md)
- [Temporary wrappers](temporary-wrappers.md)
- [Reference: RitnLibGui](../reference/runtime/RitnLibGui.md)
- [Reference: RitnLibGuiElement](../reference/runtime/RitnLibGuiElement.md)
