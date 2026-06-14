---
title: RitnLibPlayer
type: reference
lang: fr
---

# `RitnLibPlayer`


Vue raccourcie au-dessus d'un [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html). Expose les informations joueur les plus consultées (`force`, `surface`, `character`, `admin`, `driving`…) comme propriétés directes, et fournit des accesseurs qui renvoient d'autres wrappers RitnLib — ce qui permet le chaînage `:getForce():getRecipe(...)`.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnPlayer.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **Étendue par** | les sous-classes consommateur, ex. `RitnCorePlayer`, `RitnCharacter` (cf. [ADR-0001](../../adr/0001-class-factory.md)) |
| **`object_name`** | `"RitnLibPlayer"` |

---

## Constructeur

#### `RitnLibPlayer(player)` → [`RitnLibPlayer`](RitnLibPlayer.md)

Valide l'entrée puis fige les champs joueur. L'entrée est rejetée si ce n'est pas un `LuaPlayer`, s'il est invalide (`valid == false`), ou si `is_player()` est faux.

**Paramètres**
- `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html) — le joueur à encapsuler.

**Valeur de retour** → [`RitnLibPlayer`](RitnLibPlayer.md). En cas d'entrée invalide, l'instance est renvoyée avec [`isPresent`](#ispresent--boolean-read) à `false` et aucun autre champ peuplé.

```lua
local rPlayer = RitnLibPlayer(game.get_player(event.player_index))
if not rPlayer.isPresent then return end
```

> **Note** — Le plus souvent, on obtient un `RitnLibPlayer` via [`RitnLibEvent:getPlayer()`](RitnLibEvent.md#getplayer--ritnlibplayer) plutôt qu'en appelant le constructeur à la main.

---

## Attributs

Tous en lecture seule (`[Read]`) et figés à la construction (snapshot).

#### `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html) `[Read]`
Le `LuaPlayer` encapsulé (référence vivante). Sert d'échappatoire pour appeler n'importe quelle méthode native non exposée par le wrapper.

#### `index` :: `uint` `[Read]`
Index du joueur (snapshot).

#### `name` :: `string` `[Read]`
Nom du joueur (snapshot).

#### `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) `[Read]`
Surface du joueur **au moment de l'instanciation**. Peut devenir périmée si le joueur change de surface ensuite — reconstruis le wrapper si besoin.

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) `[Read]`
Force du joueur **au moment de l'instanciation**. Snapshot, susceptible de se périmer.

#### `controller_type` :: [`defines.controllers`](https://lua-api.factorio.com/latest/defines.html#defines.controllers) `[Read]`
Type de contrôleur (entier, snapshot).

#### `controller_name` :: `string?` `[Read]`
Nom symbolique résolu depuis `controller_type` (ex. `"character"`, `"god"`, `"editor"`).

#### `character` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
Entité personnage du joueur ; `nil` en contrôleur god/editor.

#### `admin` :: `boolean` `[Read]`
Le joueur est-il admin (snapshot — peut changer au runtime).

#### `driving` :: `boolean` `[Read]`
Le joueur est-il en train de conduire (snapshot).

#### `vehicle` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?` `[Read]`
Véhicule conduit, `nil` sinon.

#### `connected` :: `boolean` `[Read]`
Le joueur est-il connecté (snapshot).

#### `isPresent` :: `boolean` `[Read]`
`false` si le constructeur a rejeté son entrée, `true` sinon. À tester en garde avant d'utiliser les autres champs.

---

## Méthodes

#### `:print(text)` → [`RitnLibPlayer`](RitnLibPlayer.md)
Imprime un message au joueur. Les `table` sont sérialisées via `serpent.block` ; les valeurs ni-string ni-table tombent en `tostring` (dans un `pcall`). Renvoie `self` (chaînable).

**Paramètres**
- `text` :: `string`|`table` — texte ou table à imprimer (une [`LocalisedString`](https://lua-api.factorio.com/latest/concepts/LocalisedString.html) est une table).

```lua
RitnLibPlayer(player):print("Hello")
```

#### `:getForce()` → [`RitnLibForce`](RitnLibForce.md)
Enveloppe [`force`](#force--luaforce-read) dans un [`RitnLibForce`](RitnLibForce.md).

#### `:getSurface()` → [`RitnLibSurface`](RitnLibSurface.md)
Enveloppe [`surface`](#surface--luasurface-read) dans un [`RitnLibSurface`](RitnLibSurface.md).

#### `:cancel_all_crafting()`
Annule toutes les entrées de la file de craft du joueur. Encapsulé dans un `pcall` — les erreurs sont silencieusement ignorées.

#### `:onNauvis()` → `boolean`
`true` si le joueur est sur la surface `nauvis`.

> **Note** — Renvoie `false` sur les planètes Space Age (vulcanus/fulgora/gleba/aquilo) et sur les plateformes spatiales : le test porte sur le nom de surface `'nauvis'` exactement.

---

## Exemples d'usage

**Chaînage fluent** — désactiver une recette pour la force du joueur (`RitnElectronic/modules/electronic.lua`) :

```lua
RitnLibEvent(e):getPlayer():getForce():getRecipe("radar"):setEnabled(false)
```

**Brancher sur le statut admin** (`RitnLobbyGame/modules/menu.lua`) :

```lua
local rPlayer = RitnCoreEvent(e):getPlayer()
if rPlayer.admin then
    -- … menu réservé aux admins
end
```

**Échappatoire vers le `LuaPlayer` natif** (`RitnLobbyGame/classes/RitnSurface.lua`) :

```lua
local rPlayer = RitnCorePlayer(game.get_player(applicant))
rPlayer.player.print({ "msg.send-request", self.name }, { r = 1, g = 0, b = 0, a = 0.3 })
```

---

## Remarques

- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage` ; la reconstruire dans chaque handler. Voir [Wrappers temporaires](../../concepts/temporary-wrappers.md).
- **Champs snapshot** — `surface`, `force`, `admin`, `driving`, `connected`, `vehicle` sont figés à la construction. Pour une valeur fraîche, relis depuis [`player`](#player--luaplayer-read) ou reconstruis le wrapper.
- **God / editor** — [`character`](#character--luaentity-read) vaut `nil` dans ces contrôleurs.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibEvent`](RitnLibEvent.md) · [`RitnLibForce`](RitnLibForce.md) · [`RitnLibSurface`](RitnLibSurface.md)
- [Wrappers temporaires (règle d'or)](../../concepts/temporary-wrappers.md)
- [ADR-0001 — Factory de classes](../../adr/0001-class-factory.md)
