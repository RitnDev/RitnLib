---
title: RitnLibEntity
type: reference
lang: fr
---

# `RitnLibEntity`


Vue raccourcie au-dessus d'un [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html). Expose les infos d'entité les plus consultées (type, surface, force, position…), des drapeaux de catégorie (character/car/spider-vehicle), et des helpers conducteur/passager pour les véhicules.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnEntity.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **Étendue par** | les sous-classes consommateur, ex. `RitnPortalPortal` |
| **`object_name`** | `"RitnLibEntity"` |

---

## Constructeur

#### `RitnLibEntity(entity)` → [`RitnLibEntity`](RitnLibEntity.md)

Valide l'entrée puis fige les champs. Rejette une entrée qui n'est pas un `LuaEntity` valide.

**Paramètres**
- `entity` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html) — l'entité à encapsuler.

**Valeur de retour** → [`RitnLibEntity`](RitnLibEntity.md). En cas d'entrée invalide, [`isPresent`](#ispresent--boolean-read) vaut `false`.

---

## Attributs

Tous en lecture seule (`[Read]`), figés à la construction.

#### `entity` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html) `[Read]`
La `LuaEntity` encapsulée (référence vivante).

#### `name` :: `string` `[Read]`
Nom du prototype d'entité.

#### `id` · `unit_number` :: `uint?` `[Read]`
`unit_number` de l'entité (`id` en est un alias). `nil` pour les entités qui n'en ont pas.

#### `type` :: `string` `[Read]`
Type d'entité (`"character"`, `"car"`, `"assembling-machine"`…).

#### `prototype` :: [`LuaEntityPrototype`](https://lua-api.factorio.com/latest/classes/LuaEntityPrototype.html) `[Read]`
Référence vivante au prototype.

#### `surface` :: [`LuaSurface`](https://lua-api.factorio.com/latest/classes/LuaSurface.html) `[Read]`
Surface à l'instanciation (snapshot).

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) `[Read]`
Force à l'instanciation (snapshot).

#### `position` :: [`MapPosition`](https://lua-api.factorio.com/latest/concepts/MapPosition.html) `[Read]`
Position à l'instanciation (snapshot).

#### `backer_name` :: `string?` `[Read]`
Backer name si applicable.

#### `isCharacter` · `isCar` · `isSpiderVehicle` :: `boolean` `[Read]`
Drapeaux de catégorie d'après `type`.

#### `allowsPassenger` :: `boolean` `[Read]`
`true` si l'entité peut transporter un passager (car ou spider-vehicle).

#### `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html)`?` `[Read]`
Joueur contrôlant l'entité si c'est un character.

#### `drive` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`|`[`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html)`|nil` `[Read]`
Conducteur si `isCar`.

#### `passenger` :: [`LuaEntity`](https://lua-api.factorio.com/latest/classes/LuaEntity.html)`|`[`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html)`|nil` `[Read]`
Passager si `allowsPassenger`.

#### `isPresent` :: `boolean` `[Read]`
`false` si le constructeur a rejeté son entrée. À tester en garde.

---

## Méthodes — identité

#### `:existByName(name)` → `boolean`
`true` si l'entité est présente et porte exactement le nom `name`.

**Paramètres** : `name` :: `string`.

---

## Méthodes — véhicule (conducteur / passager)

#### `:isDriver()` → `boolean`
`true` si le véhicule a un conducteur (entité ou joueur).

#### `:isPassenger()` → `boolean`
`true` si le véhicule a un passager.

#### `:playerIsDriver(player)` → `boolean`
`true` si le `player` donné est le conducteur de cette entité.

**Paramètres** : `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html).

#### `:playerIsPassenger(player)` → `boolean`
`true` si le `player` donné est le passager de cette entité.

**Paramètres** : `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html).

#### `:setPassenger(player)`
Installe `player` comme passager si l'entité l'autorise (`allowsPassenger`). No-op sinon.

**Paramètres** : `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html).

---

## Méthodes — flags & destruction

#### `:setMinable(value?)`
Définit le flag `minable` de l'entité (`value` défaut `true`).

#### `:setDestructible(value?)`
Définit le flag `destructible` de l'entité (`value` défaut `true`).

#### `:destroy()`
Détruit l'entité.

> **Note** — `:destroy()` rappelle `:setMinable()` / `:setDestructible()` avant la destruction ; ces appels sont **redondants** (`destroy()` ignore ces flags), héritage d'un ancien cas d'usage.

---

## Méthodes — wrappers (⚠ à éviter en l'état)

#### `:getSurface()` → [`RitnLibSurface`](RitnLibSurface.md) · `:getForce()` → [`RitnLibForce`](RitnLibForce.md)

> **Avertissement** — Ces deux méthodes appellent `RitnlibSurface(...)` / `RitnlibForce(...)` (casse incorrecte, `lib` minuscule) — des globals inexistants → **elles plantent si appelées**. Défaut connu (latent, non corrigé). En attendant, enveloppe toi-même : `RitnLibSurface(rEntity.surface)` / `RitnLibForce(rEntity.force)`. Voir [bugs connus](../../debt/known-bugs.md).

---

## Exemples d'usage

**Vérifier le nom + gérer un passager** (`RitnPortal/classes/RitnPortal.lua`) :

```lua
if self:existByName(ritnlib.defines.portal.names.entity.portal) then
    -- …
end

if self:playerIsDriver(LuaPlayer) and self:isLinked() then
    rPortalDestination:setPassenger(LuaPlayer)
end
```

**Détruire l'entité encapsulée** (`RitnPortal/classes/RitnGuiPortal.lua`) :

```lua
rPortal:destroy()
```

---

## Remarques

- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage` ; la reconstruire dans chaque handler. Voir [Wrappers temporaires](../../concepts/temporary-wrappers.md).
- **Champs snapshot** — `surface`, `force`, `position`, `drive`, `passenger` sont figés à la construction.
- **`getSurface` / `getForce` cassées** — voir l'avertissement ci-dessus.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibSurface`](RitnLibSurface.md) · [`RitnLibForce`](RitnLibForce.md) · [`RitnLibPlayer`](RitnLibPlayer.md)
- [Bugs connus](../../debt/known-bugs.md) · [Wrappers temporaires](../../concepts/temporary-wrappers.md)
