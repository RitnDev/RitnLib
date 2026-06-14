---
title: core/constants.lua
type: reference
lang: en
---

# `core/constants.lua`

🇫🇷 [Version française](../../../fr/reference/core/constants.md)

RitnLib's shared constants: colour tints (science-pack recolouring), named UI colours, string markers, enemy size names, and the basic-Lua-types whitelist.

| | |
|---|---|
| **Source** | `core/constants.lua` |
| **Type** | constants table (returned) |
| **Access** | `local constants = require(ritnlib.defines.constants)` |
| **`object_name` (type)** | `"RitnLibConstants"` |

---

## Fields

#### `listTint` :: `string[]` `[Read]`
Ordered tint keys: `red`, `green`, `blue`, `yellow`, `purple`, `black` + the 6 science-pack aliases.

#### `tint` :: `table<string, {primary, secondary, tertiary, quaternary}>` `[Read]`
Tint palettes by key (4 [`Color`](https://lua-api.factorio.com/latest/concepts/Color.html) shades each). Used by [`RitnProtoRecipe:changeTint`](../prototype/RitnProtoRecipe.md).

#### `color` :: `table<string, Color>` `[Read]` · `colors` :: `table<string, Color>` `[Read]`
Named UI colours (`white`, `black`, `darkgrey`, `orange`, `deepskyblue`, `plum`…). `colors` is an **alias**: the **same** table as `color`.

#### `strings` :: `table` `[Read]`
String markers (`empty`, `space`, `hyphen`, arrows, bullets, decorators).

#### `enemy` :: `{ size: { small, medium, big, behemoth } }` `[Read]`
Enemy size names.

#### `types` :: `table<string, string>` `[Read]`
Whitelist of basic Lua types (boolean, string, number, table, function, nil), used by [`other-functions.isType`](../lualib/other-functions.md).

> **Note** — The six science-pack tint keys (`automation`, `logistic`, `chemical`, `utility`, `production`, `military`) **duplicate** the six colour keys (`red`…`black`) with identical values.

---

## Usage example

```lua
local constants = require(ritnlib.defines.constants)
local style = element.style
style.font_color = constants.color.darkgrey
```

## See also

- [Class map](../overview.md) · [`RitnProtoRecipe`](../prototype/RitnProtoRecipe.md) · [`RitnLibStyle`](../runtime/RitnLibStyle.md)
