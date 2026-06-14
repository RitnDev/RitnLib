---
title: RitnLibForce
type: reference
lang: fr
---

# `RitnLibForce`


Vue raccourcie au-dessus d'une [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html). Donne accès aux recettes et technologies de la force (sous forme de wrappers chaînables), aux statistiques de production, à la visibilité des surfaces sur la carte et aux chart tags.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnForce.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **Étendue par** | les sous-classes consommateur, ex. `RitnCoreForce` (cf. [ADR-0001](../../adr/0001-class-factory.md)) |
| **`object_name`** | `"RitnLibForce"` |

---

## Constructeur

#### `RitnLibForce(force)` → [`RitnLibForce`](RitnLibForce.md)

Valide l'entrée puis fige les champs. Rejette une entrée qui n'est pas une `LuaForce` valide.

**Paramètres**
- `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) — la force à encapsuler.

**Valeur de retour** → [`RitnLibForce`](RitnLibForce.md). En cas d'entrée invalide, [`isPresent`](#ispresent--boolean-read) vaut `false`.

```lua
local rForce = RitnLibForce(game.forces["player"])
```

> **Note** — Le plus souvent on l'obtient via [`RitnLibPlayer:getForce()`](RitnLibPlayer.md#getforce--ritnlibforce) ou [`RitnLibEvent:getForce()`](RitnLibEvent.md#getforce--ritnlibforce).

---

## Attributs

Tous en lecture seule (`[Read]`), figés à la construction.

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) `[Read]`
La `LuaForce` encapsulée (référence vivante).

#### `name` :: `string` `[Read]`
Nom de la force (`"player"`, `"enemy"`…).

#### `index` :: `uint` `[Read]`
Index de la force.

#### `items_launched` :: `table<string, uint>?` `[Read]`
Items lancés en rocket (dictionnaire item→count). Toujours disponible en Factorio 2.0.

#### `rockets_launched` :: `uint?` `[Read]`
Nombre de rockets lancées.

#### `FORCE_ENEMY_NAME` :: `"enemy"` `[Read]`
Constante du nom de la force ennemie.

#### `FORCE_PLAYER_NAME` :: `"player"` `[Read]`
Constante du nom de la force joueur.

#### `FORCE_NEUTRAL_NAME` :: `"neutral"` `[Read]`
Constante du nom de la force neutre.

#### `isPresent` :: `boolean` `[Read]`
`false` si le constructeur a rejeté son entrée. À tester en garde.

---

## Méthodes

#### `:getRecipe(recipe_name)` → [`RitnLibRecipe`](RitnLibRecipe.md)
Renvoie un [`RitnLibRecipe`](RitnLibRecipe.md) enveloppant la recette nommée de cette force.

**Paramètres**
- `recipe_name` :: `string` — nom de la recette.

> **Avertissement** — Lève une erreur (`error`) si la recette n'existe pas pour cette force. Garantis le nom en amont.

```lua
RitnLibEvent(e):getPlayer():getForce():getRecipe("electronic-circuit"):setEnabled(false)
```

#### `:getTechnology(tech_name)` → [`RitnLibTechnology`](RitnLibTechnology.md)
Renvoie un [`RitnLibTechnology`](RitnLibTechnology.md) enveloppant la technologie nommée.

**Paramètres**
- `tech_name` :: `string` — nom de la technologie.

> **Avertissement** — Lève une erreur si la technologie n'existe pas pour cette force.

```lua
RitnLibEvent(e):getPlayer():getForce():getTechnology("ritn-tech-lumberjack").technology.researched = true
```

#### `:setHiddenSurface(surfaceIdentification, value?)` → [`RitnLibForce`](RitnLibForce.md)
Masque ou affiche une surface pour cette force sur la carte. Chaînable.

**Paramètres**
- `surfaceIdentification` :: [`SurfaceIdentification`](https://lua-api.factorio.com/latest/concepts/SurfaceIdentification.html) — la surface ciblée.
- `value` :: `boolean?` — `true` pour masquer (défaut), `false` pour afficher.

```lua
rForce:setHiddenSurface(rSurface.name, true)
```

#### `:countPlayers()` → `integer`
Nombre de joueurs dans cette force (`#self.force.players`).

#### `:getChartTag(tag_number, surface_name, position)` → [`LuaCustomChartTag`](https://lua-api.factorio.com/latest/classes/LuaCustomChartTag.html)`?`
Cherche un chart tag par son `tag_number` à une position donnée.

**Paramètres**
- `tag_number` :: `uint` — identifiant du tag recherché.
- `surface_name` :: `string`|[`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) — la surface.
- `position` :: [`MapPosition`](https://lua-api.factorio.com/latest/concepts/MapPosition.html) — la position (doit avoir `.x` et `.y`).

> **Avertissement** — Construit une zone dégénérée `{position, position}` pour `find_chart_tags` ; peut rater un tag à cause d'arrondis flottants.

#### Statistiques de production — `:getStatsProduction` · `:getStatsProductionItem` · `:getStatsProductionFluid` · `:getStatsCount` · `:getStatsCountKill` · `:getStatsCountBuild`

Renvoient des compteurs de production / kills / constructions (`integer?`).

> **Avertissement** — Ces méthodes dépendent de `self.stats`, **actuellement désactivé** : son bloc constructeur lit l'API statistics Factorio **1.x**, retirée en 2.0. Sur une instance de base elles lèvent une erreur ; il faut qu'une sous-classe peuple `self.stats`. Détails et plan de migration : [Migration Factorio 2.0](../../migration-2.0.md).

---

## Exemples d'usage

**Désactiver des recettes pour une force** (`RitnElectronic/modules/electronic.lua`) :

```lua
RitnLibEvent(e):getPlayer():getForce():getRecipe("radar"):setEnabled(false)
RitnLibEvent(e):getPlayer():getForce():getRecipe("inserter"):setEnabled(false)
```

**Forcer une techno comme recherchée** (`RitnLumberjack/modules/lumberjack.lua`) :

```lua
RitnLibEvent(e):getPlayer():getForce():getTechnology("ritn-tech-lumberjack").technology.researched = true
```

**Masquer une surface sur la carte** (`RitnCoreGame/modules/force.lua`) :

```lua
local rForce = RitnCoreForce(rEvent.force)
rForce:setHiddenSurface(rSurface.name, true)
```

---

## Remarques

- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage` ; la reconstruire dans chaque handler. Voir [Wrappers temporaires](../../concepts/temporary-wrappers.md).
- **`getRecipe` / `getTechnology` lèvent** — elles `error()` si le nom n'existe pas. Préfère un nom dont tu es sûr, ou protège l'appel.
- **`getStats*` en attente de migration 2.0** — voir l'avertissement ci-dessus et [Migration Factorio 2.0](../../migration-2.0.md).

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibRecipe`](RitnLibRecipe.md) · [`RitnLibTechnology`](RitnLibTechnology.md) · [`RitnLibPlayer`](RitnLibPlayer.md)
- [Wrappers temporaires (règle d'or)](../../concepts/temporary-wrappers.md)
- [Migration Factorio 2.0](../../migration-2.0.md)
