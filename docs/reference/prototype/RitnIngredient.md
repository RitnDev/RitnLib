---
title: RitnIngredient
type: reference
lang: fr
---

# `RitnIngredient`


Normalise une entrée de recette (ingrédient ou produit, item ou fluide) en une forme uniforme `{name, type, amount, amount_min, amount_max, independent_probability}`, et fournit des opérations de liste (`:add`, `:addNew`, `:set`, `:remove`, `:combine`). C'est le moteur utilisé en interne par [`RitnProtoRecipe`](RitnProtoRecipe.md) pour ses méthodes d'ingrédients et de résultats, utilisable aussi directement.

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
Nom résolu de l'entrée.

#### `type` :: `"item"`|`"fluid"`|`nil` `[Read]`
Type résolu (auto-détecté si absent).

#### `amount` · `amount_min` · `amount_max` :: `number?` `[Read]`
Quantité (floorée pour les items) et bornes de plage.

#### `independent_probability` :: `number?` `[Read]`
Facteur de probabilité (Factorio 2.1+, renommé depuis `probability`). Lu depuis `independent_probability`, ou depuis l'ancienne clé `probability` si seule celle-ci est présente.

#### `item` :: `table` `[Read]`
Payload normalisé `{name, type, amount, amount_min, amount_max, independent_probability}` **plus tous les autres champs de l'entrée d'origine** (`temperature`, `ignored_by_productivity`, `extra_count_fraction`, `percent_spoiled`…). C'est lui qui est inséré dans les listes. La forme array (`[1]`, `[2]`) et la clé `probability` n'y sont jamais recopiées.

#### `object_name` :: `"RitnIngredient"` `[Read]`
Sentinelle de type.

---

## Méthodes

> Les opérations de liste prennent `listIngredients :: table[]` (la liste `ingredients` ou `results` d'une recette) et la modifient **sur place**.

#### `:add(listIngredients)`
Insère `self` ; **combine** (somme des quantités, moyenne des `independent_probability`) si une entrée du même nom existe déjà.

#### `:addNew(listIngredients)`
Insère `self` **seulement si** aucune entrée du même nom n'existe déjà.

#### `:set(listIngredients)`
Remplace sur place chaque entrée du même nom par `self.item` (écrase, sans combine).

#### `:remove(listIngredients)`
Supprime chaque entrée du même nom (via `[1]` ou `.name`).

#### `:combine(ingredient)` → `table`
Combine `self` avec `ingredient` (même nom) : somme les quantités, moyenne les `independent_probability`. Les champs annexes (`temperature`…) viennent de `ingredient`, c'est-à-dire de l'entrée déjà présente dans la recette. Met à jour `self.item` et renvoie le payload combiné.

**Paramètres** : `ingredient` :: `table`.

---

## Exemple d'usage

**Directement sur une liste d'ingrédients** :

```lua
local RitnIngredient = require(ritnlib.defines.class.ritnClass.ingredient)

RitnIngredient({ "iron-plate", 2 }):add(recipe.ingredients)   -- ajoute ou combine
RitnIngredient("copper-plate"):remove(recipe.ingredients)     -- retire par nom
```

**Un produit avec probabilité et température** :

```lua
RitnIngredient({ type = "fluid", name = "steam", amount = 10, temperature = 165,
                 independent_probability = 0.5 }):add(recipe.results)
```

En pratique, on passe le plus souvent par [`RitnProtoRecipe`](RitnProtoRecipe.md) (`:addIngredient`, `:addResult`…) qui délègue à `RitnIngredient`.

---

## Remarques

- **Data stage** — opère sur des tables d'ingrédients / produits de `data.raw`.
- **`probability` → `independent_probability`** — Factorio 2.1 a retiré `probability` des produits ; la clé legacy est encore acceptée en entrée mais seule `independent_probability` est écrite. Voir [Migration Factorio 2.1](../../migration-2.1.md).
- **Formes d'entrée** — array (1.x) et table (2.0) sont toutes deux acceptées. Une entrée item définie uniquement par `amount_min` / `amount_max` est gérée.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnProtoRecipe`](RitnProtoRecipe.md) · [`RitnPrototype`](RitnPrototype.md)
- [Migration Factorio 2.1](../../migration-2.1.md)
