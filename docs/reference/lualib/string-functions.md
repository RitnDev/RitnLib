---
title: lualib/string-functions
type: reference
lang: fr
---

# `lualib/string-functions`


Module utilitaire **string**. Ré-exporte les fonctions natives `string.*` (avec alias pratiques) et ajoute des **helpers nil-safe** (garde `defaultValue`, tests `isEmptyString`/`isNil`…) très utilisés dans RitnLib.

| | |
|---|---|
| **Source** | `lualib/string-functions.lua` |
| **Type** | module de fonctions (table retournée) |
| **Accès** | `local string = require(ritnlib.defines.string)` |

> La table retournée **ne remplace pas** `string` natif globalement : tu la captures dans une variable locale.

---

## Constante

#### `TOKEN_EMPTY_STRING` :: `""` `[Read]`
Marqueur de chaîne vide, réutilisé par les gardes.

---

## Helpers RitnLib

#### `defaultValue(value, default?)` → `string`
Garde nil-safe standard : renvoie `value` si c'est une string, sinon `default` (lui-même par défaut `""`).

**Paramètres** : `value` :: `any` · `default` :: `string?` (défaut `""`).

#### `isString(value)` → `boolean`
`true` si `value` est une string.

#### `isEmptyString(value)` → `boolean` · `isNotEmptyString(value)` → `boolean`
`isEmptyString` : `true` si `value` est la string vide, `nil`, ou pas une string. `isNotEmptyString` en est la négation.

#### `isNil(value)` → `boolean` · `isNotNil(value)` → `boolean`
Tests `== nil` et sa négation.

#### `equals(value1, value2)` → `boolean`
Comparaison `==` simple.

#### `startsWith(str, value)` → `boolean`
`true` si `str` commence par `value` (via `string.find` position 1).

> **Avertissement** — `value` est interprété comme un **pattern Lua**, pas une string brute : les caractères magiques (`-`, `%`, `.`…) sont actifs.

---

## Ré-exports natifs `string.*`

Disponibles tels quels (voir la [doc Lua/Factorio](https://lua-api.factorio.com/latest/)), plus quelques **alias** :

| Fonction | Alias |
|---|---|
| `byte`, `char`, `dump`, `find`, `format`, `gmatch`, `match`, `rep`, `reverse`, `sub` | — |
| `gsub` | `replace` |
| `len` | `length` |
| `lower` | `toLower` |
| `upper` | `toUpper` |

---

## Exemple d'usage

```lua
local string = require(ritnlib.defines.string)

local name = string.defaultValue(maybe_name, "anonymous")  -- nil-safe
if string.isNotEmptyString(input) then
    -- …
end
local upper = string.toUpper("ritn")
```

## Voir aussi

- [Carte des classes](../overview.md)
- [`other-functions`](other-functions.md) · [`table-functions`](table-functions.md)
