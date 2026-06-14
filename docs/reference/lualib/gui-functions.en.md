---
title: lualib/gui-functions
type: reference
lang: en
---

# `lualib/gui-functions`


**Data-stage** helpers to derive GUI styles from `data.raw['gui-style'].default`. Used by `prototypes/gui-style.lua` to build the `*-ritngui` style set.

| | |
|---|---|
| **Source** | `lualib/gui-functions.lua` |
| **Type** | function module (returned table) |
| **Access** | `require("__RitnLib__/lualib/gui-functions")` |

---

## Constant

#### `SUFFIX` :: `"-ritngui"` `[Read]`
Naming suffix for RitnLib-derived styles (namespace).

---

## Functions

#### `copyDefaultGui(dupl, source)` → `table`
Deep-copies the `source` style table into `data.raw['gui-style'].default[dupl]` and returns the new entry.

**Parameters**: `dupl` :: `string` (new key) · `source` :: `table` (existing style to copy).

> **Warning** — No collision check: if `dupl` already exists, it is **silently overwritten**. Namespace your keys (e.g. with `SUFFIX`).

#### `convertEmpty(dupl)` → `table`
Replaces (or creates) `data.raw['gui-style'].default[dupl]` with a bare `empty_widget_style` (no graphics) — to visually neutralize a style slot.

**Parameters**: `dupl` :: `string`.

## See also

- [Class map](../overview.md) · [`entity-functions`](entity-functions.md) · [`RitnProtoStyle`](../prototype/RitnProtoStyle.md)
