---
title: lualib/json-functions
type: reference
lang: fr
---

# `lualib/json-functions`


Encode / décode JSON robuste. Le module **embarque** [rxi/json.lua](https://github.com/rxi/json.lua) v0.1.2 (licence MIT) tel quel.

| | |
|---|---|
| **Source** | `lualib/json-functions.lua` |
| **Type** | module de fonctions (table retournée) |
| **Accès** | `local json = require(ritnlib.defines.json)` |
| **Origine** | [rxi/json.lua](https://github.com/rxi/json.lua) v0.1.2 (MIT) |

---

## Champs

#### `json._version` :: `"0.1.2"` `[Read]`
Version de la bibliothèque rxi embarquée.

---

## Fonctions

#### `json.encode(val)` → `string`
Sérialise une valeur Lua en chaîne JSON.

**Paramètres**
- `val` :: `any` — valeur à sérialiser (table, string, number, boolean, nil).

> **Avertissement** — Lève une erreur sur : référence circulaire, table « array creuse » (sparse), clés mixtes/invalides, type non supporté (ex. `function`), nombre `NaN`/`±inf`.

```lua
local json = require(ritnlib.defines.json)
local str = json.encode({ name = "ritn", level = 3, tags = { "a", "b" } })
```

#### `json.decode(str)` → `any`
Parse une chaîne JSON en valeurs Lua.

**Paramètres**
- `str` :: `string` — chaîne JSON.

> **Avertissement** — Lève une erreur (avec ligne/colonne) sur input malformé ou « trailing garbage » en fin de chaîne.

```lua
local data = json.decode('{"name":"ritn","level":3}')
-- data.name == "ritn", data.level == 3
```

---

## Remarques

- **JSON robuste** — pour un encodage rapide mais limité (sans échappement, objets seulement), voir le `toJson` de [`other-functions`](other-functions.md) ; pour du JSON fiable, c'est **ce module** qu'il faut.
- **Licence MIT** — le bloc de licence rxi est conservé en tête du fichier source.

## Voir aussi

- [Carte des classes](../overview.md)
- [`other-functions`](other-functions.md) · [`table-functions`](table-functions.md)
