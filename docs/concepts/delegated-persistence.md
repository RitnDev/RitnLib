---
title: Persistance déléguée
type: concept
lang: fr
---

# Persistance déléguée

> **RitnLib ne touche jamais à `storage` directement. Chaque classe qui a besoin de persister des données le fait via une table que le mod consommateur lui fournit.**

C'est le principe de la persistance déléguée. Il s'applique principalement à `RitnLibInventory`, mais le pattern peut être réutilisé dans tes propres classes.

## Pourquoi

`storage` (appelé `global` en Factorio 1.x) est la seule table sérialisée par Factorio entre les saves. Mais RitnLib est une bibliothèque — elle ne sait pas comment ton mod organise son `storage`. Plutôt que d'imposer une structure, RitnLib te demande de lui passer la sous-table où elle doit écrire.

Avantages :
- Tu gardes le contrôle total de la structure de `storage`
- Plusieurs mods peuvent utiliser RitnLib sans conflits
- La logique de persistance est testable avec n'importe quelle table ordinaire

## Exemple concret — `RitnLibInventory`

`RitnLibInventory` prend en second argument la table où il doit sauvegarder l'inventaire :

```lua
script.on_event(defines.events.on_player_died, function(event)
    local player = game.get_player(event.player_index)

    -- On passe storage.inventories[index] comme "réceptacle" de la sauvegarde
    storage.inventories = storage.inventories or {}
    storage.inventories[event.player_index] = storage.inventories[event.player_index] or {}

    local inv = RitnLibInventory(player, storage.inventories[event.player_index])
    inv:save(true)   -- sauvegarde dans storage.inventories[index]
end)

script.on_event(defines.events.on_player_respawned, function(event)
    local player = game.get_player(event.player_index)

    if storage.inventories and storage.inventories[event.player_index] then
        local inv = RitnLibInventory(player, storage.inventories[event.player_index])
        inv:load(true)  -- restore depuis storage.inventories[index]
        storage.inventories[event.player_index] = nil
    end
end)
```

`RitnLibInventory` lit et écrit dans la table que tu lui passes — jamais dans `storage` directement.

## Ce que fait `RitnLibInventory` sous le capot

```lua
-- Lors du save() :
self.storage["main"] = {}
for i = 1, #self.player.get_main_inventory() do
    self.storage["main"][i] = self.player.get_main_inventory()[i]
end

-- Lors du load() :
for i, stack in pairs(self.storage["main"] or {}) do
    self.player.get_main_inventory()[i].set_stack(stack)
end
```

`self.storage` est la table que tu as passée en deuxième argument. RitnLib n'a jamais accès à `storage` global.

## Patron réutilisable

Tu peux appliquer le même principe dans tes propres classes :

```lua
local MonSysteme = ritnlib.classFactory.newclass(nil, function(self, storage_table)
    self.data = storage_table  -- pas de global, juste une référence
end)

function MonSysteme:set(key, value)
    self.data[key] = value
end

-- Usage
script.on_init(function()
    storage.mon_système = {}
end)

script.on_event(defines.events.on_player_created, function(event)
    local sys = MonSysteme(storage.mon_système)
    sys:set("last_joined", event.player_index)
end)
```

## Règle d'or

| ✅ Fais | ❌ Évite |
|---|---|
| Passe `storage.ma_sous_table` à la classe | Laisser la classe écrire dans `storage` directement |
| Initialise la sous-table avant de la passer | Passer `nil` (la classe ne peut pas écrire dans nil) |
| Re-instancie la classe à chaque handler | Stocker l'instance de classe entre les events |

## Voir aussi

- [Wrappers temporaires](temporary-wrappers.md)
- [Cycle de vie](life-cycle.md)
- [Référence : RitnLibInventory](../reference/runtime/RitnLibInventory.md)
