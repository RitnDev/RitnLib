---
title: RitnProtoTech
type: reference
lang: fr
---

# `RitnProtoTech`


Manipulateur **data stage** pour `data.raw["technology"][<nom>]`. Boîte à outils complète pour les technologies : coûts de recherche, recettes débloquées, packs de science (dans la recherche **et** dans les labs), pré-requis, et désactivation avec purge en cascade. Chaque setter réécrit dans `data.raw` (via `:update()`) et renvoie `self` (chaînable).

> Le nom de classe réel est **`RitnProtoTech`** (et non `RitnProtoTechnology`).

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0 ; elle conserve des constructions de l'API **1.x**. Utilisable au data stage, mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../migration-2.0.md).

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

Pose les bases via `RitnPrototype.init` puis **deep-copie** `data.raw["technology"][tech_name]` dans [`prototype`](#prototype-table-read). Si la techno n'existe pas, `prototype` reste `nil` (setters no-op).

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

> Ces méthodes ne concernent que les technologies à packs de science (`unit`). Sur une technologie à déclencheur de recherche (Factorio 2.x), elles ne font rien.

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

## Méthodes — mode de déblocage

En Factorio 2.x, une technologie se débloque soit avec des **packs de science** (`unit`), soit avec un **déclencheur de recherche** (`research_trigger` : fabriquer un item, miner une entité, etc.).

#### `:getUnlockMode()` → `"unit"|"trigger"|nil`
Retourne `"unit"` (packs de science), `"trigger"` (déclencheur) ou `nil` si la technologie n'existe pas.

#### `:isUnit()` → `boolean`
`true` si la technologie se débloque avec des packs de science.

#### `:isTrigger()` → `boolean`
`true` si la technologie se débloque avec un déclencheur de recherche.

#### `:setUnit(unit)` → [`RitnProtoTech`](RitnProtoTech.md)
Remplace tout le coût de recherche (`prototype.unit`) et retire `research_trigger`. Passe une technologie à déclencheur en technologie à packs de science.

**Paramètres** : `unit` :: `table` — `TechnologyUnit` (`{count = 100, ingredients = { {"automation-science-pack", 1} }, time = 30}`).

#### `:setTrigger(trigger)` → [`RitnProtoTech`](RitnProtoTech.md)
Remplace le déclencheur de recherche (`prototype.research_trigger`) et retire `unit`. Passe une technologie à packs de science en technologie à déclencheur. No-op si `trigger` n'a pas de `type`.

**Paramètres** : `trigger` :: `table` — `TechnologyTrigger` (`{type = "craft-item", item = "iron-plate", count = 50}`).

```lua
RitnProtoTech("oil-processing"):setUnit({
    count = 100,
    ingredients = { {"automation-science-pack", 1}, {"logistic-science-pack", 1} },
    time = 30
})
RitnProtoTech("ma-techno"):setTrigger({type = "craft-item", item = "iron-plate", count = 50})
```

---

## Méthodes — déclencheur de recherche

> Ces méthodes ne concernent que les technologies à déclencheur. Sur une technologie à packs de science, elles ne font rien.

#### `:getTrigger()` → `table?`
Retourne une copie du déclencheur de recherche, ou `nil` si la technologie n'en a pas.

#### `:setTriggerTarget(target)` → [`RitnProtoTech`](RitnProtoTech.md)
Change la cible du déclencheur selon son type :

| Type de déclencheur | Champ modifié |
|---|---|
| `craft-item`, `send-item-to-orbit` | `item` |
| `craft-fluid` | `fluid` |
| `build-entity`, `capture-spawner` | `entity` |
| `mine-entity` | `entities` (un nom seul est transformé en liste) |

No-op pour les types sans cible (`create-space-platform`, `scripted`).

**Paramètres** : `target` :: `string|string[]`

#### `:setTriggerCount(count)` → [`RitnProtoTech`](RitnProtoTech.md)
Change la quantité demandée : `count` (`craft-item`) ou `amount` (`craft-fluid`). No-op pour les autres types.

**Paramètres** : `count` :: `number`

```lua
local tech = RitnProtoTech("steam-power")
if tech:isTrigger() then
    tech:setTriggerTarget("stone-brick"):setTriggerCount(20)
end
```

---

## Méthodes — recettes débloquées

#### `:addRecipe(recipe_name)` → [`RitnProtoTech`](RitnProtoTech.md)
Ajoute un effet `{type = "unlock-recipe", recipe = recipe_name}` (sauf doublon). La recette doit exister dans `data.raw.recipe`.

#### `:removeRecipe(recipe, complete?)` → [`RitnProtoTech`](RitnProtoTech.md)
Retire l'effet `unlock-recipe` correspondant. Si `complete == true`, désactive aussi la recette via `RitnProtoRecipe(recipe):disable()`.

---

## Méthodes — packs de science (recherche)

> Comme le coût de recherche, ces méthodes ne font rien sur une technologie à déclencheur. Un pack peut être un `tool` ou un `item` (Factorio 2.1 : les packs vanilla sont des `item`).

#### `:addPack(pack, count?)` → [`RitnProtoTech`](RitnProtoTech.md)
Ajoute un pack à `prototype.unit.ingredients` (`count` défaut 1). Si le pack est déjà présent, **incrémente** son amount de `count`. `pack` doit exister dans `data.raw.tool` ou `data.raw.item`.

#### `:removePack(pack)` → [`RitnProtoTech`](RitnProtoTech.md)
Retire toutes les entrées correspondant à `pack`.

#### `:replacePack(old, new)` → [`RitnProtoTech`](RitnProtoTech.md)
Remplace `old` par `new` en préservant l'amount total. `new` doit exister dans `data.raw.tool` ou `data.raw.item`.

---

## Méthodes — packs sur les labs

#### `:addPackLab(pack, index?)` → [`RitnProtoTech`](RitnProtoTech.md)
Ajoute `pack` aux `inputs` de chaque lab qui ne le contient pas (position `index`, défaut 1). `pack` doit exister dans `data.raw.tool` ou `data.raw.item`.

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
- [Migration Factorio 2.0](../../migration-2.0.md)
