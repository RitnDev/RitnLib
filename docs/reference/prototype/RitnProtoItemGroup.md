---
title: RitnProtoItemGroup
type: reference
lang: fr
---

# `RitnProtoItemGroup`


Manipulateur **data stage** pour `data.raw["item-group"][<nom>]` (onglets de crafting). Hérite de [`RitnPrototype`](RitnPrototype.md). Permet de déclarer un nouveau groupe et d'ajuster son icône.

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/ItemGroup.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.group)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoItemGroup"` |

---

## Constructeur

#### `RitnProtoItemGroup(group_name)` → [`RitnProtoItemGroup`](RitnProtoItemGroup.md)

Deep-copie `data.raw["item-group"][group_name]` dans `prototype` s'il existe.

**Paramètres**
- `group_name` :: `string` — nom du groupe.

---

## Méthodes

#### `:extend(name, order, icon, icon_size)` → [`RitnProtoItemGroup`](RitnProtoItemGroup.md)
Déclare un **nouveau** item-group via `data:extend({...})`. Pas besoin d'instance existante.

**Paramètres** : `name` :: `string` · `order` :: `string` · `icon` :: `string` (chemin) · `icon_size` :: `integer`.

#### `:setIcon(pathIcon, size)` → [`RitnProtoItemGroup`](RitnProtoItemGroup.md)
Définit `icon` et `icon_size` du groupe existant en un appel.

**Paramètres** : `pathIcon` :: `string` · `size` :: `integer`.

> Les mutateurs génériques (`:changePrototype`…) sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

**Réordonner, re-iconner, déclarer** (`RitnElectronic/prototypes/category.lua`) :

```lua
local RitnProtoGroup = require(ritnlib.defines.class.prototype.group)
RitnProtoGroup("combat"):changePrototype("order", "w-c")
RitnProtoGroup("production"):setIcon("__RitnElectronic__/graphics/item-group/production.png", 385)
RitnProtoGroup:extend("ritn-electronic", "c-a", "__RitnElectronic__/graphics/item-group/electronic.png", 385)
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoItemSubgroup`](RitnProtoItemSubgroup.md) · [Carte des classes](../overview.md) · [Migration 2.0](../../migration-2.0.md)
