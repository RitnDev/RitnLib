---
title: Démarrer avec RitnLib
audience: consumer
lang: fr
---

# Démarrer avec RitnLib

Ce guide montre comment intégrer RitnLib à un mod Factorio (nouveau ou existant). À la fin, ton mod consomme RitnLib aux trois stages : **data**, **settings** et **control**.

## 1. Installer le mod

Deux options :

- **En jeu** : s'abonner au mod [RitnLib sur le Mod Portal](https://mods.factorio.com/mod/RitnLib).
- **Manuel** : cloner ou télécharger ce dépôt dans `Factorio/mods/RitnLib/`. Le dossier doit s'appeler **exactement** `RitnLib` — pas `RitnLib-main` après un téléchargement GitHub.

Vérifie que `Factorio/mods/RitnLib/info.json` existe et que sa `factorio_version` correspond à la tienne (actuellement `2.0`).

## 2. Déclarer la dépendance dans ton mod

Dans le `info.json` de ton propre mod, ajoute `"RitnLib"` aux `dependencies` :

```json
{
  "name": "mon-mod",
  "version": "0.1.0",
  "factorio_version": "2.0",
  "title": "Mon mod",
  "author": "moi",
  "dependencies": [
    "base",
    "RitnLib"
  ]
}
```

Factorio garantit que RitnLib sera chargé **avant** ton mod aux trois stages.

## 3. Premier usage — data stage

Au data stage, RitnLib n'exécute rien automatiquement, mais il expose ses manipulateurs via le registre `ritnlib.defines`.

Crée `mon-mod/data.lua` :

```lua
require("__RitnLib__.defines")

local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)

-- Ajouter un câble de cuivre à la recette d'automation-science-pack
RitnProtoRecipe("automation-science-pack")
    :addIngredient({"copper-cable", 1})
```

**À retenir** :
- `require("__RitnLib__.defines")` peuple le global `ritnlib`. À faire une fois en haut du fichier ; les require suivants sont idempotents.
- `ritnlib.defines.class.prototype.recipe` est un **chemin abstrait** — RitnLib le résout vers le fichier source actuel. Pas besoin de hard-coder `__RitnLib__/classes/prototypes/Recipe`.
- Les classes de prototype (`RitnProto*`) s'utilisent en `local … = require(...)` — elles ne polluent pas `_G`.

Pour aller plus loin (recettes, technos, items, minerais, etc.) : [Mon premier prototype](guides/first-prototype.md).

## 4. Premier usage — control stage

Au control stage, les classes runtime de RitnLib sont **déjà disponibles en `_G`** (RitnLib s'en occupe à son chargement). Tu peux les utiliser directement.

Crée `mon-mod/control.lua` :

```lua
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    RitnLibPlayer(player):print("Bienvenue ! Tu joues avec mon-mod.")
end)

script.on_event(defines.events.on_research_finished, function(event)
    local tech = RitnLibTechnology(event.research)
    log("Recherche terminée : " .. tech.name)
end)
```

**À retenir** :
- Pas de `require` pour les classes runtime — elles sont en global (`RitnLibPlayer`, `RitnLibTechnology`, `RitnLibEvent`, `RitnLibSurface`, etc.).
- Ce sont des **vues temporaires** : tu en crées une nouvelle à chaque event. **Ne jamais** les stocker dans `storage`. Voir [Wrappers temporaires](concepts/temporary-wrappers.md) pour le détail.

Pour les patterns plus avancés (snapshot d'inventaire, GUI, désactivation cascade de recettes) : [Mon premier handler runtime](guides/first-handler.md).

## 5. Premier usage — settings stage

Crée `mon-mod/settings.lua` :

```lua
require("__RitnLib__.defines")

local RitnLibSetting = require(ritnlib.defines.class.ritnClass.setting)

RitnLibSetting("mon-mod-enable-feature-x")
    :setSettingStartup()
    :setDefaultValueBool(true)
    :new()
```

Le `:new()` final déclenche le `data:extend({...})` qui enregistre le setting auprès de Factorio. Tu verras le toggle apparaître dans **Settings → Mods → Startup** avec la clé `mon-mod-enable-feature-x`.

> ⚠ **0.9.8 — limitation connue** : le setter `:setTypeBoolean()` ne fonctionne pas (cf. [BUG-009](debt/known-bugs.md)). Heureusement le constructeur initialise déjà `dataType = "bool"`, donc le chaînage ci-dessus produit bien un `bool-setting`. Pour les autres types (`int`, `double`, `string`, `color`), attendre la version `0.10.0-fix` ou les ajouter manuellement à `self.data_setting.type`.

## 6. Vérifier que ça tourne

Lance Factorio. Ouvre **Settings → Mods → Startup** et vérifie que `mon-mod-enable-feature-x` apparaît.

Charge une partie de test. Le message « Bienvenue ! » devrait s'afficher au moment où le joueur arrive sur la carte.

Si ce n'est pas le cas, ouvre `factorio-current.log` (Windows : `%appdata%\Factorio\`, Linux : `~/.factorio/`) pour lire les erreurs. Les messages préfixés `RitnLib` ou `RitnProto*` viennent de la lib.

## La suite

- 🧩 [Architecture en 4 couches](concepts/architecture-layers.md) — comprendre comment RitnLib est organisé.
- ⚠ [Wrappers temporaires](concepts/temporary-wrappers.md) — la **règle d'or** à connaître avant de toucher aux classes runtime.
- 🗺 [Carte des classes](reference/overview.md) — lister tout ce qui est disponible.
- 📖 Les [guides](guides/installation.md) couvrent les patterns avancés (snapshot d'inventaire, GUI complète, désactivation cascade, etc.).
