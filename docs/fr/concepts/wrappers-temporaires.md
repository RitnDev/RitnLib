---
title: Wrappers temporaires (règle d'or)
type: concept
lang: fr
applies_to: runtime
---

# Wrappers temporaires — règle d'or

> **Les classes `RitnLib*` runtime sont des vues, pas des entités. Tu en crées une dans un handler, tu l'utilises, tu la jettes.**

C'est **la** règle à connaître avant de toucher à `RitnLibPlayer`, `RitnLibEntity`, `RitnLibSurface`, `RitnLibForce`, `RitnLibEvent`, `RitnLibRecipe`, `RitnLibTechnology`, `RitnLibGui`. Si tu l'ignores, tu vas tomber sur des bugs étranges, intermittents, qui survivent aux saves.

## Pourquoi

Quand tu instancies un wrapper, son constructeur fait une **capture statique** des propriétés Factorio. Exemple avec `RitnLibPlayer` :

```lua
RitnLibPlayer = ritnlib.classFactory.newclass(function(self, LuaPlayer)
    self.player = LuaPlayer
    self.index = LuaPlayer.index
    self.surface = LuaPlayer.surface            -- ← capture
    self.force = LuaPlayer.force                -- ← capture
    self.controller_type = LuaPlayer.controller_type  -- ← capture
    self.controller_name = getControllerName(LuaPlayer)
    self.character = LuaPlayer.character        -- ← capture
    self.driving = LuaPlayer.driving            -- ← capture
    self.vehicle = LuaPlayer.vehicle            -- ← capture
    self.connected = LuaPlayer.connected        -- ← capture
    -- ...
end)
```

Toutes ces propriétés **changent au cours du jeu** : un joueur change de surface, passe en mode édition (`controller_type` change), monte dans un véhicule, se déconnecte. Le wrapper, lui, garde ses valeurs initiales.

Si tu réutilises le wrapper plus tard, tu lis des valeurs obsolètes — sans qu'aucune erreur ne soit levée. Le `self.player` reste valide (c'est une référence `LuaPlayer`) mais `self.surface`, `self.driving`, etc. ne reflètent plus la réalité.

## Bonne pratique

Instancie le wrapper **dans le handler qui en a besoin**, juste avant de l'utiliser :

```lua
script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = RitnLibPlayer(game.get_player(event.player_index))
    if player.isPresent then
        player:print("Tu es maintenant sur " .. player.surface.name)
    end
end)
```

Le wrapper meurt en sortie de fonction. Au prochain event, tu en crées un nouveau, qui reflète l'état du moment.

## À ne pas faire

### ❌ Stocker le wrapper dans `storage`

```lua
-- NE FAIS PAS ÇA
script.on_init(function()
    storage.player_wrapper = RitnLibPlayer(game.get_player(1))
end)
```

Pourquoi c'est cassé :
1. Au save, Factorio sait sérialiser le `LuaPlayer` interne (c'est un userdata géré). Mais les copies scalaires (`self.surface`, `self.controller_type`…) sont sérialisées comme des valeurs **figées au moment de l'init**.
2. Au load, Factorio restaure ces scalaires tels quels — même si le joueur a changé de surface dix fois entre temps.
3. Tu te retrouves avec un objet dont `self.surface` pointe vers une `LuaSurface` qui n'est plus la surface courante du joueur.

### ❌ Garder le wrapper entre deux events

```lua
-- NE FAIS PAS ÇA
local cached_wrapper

script.on_event(defines.events.on_player_created, function(event)
    cached_wrapper = RitnLibPlayer(game.get_player(event.player_index))
end)

script.on_event(defines.events.on_player_changed_surface, function(event)
    cached_wrapper:print("Nouvelle surface : " .. cached_wrapper.surface.name)
    -- ⚠ cached_wrapper.surface est l'ANCIENNE surface, pas la nouvelle
end)
```

La variable `cached_wrapper` survit entre les events (elle est dans l'upvalue de `control.lua`), mais ses champs scalaires sont gelés au moment de l'instanciation.

### ❌ Réutiliser un `RitnLibEvent` au-delà de son event

```lua
-- NE FAIS PAS ÇA
local last_event

script.on_event(defines.events.on_built_entity, function(event)
    last_event = RitnLibEvent(event)
end)

script.on_event(defines.events.on_tick, function()
    if last_event then
        log("Dernière entité : " .. last_event.entity.name)
        -- ⚠ last_event.entity peut avoir été détruite depuis
    end
end)
```

Le `LuaEntity` interne peut avoir été invalidé (`entity.valid == false`) — toutes les opérations sur le wrapper lèveront une exception.

## Cas où c'est OK de conserver

Tu peux stocker en `storage` les **valeurs primitives extraites** du wrapper, jamais le wrapper lui-même :

```lua
-- ✅ OK
script.on_event(defines.events.on_player_created, function(event)
    local p = RitnLibPlayer(game.get_player(event.player_index))
    storage.player_names = storage.player_names or {}
    storage.player_names[p.index] = p.name  -- on stocke la string, pas le wrapper
end)
```

Ou stocke le `LuaPlayer` brut (Factorio sait le persister) et re-wrappe à chaque besoin :

```lua
-- ✅ OK aussi
script.on_event(defines.events.on_player_created, function(event)
    storage.tracked_players = storage.tracked_players or {}
    table.insert(storage.tracked_players, game.get_player(event.player_index))
end)

script.on_event(defines.events.on_tick, function()
    for _, raw_player in pairs(storage.tracked_players or {}) do
        if raw_player.valid then
            local p = RitnLibPlayer(raw_player)  -- wrapper neuf à chaque tick
            -- ...
        end
    end
end)
```

## Récapitulatif

| ✅ Fais | ❌ Évite |
|---|---|
| `RitnLibPlayer(player)` dans le handler | `storage.wrapper = RitnLibPlayer(...)` |
| Re-instancier à chaque besoin | Réutiliser un wrapper d'un event à l'autre |
| Stocker le `LuaPlayer` brut | Stocker le wrapper |
| Stocker des primitives extraites (string, index, position) | Stocker l'objet wrapper |

## Classes concernées

Toute classe sous `classes/LuaClass/` :
- [`RitnLibEvent`](../reference/runtime/RitnLibEvent.md)
- [`RitnLibPlayer`](../reference/runtime/RitnLibPlayer.md)
- [`RitnLibSurface`](../reference/runtime/RitnLibSurface.md)
- [`RitnLibForce`](../reference/runtime/RitnLibForce.md)
- [`RitnLibEntity`](../reference/runtime/RitnLibEntity.md)
- [`RitnLibRecipe`](../reference/runtime/RitnLibRecipe.md)
- [`RitnLibTechnology`](../reference/runtime/RitnLibTechnology.md)
- [`RitnLibGui`](../reference/runtime/RitnLibGui.md)
- [`RitnLibInformatron`](../reference/runtime/RitnLibInformatron.md)

**Exception** : `RitnLibInventory` est un cas particulier — la *table* qu'il reçoit en deuxième argument est par contre persistante (c'est même le but). Voir [Persistance déléguée](persistance-deleguee.md) pour le détail.

## Voir aussi

- [Architecture en 4 couches](architecture-couches.md)
- [Modèle d'events](event-model.md)
- [Persistance déléguée](persistance-deleguee.md)
