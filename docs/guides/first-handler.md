---
title: Mon premier handler runtime
type: guide
lang: fr
---

# Mon premier handler runtime

Ce guide montre comment écrire des handlers d'événements Factorio au **runtime stage** avec les classes RitnLib.

## Principe

Au runtime stage, toutes les classes `RitnLib*` sont injectées en `_G` par le `control.lua` de RitnLib. Pas besoin de `require`. Tu peux les utiliser directement dans tes handlers.

**RitnLib n'enregistre aucun handler propre.** Tous les `script.on_event(...)` viennent de ton mod.

## Exemple minimal

```lua
-- mon-mod/control.lua

script.on_event(defines.events.on_player_joined_game, function(event)
    local e      = RitnLibEvent(event)
    local player = e:getPlayer()
    if not player then return end

    player:print("Bienvenue dans la partie !")
end)
```

`RitnLibEvent` normalise le payload de l'event brut. `e:getPlayer()` retourne un `RitnLibPlayer` ou `nil` si `player_index` est absent — sans jamais lever d'erreur.

## `RitnLibEvent` — normalisation du payload

```lua
script.on_event(defines.events.on_built_entity, function(event)
    local e      = RitnLibEvent(event)
    local player = e:getPlayer()   -- RitnLibPlayer ou nil
    local entity = e:getEntity()   -- LuaEntity ou nil
    local surface = e:getSurface() -- RitnLibSurface ou nil

    if player and entity then
        player:print("Tu as construit : " .. entity.name)
    end
end)
```

## `RitnLibPlayer` — interactions joueur

`RitnLibPlayer` wrape un `LuaPlayer`. Il expose les méthodes courantes :

```lua
script.on_event(defines.events.on_player_created, function(event)
    local player = RitnLibPlayer(game.get_player(event.player_index))

    -- Afficher un message
    player:print("Bienvenue !")

    -- Lire la force
    local force = player:getForce()   -- RitnLibForce

    -- Accès au LuaPlayer sous-jacent
    local lp = player.player
    log("Nom : " .. lp.name)
end)
```

> `RitnLibPlayer` est un wrapper temporaire — ne le stocke pas dans `storage`. Ré-instancie-le à chaque handler. Voir [Wrappers temporaires](../concepts/temporary-wrappers.md).

## `RitnLibForce` — opérations sur une force

```lua
script.on_event(defines.events.on_research_finished, function(event)
    local e     = RitnLibEvent(event)
    local force = e:getForce()   -- RitnLibForce ou nil
    if not force then return end

    -- Activer une technologie
    force:setTechnology("advanced-electronics", true)
end)
```

## `RitnLibTechnology` — gestion des technologies

```lua
local function unlock_starting_tech(player)
    local tech = RitnLibTechnology(player:getForce(), "automation")
    tech:research()   -- débloque la technologie immédiatement
end
```

## Initialiser `storage`

```lua
script.on_init(function()
    -- Initialise tes tables de storage ici
    storage.mes_donnees = {}
end)

script.on_configuration_changed(function(data)
    -- Migration si le mod est mis à jour
    storage.mes_donnees = storage.mes_donnees or {}
end)
```

`on_init` s'exécute à la création d'une nouvelle partie. `on_configuration_changed` s'exécute quand les mods changent (ajout, mise à jour, suppression) dans une partie existante.

## Plusieurs handlers sur le même event

```lua
-- Les deux s'exécutent, dans l'ordre d'enregistrement
script.on_event(defines.events.on_player_joined_game, function(event)
    local e = RitnLibEvent(event)
    local player = e:getPlayer()
    if player then player:print("Bienvenue !") end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    log("Joueur connecté : " .. event.player_index)
end)
```

## Règle importante

| ✅ Fais | ❌ Évite |
|---|---|
| Ré-instancier `RitnLibPlayer(...)` à chaque handler | Stocker un `RitnLibPlayer` dans `storage` |
| Vérifier `if not player then return end` | Supposer que `e:getPlayer()` n'est jamais nil |
| Utiliser `on_init` pour initialiser `storage` | Accéder à `storage` sans initialisation préalable |

## Voir aussi

- [Modèle d'événements](../concepts/event-model.md)
- [Wrappers temporaires](../concepts/temporary-wrappers.md)
- [Pattern GUI complet](gui-pattern.md)
- [Référence : RitnLibEvent](../reference/runtime/RitnLibEvent.md)
- [Référence : RitnLibPlayer](../reference/runtime/RitnLibPlayer.md)
