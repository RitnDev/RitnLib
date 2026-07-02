---
title: Modèle d'events
type: concept
lang: fr
---

# Modèle d'events

> **RitnLib n'enregistre aucun handler. C'est ton mod qui appelle `script.on_event`. RitnLib te donne juste `RitnLibEvent` pour normaliser le payload.**

## Principe

Factorio livre les events sous forme de tables brutes avec des champs variables selon l'event (`event.player_index`, `event.entity`, `event.surface_index`…). `RitnLibEvent` normalise tout ça en un seul objet cohérent.

```lua
-- Sans RitnLib
script.on_event(defines.events.on_built_entity, function(event)
    local player = game.get_player(event.player_index)  -- peut être nil
    local entity = event.created_entity                  -- absent si non applicable
    -- ...
end)

-- Avec RitnLib
script.on_event(defines.events.on_built_entity, function(event)
    local e = RitnLibEvent(event)
    local player = e:getPlayer()   -- RitnLibPlayer ou nil, jamais d'exception
    local entity = e:getEntity()   -- LuaEntity ou nil
    -- ...
end)
```

## Ce que fait `RitnLibEvent`

Le constructeur reçoit la table event brute et en extrait les champs courants :

| Champ | Source | Type |
|---|---|---|
| `e.player_index` | `event.player_index` | `uint?` |
| `e.surface_index` | `event.surface_index` | `uint?` |
| `e.entity` | `event.entity` | `LuaEntity?` |
| `e.name` | `event.name` | `uint` (defines.events.*) |
| `e.tick` | `event.tick` | `uint` |
| … | … | … |

Les méthodes `:getPlayer()`, `:getSurface()`, `:getForce()`, `:getEntity()` retournent des wrappers RitnLib ou `nil`. Elles ne lèvent jamais d'exception si le champ est absent.

## Aucun handler propre

RitnLib ne fait pas `script.on_event(...)`. Il n'a pas de boucle interne d'events. **C'est ton mod qui est responsable de s'abonner aux events Factorio.**

```lua
-- C'est TON control.lua qui fait ça :
script.on_event(defines.events.on_player_joined_game, function(event)
    local e = RitnLibEvent(event)
    -- ta logique ici
end)
```

## Plusieurs handlers sur le même event

RitnLib n'interfère pas avec Factorio's event dispatch. Tu peux avoir plusieurs `script.on_event` pour le même event dans ton mod, et les brancher sur différentes parties de ta logique.

```lua
local function handle_player_joined(event)
    local e = RitnLibEvent(event)
    local player = e:getPlayer()
    if not player then return end
    player:print("Bienvenue !")
end

local function log_player_joined(event)
    log("Player joined: " .. event.player_index)
end

script.on_event(defines.events.on_player_joined_game, handle_player_joined)
script.on_event(defines.events.on_player_joined_game, log_player_joined)
-- Les deux s'exécutent, dans cet ordre
```

## Events et `RitnLibGui`

`RitnLibGui` suit le même principe : c'est ton mod qui enregistre le handler `on_gui_click`, et qui instancie `RitnLibGui` à l'intérieur pour dispatcher l'action.

```lua
script.on_event(defines.events.on_gui_click, function(event)
    local gui = RitnLibGui(event, "mon-mod")
    gui:on_gui_click()  -- dispatche vers remote.call("mon-mod", "gui_action_<gui_name>", ...)
end)
```

Voir [Contrat remote consommateur](remote-contract.md) pour le détail du pattern GUI.

## Voir aussi

- [Wrappers temporaires](temporary-wrappers.md)
- [Contrat remote consommateur](remote-contract.md)
- [Référence : RitnLibEvent](../reference/runtime/RitnLibEvent.md)
- [Référence : RitnLibGui](../reference/runtime/RitnLibGui.md)
