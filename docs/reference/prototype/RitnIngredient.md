---
title: RitnIngredient
type: reference
lang: fr
---

# `RitnIngredient`


Normalise un ingrédient de recette (item ou fluide) en une forme uniforme `{name, type, amount, amount_min, amount_max, probability}`, et fournit des opérations de liste (`:add`, `:addNew`, `:set`, `:remove`, `:combine`). C'est le moteur utilisé en interne par [`RitnProtoRecipe`](RitnProtoRecipe.md) pour ses méthodes d'ingrédients, utilisable aussi directement.

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnIngredient.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.ritnClass.ingredient)` |
| **Hérite de** | — (classe de base) |
| **`object_name`** | `"RitnIngredient"` |

---

## Constructeur

#### `RitnIngredient(ingredient)` → [`RitnIngredient`](RitnIngredient.md)

Normalise l'entrée. Le `type` est auto-détecté (`"fluid"` si `data.raw.fluid[name]` existe, sinon `"item"`). Pour les items, un `amount` dans `(0, 1)` est ramené à 1, sinon flooré.

**Paramètres**
- `ingredient` :: `table`|`string` — accepte trois formes :
  - array : `{ "iron-plate", 2 }` (legacy 1.x)
  - table : `{ name = "iron-plate", amount = 2, type = "item" }` (canonique 2.0)
  - string : `"iron-plate"` (sucre pour `{ name = "iron-plate" }`)

---

## Attributs

#### `name` :: `string` `[Read]`
Nom résolu de l'ingrédient.

#### `type` :: `"item"`|`"fluid"`|`nil` `[Read]`
Type résolu (auto-détecté si absent).

#### `amount` · `amount_min` · `amount_max` · `probability` :: `number?` `[Read]`
Quantité (floorée pour les items), bornes de plage, et facteur de probabilité.

#### `item` :: `table` `[Read]`
Payload normalisé `{name, type, amount, amount_min, amount_max, probability}` — c'est lui qui est inséré dans les listes.

#### `object_name` :: `"RitnIngredient"` `[Read]`
Sentinelle de type.

---

## Méthodes

> Les opérations de liste prennent `listIngredients :: table[]` (la liste d'ingrédients d'une recette) et la modifient **sur place**.

#### `:add(listIngredients)`
Insère `self` ; **combine** (somme des quantités, moyenne des probabilités) si un ingrédient du même nom existe déjà.

#### `:addNew(listIngredients)`
Insère `self` **seulement si** aucun ingrédient du même nom n'existe déjà.

#### `:set(listIngredients)`
Remplace sur place chaque entrée du même nom par `self.item` (écrase, sans combine).

#### `:remove(listIngredients)`
Supprime chaque entrée du même nom (via `[1]` ou `.name`).

#### `:combine(ingredient)` → `table`
Combine `self` avec `ingredient` (même nom) : somme les quantités, moyenne les probabilités. Met à jour `self.item` et renvoie le payload combiné.

**Paramètres** : `ingredient` :: `table`.

---

## Exemple d'usage

**Directement sur une liste d'ingrédients** :

```lua
local RitnIngredient = require(ritnlib.defines.class.ritnClass.ingredient)

RitnIngredient({ "iron-plate", 2 }):add(recipe.ingredients)   -- ajoute ou combine
RitnIngredient("copper-plate"):remove(recipe.ingredients)     -- retire par nom
```

En pratique, on passe le plus souvent par [`RitnProtoRecipe`](RitnProtoRecipe.md) (`:addIngredient`, `:setIngredient`…) qui délègue à `RitnIngredient`.

---

## Remarques

- **Data stage** — opère sur des tables d'ingrédients de `data.raw`.
- ⚠ **Bug connu (`getItem`)** — sur la branche probability, le helper interne lit `ingredient.inputs.probability` (sous-table inexistante) → « attempt to index a nil value » si un ingrédient porte une `probability`. Latent (peu d'ingrédients en ont). Voir [bugs connus](../../debt/known-bugs.md).
- **Formes d'entrée** — array (1.x) et table (2.0) sont toutes deux acceptées.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnProtoRecipe`](RitnProtoRecipe.md) · [`RitnPrototype`](RitnPrototype.md)
- [Bugs connus](../../debt/known-bugs.md)
