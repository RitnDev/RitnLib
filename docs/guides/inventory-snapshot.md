---
title: Snapshot et restauration d'inventaire
type: guide
lang: fr
---

# Snapshot et restauration d'inventaire

Ce guide montre comment sauvegarder l'inventaire d'un joueur lors de sa mort et le restaurer à sa réapparition, en utilisant `RitnLibInventory` et la [persistance déléguée](../concepts/delegated-persistence.md).

## Principe

`RitnLibInventory` ne touche jamais à `storage` directement. Tu lui passes la sous-table où il doit écrire. C'est le pattern de persistance déléguée.

## Initialisation de storage

```lua
-- mon-mod/control.lua

script.on_init(function()
    storage.inventaires = {}
end)

script.on_configuration_changed(function()
    storage.inventaires = storage.inventaires or {}
end)
```

## Sauvegarder à la mort

```lua
script.on_event(defines.events.on_player_died, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    -- Prépare la sous-table pour ce joueur
    storage.inventaires[event.player_index] = {}

    -- Délègue la sauvegarde à RitnLibInventory
    local inv = RitnLibInventory(player, storage.inventaires[event.player_index])
    inv:save(true)
end)
```

`inv:save(true)` sauvegarde l'inventaire principal et le vide. Le `true` indique de vider l'inventaire source après la sauvegarde (pour éviter que Factorio ne lâche les items au sol).

## Restaurer à la réapparition

```lua
script.on_event(defines.events.on_player_respawned, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local snapshot = storage.inventaires[event.player_index]
    if not snapshot then return end

    local inv = RitnLibInventory(player, snapshot)
    inv:load(true)

    -- Nettoie la snapshot une fois restaurée
    storage.inventaires[event.player_index] = nil
end)
```

`inv:load(true)` restaure l'inventaire depuis la sous-table passée. Après ça, nettoie l'entrée dans `storage` pour éviter une restauration double.

## Pattern complet

```lua
-- mon-mod/control.lua

script.on_init(function()
    storage.inventaires = {}
end)

script.on_configuration_changed(function()
    storage.inventaires = storage.inventaires or {}
end)

script.on_event(defines.events.on_player_died, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    storage.inventaires[event.player_index] = {}
    local inv = RitnLibInventory(player, storage.inventaires[event.player_index])
    inv:save(true)
end)

script.on_event(defines.events.on_player_respawned, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local snapshot = storage.inventaires[event.player_index]
    if not snapshot then return end

    local inv = RitnLibInventory(player, snapshot)
    inv:load(true)
    storage.inventaires[event.player_index] = nil
end)
```

## Ce que fait `RitnLibInventory` sous le capot

Il lit et écrit dans la table que tu lui passes — jamais dans `storage` directement :

```lua
-- Pendant save() :
self.storage["main"] = {}
for i = 1, #player.get_main_inventory() do
    self.storage["main"][i] = player.get_main_inventory()[i]
end

-- Pendant load() :
for i, stack in pairs(self.storage["main"] or {}) do
    player.get_main_inventory()[i].set_stack(stack)
end
```

## Règles importantes

| ✅ Fais | ❌ Évite |
|---|---|
| Initialiser `storage.inventaires[index] = {}` **avant** le `RitnLibInventory(...)` | Passer `nil` comme storage_table (erreur silencieuse) |
| Nettoyer `storage.inventaires[index] = nil` après `load()` | Laisser traîner d'anciennes snapshots |
| Ré-instancier `RitnLibInventory` à chaque handler | Stocker l'instance entre les handlers |

## Voir aussi

- [Persistance déléguée](../concepts/delegated-persistence.md)
- [Wrappers temporaires](../concepts/temporary-wrappers.md)
- [Référence : RitnLibInventory](../reference/runtime/RitnLibInventory.md)
