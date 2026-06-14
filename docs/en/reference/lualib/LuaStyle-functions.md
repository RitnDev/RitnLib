---
title: lualib/LuaStyle-functions
type: reference
lang: en
---

# `lualib/LuaStyle-functions`

🇫🇷 [Version française](../../../fr/reference/lualib/LuaStyle-functions.md)

Legacy **runtime** style presets: each function mutates a `LuaStyle` passed as argument (`ritn_small_button(element.style)`).

> ⚠ **Deprecated — superseded by [`RitnLibStyle`](../runtime/RitnLibStyle.md).**
>
> The fluent class `RitnLibStyle(element):smallButton()` covers the same presets (and more) with clean chaining. This module is kept for backward compatibility; **scheduled for removal**.

| | |
|---|---|
| **Source** | `lualib/LuaStyle-functions.lua` |
| **Type** | function module (returned table) |
| **Access** | `require("__RitnLib__/lualib/LuaStyle-functions")` |
| **Status** | 🗑 deprecated → use [`RitnLibStyle`](../runtime/RitnLibStyle.md) |

---

## Functions (each takes a `LuaStyle`)

| Legacy function | `RitnLibStyle` equivalent |
|---|---|
| `ritn_small_button(style)` | `:smallButton()` |
| `ritn_normal_button(style)` | `:normalButton()` |
| `ritn_sprite_button(style)` | `:spriteButton()` |
| `ritn_button_close(style)` | `:closeButton()` |
| `ritn_frame_style(style)` | `:frame()` |
| `ritn_label(style)` | `:label()` |
| `ritn_scroll_pane(style)` | `:scrollpane()` |
| `ritn_remote_listbox(style)` | `:listbox()` |
| `ritn_frame_remote_style`, `ritn_flow_no_padding`, `ritn_flow_panel_main`, `ritn_flow_dialog`, `ritn_flow_surfaces` | recompose via `RitnLibStyle` setters (`:noPadding()`, `:align()`, `:stretchable()`…) |

---

## Migration

```lua
-- legacy (deprecated)
local LuaStyle = require("__RitnLib__/lualib/LuaStyle-functions")
LuaStyle.ritn_small_button(element.style)

-- recommended
RitnLibStyle(element):smallButton()
```

## See also

- [`RitnLibStyle`](../runtime/RitnLibStyle.md) (replacement) · [Class map](../overview.md) · [Deprecated APIs](../../debt/deprecated.md)
