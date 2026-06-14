---
title: RitnProtoTech
type: reference
lang: fr
---

# `RitnProtoTech`

🇬🇧 [English version](../../../en/reference/prototype/RitnProtoTech.md)

Manipulateur **data stage** pour `data.raw["technology"][<nom>]`. Boîte à outils complète pour les technologies : coûts de recherche, recettes débloquées, packs de science (dans la recherche **et** dans les labs), pré-requis, et désactivation avec purge en cascade. Chaque setter réécrit dans `data.raw` (via `:update()`) et renvoie `self` (chaînable).

> Le nom de classe réel est **`RitnProtoTech`** (et non `RitnProtoTechnology`).

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0 ; elle conserve des constructions de l'API **1.x**. Utilisable au data stage, mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Technology.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.tech)` (alias `…prototype.technology`) |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoTech"` |

```lua
-- mon-mod/data.lua
require("__RitnLib__.defines")
local RitnProtoTech = require(ritnlib.defines.class.prototype.tech)
```

---

## Constructeur

#### `RitnProtoTech(tech_name)` → [`RitnProtoTech`](RitnProtoTech.md)

Pose les bases via `RitnPrototype.init` puis **deep-copie** `data.raw["technology"][tech_name]` dans [`prototype`](#prototype--table-read). Si la techno n'existe pas, `prototype` reste `nil` (setters no-op).

**Paramètres**
- `tech_name` :: `string` — nom de la technologie dans `data.raw`.

---

## Attributs

#### `name` :: `string` `[Read]`
Nom de la technologie (hérité de [`RitnPrototype`](RitnPrototype.md)).

#### `type` :: `string` `[Read]`
Type résolu (`"technology"`).

#### `prototype` :: `table?` `[Read]`
Copie de travail de `data.raw["technology"][name]`. `nil` si la techno n'existe pas.

#### `object_name` :: `"RitnProtoTech"` `[Read]`
Sentinelle de type.

> **Note** — La classe garde aussi des drapeaux internes mutables (`addit`, `doit`, `disable_recipe`, `amount_pack`, `delete_prerequisite`) que les méthodes remettent à zéro entre elles. Ce sont des détails d'implémentation, pas des champs publics.

---

## Méthodes — coût de recherche

#### `:setCount(count)` → [`RitnProtoTech`](RitnProtoTech.md)
Définit le nombre de cycles (`prototype.unit.count`).

#### `:setTime(time)` → [`RitnProtoTech`](RitnProtoTech.md)
Définit le temps par cycle (`prototype.unit.time`).

#### `:setIngredients(ingredients)` → [`RitnProtoTech`](RitnProtoTech.md)
Remplace toute la liste d'ingrédients de recherche (`prototype.unit.ingredients`).

**Paramètres** : `ingredients` :: `table[]` — liste d'ingrédients (`{ {"automation-science-pack", 1}, … }`).

#### `:multipliedPack(coeff)` → [`RitnProtoTech`](RitnProtoTech.md)
Multiplie `prototype.unit.count` par `coeff`.

---

## Méthodes — recettes débloquées

#### `:addRecipe(recipe_name)` → [`RitnProtoTech`](RitnProtoTech.md)
Ajoute un effet `{type = "unlock-recipe", recipe = recipe_name}` (sauf doublon). La recette doit exister dans `data.raw.recipe`.

#### `:removeRecipe(recipe, complete?)` → [`RitnProtoTech`](RitnProtoTech.md)
Retire l'effet `unlock-recipe` correspondant. Si `complete == true`, désactive aussi la recette via `RitnProtoRecipe(recipe):disable()`.

---

## Méthodes — packs de science (recherche)

#### `:addPack(pack, count?)` → [`RitnProtoTech`](RitnProtoTech.md)
Ajoute un pack à `prototype.unit.ingredients` (`count` défaut 1). Si le pack est déjà présent, **incrémente** son amount de `count`. `pack` doit exister dans `data.raw.tool`.

#### `:removePack(pack)` → [`RitnProtoTech`](RitnProtoTech.md)
Retire toutes les entrées correspondant à `pack`.

#### `:replacePack(old, new)` → [`RitnProtoTech`](RitnProtoTech.md)
Remplace `old` par `new` en préservant l'amount total. `new` doit exister dans `data.raw.tool`.

---

## Méthodes — packs sur les labs

#### `:addPackLab(pack, index?)` → [`RitnProtoTech`](RitnProtoTech.md)
Ajoute `pack` aux `inputs` de chaque lab qui ne le contient pas (position `index`, défaut 1). `pack` doit exister dans `data.raw.tool`.

#### `:removePackLab(pack, lab?)` → [`RitnProtoTech`](RitnProtoTech.md)
Retire `pack` des `inputs` de tous les labs, ou d'un `lab` précis si fourni.

---

## Méthodes — pré-requis

#### `:addPrerequisite(prerequisite)` → [`RitnProtoTech`](RitnProtoTech.md)
Ajoute `prerequisite` à `prototype.prerequisites` (sauf doublon). Doit référencer une techno existante.

#### `:removePrerequisite(prerequisite)` → [`RitnProtoTech`](RitnProtoTech.md)
Retire `prerequisite` de la liste.

#### `:replacePrerequisite(remove_prerequisite, add_prerequisite)` → [`RitnProtoTech`](RitnProtoTech.md)
Raccourci : `:removePrerequisite(...)` puis `:addPrerequisite(...)`.

---

## Méthodes — désactivation

#### `:disable(delete_prerequisites?)` → [`RitnProtoTech`](RitnProtoTech.md)
Désactive et masque la technologie. Si `delete_prerequisites == true`, **purge en cascade** : retire cette techno de la liste `prerequisites` de toutes les autres technos qui la référencent.

```lua
RitnProtoTech('steel-axe'):disable(true)
```

---

## Méthodes héritées de `RitnPrototype`

`:changePrototype`, `:setPrototype`, `:changeSubPrototype`, `:getProperties`, `:update`, `:changeSubgroup` — voir [`RitnPrototype`](RitnPrototype.md).

---

## Exemples d'usage

**Débloquer une recette + ajuster le temps** (`RetroFactorio/prototypes/technologies.lua`) :

```lua
ProtoTech('light-armor'):addRecipe('light-armor')
ProtoTech('landfill'):setTime(25)
```

**Désactiver une techno et purger les pré-requis qui la pointent** (`RetroFactorio/prototypes/technologies.lua`) :

```lua
ProtoTech('steel-axe'):disable(true)
ProtoTech('logistic-science-pack'):disable(true)
```

**Chaînage sur une techno de mod** (`RitnHiladdar/prototypes/robots/update-technology.lua`) :

```lua
local rTech = RitnProtoTech("hsmd-logistic-robotics-2")
RitnProtoTech("hsmd-bot-recaller"):disable(true)
```

---

## Remarques

- **Data stage uniquement** — à utiliser depuis `data.lua` / `data-updates.lua` / `data-final-fixes.lua`.
- **Copie + écriture** — mutations sur `prototype`, réécrites par `:update()` (appelé par chaque setter). Pas de `data:extend` manuel.
- **Existence requise** — `addRecipe`/`addPack`/`replacePack`/`addPrerequisite` vérifient l'existence de la cible dans `data.raw` (`recipe`, `tool`, `technology`) et sont no-op sinon.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoRecipe`](RitnProtoRecipe.md)
- [Migration Factorio 2.0](../../../migration-2.0.md)
