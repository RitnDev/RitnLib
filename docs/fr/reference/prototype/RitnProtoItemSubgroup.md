---
title: RitnProtoItemSubgroup
type: reference
lang: fr
---

# `RitnProtoItemSubgroup`

🇬🇧 [English version](../../../en/reference/prototype/RitnProtoItemSubgroup.md)

Manipulateur **data stage** pour `data.raw["item-subgroup"][<nom>]` (lignes de crafting). Hérite de [`RitnPrototype`](RitnPrototype.md). Permet de déclarer un nouveau sous-groupe et de le réassigner.

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/ItemSubgroup.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.subgroup)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoItemSubgroup"` |

---

## Constructeur

#### `RitnProtoItemSubgroup(subgroup_name)` → [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md)

Deep-copie `data.raw["item-subgroup"][subgroup_name]` dans `prototype` s'il existe.

**Paramètres**
- `subgroup_name` :: `string` — nom du sous-groupe.

---

## Méthodes

#### `:extend(name, group, order)` → [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md)
Déclare un **nouveau** item-subgroup via `data:extend({...})`.

**Paramètres** : `name` :: `string` · `group` :: `string` (item-group parent) · `order` :: `string`.

#### `:changeGroup(group, order?)` → [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md)
Réassigne le sous-groupe à un autre `group` parent (et `order` optionnel).

#### `:changeOrder(order)` → [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md)
Met à jour le champ `order`.

> Les mutateurs génériques sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

**Déclarer des sous-groupes** (`RitnElectronic/prototypes/category.lua`) :

```lua
local RitnProtoSubgroup = require(ritnlib.defines.class.prototype.subgroup)
RitnProtoSubgroup:extend("electronic-product", "ritn-electronic", "c")
RitnProtoSubgroup:extend("ritn-module", "ritn-electronic", "h")
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoItemGroup`](RitnProtoItemGroup.md) · [Carte des classes](../overview.md) · [Migration 2.0](../../../migration-2.0.md)
