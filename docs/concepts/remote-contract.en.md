---
title: Consumer remote contract
type: concept
lang: en
---

# Consumer remote contract (`RitnLibGui` extension)

> **`RitnLibGui` is an abstract base class. It does nothing on its own. Your mod subclasses it, fills the four contract fields, and registers the remote interface.**

This contract is applied in several mods (RitnMenuButton, RitnLobbyGame, RitnCharacters).

## What `RitnLibGui` expects from the subclass

| Field | Provided by | Expected value |
|---|---|---|
| `self.gui[1]` | subclass | the **container** (`player.gui.center`, etc.) — not the root frame |
| `self.gui_name` | subclass | logical GUI slug (e.g. `"changer"`) — prefix for all elements |
| `self.gui_action` | subclass | `{ [gui_name] = { [action] = true, ... } }` |
| `self.content` | subclass | path lookup table used by `:getElement()` |

`RitnLibGui.init` does **not** fill these fields — the subclass constructor does.

## `RitnLibGui.init` — what it actually initialises

```lua
RitnLibGui.init(self, event, mod_name, main_gui)
```

- `mod_name` — mod name (target of `remote.call`)
- `main_gui` — **suffix** of the root frame, not `gui_name`. Full in-game name = `gui_name .. "-" .. main_gui` (e.g. `"changer-frame-main"`)

## Element naming convention

`RitnLibGuiElement(gui_name, type, name)` generates a name of the form `gui_name-normalised_type-name`:

```
"changer-frame-main"      ← RitnLibGuiElement("changer", "frame",    "main")
"changer-button-select"   ← RitnLibGuiElement("changer", "button",   "select")
"changer-listbox-items"   ← RitnLibGuiElement("changer", "list-box", "items")
```

Normalised types: `"list-box"` → `"listbox"`, `"drop-down"` → `"dropdown"`, `"sprite-button"` → `"button"`, `"text-box"` → `"textbox"`.

## Click dispatch — how it works

`on_gui_click` parses the clicked element name via the pattern `"([^-]*)-?([^-]*)-?([^-]*)"`:

```
"changer-button-select"
    │        │       │
   ui     element   name
```

→ `action = element .. "-" .. name` = `"button-select"`

RitnLibGui checks that `self.gui_action[ui][action]` exists, then calls:

```lua
remote.call(mod_name, "gui_action_" .. gui_name, action, event)
```

## Remote interface — exact signature

```lua
remote.add_interface("my-mod", {
    ["gui_action_" .. gui_name] = function(action, event)
        -- action = "button-close", "button-confirm", etc.
        -- event  = original Factorio EventData
    end,
})
```

> ⚠ The signature is `function(action, event)` — **not** `function(player_index, element_name)`.

## `self.gui_action` — allowed actions table

```lua
self.gui_action = {
    ["changer"] = {              -- key = gui_name
        ["button-select"] = true,
        ["button-close"]  = true,
    }
}
```

The inner keys are `action` strings (`"type-name"`). If an action is not in this table, the dispatch is silently ignored.

## Complete example — RitnCharacters

```lua
-- classes/RitnGuiChanger.lua

RitnGuiCharacterChanger = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    RitnLibGui.init(self, event, ritnlib.defines.characters.name, "frame-main")
    self.object_name = "RitnGuiCharacterChanger"
    self.gui_name    = "changer"

    self.gui_action = {
        ["changer"] = {
            ["button-select"] = true,
            -- (open/close triggered by shortcut, not by internal click)
        }
    }

    self.gui = { self.player.gui.center }  -- container, not the frame

    self.content = fGui.getContent()
end)

-- modules/storage.lua

remote.add_interface("RitnCharacters", {
    ["gui_action_changer"] = function(action, event)
        if action == "button-select" then
            RitnGuiCharacterChanger(event):action_select()
        end
    end,
})
```

## `self:getElement(type, name)` — navigating the GUI

`getElement` walks `self.content[type][name]` as a path from `self.gui[1]`, prepending `gui_name .. "-"` to each step:

```lua
-- content.list = { "frame-main", "frame-submain", "flow-selecter", "listbox-characters" }
local list = self:getElement("list")
-- → self.gui[1]["changer-frame-main"]["changer-frame-submain"]
--                  ["changer-flow-selecter"]["changer-listbox-characters"]
```

## See also

- [Full GUI pattern](../guides/gui-pattern.md)
- [Event model](event-model.md)
- [Temporary wrappers](temporary-wrappers.md)
- [Reference: RitnLibGui](../reference/runtime/RitnLibGui.md)
- [Reference: RitnLibGuiElement](../reference/runtime/RitnLibGuiElement.md)
