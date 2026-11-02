---
title: lualib/entity-info
type: reference
lang: fr
---

# `lualib/entity-info`


Lecture de **ce qu'une entité sait faire**, sans liste de types : inventaires rangés par rôle, état du jeu (texte et
couleur), progression, santé, fluides, recettes acceptées. Une entité d'un autre mod fonctionne donc sans code dédié.

| | |
|---|---|
| **Source** | `lualib/entity-info.lua` |
| **Type** | module de fonctions (table retournée), étape control |
| **Accès** | `local entityInfo = require(ritnlib.defines.entity_info)` |

---

## Constantes

#### `ROLES` :: `string[]` `[Read]`
Rôles des inventaires, dans l'ordre d'affichage : `fuel`, `burnt`, `input`, `output`, `modules`, `ammo`, `main`, `trash`.

#### `COLORS` :: `table<string, Color>` `[Read]`
Couleur de chaque niveau d'état : `ok`, `warning`, `alert`.

---

## Fonctions

#### `role(name)` → `string`
Rôle d'un inventaire d'après son nom dans `defines.inventory` (ex. `crafter_input` → `input`) ; `main` si rien ne
correspond.

#### `inventories(entity)` → `RitnLibEntityInventory[]`
Inventaires de l'entité qui ont au moins une case, rangés par rôle puis par numéro : `{ id, name, role, inventory }`.

#### `status(entity)` → `RitnLibEntityStatus?`
État du jeu, ou `nil` si l'entité n'en a pas : `{ name, caption, level, color }`. `caption` est le texte du jeu
(`entity-status.*`).

#### `progress(entity)` → `number?`
Progression dans `[0, 1]` d'une machine de fabrication ou d'une foreuse, sinon `nil`.

#### `health(entity)` → `number?`
Santé dans `[0, 1]`, ou `nil` pour une entité sans santé.

#### `fluids(entity)` → `RitnLibEntityFluid[]`
Stockages de fluide qui ont une capacité : `{ index, name?, amount, capacity }`. Une machine de fabrication n'en a que
pour sa recette.

#### `hasRecipeChoice(entity)` → `boolean`
Vrai pour une machine d'assemblage sans recette fixe. Le jeu choisit la recette d'un four.

#### `acceptsRecipe(entity, recipe)` → `boolean`
Vrai si le prototype de l'entité a une catégorie de fabrication en commun avec la recette (`LuaRecipePrototype`).

#### `recipes(entity, force)` → `LuaRecipePrototype[]`
Recettes déjà débloquées par la force, acceptées par l'entité, non cachées.
