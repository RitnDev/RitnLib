---
title: RitnProtoUtilityConst
type: reference
lang: fr
---

# `RitnProtoUtilityConst`


Manipulateur **data stage** pour `data.raw["utility-constants"].default[<clé>]`. Particularité : ces constantes sont imbriquées sous `.default` (contrairement aux autres prototypes en `data.raw[type][name]`), donc la classe override `:update()`. Hérite de [`RitnPrototype`](RitnPrototype.md).

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/UtilityConstants.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.utility.constants)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoUtilityConst"` |

---

## Constructeur

#### `RitnProtoUtilityConst(constant_name)` → [`RitnProtoUtilityConst`](RitnProtoUtilityConst.md)

Deep-copie `data.raw["utility-constants"].default[constant_name]` dans `prototype` s'il existe.

**Paramètres**
- `constant_name` :: `string` — clé de la constante sous `default`.

---

## Méthodes

#### `:setValue(value)` → [`RitnProtoUtilityConst`](RitnProtoUtilityConst.md)
Remplace **intégralement** la valeur de la constante par `value` (écrase `prototype`), puis `:update()`.

**Paramètres** : `value` :: `any`.

#### `:update()`
Override : réécrit dans `data.raw["utility-constants"].default[<name>]` (indirection `.default[]` vs la base `RitnPrototype:update`).

> Les autres mutateurs génériques sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

```lua
local RitnProtoUtilityConst = require(ritnlib.defines.class.prototype.utility.constants)
RitnProtoUtilityConst("chart"):setValue(myChartConstants)
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Carte des classes](../overview.md) · [Migration 2.0](../../migration-2.0.md)
