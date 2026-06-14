---
title: ritnlib.defines — registre
type: reference
lang: fr
---

# `ritnlib.defines` — registre de chemins

🇬🇧 [English version](../../en/reference/defines.md)

Le registre central de RitnLib. Le require de `__RitnLib__.defines` crée le **global `ritnlib`** : une table de chemins de `require` (classes, modules, prototypes) + les constantes de noms, et expose `ritnlib.classFactory`. Idempotent : les requires suivants ne refont rien.

| | |
|---|---|
| **Source** | `defines.lua` |
| **Accès** | `require("__RitnLib__.defines")` → crée le global `ritnlib` |
| **`object_name` (type)** | `RitnLibGlobal` (`defines` :: `RitnLibDefines`, `classFactory` :: `RitnClassFactory`) |

```lua
require("__RitnLib__.defines")
local Recipe = require(ritnlib.defines.class.prototype.recipe)
```

---

## `ritnlib.defines` — chemins de require

| Clé | Pointe vers |
|---|---|
| `gvv` | point d'entrée du debugger gvv (dépendance optionnelle) |
| `event` | `__core__/lualib/event_handler` **vanilla** (pas le fork [`eventListener`](core/event-listener.md)) |
| `constants` | [`core/constants.lua`](core/constants.md) |
| `other` · `table` · `string` · `json` | modules [lualib](lualib/other-functions.md) |
| `vanilla.util` · `vanilla.crash_site` | helpers [vanilla](vanilla/util.md) |
| `fonts` · `gui_styles` | assets data stage (`prototypes/fonts.lua`, `prototypes/gui-style.lua`) |
| `setup` | `core/setup-classes.lua` (usage interne) |
| `names.font.*` | noms de polices (`ritn-default-12..20`, `ritn-default-bold-12..20`) |

## `ritnlib.defines.class` — chemins des classes

| Sous-clé | Contenu |
|---|---|
| `core` | la [factory de classes](core/class-factory.md) |
| `prototype.*` | `tech`/`technology`, `ore`, `entity`, `item`, `recipe`, `group`, `subgroup`, `category`, `fuelCategory`, `style`, `sprite`, `customInput`, `utility.constants` |
| `luaClass.*` | `event`, `player`, `entity`, `force`, `surface`, `recipe`, `tech`, `gui` |
| `ritnClass.*` | `prototype`, `ingredient`, `inventory`, `setting`, `informatron` (beta) |
| `gui.*` | `element`, `style` |

## `ritnlib.classFactory`

Raccourci vers la [factory de classes](core/class-factory.md) (`require(ritnlib.defines.class.core)`), disponible directement sur le global après le require de `defines`.

---

## Remarques

- **Un seul require suffit** — `require("__RitnLib__.defines")` en tête de ton fichier ; ensuite tout passe par `ritnlib.defines.*`.
- **`event` = vanilla** — la clé `event` pointe volontairement vers l'`event_handler` du moteur, pas vers le fork RitnLib (opt-in séparé).

## Voir aussi

- [Carte des classes](overview.md) · [Architecture en 4 couches](../concepts/architecture-couches.md) · [`core/class.lua`](core/class-factory.md)
