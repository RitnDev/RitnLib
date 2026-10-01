---
title: RitnProtoTile
type: reference
lang: fr
---

# `RitnProtoTile`


Manipulateur **data stage** pour `data.raw["tile"][<nom>]` (tuiles de sol : béton, landfill, revêtements…). Hérite de [`RitnPrototype`](RitnPrototype.md). Ajoutée en **0.10.5**.

| | |
|---|---|
| **Source** | `classes/prototypes/Tile.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.tile)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoTile"` |

```lua
-- mon-mod/data.lua
require("__RitnLib__.defines")
local RitnProtoTile = require(ritnlib.defines.class.prototype.tile)
```

---

## Constructeur

#### `RitnProtoTile(tile_name)` → [`RitnProtoTile`](RitnProtoTile.md)

Pose les bases via `RitnPrototype.init` puis **deep-copie** `data.raw["tile"][tile_name]` dans `prototype`. Si la tuile n'existe pas, `prototype` reste `nil` (les setters deviennent no-op).

**Paramètres**
- `tile_name` :: `string` — nom de la tuile dans `data.raw`.

---

## Attributs

#### `name` :: `string` `[Read]`
Nom de la tuile (hérité de [`RitnPrototype`](RitnPrototype.md)).

#### `type` :: `string` `[Read]`
Type résolu (`"tile"`).

#### `prototype` :: `table?` `[Read]`
Copie de travail de `data.raw["tile"][name]`. `nil` si la tuile n'existe pas.

#### `object_name` :: `"RitnProtoTile"` `[Read]`
Sentinelle de type.

---

## Méthodes

#### `:setBlueprintable(value?)` → [`RitnProtoTile`](RitnProtoTile.md)
Définit `prototype.can_be_part_of_blueprint`. `value` vaut `true` par défaut ; passer `false` pour exclure la tuile des plans (blueprints).

**Paramètres**
- `value` :: `boolean?` — `true` (défaut) ou `false`.

> Les mutateurs génériques (`:changePrototype`, `:setPrototype`, `:getProperties`…) sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

```lua
local RitnProtoTile = require(ritnlib.defines.class.prototype.tile)

RitnProtoTile("landfill"):setBlueprintable(false)          -- hors des plans
RitnProtoTile("refined-concrete"):changePrototype("walking_speed_modifier", 1.6)
```

---

## Remarques

- **Data stage uniquement** — à utiliser depuis `data.lua` / `data-updates.lua` / `data-final-fixes.lua`.
- **Copie + écriture** — chaque setter appelle `:update()` qui réécrit dans `data.raw`. Pas de `data:extend` manuel.

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Carte des classes](../overview.md)
