---
title: lualib/LuaStyle-functions
type: reference
lang: fr
---

# `lualib/LuaStyle-functions`


Presets de style **runtime** legacy : chaque fonction mute un `LuaStyle` passé en argument (`ritn_small_button(element.style)`).

> ⚠ **Déprécié — remplacé par [`RitnLibStyle`](../runtime/RitnLibStyle.md).**
>
> La classe fluent `RitnLibStyle(element):smallButton()` couvre les mêmes presets (et davantage) avec un chaînage propre. Ce module est conservé pour compatibilité ascendante ; **suppression planifiée**.

| | |
|---|---|
| **Source** | `lualib/LuaStyle-functions.lua` |
| **Type** | module de fonctions (table retournée) |
| **Accès** | `require("__RitnLib__/lualib/LuaStyle-functions")` |
| **Statut** | 🗑 déprécié → utiliser [`RitnLibStyle`](../runtime/RitnLibStyle.md) |

---

## Fonctions (chacune prend un `LuaStyle`)

| Fonction legacy | Équivalent `RitnLibStyle` |
|---|---|
| `ritn_small_button(style)` | `:smallButton()` |
| `ritn_normal_button(style)` | `:normalButton()` |
| `ritn_sprite_button(style)` | `:spriteButton()` |
| `ritn_button_close(style)` | `:closeButton()` |
| `ritn_frame_style(style)` | `:frame()` |
| `ritn_label(style)` | `:label()` |
| `ritn_scroll_pane(style)` | `:scrollpane()` |
| `ritn_remote_listbox(style)` | `:listbox()` |
| `ritn_frame_remote_style`, `ritn_flow_no_padding`, `ritn_flow_panel_main`, `ritn_flow_dialog`, `ritn_flow_surfaces` | à recomposer via les setters de `RitnLibStyle` (`:noPadding()`, `:align()`, `:stretchable()`…) |

---

## Migration

```lua
-- legacy (déprécié)
local LuaStyle = require("__RitnLib__/lualib/LuaStyle-functions")
LuaStyle.ritn_small_button(element.style)

-- recommandé
RitnLibStyle(element):smallButton()
```

## Voir aussi

- [`RitnLibStyle`](../runtime/RitnLibStyle.md) (remplacement) · [Carte des classes](../overview.md) · [APIs dépréciées](../../debt/deprecated.md)
