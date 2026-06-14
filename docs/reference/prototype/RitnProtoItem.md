---
title: RitnProtoItem
type: reference
lang: fr
---

# `RitnProtoItem`


Manipulateur **data stage** pour `data.raw[<item-type>][<nom>]`. Le constructeur **auto-détecte** le type d'item (via `getItemType()`) et deep-copie le prototype. **Aucune méthode propre** : on utilise les mutateurs génériques de [`RitnPrototype`](RitnPrototype.md).

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable au data stage, mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Item.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.item)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoItem"` |

---

## Constructeur

#### `RitnProtoItem(item_name)` → [`RitnProtoItem`](RitnProtoItem.md)

Résout le type via `:getItemType()` (itère `lualib.vanilla.types_item`) puis deep-copie `data.raw[type][item_name]` dans `prototype`. No-op si le type ou l'item est introuvable.

**Paramètres**
- `item_name` :: `string` — nom de l'item.

---

## Méthodes

Aucune méthode spécifique. Utilise les mutateurs hérités de [`RitnPrototype`](RitnPrototype.md) : `:changePrototype`, `:setPrototype`, `:changeSubPrototype`, `:changeSubgroup`, `:getProperties`, `:update`.

---

## Exemple d'usage

```lua
local RitnProtoItem = require(ritnlib.defines.class.prototype.item)
RitnProtoItem("wooden-chest"):changeSubgroup("belt")
RitnProtoItem("iron-plate"):changePrototype("stack_size", 200)
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoEntity`](RitnProtoEntity.md) · [Carte des classes](../overview.md) · [Migration 2.0](../../migration-2.0.md)
