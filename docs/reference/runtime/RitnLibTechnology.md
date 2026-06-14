---
title: RitnLibTechnology
type: reference
lang: fr
---

# `RitnLibTechnology`


Vue runtime au-dessus d'une [`LuaTechnology`](https://lua-api.factorio.com/latest/classes/LuaTechnology.html) — l'instance **par force**, au control stage. Son usage principal : à la fin d'une recherche, désactiver des recettes et réassigner les machines qui les utilisaient vers une recette de remplacement.

> Pour **modifier une techno au data stage** (packs, pré-requis, recettes débloquées), utilise plutôt [`RitnProtoTech`](../prototype/RitnProtoTech.md).

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnTechnology.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **`object_name`** | `"RitnLibTechnology"` |

---

## Constructeur

#### `RitnLibTechnology(technology)` → [`RitnLibTechnology`](RitnLibTechnology.md)

Valide l'entrée puis fige les champs. Rejette une entrée qui n'est pas une `LuaTechnology` valide.

**Paramètres**
- `technology` :: [`LuaTechnology`](https://lua-api.factorio.com/latest/classes/LuaTechnology.html) — la techno runtime (ex. `event.research`).

**Valeur de retour** → [`RitnLibTechnology`](RitnLibTechnology.md). En cas d'entrée invalide, [`isPresent`](#ispresent--boolean-read) vaut `false`.

> **Note** — Le plus souvent on l'obtient via [`RitnLibForce:getTechnology(name)`](RitnLibForce.md#gettechnologytech_name--ritnlibtechnology) ou directement depuis `event.research`.

---

## Attributs

#### `technology` :: [`LuaTechnology`](https://lua-api.factorio.com/latest/classes/LuaTechnology.html) `[Read]`
La `LuaTechnology` encapsulée (référence vivante).

#### `name` :: `string` `[Read]`
Nom de la technologie (snapshot).

#### `force` :: [`LuaForce`](https://lua-api.factorio.com/latest/classes/LuaForce.html) `[Read]`
Force à laquelle appartient la techno (snapshot).

#### `entity_type` :: `string` `[Read]`
Type d'entité ciblé par défaut par [`:updateRecipe`](#updaterecipetechfinished-disabletabrecipes-setrecipe-entitytype--ritnlibtechnology) (défaut `"assembling-machine"`).

#### `isPresent` :: `boolean` `[Read]`
`false` si le constructeur a rejeté son entrée. À tester en garde.

---

## Méthodes

#### `:updateRecipe(techFinished, disableTabRecipes, setRecipe, entityType?)` → [`RitnLibTechnology`](RitnLibTechnology.md)

À la fin d'une recherche : si `self.name == techFinished`, désactive chaque recette de `disableTabRecipes` pour la force, puis parcourt toutes les surfaces et réassigne les machines (`entity_type`) qui utilisaient l'une de ces recettes vers `setRecipe`. No-op si `self.name ~= techFinished`.

**Paramètres**
- `techFinished` :: `string` — nom de techno à matcher contre `self.name`.
- `disableTabRecipes` :: `string[]` — recettes à désactiver.
- `setRecipe` :: `string` — recette de remplacement à poser sur les machines concernées.
- `entityType` :: `string?` — surcharge `entity_type` (défaut `"assembling-machine"`).

```lua
script.on_event(defines.events.on_research_finished, function(event)
    RitnLibTechnology(event.research):updateRecipe(
        "automation-2",
        { "assembling-machine-1" },
        "assembling-machine-2"
    )
end)
```

> **Avertissement — performance** — parcourt chaque surface et chaque entité du type ciblé : O(surfaces × entités). En Space Age (plusieurs planètes), itère sur toutes. À scoper par surface si nécessaire.

> **Note 2.0** — `LuaEntity.set_recipe` accepte désormais un paramètre de qualité, que cette méthode ne transmet pas encore. Voir [Migration Factorio 2.0](../../migration-2.0.md).

---

## Exemple d'usage

**Réassignation pilotée par une table de configuration** (`RitnMiner/modules/miner.lua`) :

```lua
RitnTech:updateRecipe(iTech.name, iTech.disableTabRecipes, iTech.setRecipeName)
```

---

## Remarques

- **Runtime vs data stage** — pour modifier la définition de la techno (packs, pré-requis), c'est [`RitnProtoTech`](../prototype/RitnProtoTech.md) au data stage.
- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage`. Voir [Wrappers temporaires](../../concepts/temporary-wrappers.md).

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibForce`](RitnLibForce.md) · [`RitnProtoTech`](../prototype/RitnProtoTech.md)
- [Migration Factorio 2.0](../../migration-2.0.md)
