---
title: lualib/entity-functions
type: reference
lang: en
---

# `lualib/entity-functions`


**Data-stage** helpers for entity graphics: standard collision/selection boxes, status light/colours presets, and a sprite-layer builder.

| | |
|---|---|
| **Source** | `lualib/entity-functions.lua` |
| **Type** | function module (returned table) |
| **Access** | `require("__RitnLib__/lualib/entity-functions")` |

---

## Functions

#### `standard_3x3_collision()` → `number[][]`
Returns a standard 3×3 collision box.

#### `standard_3x3_selection()` → `number[][]`
Returns a standard 3×3 selection box.

#### `standard_status_light()` → `table`
Entity status-light preset.

#### `standard_status_colours()` → `table`
Entity status-colours preset.

#### `get_layer(data)` → `table`
Sprite-layer builder from a `data` table.

**Parameters**: `data` :: `table`.

## See also

- [Class map](../overview.md) · [`gui-functions`](gui-functions.md)
