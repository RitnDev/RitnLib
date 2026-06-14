---
title: RitnProtoOre
type: reference
lang: fr
---

# `RitnProtoOre`

🇬🇧 [English version](../../../en/reference/prototype/RitnProtoOre.md)

Manipulateur **data stage** pour `data.raw["resource"][<nom>]` (gisements de minerai). Hérite de [`RitnPrototype`](RitnPrototype.md). Fournit `:remove()` (purge complète d'un minerai) et le helper **statique** `.active(...)` pour enregistrer des minerais depuis `lualib/vanilla/ores.lua`.

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0 (le template `resource()` utilise notamment `hr_version`). Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Ore.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.ore)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoOre"` |

---

## Constructeur

#### `RitnProtoOre(resource)` → [`RitnProtoOre`](RitnProtoOre.md)

Deep-copie `data.raw["resource"][resource]` dans `prototype`. No-op si la resource est introuvable.

**Paramètres**
- `resource` :: `string` — nom de la resource (`"iron-ore"`, `"copper-ore"`…).

---

## Méthodes

#### `:remove()` → [`RitnProtoOre`](RitnProtoOre.md)
Purge complète : retire le prototype `resource`, l'`autoplace-control`, l'entrée dans `autoplace_controls` de chaque map-gen-preset, et le compagnon `"infinite-<name>"` s'il existe.

#### `RitnProtoOre.active(resource, bStart, bStandard)`
Helper **statique** (point, pas `:`). Initialise le patch set et enregistre l'autoplace-control + la resource via `data:extend`, depuis `lualib/vanilla/ores.lua`.

**Paramètres**
- `resource` :: `string` — clé du minerai dans `lualib/vanilla/ores.lua`.
- `bStart` :: `boolean` — semer le patch set près de la zone de départ.
- `bStandard` :: `boolean` — si `true`, construit la resource via le template interne ; sinon utilise `ores[resource].resource` tel quel.

```lua
local RitnProtoOre = require(ritnlib.defines.class.prototype.ore)
RitnProtoOre.active("silica-sand", true, false)
```

> Les mutateurs génériques (`:changePrototype`…) sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

**Enregistrer un minerai vanilla-template** (`RitnGlass/data.lua`) :

```lua
RitnProtoOre.active("silica-sand", true, false)
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Carte des classes](../overview.md) · [Migration 2.0](../../../migration-2.0.md)
