---
title: Carte des classes
type: reference
lang: fr
---

# Carte des classes


Cette page recense **toutes les classes publiques de RitnLib**, avec pour chacune : son fichier source, son mode d'accès, son héritage et une description courte. Pour comprendre comment ces classes s'empilent, voir [Architecture en 4 couches](../concepts/architecture-layers.md).

## Comment accéder à une classe

Deux modes d'accès selon la famille :

| Famille | Mode d'accès | Exemple |
|---|---|---|
| Classes runtime (`RitnLib*`) | **Globales** — injectées en `_G` par `core/setup-classes.lua`, aucun `require` | `local rPlayer = RitnLibPlayer(player)` |
| Classes data / settings (`RitnProto*`, `RitnIngredient`, `RitnLibSetting`) | **`require`** via le registre `ritnlib.defines` | `local Recipe = require(ritnlib.defines.class.prototype.recipe)` |

```lua
-- en tête de fichier data stage :
require("__RitnLib__.defines")          -- crée le global ritnlib (idempotent)
local Recipe = require(ritnlib.defines.class.prototype.recipe)
```

⚠ Les classes runtime produisent des **wrappers temporaires** : jamais dans `storage`. Voir la [règle d'or](../concepts/temporary-wrappers.md).

## Arbre d'héritage

```
RitnPrototype ──► tous les RitnProto* (sauf RitnProtoRecipeCategory, sans héritage)

RitnLibPlayer ──► RitnLibGui ──► RitnLibInformatron
```

Toutes les classes sont construites par la factory maison [`ritnlib.classFactory`](../adr/0001-class-factory.md) (`core/class.lua`).

## Classes runtime (control stage) — globales

| Classe | Fichier | Wrappe | Description |
|---|---|---|---|
| [`RitnLibEvent`](runtime/RitnLibEvent.md) | `classes/LuaClass/RitnEvent.lua` | n'importe quel event | Normalise le payload d'un event en champs prêts à l'emploi (`player`, `surface`, `force`, `entity`, `recipe`…). |
| [`RitnLibPlayer`](runtime/RitnLibPlayer.md) | `classes/LuaClass/RitnPlayer.lua` | `LuaPlayer` | Accès rapide aux infos joueur : force, surface, character, conduite, statut admin. |
| [`RitnLibSurface`](runtime/RitnLibSurface.md) | `classes/LuaClass/RitnSurface.lua` | `LuaSurface` | Recherche d'entités sur une surface. |
| [`RitnLibForce`](runtime/RitnLibForce.md) | `classes/LuaClass/RitnForce.lua` | `LuaForce` | Recettes, technologies, statistiques et lancements de rockets d'une force. |
| [`RitnLibEntity`](runtime/RitnLibEntity.md) | `classes/LuaClass/RitnEntity.lua` | `LuaEntity` | Manipulation d'entité : conducteur/passager de véhicule, destruction. |
| [`RitnLibRecipe`](runtime/RitnLibRecipe.md) | `classes/LuaClass/RitnRecipe.lua` | `LuaRecipe` | Activation/désactivation d'une recette au runtime. |
| [`RitnLibTechnology`](runtime/RitnLibTechnology.md) | `classes/LuaClass/RitnTechnology.lua` | `LuaTechnology` | Hook de fin de recherche d'une technologie. |
| [`RitnLibGui`](runtime/RitnLibGui.md) | `classes/LuaClass/RitnGui.lua` | event GUI | Dispatcher d'events GUI par convention de nommage des éléments. Hérite de `RitnLibPlayer`. |
| [`RitnLibInformatron`](runtime/RitnLibInformatron.md) | `classes/RitnClass/RitnInformatron.lua` | event Informatron | Intégration de pages Informatron. Hérite de `RitnLibGui`. Marquée `-- beta` dans `defines.lua`. |
| [`RitnLibInventory`](runtime/RitnLibInventory.md) | `classes/RitnClass/RitnInventory.lua` | `LuaPlayer` + table fournie | Snapshot et restauration d'inventaire joueur (le mod consommateur fournit la table de stockage). |
| [`RitnLibGuiElement`](runtime/RitnLibGuiElement.md) | `classes/RitnClass/gui/RitnGuiElement.lua` | payload `add{...}` | Builder fluent du payload de création d'un `LuaGuiElement`. |
| [`RitnLibStyle`](runtime/RitnLibStyle.md) | `classes/RitnClass/gui/RitnStyle.lua` | `LuaStyle` | Presets de style : étirement, alignement, visibilité, couleurs. |

Ces classes existent aussi en `require` (clés `ritnlib.defines.class.luaClass.*`, `ritnClass.*`, `gui.*`), mais c'est le chargement interne — en pratique tu utilises les globales.

## Classes data (data stage) — via `require`

Clé `defines` = à préfixer par `ritnlib.defines.class.` dans le `require`.

| Classe | Clé `defines` | Manipule | Description |
|---|---|---|---|
| [`RitnPrototype`](prototype/RitnPrototype.md) | `ritnClass.prototype` | `data.raw[type][name]` | Classe de base de tous les manipulateurs : copie du prototype + mutators génériques (`:changePrototype`, `:setPrototype`, `:update`…). |
| [`RitnProtoEntity`](prototype/RitnProtoEntity.md) | `prototype.entity` | `data.raw[<entity-type>]` | Entités, type auto-détecté. |
| [`RitnProtoItem`](prototype/RitnProtoItem.md) | `prototype.item` | `data.raw[<item-type>]` | Items, type auto-détecté. |
| [`RitnProtoRecipe`](prototype/RitnProtoRecipe.md) | `prototype.recipe` | `data.raw.recipe` | Recettes : ingrédients, résultats, activation. |
| [`RitnProtoTech`](prototype/RitnProtoTech.md) | `prototype.tech` (alias `technology`) | `data.raw.technology` | Technologies : coûts, packs de science, pré-requis, unlocks de recettes, disable en cascade. |
| [`RitnProtoOre`](prototype/RitnProtoOre.md) | `prototype.ore` | `data.raw.resource` + autoplace | Minerais et leur contrôle d'autoplacement. |
| [`RitnProtoSprite`](prototype/RitnProtoSprite.md) | `prototype.sprite` | `data.raw.sprite` + utility-sprites | Sprites. |
| [`RitnProtoStyle`](prototype/RitnProtoStyle.md) | `prototype.style` | `data.raw["gui-style"].default` | Styles GUI prototypés. |
| [`RitnProtoItemGroup`](prototype/RitnProtoItemGroup.md) | `prototype.group` | `data.raw["item-group"]` | Groupes d'items (onglets de crafting). |
| [`RitnProtoItemSubgroup`](prototype/RitnProtoItemSubgroup.md) | `prototype.subgroup` | `data.raw["item-subgroup"]` | Sous-groupes d'items (lignes de crafting). |
| [`RitnProtoRecipeCategory`](prototype/RitnProtoRecipeCategory.md) | `prototype.category` | `data.raw["recipe-category"]` | Catégories de recettes. ⚠ Déclarée **sans** héritage de `RitnPrototype` : les mutators génériques ne sont pas disponibles. |
| [`RitnProtoFuelCategory`](prototype/RitnProtoFuelCategory.md) | `prototype.fuelCategory` | `data.raw["fuel-category"]` | Catégories de carburant. |
| [`RitnProtoCustomInput`](prototype/RitnProtoCustomInput.md) | `prototype.customInput` | `data.raw["custom-input"]` | Raccourcis clavier custom. |
| [`RitnProtoUtilityConst`](prototype/RitnProtoUtilityConst.md) | `prototype.utility.constants` | `data.raw["utility-constants"].default` | Constantes d'interface du moteur. |
| [`RitnIngredient`](prototype/RitnIngredient.md) | `ritnClass.ingredient` | table ingrédient | Normalisation d'un ingrédient de recette. |

> Note : le nom de classe réel est **`RitnProtoTech`** (et non `RitnProtoTechnology`) — c'est lui qui apparaît dans `object_name` et dans les annotations LuaLS.

## Settings stage — via `require`

| Classe | Clé `defines` | Description |
|---|---|---|
| [`RitnLibSetting`](settings/RitnLibSetting.md) | `ritnClass.setting` | Builder fluent d'un prototype de mod-setting, enregistré via `data:extend`. ⚠ En l'état, seuls les settings **bool** fonctionnent (voir [bugs connus](../debt/known-bugs.md)). |

## Bibliothèques utilitaires (`lualib/`) — via `require`

Pas des classes, mais des modules de fonctions. Clés directes dans `ritnlib.defines` :

| Module | Clé `defines` | Description |
|---|---|---|
| [`other-functions`](lualib/other-functions.md) | `other` | `type()` custom (reconnaît `LuaPlayer`, `LuaEntity`…), `ifElse`, `tryCatch`, `uuid`, helpers freeplay. |
| [`table-functions`](lualib/table-functions.md) | `table` | Wrappers enrichis sur `table`. |
| [`string-functions`](lualib/string-functions.md) | `string` | Wrappers enrichis sur `string`. |
| [`json-functions`](lualib/json-functions.md) | `json` | Encode/décode JSON — embarque [rxi/json.lua](https://github.com/rxi/json.lua) (MIT). |
| [`entity-functions`](lualib/entity-functions.md) | *(require direct)* | Helpers de prototypes d'entités. |
| [`gui-functions`](lualib/gui-functions.md) | *(require direct)* | Helpers de prototypes GUI. |
| [`LuaStyle-functions`](lualib/LuaStyle-functions.md) | *(require direct)* | ⚠ Déprécié — remplacé par `RitnLibStyle`. |

## Couche fondation (`core/`)

| Fichier | Description |
|---|---|
| [`core/class.lua`](core/class-factory.md) | La factory `ritnlib.classFactory.newclass(super, init)` qui construit toutes les classes ci-dessus. Voir [ADR-0001](../adr/0001-class-factory.md). |
| [`core/constants.lua`](core/constants.md) | Tints de science packs, couleurs UI, marqueurs de chaînes, tailles d'ennemis. |
| [`core/eventListener.lua`](core/event-listener.md) | ⚠ Fork de `event_handler` au statut expérimental — non branché par `control.lua`. |
| [`core/interfaces.lua`](core/interfaces.md) | `remote.add_interface("RitnLib", {})` — interface vide aujourd'hui, réservée. |

## Voir aussi

- [Registre `ritnlib.defines`](defines.md)
- [Architecture en 4 couches](../concepts/architecture-layers.md)
- [Wrappers temporaires (règle d'or)](../concepts/temporary-wrappers.md)
- [Bugs connus](../debt/known-bugs.md)
