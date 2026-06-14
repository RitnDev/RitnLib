---
title: RitnProtoCustomInput
type: reference
lang: en
---

# `RitnProtoCustomInput`

🇫🇷 [Version française](../../../fr/reference/prototype/RitnProtoCustomInput.md)

**Data-stage** manipulator for `data.raw["custom-input"][<name>]` (custom keyboard shortcuts). Inherits from [`RitnPrototype`](RitnPrototype.md).

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0. Usable but **not validated for 2.0** — see [Factorio 2.0 migration](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/CustomInput.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.customInput)` |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoCustomInput"` |

---

## Constructor

#### `RitnProtoCustomInput(input_name)` → [`RitnProtoCustomInput`](RitnProtoCustomInput.md)

Deep-copies `data.raw["custom-input"][input_name]` into `prototype` if it exists.

**Parameters**
- `input_name` :: `string` — custom-input name.

---

## Methods

#### `:extend(name, key_sequence, consuming?)` → [`RitnProtoCustomInput`](RitnProtoCustomInput.md)
Declares a **new** custom-input via `data:extend({...})`. Default `consuming = "game-only"`.

**Parameters**: `name` :: `string` · `key_sequence` :: `string` (e.g. `"CONTROL + ALT + M"`) · `consuming` :: `"none"|"game-only"|"script-only"?`.

#### `:linkedControl(linked_game_control)` → [`RitnProtoCustomInput`](RitnProtoCustomInput.md)
Sets `linked_game_control` on the current custom-input, linking it to a built-in Factorio control.

**Parameters**: `linked_game_control` :: `string` (e.g. `"build"`, `"mine"`).

> The generic mutators are inherited from [`RitnPrototype`](RitnPrototype.md).

---

## Usage example

**Declare a menu-toggle shortcut** (`RitnLobbyGame/prototypes/custom-inputs.lua`):

```lua
local RitnInputCustom = require(ritnlib.defines.class.prototype.customInput)
RitnInputCustom:extend(
    ritnlib.defines.lobby.names.customInput.toggle_main_menu,
    "CONTROL + ALT + M"
)
```

## See also

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Class map](../overview.md) · [2.0 migration](../../../migration-2.0.md)
