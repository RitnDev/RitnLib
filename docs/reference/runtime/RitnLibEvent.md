---
title: RitnLibEvent
type: reference
lang: fr
---

# `RitnLibEvent`


Vue uniforme au-dessus de n'importe quel [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) Factorio. Plutôt que d'inspecter à la main un payload différent pour chaque event (`event.player_index` ici, `event.entity` là, `event.destination` pour les fusions de force…), tu construis **un** `RitnLibEvent` et tu lis directement `player`, `surface`, `force`, `entity`, `position`… — toujours au même endroit, quel que soit l'event. Les valeurs absentes valent `nil`.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnEvent.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **Étendue par** | les sous-classes consommateur, ex. `RitnCoreEvent` (cf. [ADR-0001](../../adr/0001-class-factory.md)) |
| **`object_name`** | `"RitnLibEvent"` |

---

## Constructeur

#### `RitnLibEvent(event, mod_name?)` → [`RitnLibEvent`](RitnLibEvent.md)

Construit le wrapper et extrait tous les champs du payload **au moment de la construction** (copies de références prises une fois, pas des accesseurs paresseux).

**Paramètres**
- `event` :: [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) — le payload reçu par ton handler.
- `mod_name` :: `string?` — nom du mod consommateur, utilisé par les classes dérivées (GUI notamment). Défaut : `"RitnLib"`.

**Valeur de retour** → [`RitnLibEvent`](RitnLibEvent.md). Si `event` est `nil`, l'instance est renvoyée avec [`isPresent`](#ispresent--boolean-read) à `false` et aucun autre champ peuplé.

```lua
script.on_event(defines.events.on_player_created, function(event)
    local rEvent = RitnLibEvent(event)
    if not rEvent.isPresent then return end
    game.print(rEvent.name .. " → " .. rEvent.player.name)
end)
```

> **Note** — En pratique, les mods Ritn ne construisent pas `RitnLibEvent` directement : ils en dérivent une sous-classe (`RitnCoreEvent`) dont les méthodes `:getPlayer()` / `:getSurface()` / `:getForce()` renvoient leurs propres wrappers spécialisés. Le pattern d'extension est décrit dans l'[ADR-0001](../../adr/0001-class-factory.md).

---

## Attributs

Tous en lecture seule (`[Read]`) et figés à la construction. Un champ vaut `nil` quand l'event ne le porte pas.

#### `isPresent` :: `boolean` `[Read]`
`false` si le constructeur a reçu un `event` `nil`, `true` sinon. À tester en garde au début du handler avant de lire les autres champs.

#### `name` :: `string` `[Read]`
Nom symbolique de l'event, résolu depuis `defines.events` (ex. `"on_player_created"`). Cas particulier : vaut `"on_tick"` quand `event.name == 0`.

#### `index` :: `uint` `[Read]`
Identifiant numérique de l'event (alias de `event.name`).

#### `mod_name` :: `string` `[Read]`
Nom du mod consommateur passé au constructeur (`"RitnLib"` par défaut).

#### `event` :: [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) `[Read]`
Le payload d'origine, conservé tel quel — utile pour accéder à un champ rare non normalisé par la classe.

#### `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html)`?` `[Read]`
Extrait via `event.player_index` (`game.get_player(...)`).

#### `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html)`?` `[Read]`
Extrait via `event.surface_index` (`game.get_surface(...)`), sinon via `event.surface`.

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html)`?` `[Read]`
Extrait via `event.force`. Cas particulier `on_forces_merging` : vaut `event.destination` (la force survivante).

#### `recipe` :: [`LuaRecipe`](https://lua-api.factorio.com/latest/classes/LuaRecipe.html)`?` `[Read]`
`event.recipe` si présent.

#### `technology` :: [`LuaTechnology`](https://lua-api.factorio.com/latest/classes/LuaTechnology.html)`?` `[Read]`
`event.research` si présent (events de recherche).

#### `entity` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
Premier disponible parmi `created_entity` (1.x), `vehicle`, puis `entity`. **Note 2.0** : `event.created_entity` n'existe plus en 2.0 (branche inerte) ; les entités créées par trigger arrivent via l'event `on_trigger_created_entity`. Voir [Migration 2.0](../../migration-2.0.md).

#### `robot` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
`event.robot` si présent (construction/minage par robot).

#### `rocket` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
`event.rocket` si présent. Toujours valable en 2.0 ; pour la fin **complète** d'un lancement, écouter plutôt `on_cargo_pod_finished_ascending` (voir [Migration 2.0](../../migration-2.0.md)).

#### `inventory` :: [`LuaInventory`](https://lua-api.factorio.com/latest/classes/LuaInventory.html)`?` `[Read]`
Premier disponible parmi `buffer`, `loot`, `items`, `inventory`.

#### `cause` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
`event.cause` (events de mort : l'entité à l'origine).

#### `reason` :: [`defines.disconnect_reason`](https://lua-api.factorio.com/latest/defines.html#defines.disconnect_reason)`?` `[Read]`
`event.reason` (events de déconnexion). Voir [`:getReason()`](#getreason--string) pour le nom symbolique.

#### `queued_count` :: `number?` `[Read]`
`event.queued_count` (requêtes de chunks).

#### `gui_type` :: `string?` `[Read]`
Nom symbolique résolu depuis `event.gui_type` (`defines.gui_type`).

#### `source` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html)`?` `[Read]`
`event.source` (force source d'une fusion).

#### `source_name` :: `string?` `[Read]`
`event.source_name` (nom de la force source après fusion).

#### `area` :: [`BoundingBox`](https://lua-api.factorio.com/latest/concepts/BoundingBox.html)`?` `[Read]`
`event.area` (events de sélection de zone).

#### `element` :: [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html)`?` `[Read]`
`event.element` (events GUI).

#### `setting_name` :: `string?` `[Read]`
`event.setting` — nom du mod-setting modifié (`on_runtime_mod_setting_changed`).

#### `setting_type` :: `string?` `[Read]`
`event.setting_type` — `"startup"`, `"runtime-global"` ou `"runtime-per-user"`.

#### `position` :: [`MapPosition`](https://lua-api.factorio.com/latest/concepts/MapPosition.html)`?` `[Read]`
`event.cursor_position` en priorité, sinon `event.position`. Renvoie `nil` pour les events de chunk (`on_chunk_charted`, `on_chunk_generated`) où `position` n'est pas la position pertinente côté joueur.

---

## Méthodes

#### `:getPlayer()` → [`RitnLibPlayer`](RitnLibPlayer.md)
Enveloppe [`player`](#player--luaplayer-read) dans un [`RitnLibPlayer`](RitnLibPlayer.md) (accès rapide force/surface/character…).

```lua
local rPlayer = RitnLibEvent(event):getPlayer()
```

#### `:getSurface()` → [`RitnLibSurface`](RitnLibSurface.md)
Enveloppe [`surface`](#surface--luasurface-read) dans un [`RitnLibSurface`](RitnLibSurface.md).

#### `:getForce()` → [`RitnLibForce`](RitnLibForce.md)
Enveloppe [`force`](#force--luaforce-read) dans un [`RitnLibForce`](RitnLibForce.md).

#### `:getTechnology()` → [`RitnLibTechnology`](RitnLibTechnology.md)
Enveloppe [`technology`](#technology--luatechnology-read) dans un [`RitnLibTechnology`](RitnLibTechnology.md).

#### `:getReason()` → `string?`
Traduit [`reason`](#reason--definesdisconnect_reason-read) (un `defines.disconnect_reason`) en nom symbolique, pour les events de déconnexion.

**Valeur de retour** → `string?` — l'un de `"quit"`, `"dropped"`, `"reconnect"`, `"wrong_input"`, `"desync_limit_reached"`, `"cannot_keep_up"`, `"afk"`, `"kicked"`, `"kicked_and_deleted"`, `"banned"`, `"switching_servers"` ; `nil` si non reconnu.

```lua
script.on_event(defines.events.on_player_left_game, function(event)
    local rEvent = RitnLibEvent(event)
    log("départ joueur : " .. tostring(rEvent:getReason()))
end)
```

#### `RitnLibEvent.setIngredientColor(ingredient, color)`
Helper **statique** (à appeler avec un point, pas `:`). Relaie vers le mod DiscoScience s'il est chargé et expose l'interface `setIngredientColor` ; no-op sinon.

**Paramètres**
- `ingredient` :: `string` — nom d'item transmis à DiscoScience.
- `color` :: [`Color`](https://lua-api.factorio.com/latest/concepts/Color.html) — table couleur `{r, g, b, a}`.

```lua
RitnLibEvent.setIngredientColor("automation-science-pack", { r = 1, g = 0.2, b = 0.2 })
```

> **Avertissement** — Méthode statique : `RitnLibEvent.setIngredientColor(...)`, **pas** `instance:setIngredientColor(...)`.

---

## Exemples d'usage

**Handler minimal** — réagir à la création d'un joueur :

```lua
script.on_event(defines.events.on_player_created, function(event)
    local rEvent = RitnLibEvent(event)
    if not rEvent.isPresent then return end
    rEvent.player.print({ "", "Bienvenue sur ", rEvent.surface.name })
end)
```

**Réagir à un mod-setting runtime** (`RitnLobbyGame/modules/lobby.lua`) :

```lua
local rEvent = RitnCoreEvent(e)
if rEvent.setting_type == "runtime-global" then
    if rEvent.setting_name == ritnlib.defines.lobby.names.settings.surfaceMax then
        local value = settings.global[rEvent.setting_name].value
        -- … appliquer la nouvelle limite
    end
end
```

**Surface + zone d'un event de sélection** (`RitnEnemy/modules/player.lua`) :

```lua
local rEvent = RitnCoreEvent(e)
RitnEnemySurface(rEvent.surface):changeForceEnemy(rEvent.area)
```

---

## Remarques

- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage` ; la reconstruire dans chaque handler. Voir [Wrappers temporaires](../../concepts/temporary-wrappers.md).
- **Extraction figée** — les champs sont lus une fois à la construction. Si l'état du jeu change pendant le handler, reconstruis un `RitnLibEvent`.
- **Compatibilité 2.0** — `created_entity` est inerte, `rocket` reste valable (voir [Migration 2.0](../../migration-2.0.md)). Les events Space Age (`on_space_platform_*`, `on_player_changed_planet`, `on_segment_*`, `on_object_destroyed`) ne sont pas encore normalisés.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibPlayer`](RitnLibPlayer.md) · [`RitnLibSurface`](RitnLibSurface.md) · [`RitnLibForce`](RitnLibForce.md) · [`RitnLibTechnology`](RitnLibTechnology.md)
- [Wrappers temporaires (règle d'or)](../../concepts/temporary-wrappers.md)
- [ADR-0001 — Factory de classes](../../adr/0001-class-factory.md)
