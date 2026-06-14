---
title: RitnLibRecipe
type: reference
lang: fr
---

# `RitnLibRecipe`


Vue runtime au-dessus d'un [`LuaRecipe`](https://lua-api.factorio.com/latest/classes/LuaRecipe.html) — l'instance **par force**, au control stage. Permet de lire les propriétés (prototype et instance) et d'activer/désactiver la recette pour la force.

> Pour **modifier une recette au data stage** (ingrédients, résultats…), utilise plutôt [`RitnProtoRecipe`](../prototype/RitnProtoRecipe.md).

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnRecipe.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **`object_name`** | `"RitnLibRecipe"` |

---

## Constructeur

#### `RitnLibRecipe(recipe)` → [`RitnLibRecipe`](RitnLibRecipe.md)

Valide l'entrée puis stocke la recette et son prototype. Rejette une entrée qui n'est pas un `LuaRecipe` valide.

**Paramètres**
- `recipe` :: [`LuaRecipe`](https://lua-api.factorio.com/latest/classes/LuaRecipe.html) — la recette runtime à encapsuler.

**Valeur de retour** → [`RitnLibRecipe`](RitnLibRecipe.md). En cas d'entrée invalide, [`isPresent`](#ispresent--boolean-read) vaut `false`.

> **Note** — Le plus souvent on l'obtient via [`RitnLibForce:getRecipe(name)`](RitnLibForce.md#getrecipename--ritnlibrecipe).

---

## Attributs

#### `recipe` :: [`LuaRecipe`](https://lua-api.factorio.com/latest/classes/LuaRecipe.html) `[Read]`
La `LuaRecipe` encapsulée (référence vivante, état par force).

#### `prototype` :: [`LuaRecipePrototype`](https://lua-api.factorio.com/latest/classes/LuaRecipePrototype.html) `[Read]`
Le prototype de la recette (depuis `LuaRecipe.prototype`).

#### `isPresent` :: `boolean` `[Read]`
`false` si le constructeur a rejeté son entrée. À tester en garde.

---

## Méthodes

#### `:getProperties(propertie)` → `any`
Lit une propriété sur le **prototype** de la recette (ex. `"category"`, `"energy_required"`, `"hidden"`).

**Paramètres** : `propertie` :: `string`.

#### `:get(propertie)` → `any`
Lit une propriété sur l'**instance runtime** (état par force : `"enabled"`, `"hidden_from_flow_stats"`…).

**Paramètres** : `propertie` :: `string`.

#### `:setEnabled(value)` → [`RitnLibRecipe`](RitnLibRecipe.md)
Active ou désactive la recette pour sa force. No-op si `value` est nil ou pas un booléen. Chaînable.

**Paramètres** : `value` :: `boolean`.

---

## Exemple d'usage

**Désactiver une recette pour la force du joueur** (`RitnElectronic/modules/electronic.lua`) :

```lua
RitnLibEvent(e):getPlayer():getForce():getRecipe("radar"):setEnabled(false)
```

**Désactivation directe sur des recettes connues** (`NoLogisticsChallenge/lualib/player.lua`) :

```lua
RitnRecipe(recipes["burner-mining-drill"]):setEnabled(false)
```

---

## Remarques

- **Runtime vs data stage** — `RitnLibRecipe` agit sur l'instance **runtime** (par force). Pour changer la définition (ingrédients/résultats), c'est [`RitnProtoRecipe`](../prototype/RitnProtoRecipe.md) au data stage.
- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage`. Voir [Wrappers temporaires](../../concepts/temporary-wrappers.md).

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibForce`](RitnLibForce.md) · [`RitnProtoRecipe`](../prototype/RitnProtoRecipe.md)
- [Wrappers temporaires (règle d'or)](../../concepts/temporary-wrappers.md)
