# RitnLib

> **FR** — Bibliothèque pour mods Factorio : raccourcis sur `data.raw`, wrappers sur les classes runtime (`LuaPlayer`, `LuaForce`, `LuaEntity`…), constructeur de GUI, builder de mod settings, snapshot d'inventaires.
>
> **EN** — Library for Factorio mods: shortcuts over `data.raw`, wrappers for the runtime classes (`LuaPlayer`, `LuaForce`, `LuaEntity`…), GUI builder, mod settings builder, inventory snapshot.

---

## 🇫🇷 Français

**RitnLib** est un *library mod* pour Factorio 2.0. Il n'ajoute rien au jeu — il sert de **dépendance à d'autres mods** pour raccourcir les patterns Factorio qui reviennent dans tout mod un peu sérieux : modifier `data.raw`, manipuler des entités, gérer des events, monter une GUI, créer des settings, sauvegarder un inventaire…

### Concrètement, à quoi ça ressemble

**Sans RitnLib**, snapshot et restauration d'inventaire au respawn :

```lua
script.on_event(defines.events.on_player_died, function(event)
    storage.snapshots = storage.snapshots or {}
    local player = game.get_player(event.player_index)
    if not storage.snapshots[player.name] then
        storage.snapshots[player.name] = {
            [defines.inventory.character_main]  = game.create_inventory(65535),
            [defines.inventory.character_guns]  = game.create_inventory(65535),
            [defines.inventory.character_ammo]  = game.create_inventory(65535),
            [defines.inventory.character_armor] = game.create_inventory(65535),
            [defines.inventory.character_trash] = game.create_inventory(65535),
        }
    end
    for define, snapshot in pairs(storage.snapshots[player.name]) do
        local inv = player.get_inventory(define)
        for i = 1, #inv do
            if inv[i].valid then snapshot[i].swap_stack(inv[i]) end
        end
    end
end)

script.on_event(defines.events.on_player_respawned, function(event)
    -- … miroir du bloc ci-dessus, dans l'autre sens …
end)
```

**Avec RitnLib** :

```lua
script.on_event(defines.events.on_player_died, function(event)
    storage.snapshots = storage.snapshots or {}
    RitnLibInventory(game.get_player(event.player_index), storage.snapshots):save()
end)

script.on_event(defines.events.on_player_respawned, function(event)
    RitnLibInventory(game.get_player(event.player_index), storage.snapshots):load()
end)
```

C'est l'idée pour chaque sous-système : tu écris **ce que tu veux faire**, RitnLib s'occupe de la plomberie Factorio.

### Ce qu'il y a dedans

#### Data stage — manipuler `data.raw`
- `RitnProtoRecipe` — désactiver, cacher, modifier ingrédients, changer le tint des packs de science.
- `RitnProtoTechnology` — désactiver (avec purge des prerequisites), ajouter/retirer/remplacer des packs, gérer les `lab.inputs`, débloquer/retirer des recettes.
- `RitnProtoEntity`, `RitnProtoItem`, `RitnProtoOre` (avec autoplace), `RitnProtoSprite`, `RitnProtoStyle`.
- `RitnProtoItemGroup`, `RitnProtoItemSubgroup`, `RitnProtoRecipeCategory`, `RitnProtoFuelCategory`, `RitnProtoCustomInput`, `RitnProtoUtilityConst`.
- Polices `ritn-default-{12..20}` (normal + bold) et un set de styles GUI `*-ritngui` prêts à require.
- Helpers pour `data.raw['gui-style'].default` et fork local du `util.lua` du moteur.

#### Control stage — runtime
- Wrappers : `RitnLibPlayer`, `RitnLibSurface`, `RitnLibForce`, `RitnLibEntity`, `RitnLibRecipe`, `RitnLibTechnology`.
- `RitnLibEvent(event)` — normalise n'importe quel event Factorio et expose directement `event.player`, `event.surface`, `event.force`, `event.entity`, `event.recipe`, `event.technology`, `event.inventory`, `event.element`, `event.area`, `event.position`… sans avoir à connaître la structure de chaque event.
- `RitnLibInventory` — snapshot/restore (main, guns, ammo, armor, trash, cursor) via `game.create_inventory`.
- `RitnLibGui` + `RitnLibGuiElement` + `RitnLibStyle` — construction GUI chaînée, dispatcher de clic via `remote.call("<ton-mod>", "gui_action_<gui_name>", …)`.

#### Settings stage
- `RitnLibSetting` — builder pour `data:extend({...})` (`bool-setting`, `int-setting`, `double-setting`, `string-setting`, `color-setting` ; portée `startup`/`runtime-global`/`runtime-per-user`).

#### Intégrations avec d'autres mods
- `remote.call` prêts pour le scénario `freeplay` : `set_created_items`, `set_respawn_items`, `set_skip_intro`, `set_disable_crashsite`.
- `remote.call("silo_script", "set_no_victory", …)`.
- Hook optionnel `DiscoScience.setIngredientColor` pour les packs de science custom.
- Détection automatique de [`gvv`](https://mods.factorio.com/mod/gvv) (debugger d'état global) et [`zk-lib`](https://mods.factorio.com/mod/zk-lib) (event_handler optimisé).

### Statut

Migration Factorio 2.0 en cours. Quelques méthodes contiennent encore des branches 1.x (recipe `normal/expensive`, `force.items_launched`, `hr_version` sur les sprites…). Le code se nettoie version après version — voir [`changelog.txt`](https://github.com/RitnDev/RitnLib/blob/main/changelog.txt).

### Installation

S'abonner depuis le Mod Portal en jeu, ou cloner ce dépôt dans `Factorio/mods/RitnLib/`.

Puis ajouter `"RitnLib"` aux `dependencies` du `info.json` de ton propre mod :

```json
{
  "name": "mon-mod",
  "dependencies": [ "base", "RitnLib" ]
}
```

### Documentation

- 📖 [Documentation](https://ritndev.github.io/RitnLib/) — guides et référence des classes (FR · EN)
- 🏗 [Architecture interne](https://github.com/RitnDev/RitnLib/blob/main/docs/architecture.md) (FR, mainteneur)
- 📜 [Changelog](https://github.com/RitnDev/RitnLib/blob/main/changelog.txt)

### Source / Issues

- 💾 [Dépôt GitHub](https://github.com/RitnDev/RitnLib)
- 🐛 [Signaler un bug](https://github.com/RitnDev/RitnLib/issues)

---

## 🇬🇧 English

**RitnLib** is a *library mod* for Factorio 2.0. It doesn't add anything to the game — it serves as a **dependency for other mods**, shortening the Factorio patterns that come up in every non-trivial mod: mutating `data.raw`, handling entities, dispatching events, building a GUI, declaring mod settings, snapshotting an inventory…

### What it looks like

**Without RitnLib**, snapshot and restore on respawn:

```lua
script.on_event(defines.events.on_player_died, function(event)
    storage.snapshots = storage.snapshots or {}
    local player = game.get_player(event.player_index)
    if not storage.snapshots[player.name] then
        storage.snapshots[player.name] = {
            [defines.inventory.character_main]  = game.create_inventory(65535),
            [defines.inventory.character_guns]  = game.create_inventory(65535),
            [defines.inventory.character_ammo]  = game.create_inventory(65535),
            [defines.inventory.character_armor] = game.create_inventory(65535),
            [defines.inventory.character_trash] = game.create_inventory(65535),
        }
    end
    for define, snapshot in pairs(storage.snapshots[player.name]) do
        local inv = player.get_inventory(define)
        for i = 1, #inv do
            if inv[i].valid then snapshot[i].swap_stack(inv[i]) end
        end
    end
end)

script.on_event(defines.events.on_player_respawned, function(event)
    -- … mirror of the above, the other way around …
end)
```

**With RitnLib**:

```lua
script.on_event(defines.events.on_player_died, function(event)
    storage.snapshots = storage.snapshots or {}
    RitnLibInventory(game.get_player(event.player_index), storage.snapshots):save()
end)

script.on_event(defines.events.on_player_respawned, function(event)
    RitnLibInventory(game.get_player(event.player_index), storage.snapshots):load()
end)
```

That's the idea across the whole library: you state **what you want to do**, RitnLib handles the Factorio plumbing.

### What's inside

#### Data stage — mutating `data.raw`
- `RitnProtoRecipe` — disable, hide, modify ingredients, retint science packs.
- `RitnProtoTechnology` — disable (with prerequisite purge), add/remove/replace science packs, manage `lab.inputs`, unlock/remove recipes.
- `RitnProtoEntity`, `RitnProtoItem`, `RitnProtoOre` (with autoplace), `RitnProtoSprite`, `RitnProtoStyle`.
- `RitnProtoItemGroup`, `RitnProtoItemSubgroup`, `RitnProtoRecipeCategory`, `RitnProtoFuelCategory`, `RitnProtoCustomInput`, `RitnProtoUtilityConst`.
- Ready-to-require fonts `ritn-default-{12..20}` (normal + bold) and a set of GUI styles `*-ritngui`.
- Helpers for `data.raw['gui-style'].default` and a local fork of the engine's `util.lua`.

#### Control stage — runtime
- Wrappers: `RitnLibPlayer`, `RitnLibSurface`, `RitnLibForce`, `RitnLibEntity`, `RitnLibRecipe`, `RitnLibTechnology`.
- `RitnLibEvent(event)` — normalizes any Factorio event and exposes `event.player`, `event.surface`, `event.force`, `event.entity`, `event.recipe`, `event.technology`, `event.inventory`, `event.element`, `event.area`, `event.position`… without having to remember each event's structure.
- `RitnLibInventory` — snapshot/restore (main, guns, ammo, armor, trash, cursor) via `game.create_inventory`.
- `RitnLibGui` + `RitnLibGuiElement` + `RitnLibStyle` — chained GUI construction, click dispatcher via `remote.call("<your-mod>", "gui_action_<gui_name>", …)`.

#### Settings stage
- `RitnLibSetting` — builder for `data:extend({...})` (`bool-setting`, `int-setting`, `double-setting`, `string-setting`, `color-setting`; scope `startup`/`runtime-global`/`runtime-per-user`).

#### Integrations with other mods
- Ready `remote.call`s for the `freeplay` scenario: `set_created_items`, `set_respawn_items`, `set_skip_intro`, `set_disable_crashsite`.
- `remote.call("silo_script", "set_no_victory", …)`.
- Optional `DiscoScience.setIngredientColor` hook for custom science packs.
- Automatic detection of [`gvv`](https://mods.factorio.com/mod/gvv) (global-state debugger) and [`zk-lib`](https://mods.factorio.com/mod/zk-lib) (optimized event_handler).

### Status

Factorio 2.0 migration is in progress. A few methods still carry 1.x branches (recipe `normal/expensive`, `force.items_launched`, `hr_version` on sprites…). Code is being cleaned up version after version — see [`changelog.txt`](https://github.com/RitnDev/RitnLib/blob/main/changelog.txt).

### Installation

Subscribe via the in-game Mod Portal, or clone this repository into `Factorio/mods/RitnLib/`.

Then add `"RitnLib"` to your own mod's `info.json` `dependencies`:

```json
{
  "name": "my-mod",
  "dependencies": [ "base", "RitnLib" ]
}
```

### Documentation

- 📖 [Documentation](https://ritndev.github.io/RitnLib/) — guides and class reference (EN · FR)
- 🏗 [Internal architecture](https://github.com/RitnDev/RitnLib/blob/main/docs/architecture.md) (FR, maintainer-facing)
- 📜 [Changelog](https://github.com/RitnDev/RitnLib/blob/main/changelog.txt)

### Source / Issues

- 💾 [GitHub repository](https://github.com/RitnDev/RitnLib)
- 🐛 [Report an issue](https://github.com/RitnDev/RitnLib/issues)

---

## License

The Lua source code is © 2021-2026 Ritn. Embedded third-party content is licensed individually — notably [rxi/json.lua](https://github.com/RitnDev/RitnLib/blob/main/lualib/json-functions.lua) (MIT).
