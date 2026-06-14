---
title: lualib/gui-functions
type: reference
lang: fr
---

# `lualib/gui-functions`


Helpers **data stage** pour dériver des styles GUI depuis `data.raw['gui-style'].default`. Utilisés par `prototypes/gui-style.lua` pour construire le set de styles `*-ritngui`.

| | |
|---|---|
| **Source** | `lualib/gui-functions.lua` |
| **Type** | module de fonctions (table retournée) |
| **Accès** | `require("__RitnLib__/lualib/gui-functions")` |

---

## Constante

#### `SUFFIX` :: `"-ritngui"` `[Read]`
Suffixe de nommage des styles dérivés par RitnLib (namespace).

---

## Fonctions

#### `copyDefaultGui(dupl, source)` → `table`
Deep-copie la table de style `source` dans `data.raw['gui-style'].default[dupl]` et renvoie la nouvelle entrée.

**Paramètres** : `dupl` :: `string` (nouvelle clé) · `source` :: `table` (style existant à copier).

> **Avertissement** — Pas de vérification de collision : si `dupl` existe déjà, il est **écrasé silencieusement**. Namespace tes clés (ex. avec `SUFFIX`).

#### `convertEmpty(dupl)` → `table`
Remplace (ou crée) `data.raw['gui-style'].default[dupl]` par un `empty_widget_style` nu (sans graphismes) — pour neutraliser visuellement un slot.

**Paramètres** : `dupl` :: `string`.

## Voir aussi

- [Carte des classes](../overview.md) · [`entity-functions`](entity-functions.md) · [`RitnProtoStyle`](../prototype/RitnProtoStyle.md)
