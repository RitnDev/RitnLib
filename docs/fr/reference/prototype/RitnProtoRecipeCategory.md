---
title: RitnProtoRecipeCategory
type: reference
lang: fr
---

# `RitnProtoRecipeCategory`

🇬🇧 [English version](../../../en/reference/prototype/RitnProtoRecipeCategory.md)

Manipulateur **data stage** pour `data.raw["recipe-category"][<nom>]`. Sert surtout à déclarer une nouvelle catégorie de recettes.

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../../migration-2.0.md).

> ⚠ **Sans héritage** — contrairement aux autres `RitnProto*`, cette classe est déclarée **sans** passer `RitnPrototype` comme parent. Les mutateurs génériques (`:changePrototype`, `:setPrototype`, `:update`…) **ne sont donc pas disponibles** sur les instances ; seules les méthodes définies ici le sont.

| | |
|---|---|
| **Source** | `classes/prototypes/RecipeCategory.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.category)` |
| **Hérite de** | — (aucun ; voir l'avertissement) |
| **`object_name`** | `"RitnProtoRecipeCategory"` |

---

## Constructeur

#### `RitnProtoRecipeCategory(category_name)` → [`RitnProtoRecipeCategory`](RitnProtoRecipeCategory.md)

Appelle `RitnProtoBase.init` pour remplir les bases (`object_name`, `name`, `type`, `prototype`) et deep-copie `data.raw["recipe-category"][category_name]` s'il existe.

**Paramètres**
- `category_name` :: `string` — nom de la catégorie.

---

## Attributs

#### `name` :: `string` `[Read]`
Nom de la catégorie.

#### `type` :: `"recipe-category"` `[Read]`
Type du prototype.

#### `prototype` :: `table?` `[Read]`
Copie de `data.raw["recipe-category"][name]` (ou `nil`).

---

## Méthodes

#### `:extend(name, order)` → [`RitnProtoRecipeCategory`](RitnProtoRecipeCategory.md)
Déclare une **nouvelle** recipe-category via `data:extend({...})`.

**Paramètres** : `name` :: `string` · `order` :: `string`.

---

## Exemple d'usage

**Déclarer une catégorie** (`RitnElectronic/prototypes/category.lua`) :

```lua
local RitnProtoCategory = require(ritnlib.defines.class.prototype.category)
RitnProtoCategory:extend("ritn-electronics")
```

## Voir aussi

- [Carte des classes](../overview.md) · [`RitnProtoRecipe`](RitnProtoRecipe.md) · [Migration 2.0](../../../migration-2.0.md)
