---
title: RitnProtoSprite
type: reference
lang: fr
---

# `RitnProtoSprite`

🇬🇧 [English version](../../../en/reference/prototype/RitnProtoSprite.md)

Manipulateur **data stage** pour `data.raw["sprite"][<nom>]`. Hérite de [`RitnPrototype`](RitnPrototype.md). Fournit des raccourcis pour injecter un sprite dans les `utility-sprites` et pour déclarer de nouveaux sprites.

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Sprite.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.sprite)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoSprite"` |

---

## Constructeur

#### `RitnProtoSprite(sprite_name)` → [`RitnProtoSprite`](RitnProtoSprite.md)

Deep-copie `data.raw["sprite"][sprite_name]` dans `prototype` s'il existe.

**Paramètres**
- `sprite_name` :: `string` — nom du sprite.

---

## Méthodes

#### `:createUtility(priority?, flags?)` → [`RitnProtoSprite`](RitnProtoSprite.md)
Copie le sprite dans `data.raw["utility-sprites"].default[<name>]` pour le rendre disponible comme utility-sprite. Défauts : `priority = "medium"`, `flags = {"icon"}`.

**Paramètres** : `priority` :: `string?` · `flags` :: `string[]?`.

#### `:extend(name, file_name, size?)`
Déclare un **nouveau** sprite via `data:extend({...})`. `size` accepte un `number` (carré) ou une table `{w, h}` (défaut 32×32).

**Paramètres** : `name` :: `string` · `file_name` :: `string` (chemin) · `size` :: `number`|`number[]?`.

```lua
local RitnSprite = require(ritnlib.defines.class.prototype.sprite)
RitnSprite():extend("ritn-logo", "__MonMod__/graphics/logo.png", 64)
```

> Les mutateurs génériques sont hérités de [`RitnPrototype`](RitnPrototype.md).

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoStyle`](RitnProtoStyle.md) · [Carte des classes](../overview.md) · [Migration 2.0](../../../migration-2.0.md)
