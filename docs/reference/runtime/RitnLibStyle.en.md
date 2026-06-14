---
title: RitnLibStyle
type: reference
lang: en
---

# `RitnLibStyle`


A **fluent** helper to mutate the [`LuaStyle`](https://lua-api.factorio.com/latest/classes/LuaStyle.html) of an **already-created** `LuaGuiElement`. Every setter returns `self` for chaining. Provides ready-made **presets** (label, frame, listbox, buttons…) and **atomic setters** (dimensions, margins, paddings, alignment, font).

> Distinct from [`RitnLibGuiElement`](RitnLibGuiElement.md), which builds the creation *payload*. `RitnLibStyle` applies **afterwards**, on the instantiated element.

| | |
|---|---|
| **Source** | `classes/RitnClass/gui/RitnStyle.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **`object_name`** | `"RitnLibStyle"` |

---

## Constructor

#### `RitnLibStyle(element)` → [`RitnLibStyle`](RitnLibStyle.md)

Validates the input (must be a `LuaGuiElement`) and captures its `.style` reference. All setters mutate that `LuaStyle`.

**Parameters**
- `element` :: [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html) — the element whose `LuaStyle` to style.

```lua
RitnLibStyle(content.frame.lobby):frame():maxHeight(450):maxWidth(260)
```

---

## Attributes

#### `style` :: [`LuaStyle`](https://lua-api.factorio.com/latest/classes/LuaStyle.html) `[Read]`
The wrapped `LuaStyle` (live reference of `element.style`).

#### `stretch` :: `boolean` `[Read]`
Flag reused by the stretch helpers (default `true`, reset to `true` after each call).

#### `color` :: `table` `[Read]`
Reference to the `core/constants.lua::color` palette (keys `"white"`, `"darkgrey"`…).

#### `alignH` · `alignV` :: `string` `[Read]`
Current alignment (default `"center"`).

---

## Presets

| Preset | Effect |
|---|---|
| `:label()` | `minimal_height = 25` |
| `:frame()` | paddings + `maximal_height = 338` + `maximal_width = 220` |
| `:scrollpane()` | `minimal_height = 220` + horizontal stretch |
| `:listbox()` | `min`/`max_height = 220` + horizontal stretch |
| `:smallButton()` | `height = 30`, `min_width = 90`, `max_width = 100` |
| `:normalButton()` | `min_height = 45`, `min_width = 200` |
| `:menuButton()` | `normalButton` + `min_width = 220` + dark-grey font |
| `:closeButton()` | `smallButton` + `width = 100` |
| `:spriteButton(size?)` | square dimensions (`number` or `{w,h}`, default 32) |

#### `:fontColor(color, hovered?, clicked?)` → [`RitnLibStyle`](RitnLibStyle.md)
Sets `font_color`. `color` = palette key (`"white"`, `"darkgrey"`…) or a `{r,g,b,a}` table. If `hovered`/`clicked` are `true`, also applies to those states.

#### `:straitFrame()` → [`RitnLibStyle`](RitnLibStyle.md)
> **Warning** — Known defect: calls `self:standardFrame()`, which doesn't exist → **raises if called** (probably meant `:frame()`). See [known bugs](../../debt/known-bugs.md).

---

## Atomic setters

#### `:visible(visible)` → [`RitnLibStyle`](RitnLibStyle.md)
Sets `style.visible`.
> **Warning** — Known defect: the `log` line concatenates `self.gui_name`, never defined on `RitnLibStyle` → **raises on first call**. See [known bugs](../../debt/known-bugs.md).

**Dimensions**

| Method | Effect |
|---|---|
| `:size(width, height)` | width + height |
| `:width(w)` · `:height(h)` | single dimension |
| `:minWidth(v)` · `:minHeight(v)` | `minimal_*` |
| `:maxWidth(v)` · `:maxHeight(v)` | `maximal_*` |

**Stretch & alignment**

| Method | Effect |
|---|---|
| `:stretchable()` | horizontal + vertical stretch |
| `:horizontalStretch(value?)` · `:verticalStretch(value?)` | stretch on one axis |
| `:align(valueH?, valueV?)` | `horizontal_align` / `vertical_align` (default `"center"`) |

**Spacing, margins & paddings** (all `number`)

| Family | Methods |
|---|---|
| Spacing | `:spacing(h, v)` · `:horizontalSpacing(v)` · `:verticalSpacing(v)` |
| Margins | `:margin(v)` · `:horizontalMargin(v)` · `:verticalMargin(v)` · `:topMargin(v)` · `:bottomMargin(v)` · `:leftMargin(v)` · `:rightMargin(v)` |
| Paddings | `:padding(v)` · `:horizontalPadding(v)` · `:verticalPadding(v)` · `:topPadding(v)` · `:bottomPadding(v)` · `:leftPadding(v)` · `:rightPadding(v)` · `:noPadding()` |

**Font**

#### `:font(font)` → [`RitnLibStyle`](RitnLibStyle.md)
Sets `style.font` (registered font name, e.g. `ritnlib.defines.names.font.bold18`).

---

## Usage example

**Style a GUI tree after creation** (`RitnLobbyGame/classes/RitnGuiLobby.lua`):

```lua
RitnLibStyle(content.frame.lobby):frame():maxHeight(450):maxWidth(260)
RitnLibStyle(content.flow.main):align():stretchable()
RitnLibStyle(content.button.create):menuButton():font(font.bold18)
RitnLibStyle(content.pane):scrollpane()
RitnLibStyle(content.list):listbox()
RitnLibStyle(content.flow.dialog):stretchable():topPadding(4):align("left")
RitnLibStyle(content.empty):size(30, 30)
```

---

## Remarks

- **Applies to an existing element** — pass an already-added `LuaGuiElement`; the wrapper mutates its `.style`.
- **Preset then tweak** — typically apply a preset (`:frame()`, `:menuButton()`…) then refine (`:maxWidth()`, `:font()`…).
- **`:straitFrame()` / `:visible()` broken** — see the warnings above.

## See also

- [Class map](../overview.md)
- [`RitnLibGuiElement`](RitnLibGuiElement.md) · [`RitnLibGui`](RitnLibGui.md)
- [Known bugs](../../debt/known-bugs.md)
