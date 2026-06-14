---
title: RitnProtoCustomInput
type: reference
lang: fr
---

# `RitnProtoCustomInput`


Manipulateur **data stage** pour `data.raw["custom-input"][<nom>]` (raccourcis clavier custom). Hérite de [`RitnPrototype`](RitnPrototype.md).

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/CustomInput.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.customInput)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoCustomInput"` |

---

## Constructeur

#### `RitnProtoCustomInput(input_name)` → [`RitnProtoCustomInput`](RitnProtoCustomInput.md)

Deep-copie `data.raw["custom-input"][input_name]` dans `prototype` s'il existe.

**Paramètres**
- `input_name` :: `string` — nom du custom-input.

---

## Méthodes

#### `:extend(name, key_sequence, consuming?)` → [`RitnProtoCustomInput`](RitnProtoCustomInput.md)
Déclare un **nouveau** custom-input via `data:extend({...})`. Défaut `consuming = "game-only"`.

**Paramètres** : `name` :: `string` · `key_sequence` :: `string` (ex. `"CONTROL + ALT + M"`) · `consuming` :: `"none"|"game-only"|"script-only"?`.

#### `:linkedControl(linked_game_control)` → [`RitnProtoCustomInput`](RitnProtoCustomInput.md)
Définit `linked_game_control` sur le custom-input courant, le liant à un contrôle Factorio natif.

**Paramètres** : `linked_game_control` :: `string` (ex. `"build"`, `"mine"`).

> Les mutateurs génériques sont hérités de [`RitnPrototype`](RitnPrototype.md).

---

## Exemple d'usage

**Déclarer un raccourci d'ouverture de menu** (`RitnLobbyGame/prototypes/custom-inputs.lua`) :

```lua
local RitnInputCustom = require(ritnlib.defines.class.prototype.customInput)
RitnInputCustom:extend(
    ritnlib.defines.lobby.names.customInput.toggle_main_menu,
    "CONTROL + ALT + M"
)
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [Carte des classes](../overview.md) · [Migration 2.0](../../migration-2.0.md)
