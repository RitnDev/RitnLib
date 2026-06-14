---
title: RitnProtoRecipe
type: reference
lang: fr
---

# `RitnProtoRecipe`


Manipulateur **data stage** pour `data.raw["recipe"][<nom>]`. Boîte à outils fluente pour muter une recette : activer/désactiver, masquer/afficher, ajouter/retirer/remplacer des ingrédients, propager le tint des packs de science et le subgroup vers l'item correspondant. Chaque setter réécrit dans `data.raw` (via `:update()`) et renvoie `self` (chaînable).

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0 ; elle conserve des constructions de l'API **1.x** (notamment les variantes de difficulté `normal` / `expensive`). Utilisable au data stage, mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../migration-2.0.md).

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

Pose les bases via `RitnPrototype.init` puis **deep-copie** `data.raw["recipe"][recipe_name]` dans [`prototype`](#prototype--table-read). Si la recette n'existe pas, `prototype` reste `nil` (tous les setters deviennent no-op).

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
Désactive **et** masque la recette, puis pose `flags = {"hidden"}` sur l'item résultat (via `RitnProtoItem`).

#### `:setHidden(value, crafting?, stats?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Définit `hidden` sur le prototype et ses branches de difficulté. Si `crafting` est non-nil, pose aussi `hide_from_player_crafting` ; si `stats` est non-nil, `hide_from_player_stats`.

**Paramètres**
- `value` :: `boolean` — valeur du flag.
- `crafting` :: `any?` — si non-nil, applique aussi à `hide_from_player_crafting`.
- `stats` :: `any?` — si non-nil, applique aussi à `hide_from_player_stats`.

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

#### `:getIngredient(ingredient)` → `table?`
Renvoie le payload `item` normalisé du premier ingrédient au nom donné, ou `nil`.

**Paramètres** : `ingredient` :: `string` — nom recherché.

#### `:ingredientExiste(ingredient)` → `boolean`
`true` si un ingrédient au nom donné existe dans la recette.

---

## Méthodes — tint & subgroup

#### `:changeTint(parameter, tint)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Affecte une couleur de [`tint`](#tint--tablestring-table-read) (par clé : `"red"`, `"automation"`…) au champ `parameter` du prototype (typiquement `"crafting_machine_tint"`). No-op si la clé est inconnue.

#### `:updatePackTint()` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Auto-détecte les packs de science (nom finissant par `-science-pack`) et applique le tint correspondant au `crafting_machine_tint`.

#### `:changeSubgroup(subgroup, order?)` → [`RitnProtoRecipe`](RitnProtoRecipe.md)
Définit `subgroup` (et `order`) sur la recette **et** propage à l'item correspondant (via `RitnProtoItem`). Override la version héritée pour gérer la propagation à l'item.

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
- **Branches `normal` / `expensive`** — résidus des variantes de difficulté Factorio 1.x. Les méthodes les parcourent en plus de `ingredients` (canonique 2.0) ; si elles n'existent pas sur le prototype chargé, ces branches sont simplement no-op. Voir [Migration Factorio 2.0](../../migration-2.0.md).

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnIngredient`](RitnIngredient.md) · [`RitnProtoTech`](RitnProtoTech.md)
- [Migration Factorio 2.0](../../migration-2.0.md)
