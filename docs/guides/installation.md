---
title: Guide d'installation
type: guide
lang: fr
---

# Guide d'installation

## 1. Installer RitnLib

### Via le Mod Portal (recommandé)

Dans Factorio : **Mods → Parcourir en ligne → rechercher "RitnLib"** → Télécharger.

RitnLib sera automatiquement actif pour toutes les parties où il est en dépendance.

### Manuellement / en développement

Clone le dépôt dans le dossier `mods/` de Factorio :

```
Factorio/
└─ mods/
   └─ RitnLib/          ← nom du dossier EXACT (pas RitnLib-main, pas RitnLib-0.10.1)
      ├─ info.json
      ├─ control.lua
      └─ ...
```

> Le nom du dossier doit être **exactement** `RitnLib`. Factorio identifie le mod par ce nom.

## 2. Déclarer la dépendance

Dans l'`info.json` de ton mod :

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

Factorio charge RitnLib **avant** ton mod aux trois stages (settings, data, runtime).

## 3. Vérifier l'installation

Lance Factorio et charge une partie. Dans ton `control.lua`, un test rapide :

```lua
script.on_event(defines.events.on_player_created, function(event)
    local player = RitnLibPlayer(game.get_player(event.player_index))
    player:print("RitnLib fonctionne !")
end)
```

Si tu vois le message en jeu, l'installation est bonne. Si `RitnLibPlayer` est `nil`, vérifie que la dépendance est bien déclarée dans `info.json`.

## 4. Autocomplétion IDE (LuaLS / VS Code)

RitnLib embarque des annotations LuaLS dans son dossier `types/`. Elles sont incluses dans le zip du mod pour les développeurs consommateurs.

**Prérequis** : extension [Lua Language Server](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) dans VS Code.

### Configuration `.luarc.json`

À la racine de **ton** mod, crée `.luarc.json` :

```json
{
  "workspace.library": [
    "C:/Users/TONNOM/AppData/Roaming/Factorio/mods/RitnLib/types"
  ],
  "runtime.version": "Lua 5.2"
}
```

Adapte le chemin vers le dossier `types/` de RitnLib selon ton système. Après ça, tu obtiens l'autocomplétion sur `RitnLibPlayer`, `RitnLibEvent`, `RitnProtoRecipe`, etc. directement dans VS Code.

## 5. Structure minimale d'un mod consommateur

```
mon-mod/
├─ info.json          ← dépendance RitnLib déclarée
├─ settings.lua       ← (optionnel) RitnLibSetting
├─ data.lua           ← require("__RitnLib__.defines") + RitnProto*
├─ control.lua        ← handlers avec RitnLib* disponibles en _G
└─ .luarc.json        ← (dev) chemin vers types/ de RitnLib
```

## Voir aussi

- [Démarrer avec RitnLib](../getting-started.md)
- [Mon premier prototype](first-prototype.md)
- [Mon premier handler runtime](first-handler.md)
