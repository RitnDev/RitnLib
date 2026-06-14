---
title: Architecture interne RitnLib
audience: mainteneur
status: living
last_review: 2026-06-11
pinned_version: 0.9.8
---

# Architecture interne — RitnLib

> Document interne mainteneur. Vue d'ensemble de la structure du code, des dépendances et des choix de conception.
> Mis à jour à chaque refactor structurel — section « Historique » en bas.

## 1. Identité

RitnLib est un **mod-bibliothèque** pour Factorio 2.0 (`info.json.factorio_version = "2.0"`). Il ne propose aucune entité, recette ou recherche de gameplay : il publie une **API consommée par d'autres mods Ritn** au moment du chargement.

Conséquence directe sur la lecture du code : la grande majorité des fichiers n'a pas vocation à s'exécuter dans la VM de RitnLib lui-même, mais à être require par des mods clients (au data stage, au settings stage, ou au control stage).

## 2. Vue d'ensemble en 4 couches

```
┌───────────────────────────────────────────────────────────────┐
│  Couche assets data            prototypes/                    │
│  fonts.lua, gui-style.lua      (consommée par data stage      │
│                                 d'un mod client via require)  │
├───────────────────────────────────────────────────────────────┤
│  Couche classes                classes/                       │
│  ┌──────────────────┬──────────────────┬───────────────────┐  │
│  │  prototypes/     │  RitnClass/      │  LuaClass/        │  │
│  │  (data stage)    │  (hybride)       │  (runtime)        │  │
│  │  RitnProto*      │  Setting,        │  Player, Surface, │  │
│  │                  │  Inventory,      │  Force, Entity,   │  │
│  │                  │  Ingredient,     │  Event, Recipe,   │  │
│  │                  │  Prototype base, │  Technology, Gui  │  │
│  │                  │  Informatron,    │                   │  │
│  │                  │  gui/Element,    │                   │  │
│  │                  │  gui/Style       │                   │  │
│  └──────────────────┴──────────────────┴───────────────────┘  │
├───────────────────────────────────────────────────────────────┤
│  Couche utilities              lualib/                        │
│  table, string, json, other, gui, entity, LuaStyle            │
│  vanilla/{util, crash-site, ores, types_*}                    │
│  informatron/{menu, pages}                                    │
├───────────────────────────────────────────────────────────────┤
│  Couche fondation              core/                          │
│  class.lua          → classFactory                            │
│  constants.lua      → tints, colors, strings, types           │
│  eventListener.lua  → fork event_handler (statut incertain)   │
│  interfaces.lua     → remote.add_interface("RitnLib", {})     │
│  setup-classes.lua  → chargeur des classes runtime            │
├───────────────────────────────────────────────────────────────┤
│  Bootstrap                     defines.lua + control.lua      │
│  ritnlib (global) + ritnlib.classFactory                      │
└───────────────────────────────────────────────────────────────┘
```

## 3. Entrypoints

| Stage | Fichier | Action |
|---|---|---|
| **control** | [control.lua](https://github.com/RitnDev/RitnLib/blob/0.9.8/control.lua) | `require('core.setup-classes')`, `require('core.interfaces')`, activation conditionnelle de `gvv` |
| **data** | _aucun_ | Les fichiers `prototypes/fonts.lua` et `prototypes/gui-style.lua` existent mais ne sont **pas** chargés par RitnLib lui-même — un mod client doit les require explicitement |
| **settings** | _aucun_ | La classe `RitnLibSetting` est un builder appelé depuis le settings stage d'un mod client |

⚠ La présence d'un dossier `prototypes/` sans `data.lua` à la racine est intentionnelle : les assets y sont des **fichiers prêts à require**, exposés via `ritnlib.defines.fonts` et `ritnlib.defines.gui_styles`.

## 4. Registre global `ritnlib`

[defines.lua](https://github.com/RitnDev/RitnLib/blob/0.9.8/defines.lua) construit un global `ritnlib` qui sert de **registre de chemins** :

```lua
ritnlib = {
    defines = {
        event, constants, other, table, string, json,
        vanilla = { util, crash_site },
        fonts, gui_styles, setup,
        class = {
            core,
            prototype = { tech, ore, entity, item, recipe, group, subgroup,
                          category, fuelCategory, style, sprite, customInput,
                          utility = { constants } },
            luaClass  = { event, player, entity, force, surface, recipe, tech, gui },
            ritnClass = { prototype, ingredient, inventory, setting, informatron },
            gui       = { element, style },
        },
        names = { font = {...} },
    },
    classFactory = <core/class.lua>,
}
```

**Avantage** : un consommateur ne hard-code aucun chemin de fichier ; il fait `require(ritnlib.defines.class.luaClass.player)`. Si la lib réorganise ses fichiers, seul `defines.lua` change.

**Dette identifiée** :
- Plusieurs clés racine commentées `DEPRECATED` ([defines.lua:17-25](https://github.com/RitnDev/RitnLib/blob/0.9.8/defines.lua#L17-L25)) — migration de paths inachevée.
- `ritnlib.defines.event` pointe vers `__core__/lualib/event_handler` **et non vers** `core/eventListener.lua` — incohérence à statuer (cf. [ADR-R3-A](adr/0003-event-handler-fork.md) à venir).
- Faute de frappe `defaut*` au lieu de `default*` pour les noms de fontes.

## 5. Système de classes

### 5.1 Factory `ritnlib.classFactory`

[core/class.lua](https://github.com/RitnDev/RitnLib/blob/0.9.8/core/class.lua) — factory de classes orientée objet en Lua 5.1 :

- `newclass(super, init)` : héritage par copie superficielle des champs du parent + `__call` constructeur + `:is_a()`.
- `new(super, init)` : variante non utilisée ailleurs dans le dépôt → code mort à supprimer (cf. [BUG-DEAD-001](debt/known-bugs.md)).

⚠ **Pas de copie profonde** des champs du parent : si le parent expose une table partagée, toutes les instances la partagent par référence. Concerné : `RitnLibGui.list_valid`, `RitnLibGuiElement.hsp_valid`.

### 5.2 Deux familles de classes

| Famille | Dossier | Mode de retour | Stage |
|---|---|---|---|
| `RitnLib*` (runtime) | `classes/LuaClass/`, `classes/RitnClass/gui/`, `RitnLibInformatron`, `RitnLibInventory` | **globales `_G`** (assignation sans `local`) | control |
| `RitnProto*` / `Ritn*` (data + helpers) | `classes/prototypes/`, `RitnPrototype`, `RitnIngredient`, `RitnLibSetting` | `local … return` (require classique) | data / settings |

⚠ **Pollution `_G`** : toutes les classes runtime s'inscrivent dans le namespace global. C'est un choix assumé qui rend l'usage côté consommateur très court (`RitnLibPlayer(p)`), mais bloque l'évolution vers des modules typés. À statuer (cf. ADR-R3-C).

### 5.3 Hiérarchies actuelles

```
RitnLibPlayer ◄── RitnLibGui ◄── RitnLibInformatron

RitnPrototype ◄── RitnProtoEntity, RitnProtoItem, RitnProtoRecipe,
                  RitnProtoTechnology, RitnProtoOre, RitnProtoSprite,
                  RitnProtoStyle, RitnProtoItemGroup,
                  RitnProtoItemSubgroup, RitnProtoFuelCategory,
                  RitnProtoCustomInput, RitnProtoUtilityConst

⚠ RitnProtoRecipeCategory NE devrait PAS être à part — bug d'héritage
  (cf. BUG-005 dans debt/known-bugs.md)
```

## 6. Flux d'exécution

### Bootstrap effectif (au chargement de Factorio)

```
Factorio → RitnLib/control.lua
            ├─► require('core.setup-classes')
            │     └─► require('__RitnLib__.defines')     [crée le global ritnlib]
            │         └─► require(ritnlib.defines.class.core)  [classFactory]
            │     └─► require(...) × N classes runtime    [s'auto-inscrivent en _G]
            ├─► require('core.interfaces')
            │     └─► remote.add_interface("RitnLib", {}) [interface vide actuellement]
            └─► require("__gvv__.gvv")()                  [conditionnel : si gvv actif]
```

**Aucun handler `script.on_event` n'est enregistré**, **aucun accès à `storage`/`global`**. RitnLib est passif côté runtime.

### Bootstrap consommateur typique (data stage)

```
mod_client/data.lua
    require("__RitnLib__/defines")
    require(ritnlib.defines.fonts)       -- data:extend({fonts ritn-*})
    require(ritnlib.defines.gui_styles)  -- mutations sur data.raw['gui-style'].default

    local Recipe = require(ritnlib.defines.class.prototype.recipe)
    Recipe("automation-science-pack"):setCount(10):addIngredient({"iron-plate", 3})
```

### Bootstrap consommateur typique (control stage)

```
mod_client/control.lua
    -- ritnlib est déjà chargé par RitnLib/control.lua
    -- les classes RitnLib* sont déjà disponibles en _G

    script.on_event(defines.events.on_player_died, function(event)
        RitnLibInventory(game.get_player(event.player_index),
                          storage.inventory_snapshots):save(true)
    end)

    remote.add_interface("mod_client", {
        gui_action_main = function(action, event, ...) ... end,
    })
```

## 7. Persistance

| Aspect | Statut |
|---|---|
| `storage.X` propre à RitnLib | **aucun** |
| `global.X` (alias 1.x) | **aucun** |
| `script.register_metatable` | aucun |
| Méta-objets persistés | aucun |

RitnLib n'a **aucune donnée persistante propre**. Le seul cas d'état durable est `RitnLibInventory`, qui **délègue** la table de persistance au consommateur via le 2ᵉ paramètre du constructeur. Voir [Persistance déléguée](concepts/delegated-persistence.md).

## 8. Évènements

- **Aucun `script.on_event`** dans le code de RitnLib (vérifié par grep).
- `core/eventListener.lua` est un fork de `event_handler` (ZwerOxotnik) qui enregistre `on_init/on_load/on_configuration_changed/on_event/on_nth_tick` **au moment du require**. Mais ce fichier **n'est jamais require par `control.lua`** et `ritnlib.defines.event` pointe ailleurs → statut indéterminé. Cf. [ADR-R3-A](adr/0003-event-handler-fork.md).
- `RitnLibEvent` est un **wrapper d'event** (normalise le payload) ; il est instancié par le consommateur dans ses propres handlers.

## 9. Interfaces remote

### Exposées
| Nom | Méthodes | État |
|---|---|---|
| `"RitnLib"` | ∅ | ◆ enregistrée mais vide |
| `"RitnLib"` (variante Informatron, brouillon) | `informatron_menu`, `informatron_page_content` | ⚠ commentée, non enregistrée ([core/interfaces.lua:30](https://github.com/RitnDev/RitnLib/blob/0.9.8/core/interfaces.lua#L30)) |

### Consommées
| Mod cible | Fonctions | Localisation |
|---|---|---|
| `freeplay` | `set_created_items`, `set_respawn_items`, `set_skip_intro`, `set_disable_crashsite` | [lualib/other-functions.lua:421-452](https://github.com/RitnDev/RitnLib/blob/0.9.8/lualib/other-functions.lua#L421-L452) |
| `silo_script` | `set_no_victory` | [lualib/other-functions.lua:445](https://github.com/RitnDev/RitnLib/blob/0.9.8/lualib/other-functions.lua#L445) |
| `DiscoScience` | `setIngredientColor` | [classes/LuaClass/RitnEvent.lua:238](https://github.com/RitnDev/RitnLib/blob/0.9.8/classes/LuaClass/RitnEvent.lua#L238) |
| `<mod_name>` (dynamique) | `gui_action_<gui_name>` | [classes/LuaClass/RitnGui.lua:122](https://github.com/RitnDev/RitnLib/blob/0.9.8/classes/LuaClass/RitnGui.lua#L122) |

⚠ **Aucune** dépendance optionnelle n'est déclarée dans `info.json`. À ajouter au moins pour `gvv`, `zk-lib`, et les mods scénarios consommés.

## 10. APIs Factorio touchées (vue synthétique)

| Surface | Where | Usage type |
|---|---|---|
| `LuaPlayer.*` | RitnPlayer, RitnInventory, RitnGui, RitnInformatron | wrappers + GUI |
| `LuaSurface.find_entities_filtered`, `find_entity` | RitnSurface | recherche entité |
| `LuaForce.recipes/technologies/players` | RitnForce | navigation |
| `LuaForce.items_launched`, `rockets_launched` | RitnForce ([:42-43](https://github.com/RitnDev/RitnLib/blob/0.9.8/classes/LuaClass/RitnForce.lua#L42-L43)) | ⚠ **retiré en 2.0** |
| `LuaEntity.*` | RitnEntity, RitnTechnology, RitnSurface | manipulation entité |
| `data.raw[*]` | RitnPrototype + RitnProto* | mutation prototype |
| `data:extend({...})` | Sprite, CustomInput, ItemGroup, ItemSubgroup, RecipeCategory, FuelCategory, Setting, fonts, gui-style | déclaration |
| `defines.{events,controllers,inventory,gui_type,disconnect_reason}` | RitnEvent, RitnPlayer, RitnInventory | résolutions |
| `game.create_inventory` | RitnInventory | snapshot |
| `remote.add_interface/call` | core/interfaces, other-functions, RitnGui, RitnEvent | IPC |
| `script.*` (indirect) | core/eventListener | handler agrégé |
| `mod-gui` | RitnGui | (require seul, usages commentés) |
| `resource-autoplace` | lualib/vanilla/ores | autoplace minerais |
| `__base__.prototypes.entity.sounds` | lualib/vanilla/ores | accès direct mod base |

## 11. Couches d'erreur résiduelles (synthèse)

Voir [debt/known-bugs.md](debt/known-bugs.md) pour la liste exhaustive. Vue de surface :

- 🔴 **14 bugs P0** identifiés (typos, références à champs non initialisés, héritages cassés).
- 🟠 **10 zones API 1.x** mortes en 2.0 (`recipe.normal/expensive`, `force.items_launched`, `hr_version`, `icon_mipmaps`, `event.created_entity`, `data.raw.lab.inputs` format mixte).
- ⚠ **2 systèmes** au statut indéterminé : fork `eventListener`, intégration Informatron.

## 12. Sortie attendue post-refactor

| Version | Vague | Contenu |
|---|---|---|
| `0.10.0-fix` | R1 | Tous les P0 corrigés |
| `0.11.0` | R2 | Compat 2.0 (purge 1.x) |
| `0.12.0` | R3 | Décisions architecturales (ADR R3-A à R3-G) |
| `0.x.y+` | R4 | Qualité continue |

Détails dans le [plan de refactor](https://github.com/RitnDev/RitnLib/blob/0.9.8/docs/architecture.md#historique).

## Historique

| Date | Version pin | Changement |
|---|---|---|
| 2026-06-11 | 0.9.8 | Document initial (Phase 1 audit) |
