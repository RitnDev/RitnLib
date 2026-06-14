---
title: RitnLibGuiElement
type: reference
lang: en
---

# `RitnLibGuiElement`

🇫🇷 [Version française](../../../fr/reference/runtime/RitnLibGuiElement.md)

A **fluent** builder for a `LuaGuiElement.add{...}` payload. Every setter returns `self` for chaining; at the end, `:add(parent)` instantiates the element on a real GUI tree, or `:get()` returns the payload only. It also builds a normalized element name (`<ui>-<type>-<name>`) compatible with [`RitnLibGui`](RitnLibGui.md) routing.

| | |
|---|---|
| **Source** | `classes/RitnClass/gui/RitnGuiElement.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **`object_name`** | `"RitnLibGuiElement"` |

---

## Constructor

#### `RitnLibGuiElement(ui_name, element_type, element_name)` → [`RitnLibGuiElement`](RitnLibGuiElement.md)

Initializes the `add{...}` payload. The `element_type` (Factorio type, e.g. `"sprite-button"`, `"text-box"`, `"scroll-pane"`) is normalized to a short form for the slug (`button`, `textbox`, `pane`…); the real Factorio type is kept in [`type`](#type--string-read).

**Parameters**
- `ui_name` :: `string` — UI namespace (prefix), typically the parent GUI's `gui_name`.
- `element_type` :: `string` — Factorio element type (`"flow"`, `"frame"`, `"button"`, `"label"`, `"sprite-button"`, `"scroll-pane"`, `"list-box"`…).
- `element_name` :: `string` — logical element name.

**Return value** → [`RitnLibGuiElement`](RitnLibGuiElement.md). The final element name (`gui_element.name`) is `ui_name-<normalizedType>-element_name`.

```lua
local payload = RitnLibGuiElement("lobby", "flow", "common"):horizontal():get()
```

---

## Attributes

#### `gui_name` :: `string` `[Read]`
`ui-normalizedType-name` slug — used as the element's `name` and for GUI routing.

#### `name` · `type` · `ui` :: `string` `[Read]`
Constructor arguments kept verbatim (`type` = real Factorio type, **not** the slug).

#### `action` :: `string` `[Read]`
Default action key `<type>-<name>`.

#### `gui_element` :: `table` `[Read]`
The `add{...}` payload being built (returned by [`:get()`](#get--table)).

> **Note** — The class also keeps internal validation tables (`hsp_valid`, `string_valid`, `orientation_valid`, `text_valid`, `button_valid`, `sprite_valid`, `check_valid`) that gate setters by element type.

---

## Methods — output

#### `:add(parent)` → [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html)`?`
Adds the built element to `parent` and returns the created `LuaGuiElement`.

**Parameters**: `parent` :: [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html).

#### `:get()` → `table`
Returns the raw `add{...}` payload without instantiating (handy to pass to `parent.add(...)` later).

---

## Methods — orientation & layout

| Method | Effect |
|---|---|
| `:horizontal()` | `direction = "horizontal"` (frame/flow/line) |
| `:vertical()` | `direction = "vertical"` (frame/flow/line) |
| `:autoCenter()` | `auto_center = true` (frame only) |
| `:index(index)` | insertion position in the parent (`index :: integer`) |

---

## Methods — content

#### `:caption(caption)` → self · `:tooltip(tooltip)` → self
Set caption / tooltip. Accept a [`LocalisedString`](https://lua-api.factorio.com/latest/concepts/LocalisedString.html) (`string` or `table`).

#### `:text(text)` → self
Sets the text (`textfield` / `text-box`).

> **Warning** — Known defect: the method tests `type(tooltip)` (undefined variable) instead of `type(text)`; the text is therefore **never** applied. See [known bugs](../../debt/known-bugs.md).

---

## Methods — state

| Method | Effect |
|---|---|
| `:visible(visible)` | `visible` flag (`boolean`) |
| `:enabled(enabled)` | `enabled` flag (`boolean`) |
| `:checked(check?)` | checked state (checkbox/radiobutton; default `true`) |
| `:progress(value?)` | 0..100 value (progressbar; default 0) |

---

## Methods — appearance

| Method | Effect |
|---|---|
| `:style(style)` | registered GUI style name (`string`) |
| `:spritePath(sprite)` | sprite (sprite / sprite-button) |
| `:resizeSprite(resize)` | `resize_to_sprite` (sprite type) |
| `:mouseButtonFilter(value?)` | `mouse_button_filter` (button/sprite-button; default `{"left"}`) |

---

## Methods — scroll (scroll-pane)

#### `:horizontalScrollPolicy(hsp)` → self
Horizontal scroll policy. `hsp` ∈ `"auto"` | `"never"` | `"always"` | `"auto-and-reserve-space"` | `"dont-show-but-allow-scrolling"`.

#### `:verticalScrollPolicy(vsp)` → self
Vertical scroll policy (same values).

> **Note** — Known minor defect: validates `vsp` against `hsp_valid` instead of a dedicated set. Harmless today (same allowed values).

---

## Usage example

**Build a GUI tree** (`RitnLobbyGame/gui/lobby.lua`):

```lua
return {
    flow = {
        common = RitnLibGuiElement(gui_name, "flow", "common"):horizontal():get(),
        main   = RitnLibGuiElement(gui_name, "flow", "main"):vertical():get(),
    },
    button = {
        request = RitnLibGuiElement(gui_name, "button", "request")
            :caption(captions.button_request)
            :style("confirm_button")
            :tooltip({ "tooltip.button-valid" })
            :get(),
    },
}
```

---

## Remarks

- **Builder, not a live-element wrapper** — `RitnLibGuiElement` builds a *payload*; the real element is born at `:add(parent)`.
- **Naming** — the `ui-type-name` slug lets [`RitnLibGui`](RitnLibGui.md) re-route click events.
- **Type gating** — type-specific setters (orientation, sprite, scroll…) are no-ops on an incompatible element type.

## See also

- [Class map](../overview.md)
- [`RitnLibGui`](RitnLibGui.md) · [`RitnLibStyle`](RitnLibStyle.md)
- [Known bugs](../../debt/known-bugs.md)
