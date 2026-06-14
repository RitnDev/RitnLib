---
title: RitnLibGui
type: reference
lang: en
---

# `RitnLibGui`


Base class to build event-driven Factorio GUIs. It inherits from [`RitnLibPlayer`](RitnLibPlayer.md) (so all player fields are available), parses clicked element names by convention, and dispatches the action to a remote interface of the consumer mod.

`RitnLibGui` is **abstract**: you don't use it as-is, you **derive a subclass** that fills a few fields the base leaves empty. See the [extension contract](#extension-contract) below.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnGui.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | [`RitnLibPlayer`](RitnLibPlayer.md) |
| **Extended by** | the mod's GUI classes, e.g. `RitnGuiMenuButton`, `RitnLobbyGuiLobby` |
| **`object_name`** | `"RitnLibGui"` |

---

## Constructor

#### `RitnLibGui(event, mod_name, main_gui?)` → [`RitnLibGui`](RitnLibGui.md)

Extracts the player from the event (via [`RitnLibEvent`](RitnLibEvent.md)), initializes the [`RitnLibPlayer`](RitnLibPlayer.md) part, and leaves `gui`, `gui_name`, `gui_action`, `content` **empty** — to be filled by the subclass.

**Parameters**
- `event` :: [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) — the GUI event (or any event carrying a `player_index`).
- `mod_name` :: `string` — consumer mod name; used to target the remote interface.
- `main_gui` :: `string?` — suffix of the root element's name.

**Return value** → [`RitnLibGui`](RitnLibGui.md). No-op if `mod_name` is `nil`.

---

## Extension contract

The base class leaves four fields empty **on purpose**; your subclass fills them in its constructor, and the mod registers the dispatch interface:

```lua
RitnGuiMenuButton = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    RitnLibGui.init(self, event, ritnlib.defines.menu.name, "button-menu")
    self.object_name = "RitnGuiMenuButton"
    self.gui_name = "ritn"                                   -- (1) logical slug
    self.gui      = { modGui.get_button_flow(self.player) }  -- (2) root at [1]
    self.content  = flib.getContent()                        -- (3) element tree
    self.gui_action = {                                      -- (4) accepted actions
        [self.gui_name] = { ["button-menu"] = true },
    }
end)

-- on the mod side: register the remote dispatcher
remote.add_interface("MyMod", {
    gui_action_ritn = function(action, event, ...) --[[ … ]] end,
})
```

| To provide | Role |
|---|---|
| `self.gui = { <root LuaGuiElement> }` | `:getElement` / `:on_gui_click` walk `self.gui[1]`. |
| `self.gui_name` | element-name prefix + remote interface suffix (`gui_action_<gui_name>`). |
| `self.gui_action[gui_name] = { [action] = true }` | the actions this GUI accepts. |
| `self.content` | path table used by `:getElement`. |
| `remote.add_interface(mod_name, { gui_action_<gui_name> = … })` | receives the dispatched action. |

Design details in [ADR-0001](../../adr/0001-class-factory.md).

---

## Attributes

In addition to the fields inherited from [`RitnLibPlayer`](RitnLibPlayer.md):

#### `mod_name` :: `string` `[Read]`
Consumer mod name — target of `remote.call`.

#### `event` :: [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) `[Read]`
The original GUI event payload.

#### `element` :: [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html)`?` `[Read]`
The clicked/changed element (`event.element`).

#### `gui` :: `table` `[Read]`
Filled by the subclass: `gui[1]` must be the root `LuaGuiElement` (extension contract).

#### `gui_name` :: `string` `[Read]`
Logical GUI slug (e.g. `"lobby"`), filled by the subclass.

#### `gui_action` :: `table<string, table<string, true>>` `[Read]`
`[gui_name][action] = true` map of accepted actions, filled by the subclass.

#### `content` :: `table` `[Read]`
Element-path table used by `:getElement`, filled by the subclass.

#### `main_gui` :: `string?` `[Read]`
Suffix of the root element's name.

#### `list_valid` :: `table<string, true>` `[Read]`
Element types accepted by `:on_gui_selection_state_changed` (`listbox`, `dropdown`).

#### `pattern` :: `string` `[Read]`
Regex splitting element names into the `ui`/`element`/`name` triplet.

---

## Methods

#### `:getEvent()` → [`RitnLibEvent`](RitnLibEvent.md)
Returns a fresh [`RitnLibEvent`](RitnLibEvent.md) wrapping the original payload.

#### `:setMainGui(main_gui)` → [`RitnLibGui`](RitnLibGui.md)
Sets the `main_gui` root element name. No-op if the argument isn't a `string`. Chainable.

#### `:getElement(element_type, element_name?)` → [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html)`?`
Retrieves an element by walking `self.content[element_type][element_name]` as a path of suffixes prefixed by `gui_name`, starting from `self.gui[1]`.

**Parameters**
- `element_type` :: `string` — element category in `content`.
- `element_name` :: `string?` — specific name; if omitted, targets `content[element_type]`.

> **Note** — Relies on the extension contract: `self.gui[1]` and `self.content` must have been filled by the subclass. Returns `nil` if the path doesn't resolve.

#### `:getListSelectedItem(element_type, element_name)` → `string?`
Returns the selected item of a `list-box` / `drop-down` identified by `(element_type, element_name)`. Validates the type and selection; `nil` if nothing is selected.

#### `:actionGui(action, ...)` → [`RitnLibGui`](RitnLibGui.md)
Dispatches an action via `remote.call(self.mod_name, "gui_action_"..self.gui_name, action, self.event, ...)`. No-op if the action isn't declared in `self.gui_action[self.gui_name]`.

> **Warning** — The consumer mod **must** have registered `remote.add_interface(mod_name, { gui_action_<gui_name> = … })`, otherwise the `remote.call` raises.

#### `:on_gui_click(...)`
Click handler: parses `self.element.name` via `pattern` into `(ui, element, name)` and dispatches `action = "<element>-<name>"` via `:actionGui`. Call it from the mod's `on_gui_click` event. Returns early and harmlessly when the click isn't for this GUI.

#### `:on_gui_selection_state_changed(...)`
Like `:on_gui_click`, for `list-box` / `drop-down`; dispatches `action = "<element>-<name>-selection_state_changed"`. Call it from the matching event.

---

## Usage examples

**Wire the Factorio handler to the subclass** (`RitnLobbyGame/modules/lobby.lua`):

```lua
local function on_gui_click(e)
    RitnLobbyGuiLobby(e):on_gui_click()
end
module.events[defines.events.on_gui_click] = on_gui_click
```

**Receive the dispatched action** (`RitnLobbyGame/modules/storage.lua`):

```lua
local lobby_interface = {
    ["gui_action_lobby"] = function(action, event)
        if     action == "open"    then RitnLobbyGuiLobby(event):action_open()
        elseif action == "close"   then RitnLobbyGuiLobby(event):action_close()
        elseif action == "request" then RitnLobbyGuiLobby(event):action_request()
        end
    end,
}
remote.add_interface("RitnLobbyGame", lobby_interface)
```

**Read a list selection** (`RitnLobbyGame/classes/RitnGuiLobby.lua`):

```lua
local index = self:getElement("list").selected_index
```

---

## Remarks

- **Temporary wrapper** — never store the instance in `storage`; rebuild it in each GUI handler. See [Temporary wrappers](../../concepts/temporary-wrappers.md).
- **Abstract by design** — without a subclass fulfilling the [extension contract](#extension-contract), `:getElement` / `:on_gui_click` have no `gui[1]` root to walk.
- **Naming convention** — element names follow `gui_name-element-name` so `pattern` can split them back and route the action.

## See also

- [Class map](../overview.md)
- [`RitnLibPlayer`](RitnLibPlayer.md) (parent) · [`RitnLibEvent`](RitnLibEvent.md) · [`RitnLibGuiElement`](RitnLibGuiElement.md) · [`RitnLibStyle`](RitnLibStyle.md)
- [Temporary wrappers (golden rule)](../../concepts/temporary-wrappers.md)
- [ADR-0001 — Class factory](../../adr/0001-class-factory.md)
