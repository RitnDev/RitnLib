---
title: Cycle de vie (settings → data → runtime)
type: concept
lang: fr
---

# Cycle de vie — settings → data → runtime

Factorio charge les mods en **trois passes séquentielles**. RitnLib expose des outils différents à chaque passe. Savoir quelle passe est active te dit quel `require` est valide, quelles APIs Factorio sont disponibles, et quelles classes RitnLib tu peux instancier.

## Vue d'ensemble

```
Factorio démarre
│
├─► SETTINGS STAGE  settings.lua / settings-updates.lua / settings-final-fixes.lua
│   Disponible : settings (écriture)
│   RitnLib   : RitnLibSetting (🚧 beta)
│
├─► DATA STAGE      data.lua / data-updates.lua / data-final-fixes.lua
│   Disponible : data, settings (lecture)
│   RitnLib   : RitnProto* + RitnIngredient (require explicite)
│               helpers lualib/entity, lualib/gui, lualib/LuaStyle
│
└─► RUNTIME STAGE   control.lua + handlers script.on_event(...)
    Disponible : game, storage, script, rendering, remote…
    RitnLib   : toutes les classes LuaClass/* injectées en _G automatiquement
                + RitnLibInventory, RitnLibGui, RitnLibInformatron
```

## Settings stage

Le premier à s'exécuter. Les settings Factorio (`mod-settings.dat`) sont lus et écrits ici.

RitnLib propose `RitnLibSetting` comme builder fluent — voir sa page de référence pour l'état actuel (🚧 beta).

```lua
-- mon-mod/settings.lua
require("__RitnLib__.defines")
local RitnSetting = require(ritnlib.defines.class.ritnClass.setting)

RitnSetting("mon-mod-activer-feature")
    :setSettingStartup()
    :setDefaultValueBool(true)
    :new()
```

## Data stage

Tous les `data.lua` s'exécutent, construisant `data.raw` (le registre des prototypes). Les settings sont accessibles en lecture.

RitnLib injecte `ritnlib.defines` dès le premier `require("__RitnLib__.defines")` dans ton `data.lua`. Ensuite tu peux require les classes proto :

```lua
-- mon-mod/data.lua
require("__RitnLib__.defines")

local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)

RitnProtoRecipe("ma-recette")
    :setIngredients({ { "iron-plate", 5 } })
    :setResult("iron-gear-wheel", 2)
    :new()
```

**Limitation** : `game`, `storage`, `script` n'existent pas au data stage. Ne les utilise jamais ici.

## Runtime stage

C'est l'étape de jeu. RitnLib charge `core/setup-classes.lua` dans son `control.lua`, ce qui injecte toutes les classes runtime en `_G`. Tu les utilises sans `require` :

```lua
-- mon-mod/control.lua
script.on_event(defines.events.on_player_created, function(event)
    local player = RitnLibPlayer(game.get_player(event.player_index))
    player:print("Bienvenue !")
end)
```

**RitnLib n'enregistre aucun handler propre.** Il n'appelle pas `script.on_event`, n'accède pas à `storage`. Tous les handlers viennent de ton mod.

## Erreurs courantes

| Erreur | Cause | Correction |
|---|---|---|
| `attempt to index a nil value (global 'game')` au data stage | `game` n'existe pas au data stage | Retire l'appel, utilise `data.raw` à la place |
| `RitnLibPlayer` est `nil` au data stage | Classes LuaClass/* non chargées | Elles ne sont disponibles qu'au runtime stage |
| `data.raw` est `nil` au runtime stage | `data` n'existe qu'aux stages settings/data | Lis les prototypes au bon stage |

## Voir aussi

- [Architecture en 4 couches](architecture-layers.md)
- [Wrappers temporaires](temporary-wrappers.md)
- [Référence : RitnLibEvent](../reference/runtime/RitnLibEvent.md)
- [Référence : RitnPrototype](../reference/prototype/RitnPrototype.md)
