---
title: Architecture en 4 couches
type: concept
lang: fr
---

# Architecture en 4 couches

RitnLib est organisé en **4 couches superposées**. Comprendre où vit chaque chose te permet de require le bon fichier au bon stage, et d'éviter les chargements inutiles.

```
┌────────────────────────────────────────────────────────────────┐
│  4. Assets data                  prototypes/                   │
│  (require depuis ton data.lua)   fonts.lua, gui-style.lua      │
├────────────────────────────────────────────────────────────────┤
│  3. Classes                      classes/                      │
│  ┌─────────────────┬─────────────────┬─────────────────────┐  │
│  │  prototypes/    │  RitnClass/     │  LuaClass/          │  │
│  │  (data stage)   │  (hybride)      │  (control stage)    │  │
│  │                 │                 │                     │  │
│  │  RitnProto*     │  Setting,       │  Player, Surface,   │  │
│  │  (recette,      │  Inventory,     │  Force, Entity,     │  │
│  │   techno,       │  Ingredient,    │  Event, Recipe,     │  │
│  │   item, ore…)   │  Prototype,     │  Technology, Gui    │  │
│  │                 │  Informatron,   │                     │  │
│  │                 │  gui/Element,   │                     │  │
│  │                 │  gui/Style      │                     │  │
│  └─────────────────┴─────────────────┴─────────────────────┘  │
├────────────────────────────────────────────────────────────────┤
│  2. Utilities                    lualib/                       │
│  table, string, json, other, gui, entity, LuaStyle             │
│  vanilla/{util, crash-site, ores, types_*}                     │
│  informatron/{menu, pages}                                     │
├────────────────────────────────────────────────────────────────┤
│  1. Fondation                    core/                         │
│  class.lua          → factory de classes                       │
│  constants.lua      → tints, colors, strings                   │
│  eventListener.lua  → fork event_handler (statut incertain)    │
│  interfaces.lua     → remote.add_interface("RitnLib", …)       │
│  setup-classes.lua  → chargeur des classes runtime             │
├────────────────────────────────────────────────────────────────┤
│  Bootstrap                       defines.lua + control.lua     │
│  global ritnlib + ritnlib.classFactory                         │
└────────────────────────────────────────────────────────────────┘
```

## Couche 1 — Fondation (`core/`)

Le plus bas niveau. Trois bricks essentielles :

- **`core/class.lua`** : la factory `ritnlib.classFactory.newclass(super, init)` qui sert à construire **toutes** les classes de la lib. Héritage simple, `:is_a()`, constructeur via `__call`.
- **`core/constants.lua`** : tables partagées de tints colorimétriques (pour les `science-pack`), couleurs UI, marqueurs de chaînes, tailles d'ennemis.
- **`core/setup-classes.lua`** : exécuté par `control.lua`, instancie en `_G` toutes les classes runtime.

Tu n'interagis quasi jamais directement avec cette couche. Elle sert la couche 3.

## Couche 2 — Utilities (`lualib/`)

Bibliothèques de fonctions pures, sans état :

- `other-functions.lua` — `type()` custom qui reconnaît `LuaPlayer`/`LuaEntity`, helpers `ifElse`, `tryCatch`, `uuid`, helpers freeplay.
- `table-functions.lua`, `string-functions.lua` — wrappers enrichis sur `table` et `string`.
- `json-functions.lua` — [rxi/json.lua](https://github.com/rxi/json.lua) (MIT) intact.
- `entity-functions.lua`, `gui-functions.lua`, `LuaStyle-functions.lua` — helpers de prototypes graphiques.
- `vanilla/util.lua`, `crash-site.lua`, `ores.lua`, `types_*.lua` — forks de fichiers du moteur (`util`, `crash-site`) et listes de types pour résolution dynamique.
- `informatron/menu.lua`, `pages.lua` — squelettes pour l'intégration Informatron (⚠ inachevée).

Ces utilitaires sont consommés par la couche 3 mais peuvent aussi être require directement par un mod client.

## Couche 3 — Classes (`classes/`)

Le cœur de l'API publique. Trois familles :

### 3a — `classes/LuaClass/` (control stage)
Wrappers runtime sur les objets Factorio :

| Classe | Wrappe | Spécialité |
|---|---|---|
| `RitnLibEvent` | event Factorio | normalise tout event (player, surface, force, entity…) |
| `RitnLibPlayer` | `LuaPlayer` | impression, force, surface, character |
| `RitnLibSurface` | `LuaSurface` | recherche d'entités |
| `RitnLibForce` | `LuaForce` | recettes, technos, stats, chart tags |
| `RitnLibEntity` | `LuaEntity` | conducteur/passager, destruction |
| `RitnLibRecipe` | `LuaRecipe` | activation runtime |
| `RitnLibTechnology` | `LuaTechnology` | hook fin de recherche |
| `RitnLibGui` | event GUI | dispatcher de clic |

Ces classes sont **toutes injectées en `_G`** par `core/setup-classes.lua` lors du chargement de RitnLib. Tu les utilises sans `require`.

### 3b — `classes/RitnClass/` (mixte data/control)
Classes hybrides ou plus complexes :

- `RitnPrototype` — base de tous les manipulateurs de prototypes.
- `RitnIngredient` — normalisation d'ingrédient.
- `RitnLibInventory` — snapshot/restore d'inventaire (control).
- `RitnLibSetting` — builder de settings (settings stage).
- `RitnLibInformatron` — extension GUI pour Informatron (hérite de `RitnLibGui`).
- `gui/RitnGuiElement`, `gui/RitnStyle` — builders GUI.

### 3c — `classes/prototypes/` (data stage)
Manipulateurs de `data.raw` :

| Classe | Manipule |
|---|---|
| `RitnProtoEntity` | `data.raw[<entity-type>]` (auto-détection) |
| `RitnProtoItem` | `data.raw[<item-type>]` (auto-détection) |
| `RitnProtoRecipe` | `data.raw.recipe` |
| `RitnProtoTechnology` | `data.raw.technology` |
| `RitnProtoOre` | `data.raw.resource` + `data.raw["autoplace-control"]` |
| `RitnProtoSprite` | `data.raw.sprite` + `utility-sprites.default` |
| `RitnProtoStyle` | `data.raw["gui-style"].default[<style>]` |
| `RitnProtoItemGroup`, `RitnProtoItemSubgroup` | groupes |
| `RitnProtoRecipeCategory`, `RitnProtoFuelCategory` | catégories |
| `RitnProtoCustomInput` | `data.raw["custom-input"]` |
| `RitnProtoUtilityConst` | `data.raw["utility-constants"].default[<key>]` |

Toutes les `RitnProto*` héritent de `RitnPrototype` et exposent les méthodes communes (`:changePrototype`, `:changeSubgroup`, `:setPrototype`, `:update`).

## Couche 4 — Assets data (`prototypes/`)

Fichiers data stage **prêts à require** depuis le `data.lua` d'un mod consommateur :

- `prototypes/fonts.lua` — `data:extend({...})` des polices `ritn-default-{12..20}` (normal + bold).
- `prototypes/gui-style.lua` — mutations sur `data.raw['gui-style'].default` pour produire un set de styles `*-ritngui` (flow, frame, label, scroll-pane).

Ces fichiers ne sont **pas** chargés automatiquement par RitnLib. Tu dois les require explicitement :

```lua
-- mon-mod/data.lua
require("__RitnLib__.defines")
require(ritnlib.defines.fonts)      -- charge prototypes/fonts.lua
require(ritnlib.defines.gui_styles) -- charge prototypes/gui-style.lua
```

## Bootstrap

Quand Factorio charge RitnLib, voici ce qui s'exécute :

```
RitnLib/control.lua
   ├─► require('core.setup-classes')
   │     ├─► require('__RitnLib__.defines')      ← crée le global ritnlib
   │     │     └─► require(ritnlib.defines.class.core)  ← classFactory
   │     └─► require(...) × N classes runtime    ← s'inscrivent en _G
   ├─► require('core.interfaces')
   │     └─► remote.add_interface("RitnLib", {})  ← interface remote (vide aujourd'hui)
   └─► require("__gvv__.gvv")()                   ← seulement si gvv est actif
```

**Important** : aucun `script.on_event` n'est enregistré, aucun accès à `storage`. RitnLib est **passif** côté runtime. Tu enregistres tes propres handlers comme d'habitude — RitnLib t'aide à les écrire courts.

## Voir aussi

- [Cycle de vie data → settings → control](cycle-de-vie.md)
- [Wrappers temporaires](wrappers-temporaires.md)
- [Factory de classes orientée objet maison](factory-oo.md)
- [Carte des classes](../reference/overview.md)
