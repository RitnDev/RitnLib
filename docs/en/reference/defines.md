---
title: ritnlib.defines — registry
type: reference
lang: en
---

# `ritnlib.defines` — path registry

🇫🇷 [Version française](../../fr/reference/defines.md)

RitnLib's central registry. Requiring `__RitnLib__.defines` creates the **`ritnlib` global**: a table of `require` paths (classes, modules, prototypes) + name constants, and exposes `ritnlib.classFactory`. Idempotent: subsequent requires do nothing.

| | |
|---|---|
| **Source** | `defines.lua` |
| **Access** | `require("__RitnLib__.defines")` → creates the `ritnlib` global |
| **`object_name` (type)** | `RitnLibGlobal` (`defines` :: `RitnLibDefines`, `classFactory` :: `RitnClassFactory`) |

```lua
require("__RitnLib__.defines")
local Recipe = require(ritnlib.defines.class.prototype.recipe)
```

---

## `ritnlib.defines` — require paths

| Key | Points to |
|---|---|
| `gvv` | gvv debugger entry point (optional dependency) |
| `event` | **vanilla** `__core__/lualib/event_handler` (not the [`eventListener`](core/event-listener.md) fork) |
| `constants` | [`core/constants.lua`](core/constants.md) |
| `other` · `table` · `string` · `json` | [lualib](lualib/other-functions.md) modules |
| `vanilla.util` · `vanilla.crash_site` | [vanilla](vanilla/util.md) helpers |
| `fonts` · `gui_styles` | data-stage assets (`prototypes/fonts.lua`, `prototypes/gui-style.lua`) |
| `setup` | `core/setup-classes.lua` (internal use) |
| `names.font.*` | font names (`ritn-default-12..20`, `ritn-default-bold-12..20`) |

## `ritnlib.defines.class` — class paths

| Sub-key | Contents |
|---|---|
| `core` | the [class factory](core/class-factory.md) |
| `prototype.*` | `tech`/`technology`, `ore`, `entity`, `item`, `recipe`, `group`, `subgroup`, `category`, `fuelCategory`, `style`, `sprite`, `customInput`, `utility.constants` |
| `luaClass.*` | `event`, `player`, `entity`, `force`, `surface`, `recipe`, `tech`, `gui` |
| `ritnClass.*` | `prototype`, `ingredient`, `inventory`, `setting`, `informatron` (beta) |
| `gui.*` | `element`, `style` |

## `ritnlib.classFactory`

Shortcut to the [class factory](core/class-factory.md) (`require(ritnlib.defines.class.core)`), available directly on the global after requiring `defines`.

---

## Remarks

- **One require is enough** — `require("__RitnLib__.defines")` at the top of your file; then everything goes through `ritnlib.defines.*`.
- **`event` = vanilla** — the `event` key deliberately points to the engine's `event_handler`, not the RitnLib fork (separate opt-in).

## See also

- [Class map](overview.md) · [The 4-layer architecture](../concepts/architecture-layers.md) · [`core/class.lua`](core/class-factory.md)
