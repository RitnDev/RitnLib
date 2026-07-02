---
title: Mon premier prototype
type: guide
lang: fr
---

# Mon premier prototype

Ce guide montre comment créer des prototypes Factorio (recettes, technologies, entités, items) en utilisant les classes `RitnProto*` de RitnLib au **data stage**.

## Prérequis

RitnLib déclaré en dépendance dans `info.json`. Voir le [guide d'installation](installation.md).

## Structure de base

Au data stage, commence toujours par importer les defines :

```lua
-- mon-mod/data.lua
require("__RitnLib__.defines")
```

Cela injecte `ritnlib.defines` en global, qui contient les chemins vers toutes les classes RitnLib. Tu peux ensuite require ce dont tu as besoin.

## Recette — `RitnProtoRecipe`

```lua
-- mon-mod/data.lua
require("__RitnLib__.defines")

local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)

RitnProtoRecipe("mon-mod-ma-recette")
    :setIngredients({
        { "iron-plate", 5 },
        { "copper-plate", 2 },
    })
    :setResult("iron-gear-wheel", 3)
    :setTime(5)
    :new()
```

`:new()` est l'appel final qui enregistre le prototype dans `data.raw`. Sans `:new()`, rien n'est créé.

## Technologie — `RitnProtoTech`

```lua
local RitnProtoTech = require(ritnlib.defines.class.prototype.technology)

RitnProtoTech("mon-mod-ma-tech")
    :setPrerequisites({ "automation" })
    :setResearchUnit({ { "automation-science-pack", 1 } }, 10, 30)
    :addUnlockedRecipe("mon-mod-ma-recette")
    :new()
```

## Item — `RitnProtoItem`

```lua
local RitnProtoItem = require(ritnlib.defines.class.prototype.item)

RitnProtoItem("mon-mod-mon-item")
    :setStack(50)
    :setGroup("combat")
    :setSubGroup("ammo")
    :new()
```

## Entité — `RitnProtoEntity`

```lua
local RitnProtoEntity = require(ritnlib.defines.class.prototype.entity)

RitnProtoEntity("mon-mod-mon-entite")
    :setMaxHealth(200)
    :new()
```

> `RitnProtoEntity` est un wrapper générique. Pour des types complexes (assembling-machine, furnace…), il peut être plus simple de manipuler `data.raw` directement après le `:new()`.

## Ingrédients — `RitnIngredient`

Pour les recettes nécessitant des ingrédients fluides ou avec des formules complexes :

```lua
local RitnIngredient = require(ritnlib.defines.class.prototype.ingredient)

local ing_eau  = RitnIngredient("water"):setFluid(100):build()
local ing_fer  = RitnIngredient("iron-plate"):setAmount(5):build()

RitnProtoRecipe("mon-mod-ma-recette-fluide")
    :setIngredients({ ing_eau, ing_fer })
    :setResult("mon-mod-mon-item", 1)
    :new()
```

## Règle importante

| ✅ Fais | ❌ Évite |
|---|---|
| `require("__RitnLib__.defines")` au tout début | Utiliser `RitnLibPlayer` ou `game` au data stage |
| Appeler `:new()` à la fin de chaque chaîne | Oublier `:new()` (aucune erreur, mais rien n'est créé) |
| Travailler avec `data.raw` pour les ajustements fins | Appeler `storage` ou `script` au data stage |

## data-updates.lua

`data-updates.lua` s'exécute dans les mêmes conditions que `data.lua` : les classes `RitnProto*` sont disponibles exactement de la même façon. Tu peux créer de nouveaux prototypes **et** modifier des prototypes existants via `data.raw` :

```lua
-- mon-mod/data-updates.lua
require("__RitnLib__.defines")

local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)

-- Créer une nouvelle recette (même pattern que data.lua)
RitnProtoRecipe("mon-mod-ma-recette-bis")
    :setIngredients({ { "steel-plate", 3 } })
    :setResult("mon-mod-mon-item", 1)
    :new()

-- Modifier un prototype vanilla directement via data.raw
data.raw.recipe["iron-gear-wheel"].energy_required = 1
```

## Voir aussi

- [Cycle de vie](../concepts/life-cycle.md)
- [Mon premier handler runtime](first-handler.md)
- [Référence : RitnPrototype](../reference/prototype/RitnPrototype.md)
