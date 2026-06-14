---
title: lualib/entity-functions
type: reference
lang: fr
---

# `lualib/entity-functions`

🇬🇧 [English version](../../../en/reference/lualib/entity-functions.md)

Helpers **data stage** pour les graphismes d'entités : boîtes de collision/sélection standard, presets de lumière/couleurs de statut, et builder de layer de sprite.

| | |
|---|---|
| **Source** | `lualib/entity-functions.lua` |
| **Type** | module de fonctions (table retournée) |
| **Accès** | `require("__RitnLib__/lualib/entity-functions")` |

---

## Fonctions

#### `standard_3x3_collision()` → `number[][]`
Renvoie une collision box 3×3 standard.

#### `standard_3x3_selection()` → `number[][]`
Renvoie une selection box 3×3 standard.

#### `standard_status_light()` → `table`
Preset de lumière de statut d'entité.

#### `standard_status_colours()` → `table`
Preset de couleurs de statut d'entité.

#### `get_layer(data)` → `table`
Builder de layer de sprite à partir d'une table `data`.

**Paramètres** : `data` :: `table`.

## Voir aussi

- [Carte des classes](../overview.md) · [`gui-functions`](gui-functions.md)
