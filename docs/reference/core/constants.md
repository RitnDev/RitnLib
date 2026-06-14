---
title: core/constants.lua
type: reference
lang: fr
---

# `core/constants.lua`


Constantes partagées de RitnLib : tints colorimétriques (recoloration des packs de science), couleurs UI nommées, marqueurs de chaînes, noms de tailles d'ennemis, et la whitelist de types Lua de base.

| | |
|---|---|
| **Source** | `core/constants.lua` |
| **Type** | table de constantes (retournée) |
| **Accès** | `local constants = require(ritnlib.defines.constants)` |
| **`object_name` (type)** | `"RitnLibConstants"` |

---

## Champs

#### `listTint` :: `string[]` `[Read]`
Clés de tint ordonnées : `red`, `green`, `blue`, `yellow`, `purple`, `black` + les 6 alias science-pack.

#### `tint` :: `table<string, {primary, secondary, tertiary, quaternary}>` `[Read]`
Palettes de tint par clé (4 nuances de [`Color`](https://lua-api.factorio.com/latest/concepts/Color.html) chacune). Utilisé par [`RitnProtoRecipe:changeTint`](../prototype/RitnProtoRecipe.md).

#### `color` :: `table<string, Color>` `[Read]` · `colors` :: `table<string, Color>` `[Read]`
Couleurs UI nommées (`white`, `black`, `darkgrey`, `orange`, `deepskyblue`, `plum`…). `colors` est un **alias** : c'est la **même** table que `color`.

#### `strings` :: `table` `[Read]`
Marqueurs de chaînes (`empty`, `space`, `hyphen`, flèches, puces, décorateurs).

#### `enemy` :: `{ size: { small, medium, big, behemoth } }` `[Read]`
Noms de tailles d'ennemis.

#### `types` :: `table<string, string>` `[Read]`
Whitelist des types Lua de base (boolean, string, number, table, function, nil), utilisée par [`other-functions.isType`](../lualib/other-functions.md).

> **Note** — Les six clés de tint science-pack (`automation`, `logistic`, `chemical`, `utility`, `production`, `military`) **dupliquent** les six clés couleur (`red`…`black`) avec des valeurs identiques.

---

## Exemple d'usage

```lua
local constants = require(ritnlib.defines.constants)
local style = element.style
style.font_color = constants.color.darkgrey
```

## Voir aussi

- [Carte des classes](../overview.md) · [`RitnProtoRecipe`](../prototype/RitnProtoRecipe.md) · [`RitnLibStyle`](../runtime/RitnLibStyle.md)
