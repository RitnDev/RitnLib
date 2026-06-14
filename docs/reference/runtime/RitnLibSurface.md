---
title: RitnLibSurface
type: reference
lang: fr
---

# `RitnLibSurface`


Vue raccourcie au-dessus d'un [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html). Expose nom/index, un drapeau `isNauvis`, et la recherche d'une entité par position + `unit_number`.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnSurface.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **Étendue par** | les sous-classes consommateur, ex. `RitnCoreSurface` |
| **`object_name`** | `"RitnLibSurface"` |

---

## Constructeur

#### `RitnLibSurface(surface)` → [`RitnLibSurface`](RitnLibSurface.md)

Valide l'entrée puis fige les champs. Rejette une entrée qui n'est pas un `LuaSurface` valide.

**Paramètres**
- `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) — la surface à encapsuler.

**Valeur de retour** → [`RitnLibSurface`](RitnLibSurface.md). En cas d'entrée invalide, [`isPresent`](#ispresent--boolean-read) vaut `false`.

> **Note** — Le plus souvent on l'obtient via [`RitnLibEvent:getSurface()`](RitnLibEvent.md#getsurface--ritnlibsurface) ou [`RitnLibPlayer:getSurface()`](RitnLibPlayer.md#getsurface--ritnlibsurface).

---

## Attributs

Tous en lecture seule (`[Read]`), figés à la construction.

#### `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) `[Read]`
La `LuaSurface` encapsulée (référence vivante).

#### `name` :: `string` `[Read]`
Nom de la surface (`"nauvis"`, `"vulcanus"`…).

#### `index` :: `uint` `[Read]`
Index de la surface.

#### `isNauvis` :: `boolean` `[Read]`
`true` si `name == "nauvis"` à l'instanciation. Vaut `false` sur les planètes Space Age et les plateformes spatiales.

#### `isPresent` :: `boolean` `[Read]`
`false` si le constructeur a rejeté son entrée. À tester en garde.

---

## Méthodes

#### `:print(text)` → [`RitnLibSurface`](RitnLibSurface.md)
Diffuse un message à **tous** les joueurs présents sur la surface. Les `table` sont sérialisées via `serpent.block` ; les valeurs ni-string ni-table tombent en `tostring` (dans un `pcall`). Chaînable.

**Paramètres**
- `text` :: `string`|`table` — texte ou [`LocalisedString`](https://lua-api.factorio.com/latest/concepts/LocalisedString.html).

#### `:getEntity(position, unit_number, name?, entityType?)` → [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`?`
Trouve une entité précise par position + `unit_number`. Stratégie : `find_entities_filtered{position, name?, type?}` → recherche du `unit_number` dans la liste → fallback sur le premier match → fallback sur `find_entity(name, position)`.

**Paramètres**
- `position` :: [`MapPosition`](https://lua-api.factorio.com/latest/concepts/MapPosition.html) — centre de recherche (doit avoir `.x`/`.y`).
- `unit_number` :: `uint` — unit number recherché.
- `name` :: `string?` — filtre optionnel par nom d'entité.
- `entityType` :: `string?` — filtre optionnel par type (doit exister dans `lualib.vanilla.types_entity`).

```lua
local entity = RitnLibSurface(game.get_surface(surface_name))
    :getEntity(portal.position, id_portal, "ritn-portal", portal.entity_type)
```

> **Avertissement** — Cette méthode écrit aussi son résultat dans la variable **globale** `LuaEntity` (effet de bord à connaître). Sur 2.0, si tu as déjà l'`unit_number`, `game.get_entity_by_unit_number(n)` est en O(1). Voir [Migration Factorio 2.0](../../migration-2.0.md).

---

## Exemple d'usage

**Retrouver une entité par unit_number** (`RitnPortal/classes/RitnSurface.lua`) :

```lua
local LuaEntity = RitnLibSurface(game.get_surface(surface_name))
    :getEntity(portal.position, id_portal, ritnlib.defines.portal.names.entity.portal, portal.entity_type)
```

---

## Remarques

- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage` ; la reconstruire dans chaque handler. Voir [Wrappers temporaires](../../concepts/temporary-wrappers.md).
- **`isNauvis` et Space Age** — test sur le nom exact `'nauvis'` ; `false` ailleurs (planètes, plateformes).

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibEvent`](RitnLibEvent.md) · [`RitnLibPlayer`](RitnLibPlayer.md) · [`RitnLibEntity`](RitnLibEntity.md)
- [Wrappers temporaires (règle d'or)](../../concepts/temporary-wrappers.md)
