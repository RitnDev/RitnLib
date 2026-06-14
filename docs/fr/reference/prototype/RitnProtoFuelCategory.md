---
title: RitnProtoFuelCategory
type: reference
lang: fr
---

# `RitnProtoFuelCategory`

🇬🇧 [English version](../../../en/reference/prototype/RitnProtoFuelCategory.md)

Manipulateur **data stage** pour `data.raw["fuel-category"][<nom>]`. Hérite de [`RitnPrototype`](RitnPrototype.md). Sert surtout à déclarer une nouvelle catégorie de carburant.

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/FuelCategory.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.fuelCategory)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoFuelCategory"` |

---

## Constructeur

#### `RitnProtoFuelCategory(category_name)` → [`RitnProtoFuelCategory`](RitnProtoFuelCategory.md)

Deep-copie `data.raw["fuel-category"][category_name]` dans `prototype` s'il existe.

**Paramètres**
- `category_name` :: `string` — nom de la catégorie.

---

## Méthodes

#### `:extend(name, order)` → [`RitnProtoFuelCategory`](RitnProtoFuelCategory.md)
Déclare une **nouvelle** fuel-category via `data:extend({...})`.

**Paramètres** : `name` :: `string` · `order` :: `string`.

> Les mutateurs génériques sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

```lua
local RitnProtoFuelCategory = require(ritnlib.defines.class.prototype.fuelCategory)
RitnProtoFuelCategory:extend("ritn-fuel", "a")
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Carte des classes](../overview.md) · [Migration 2.0](../../../migration-2.0.md)
