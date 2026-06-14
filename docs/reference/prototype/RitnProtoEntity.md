---
title: RitnProtoEntity
type: reference
lang: fr
---

# `RitnProtoEntity`


Manipulateur **data stage** pour `data.raw[<entity-type>][<nom>]`. Le constructeur **auto-détecte** le type d'entité (via `getEntityType()`) et deep-copie le prototype. Hérite de tous les mutateurs génériques de [`RitnPrototype`](RitnPrototype.md).

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable au data stage, mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Entity.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.entity)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoEntity"` |

---

## Constructeur

#### `RitnProtoEntity(entity_name)` → [`RitnProtoEntity`](RitnProtoEntity.md)

Résout le type via `:getEntityType()` (itère `lualib.vanilla.types_entity`) puis deep-copie `data.raw[type][entity_name]` dans `prototype`. No-op si le type ou l'entité est introuvable.

**Paramètres**
- `entity_name` :: `string` — nom de l'entité.

---

## Attributs

#### `prototype` :: `table?` `[Read]`
Copie de travail de `data.raw[type][name]`.

#### `lua_prototype` :: `table?` `[Read]`
Référence **directe** vers `data.raw[type][name]` (pas la copie).

#### `object_name` :: `"RitnProtoEntity"` `[Read]`
Sentinelle de type. (Voir aussi `name`/`type` hérités de [`RitnPrototype`](RitnPrototype.md).)

---

## Méthodes

#### `:addCraftingCategories(category)` → [`RitnProtoEntity`](RitnProtoEntity.md)
Ajoute `category` à `crafting_categories` de l'entité (normalise d'abord le champ en table si c'était une string unique).

**Paramètres** : `category` :: `string`.

> Les mutateurs génériques (`:changePrototype`, `:setPrototype`, `:changeSubgroup`, `:update`…) sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

```lua
local RitnProtoEntity = require(ritnlib.defines.class.prototype.entity)
RitnProtoEntity("assembling-machine-2"):addCraftingCategories("ritn-electronics")
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Carte des classes](../overview.md) · [Migration 2.0](../../migration-2.0.md)
