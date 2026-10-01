---
title: RitnProtoOre
type: reference
lang: fr
---

# `RitnProtoOre`


Manipulateur **data stage** pour `data.raw["resource"][<nom>]` (gisements de minerai). Hérite de [`RitnPrototype`](RitnPrototype.md). Fournit `:remove()` (purge complète d'un minerai) et le helper **statique** `.active(...)` pour enregistrer des minerais depuis `lualib/vanilla/ores.lua`.

> **Note — résidus 1.x** : le template interne `make_resource()` (utilisé quand `bStandard = true`) contient encore des clés legacy (`hr_version`, `icon_mipmaps`) ignorées silencieusement par Factorio. Voir [Résidus API 1.x](../../debt/api-1.x-leftover.md).

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
Purge complète : retire le prototype `resource`, l'`autoplace-control`, l'entrée dans `autoplace_controls` de chaque map-gen-preset **et** dans le `map_gen_settings` de chaque planète (`autoplace_controls` + `autoplace_settings.entity.settings`, Factorio 2.0+), puis fait de même pour le compagnon `"infinite-<name>"` s'il existe. Sans le nettoyage des planètes, le jeu plantait à l'initialisation de la planète (« `<ore>` is not a valid autoplace control name »).

#### `RitnProtoOre.active(resource, bStart, bStandard, planets?)`
Helper **statique** (point, pas `:`). Initialise le patch set et enregistre l'autoplace-control + la resource via `data:extend`, depuis `lualib/vanilla/ores.lua`. Enregistre aussi le minerai dans les `map_gen_settings` des planètes indiquées (nécessaire en Factorio 2.x pour qu'il spawne).

**Paramètres**
- `resource` :: `string` — clé du minerai dans `lualib/vanilla/ores.lua`.
- `bStart` :: `boolean` — semer le patch set près de la zone de départ.
- `bStandard` :: `boolean` — si `true`, construit la resource via le template interne ; sinon utilise `ores[resource].resource` tel quel.
- `planets` :: `string[]?` — liste des planètes (défaut `{"nauvis"}`). Le minerai n'est ajouté qu'aux `map_gen_settings` de ces planètes.

```lua
local RitnProtoOre = require(ritnlib.defines.class.prototype.ore)
RitnProtoOre.active("silica-sand", true, false)          -- nauvis uniquement
RitnProtoOre.active("silica-sand", true, false, {"nauvis", "vulcanus"})
```

> Les mutateurs génériques (`:changePrototype`…) sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

**Enregistrer un minerai vanilla-template** (`RitnGlass/data.lua`) :

```lua
RitnProtoOre.active("silica-sand", true, false)
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Carte des classes](../overview.md) · [Migration 2.0](../../migration-2.0.md)
