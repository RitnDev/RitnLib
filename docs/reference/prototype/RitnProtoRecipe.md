---
title: RitnProtoRecipe
type: reference
lang: fr
---

# `RitnProtoRecipe`


Manipulateur **data stage** pour `data.raw["recipe"][<nom>]`. Boîte à outils fluente pour muter une recette : activer/désactiver, masquer/afficher, ajouter/retirer/remplacer des ingrédients, propager le tint des packs de science et le subgroup vers l'item correspondant. Chaque setter réécrit dans `data.raw` (via `:update()`) et renvoie `self` (chaînable).

> **Note — variantes de difficulté** : les méthodes parcourent aussi les branches legacy `normal` / `expensive` (API 1.x) en plus de `ingredients` / `results`. Si ces branches n'existent pas, elles sont simplement no-op. Voir [Migration Factorio 2.0](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Recipe.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.recipe)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoRecipe"` |

```lua
-- mon-mod/data.lua
require("__RitnLib__.defines")
local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)
```

---

## Constructeur

#### `RitnProtoRecipe(recipe_name)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)

Pose les bases via `RitnPrototype.init` puis **deep-copie** `data.raw["recipe"][recipe_name]` dans [`prototype`](#prototype-table-read). Si la recette n'existe pas, `prototype` reste `nil` (tous les setters deviennent no-op).

**Paramètres**
- `recipe_name` :: `string` — nom de la recette dans `data.raw`.

---

## Attributs

#### `name` :: `string` `[Read]`
Nom de la recette (hérité de [`RitnPrototype`](RitnPrototype.md)).

#### `type` :: `string` `[Read]`
Type résolu (`"recipe"`).

#### `prototype` :: `table?` `[Read]`
Copie de travail de `data.raw["recipe"][name]`. Toutes les mutations s'appliquent dessus, puis `:update()` réécrit dans `data.raw`. `nil` si la recette n'existe pas.

#### `object_name` :: `"RitnProtoRecipe"` `[Read]`
Sentinelle de type.

#### `listTint` :: `string[]` `[Read]`
Liste ordonnée des clés de tint (`"red"`, `"automation"`, `"logistic"`…), depuis `core/constants.lua`.

#### `tint` :: `table<string, table>` `[Read]`
Palette de tints (jeu `{primary, secondary, tertiary, quaternary}` par clé), depuis `core/constants.lua`.

---

## Format d'ingrédient

Les méthodes d'ingrédient acceptent (via [`RitnIngredient`](RitnIngredient.md)) :

- forme array : `{ "advanced-circuit", 2 }`
- forme table : `{ type = "item", name = "steel-plate", amount = 4 }`
- string seule : `"steel-plate"` (pour les recherches/suppressions)

---

## Méthodes — activation & visibilité

#### `:setEnabled(value?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Définit le flag `enabled` sur le prototype **et** sur les branches legacy `normal` / `expensive` si présentes. `value` défaut `true`.

```lua
RitnProtoRecipe('logistic-science-pack'):setEnabled()
RitnProtoRecipe('light-armor'):setEnabled(false)
```

#### `:disable()` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Désactive **et** masque la recette, puis pose `hidden = true` sur l'item résultat (via `RitnProtoItem`).

#### `:setHidden(value, crafting?, stats?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Définit `hidden` sur le prototype et ses branches de difficulté. Si `crafting` est non-nil, pose aussi `hide_from_player_crafting` ; si `stats` est non-nil, `hide_from_player_stats`.

**Paramètres**
- `value` :: `boolean` — valeur du flag.
- `crafting` :: `any?` — si non-nil, applique aussi à `hide_from_player_crafting`.
- `stats` :: `any?` — si non-nil, applique aussi à `hide_from_player_stats`.

> ⚠ `hide_from_player_stats` n'existe pas dans le schéma Factorio (la clé correcte est `hide_from_stats`) : le paramètre `stats` est sans effet. Voir [Résidus API 1.x](../../debt/api-1.x-leftover.md).

---

## Méthodes — ingrédients

#### `:addIngredient(ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Ajoute l'ingrédient ; **combine** (somme les quantités) si un ingrédient du même nom existe déjà.

#### `:addNewIngredient(ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Ajoute l'ingrédient ; **ignore** si un ingrédient du même nom existe déjà.

#### `:setIngredient(ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Remplace sur place chaque entrée matchant le nom de l'ingrédient.

#### `:removeIngredient(ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Retire l'ingrédient de toutes les branches.

#### `:removeAllIngredient()` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Vide toutes les listes d'ingrédients.

#### `:replaceIngredient(old_name, new_ingredient)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Remplace l'ingrédient nommé `old_name` par `new_ingredient` dans chaque branche existante. Si `new_ingredient` est une string, l'amount de l'ancienne entrée est conservé et le type est déduit du nouveau nom (fluide ou item). Si le nouvel ingrédient existe déjà, les amounts sont combinés. No-op sur les branches qui ne contiennent pas `old_name`.

**Paramètres**
- `old_name` :: `string` — nom de l'ingrédient à remplacer.
- `new_ingredient` :: `table|string` — nouvel ingrédient (table ou string shorthand).

#### `:getIngredient(ingredient)` → `table?`
Renvoie le payload `item` normalisé du premier ingrédient au nom donné, ou `nil`.

**Paramètres** : `ingredient` :: `string` — nom recherché.

#### `:ingredientExiste(ingredient)` → `boolean`
`true` si un ingrédient au nom donné existe dans la recette.

---

## Méthodes — résultats

#### `:addResult(result)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Ajoute `result` à `prototype.results` — **combine** (somme les amounts, moyenne `independent_probability`) si un résultat du même nom existe déjà. Crée `results` si absent.

#### `:removeResult(result)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Retire chaque résultat matchant le nom de `result` de `prototype.results`.

#### `:setResult(result)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Remplace sur place chaque résultat matchant le nom de `result` dans `prototype.results` (sans combine).

**Paramètres** (communs aux méthodes résultats) : `result` :: `table|string` — payload produit (`{type=, name=, amount=, independent_probability=}` ou string shorthand).

---

## Méthodes — catégories (Factorio 2.1+)

#### `:setCategories(categories)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Remplace `prototype.categories` (Factorio 2.1+, remplace les clés legacy `category` / `additional_categories` supprimées). Accepte un nom seul ou une liste. Supprime aussi les clés legacy si présentes.

**Paramètres**
- `categories` :: `string|string[]` — catégorie(s) de fabrication.

#### `:addCategory(category)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Ajoute une catégorie à `prototype.categories` si elle n'y est pas déjà. Si la recette n'a pas de `categories`, part de `{"crafting"}` (le défaut du moteur).

**Paramètres**
- `category` :: `string` — catégorie à ajouter.

---

## Méthodes — tint & subgroup

#### `:changeTint(parameter, tint)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Affecte une couleur de [`tint`](#tint-tablestring-table-read) (par clé : `"red"`, `"automation"`…) au champ `parameter` du prototype (typiquement `"crafting_machine_tint"`). No-op si la clé est inconnue.

#### `:updatePackTint()` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Auto-détecte les packs de science (nom finissant par `-science-pack`) et applique le tint correspondant au `crafting_machine_tint`.

#### `:changeSubgroup(subgroup, order?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Définit `subgroup` (et `order`) sur la recette **et** propage à l'item correspondant (via `RitnProtoItem`). Override la version héritée pour gérer la propagation à l'item.

#### `:setProductivity(value?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Définit `prototype.allow_productivity` (Factorio 2.0+, remplace les listes `limitation` des modules supprimées). `value` vaut `true` par défaut.

---

## Méthodes héritées de `RitnPrototype`

Disponibles sur toute instance — voir [`RitnPrototype`](RitnPrototype.md) pour le détail :

| Méthode | Rôle |
|---|---|
| `:changePrototype(parameter, value)` | écrit `prototype[parameter] = value` puis `:update()`. |
| `:setPrototype(parameter, value)` | idem, sans log. |
| `:changeSubPrototype(parameter, sub, value)` | écrit `prototype[parameter][sub] = value`. |
| `:getProperties(propertie)` | lit une propriété de `prototype`. |
| `:update()` | réécrit `prototype` dans `data.raw[type][name]` (appelé par chaque setter). |

---

## Exemples d'usage

**Recomposer entièrement une recette de module** (`RitnElectronic/prototypes/update-recipes.lua`) :

```lua
local recipeModule = RitnProtoRecipe("speed-module"):removeAllIngredient()
recipeModule:addIngredient({ "advanced-circuit-module", 1 })
recipeModule:addIngredient({ "electronic-circuit-module", 1 })
```

**Ajout conditionnel via `pcall`** (`RitnElectronic/prototypes/update-recipes.lua`) :

```lua
local ok = pcall(function()
    RitnProtoRecipe("electric-furnace"):addIngredient({ type = "item", name = "steel-furnace", amount = 1 })
end)
if not ok then
    RitnProtoRecipe("electric-furnace"):addNewIngredient({ type = "item", name = "steel-furnace", amount = 1 })
end
RitnProtoRecipe("electric-furnace"):setIngredient({ type = "item", name = "steel-plate", amount = 4 })
```

**Déplacer une recette de subgroup** (`RitnDemo/data.lua`) :

```lua
RitnProtoRecipe("wooden-chest"):changeSubgroup("belt")
```

---

## Remarques

- **Data stage uniquement** — à utiliser depuis `data.lua` / `data-updates.lua` / `data-final-fixes.lua`, jamais au runtime.
- **Copie + écriture** — les mutations s'appliquent sur une copie (`prototype`) ; chaque setter appelle `:update()` qui réécrit dans `data.raw`. Pas besoin d'appeler `data:extend` toi-même.
- **Branches `normal` / `expensive`** — résidus des variantes de difficulté Factorio 1.x. Les méthodes les parcourent en plus de `ingredients` / `results` (canoniques 2.0+) ; si elles n'existent pas sur le prototype chargé, ces branches sont simplement no-op. Voir [Migration Factorio 2.0](../../migration-2.0.md).
- **`independent_probability`** — les méthodes résultats utilisent `independent_probability` (Factorio 2.1+). La clé legacy `probability` est acceptée en entrée mais jamais écrite.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnIngredient`](RitnIngredient.md) · [`RitnProtoTech`](RitnProtoTech.md)
- [Migration Factorio 2.0](../../migration-2.0.md)
