---
title: RitnProtoStyle
type: reference
lang: en
---

# `RitnProtoStyle`


**Data-stage** manipulator for `data.raw["gui-style"].default[<style>]`. A fluent builder to declare prototyped GUI styles (type/name/parent/padding/size), with an `:extendButton` shortcut. Inherits from [`RitnPrototype`](RitnPrototype.md) and overrides `:update()` for the `default[...]` indirection.

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Style.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.style)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoStyle"` |

---

## Constructor

#### `RitnProtoStyle(style_name?)` → [`RitnProtoStyle`](RitnProtoStyle.md)

Always targets `data.raw["gui-style"]["default"]`. If `style_name` is provided, deep-copies the existing style; otherwise copies the whole `default` table. Prepares a blank `style` payload for the `:set*` / `:extend*` methods.

**Parameters**
- `style_name` :: `string?` — style key under `data.raw["gui-style"].default`.

---

## Attributes

#### `style_name` :: `string?` `[Read]`
Targeted style key.

#### `style` :: `table` `[Read]`
Style payload being built (`{ type, name, parent, padding, size }`).

---

## Methods — builder

| Method | Effect |
|---|---|
| `:setType(type_gui)` | `style.type` (e.g. `"button_style"`, `"frame_style"`) |
| `:setName(name)` | `style.name` (key under `default`) |
| `:setParent(parent)` | `style.parent` (style to inherit from) |
| `:setPadding(padding)` | `style.padding` |

#### `:extend()`
Commits the current `style` payload into `prototype[style.name]`, then `:update()`. Raises if the root prototype's `type`/`name` are empty.

#### `:extendButton(name, parent, size?)`
Shortcut: builds a child `button_style` (`type = "button_style"`, `name`, `parent`, optional `size` `number`|`{w,h}`), then commits via `:extend()`.

**Parameters**: `name` :: `string` · `parent` :: `string` · `size` :: `number`|`number[]?`.

#### `:update()`
Override: writes to `data.raw["gui-style"].default[style_name]` if `style_name` is set, otherwise to `data.raw["gui-style"].default`.

---

## Usage example

**Declare button styles** (`RitnLobbyGame/prototypes/styles.lua`):

```lua
local RitnStyle = require(ritnlib.defines.class.prototype.style)
RitnStyle():extendButton(ritnlib.defines.lobby.names.styles.ritn_normal_sprite_button, "button")
RitnStyle():extendButton(ritnlib.defines.lobby.names.styles.ritn_red_sprite_button, "red_button")
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnLibStyle`](../runtime/RitnLibStyle.md) (runtime) · [Class map](../overview.md) · [2.0 migration](../../migration-2.0.md)
