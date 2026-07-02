---
title: Full GUI pattern
type: guide
lang: en
---

# Full GUI pattern

This guide shows how to build a GUI with `RitnLibGui` and `RitnLibGuiElement`, starting from the simplest case up to the full pattern used in RitnCharacters.

## Minimal example

For a simple GUI (one frame + one button), everything can fit in `control.lua`.

### The class

```lua
-- my-mod/control.lua

MyGui = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    -- mod_name + root frame suffix ("panel-frame-main" in game)
    RitnLibGui.init(self, event, "my-mod", "frame-main")
    self.object_name = "MyGui"
    self.gui_name    = "panel"

    -- Allowed actions: "normalised_type-element_name"
    self.gui_action = {
        ["panel"] = {
            ["button-close"] = true,
        }
    }

    -- self.gui[1] = the container, not the root frame
    self.gui     = { self.player.gui.center }
    self.content = {}
end)

function MyGui:create()
    -- Check if the GUI already exists
    if self.gui[1]["panel-frame-main"] then return self end

    local frame = self.gui[1].add(
        RitnLibGuiElement("panel", "frame", "main"):vertical():get()
    )
    frame.add(
        RitnLibGuiElement("panel", "button", "close"):caption("Close"):get()
    )
    return self
end

function MyGui:action_close()
    local frame = self.gui[1]["panel-frame-main"]
    if frame then frame.destroy() end
    return self
end
```

### The remote interface

```lua
remote.add_interface("my-mod", {
    gui_action_panel = function(action, event)
        if action == "button-close" then
            MyGui(event):action_close()
        end
    end,
})
```

### The handlers

```lua
script.on_event(defines.events.on_player_created, function(event)
    MyGui(event):create()
end)

script.on_event(defines.events.on_gui_click, function(event)
    MyGui(event):on_gui_click()
    -- parses "panel-button-close" → action = "button-close"
    -- → remote.call("my-mod", "gui_action_panel", "button-close", event)
end)
```

---

## Full pattern — 3-file structure

For a more complex GUI (list, nested flows, styles), the recommended approach is to split into 3 files as in RitnCharacters.

```
my-mod/
├─ gui/my-panel.lua         ← element specs + paths
├─ classes/MyGui.lua        ← class with :create() and actions
└─ modules/storage.lua      ← remote.add_interface
```

### `gui/my-panel.lua` — specs and paths

```lua
local function getElement(gui_name)
    return {
        frame = {
            main    = RitnLibGuiElement(gui_name, "frame", "main"):vertical():get(),
            submain = RitnLibGuiElement(gui_name, "frame", "submain"):vertical()
                        :style("inside_shallow_frame"):get(),
        },
        flow = {
            footer = RitnLibGuiElement(gui_name, "flow", "footer"):horizontal():get(),
        },
        list   = RitnLibGuiElement(gui_name, "list-box", "items"):get(),
        button = {
            confirm = RitnLibGuiElement(gui_name, "button", "confirm"):caption("Confirm"):get(),
            close   = RitnLibGuiElement(gui_name, "button", "close"):caption("Close"):get(),
        },
    }
end

local function getContent()
    return {
        frame  = {
            main    = { "frame-main" },
            submain = { "frame-main", "frame-submain" },
        },
        flow   = {
            footer = { "frame-main", "frame-submain", "flow-footer" },
        },
        list   = { "frame-main", "frame-submain", "listbox-items" },
        button = {
            confirm = { "frame-main", "frame-submain", "flow-footer", "button-confirm" },
            close   = { "frame-main", "frame-submain", "flow-footer", "button-close" },
        },
    }
end

return { getElement = getElement, getContent = getContent }
```

`getContent` describes the traversal path from `self.gui[1]` to each element. `self:getElement("list")` walks it, prepending `gui_name .. "-"` to each step.

### `classes/MyGui.lua`

```lua
local fGui = require(ritnlib.defines.mymod.gui.panel)

MyGui = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    RitnLibGui.init(self, event, ritnlib.defines.mymod.name, "frame-main")
    self.object_name = "MyGui"
    self.gui_name    = "panel"

    self.gui_action = {
        ["panel"] = {
            ["button-confirm"] = true,
            ["button-close"]   = true,
        }
    }

    self.gui     = { self.player.gui.center }
    self.content = fGui.getContent()
end)

function MyGui:create()
    if self.gui[1]["panel-frame-main"] then return self end

    local e = fGui.getElement(self.gui_name)
    local c = {}
    c.frame_main    = self.gui[1].add(e.frame.main)
    c.frame_submain = c.frame_main.add(e.frame.submain)
    c.list          = c.frame_submain.add(e.list)
    c.flow_footer   = c.frame_submain.add(e.flow.footer)
    c.btn_confirm   = c.flow_footer.add(e.button.confirm)
    c.btn_close     = c.flow_footer.add(e.button.close)

    -- Post-creation styling
    RitnLibStyle(c.frame_main):padding(4)
    RitnLibStyle(c.list):horizontalStretch():maxHeight(400)
    RitnLibStyle(c.flow_footer):align("right")

    for _, item in pairs({ "Option A", "Option B", "Option C" }) do
        c.list.add_item(item)
    end
    return self
end

function MyGui:action_close()
    local frame = self.gui[1]["panel-frame-main"]
    if frame then frame.destroy() end
    return self
end

function MyGui:action_confirm()
    local list = self:getElement("list")
    if not list or list.selected_index == 0 then return self end
    self.player.player.print("Selected: " .. list.get_item(list.selected_index))
    self:action_close()
    return self
end
```

### `modules/storage.lua`

```lua
remote.add_interface("my-mod", {
    ["gui_action_panel"] = function(action, event)
        if action == "button-confirm" then
            MyGui(event):action_confirm()
        elseif action == "button-close" then
            MyGui(event):action_close()
        end
    end,
})
return {}
```

---

## Quick reference

### `RitnLibGuiElement` — naming

`RitnLibGuiElement(gui_name, type, name)` generates the in-game name `gui_name-normalised_type-name`:

| Type passed | Normalised | Example with gui_name="panel" |
|---|---|---|
| `"frame"` | `"frame"` | `"panel-frame-main"` |
| `"flow"` | `"flow"` | `"panel-flow-footer"` |
| `"button"` / `"sprite-button"` | `"button"` | `"panel-button-close"` |
| `"list-box"` | `"listbox"` | `"panel-listbox-items"` |
| `"drop-down"` | `"dropdown"` | `"panel-dropdown-x"` |
| `"text-box"` | `"textbox"` | `"panel-textbox-x"` |

### Common methods

| Method | Purpose |
|---|---|
| `:horizontal()` / `:vertical()` | Direction (frame, flow, line) |
| `:caption(text)` | Displayed text |
| `:style(name)` | Factorio GUI style |
| `:tooltip(text)` | Tooltip |
| `:visible(bool)` | Initial visibility |
| `:enabled(bool)` | Enabled/disabled |
| `:get()` | Returns the raw payload (to pass to `parent.add(...)`) |
| `:add(parent)` | Adds directly to `parent`, returns the `LuaGuiElement` |

## See also

- [Consumer remote contract](../concepts/remote-contract.md)
- [Remote interfaces](remote-interfaces.en.md)
- [Temporary wrappers](../concepts/temporary-wrappers.md)
- [Reference: RitnLibGui](../reference/runtime/RitnLibGui.md)
- [Reference: RitnLibGuiElement](../reference/runtime/RitnLibGuiElement.md)
