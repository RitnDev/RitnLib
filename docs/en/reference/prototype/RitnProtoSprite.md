---
title: RitnProtoSprite
type: reference
lang: en
---

# `RitnProtoSprite`

🇫🇷 [Version française](../../../fr/reference/prototype/RitnProtoSprite.md)

**Data-stage** manipulator for `data.raw["sprite"][<name>]`. Inherits from [`RitnPrototype`](RitnPrototype.md). Provides shortcuts to inject a sprite into the `utility-sprites` and to declare new sprites.

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Sprite.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.sprite)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoSprite"` |

---

## Constructor

#### `RitnProtoSprite(sprite_name)` → [`RitnProtoSprite`](RitnProtoSprite.md)

Deep-copies `data.raw["sprite"][sprite_name]` into `prototype` if it exists.

**Parameters**
- `sprite_name` :: `string` — sprite name.

---

## Methods

#### `:createUtility(priority?, flags?)` → [`RitnProtoSprite`](RitnProtoSprite.md)
Copies the sprite into `data.raw["utility-sprites"].default[<name>]` so it becomes available as a utility-sprite. Defaults: `priority = "medium"`, `flags = {"icon"}`.

**Parameters**: `priority` :: `string?` · `flags` :: `string[]?`.

#### `:extend(name, file_name, size?)`
Declares a **new** sprite via `data:extend({...})`. `size` accepts a `number` (square) or a `{w, h}` table (default 32×32).

**Parameters**: `name` :: `string` · `file_name` :: `string` (path) · `size` :: `number`|`number[]?`.

```lua
local RitnSprite = require(ritnlib.defines.class.prototype.sprite)
RitnSprite():extend("ritn-logo", "__MyMod__/graphics/logo.png", 64)
```

> The generic mutators are inherited from [`RitnPrototype`](RitnPrototype.md).

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoStyle`](RitnProtoStyle.md) · [Class map](../overview.md) · [2.0 migration](../../../migration-2.0.md)
