---
title: RitnProtoStyle
type: reference
lang: fr
---

# `RitnProtoStyle`

🇬🇧 [English version](../../../en/reference/prototype/RitnProtoStyle.md)

Manipulateur **data stage** pour `data.raw["gui-style"].default[<style>]`. Builder fluent pour déclarer des styles GUI prototypés (type/name/parent/padding/size), avec un raccourci `:extendButton`. Hérite de [`RitnPrototype`](RitnPrototype.md) et override `:update()` pour l'indirection `default[...]`.

> **Avertissement — API Factorio 1.x** : cette classe n'a pas été révisée depuis Factorio 2.0. Utilisable mais **non validée pour 2.0** — voir [Migration Factorio 2.0](../../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Style.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.prototype.style)` |
| **Hérite de** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoStyle"` |

---

## Constructeur

#### `RitnProtoStyle(style_name?)` → [`RitnProtoStyle`](RitnProtoStyle.md)

Cible toujours `data.raw["gui-style"]["default"]`. Si `style_name` est fourni, deep-copie le style existant ; sinon, copie toute la table `default`. Prépare un payload `style` vierge pour les méthodes `:set*` / `:extend*`.

**Paramètres**
- `style_name` :: `string?` — clé du style sous `data.raw["gui-style"].default`.

---

## Attributs

#### `style_name` :: `string?` `[Read]`
Clé du style ciblé.

#### `style` :: `table` `[Read]`
Payload de style en construction (`{ type, name, parent, padding, size }`).

---

## Méthodes — builder

| Méthode | Effet |
|---|---|
| `:setType(type_gui)` | `style.type` (ex. `"button_style"`, `"frame_style"`) |
| `:setName(name)` | `style.name` (clé sous `default`) |
| `:setParent(parent)` | `style.parent` (style dont hériter) |
| `:setPadding(padding)` | `style.padding` |

#### `:extend()`
Commit le payload `style` courant dans `prototype[style.name]`, puis `:update()`. Lève une erreur si `type`/`name` du prototype racine sont vides.

#### `:extendButton(name, parent, size?)`
Raccourci : construit un `button_style` enfant (`type = "button_style"`, `name`, `parent`, `size` optionnel `number`|`{w,h}`), puis commit via `:extend()`.

**Paramètres** : `name` :: `string` · `parent` :: `string` · `size` :: `number`|`number[]?`.

#### `:update()`
Override : écrit dans `data.raw["gui-style"].default[style_name]` si `style_name` est défini, sinon dans `data.raw["gui-style"].default`.

---

## Exemple d'usage

**Déclarer des styles de bouton** (`RitnLobbyGame/prototypes/styles.lua`) :

```lua
local RitnStyle = require(ritnlib.defines.class.prototype.style)
RitnStyle():extendButton(ritnlib.defines.lobby.names.styles.ritn_normal_sprite_button, "button")
RitnStyle():extendButton(ritnlib.defines.lobby.names.styles.ritn_red_sprite_button, "red_button")
```

## Voir aussi

- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnLibStyle`](../runtime/RitnLibStyle.md) (runtime) · [Carte des classes](../overview.md) · [Migration 2.0](../../../migration-2.0.md)
