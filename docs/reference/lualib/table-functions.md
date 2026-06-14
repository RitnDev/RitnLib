---
title: lualib/table-functions
type: reference
lang: fr
---

# `lualib/table-functions`


Module utilitaire **table**. Ré-exporte les fonctions natives/Factorio `table.*` (`deepcopy`, `compare`, `insert`…) et ajoute des helpers (tests de vacuité, recherche d'index, position…).

| | |
|---|---|
| **Source** | `lualib/table-functions.lua` |
| **Type** | module de fonctions (table retournée) |
| **Accès** | `local table = require(ritnlib.defines.table)` |

---

## Helpers RitnLib

#### `isEmpty(pTable)` → `boolean` · `empty(pTable)` → `boolean` · `isNotEmpty(pTable)` → `boolean`
Tests de vacuité. `empty` est un **alias** de `isEmpty` ; `isNotEmpty` en est la négation.

#### `length(pTable)` → `integer`
Nombre d'éléments de la table (compte par `pairs`, gère les tables non-séquentielles).

#### `isTable(value)` → `boolean`
`true` si `value` est une table.

#### `isPosition(value)` → `boolean`
`true` si `value` ressemble à une `MapPosition`.

> **Avertissement** — Ne reconnaît que la **forme objet** `{x = …, y = …}`. La forme array `{x, y}` (aussi acceptée par les API Factorio) est **rejetée**.

#### `containsKey(pTable, key)` → `boolean`
`true` si `key` existe dans `pTable`.

#### `indexOf(pTable, pValue)` → `integer`
Position de `pValue` dans la table.

> **Avertissement** — Renvoie la **position dans l'ordre d'itération** (le Nème couple visité par `pairs`), pas forcément la clé. Pour les tables array pures, les deux coïncident.

#### `index(pTable, key, value)` → `any`
Cherche l'entrée (sous-table) dont `[key] == value` et renvoie sa position d'itération.

#### `getIndex(pTable, pPosition)` → `any?`
Renvoie l'élément situé à la `pPosition`-ème position d'itération.

#### `getRandom(pTable)` → `any?`
Renvoie un élément au hasard de la table.

#### `busy(pTable)` → `boolean`
Indicateur d'occupation (table non vide).

#### `removeByValue(pTable, value)`
Supprime de `pTable` la (les) entrée(s) égale(s) à `value`.

---

## Ré-exports natifs `table.*`

| Fonction | Note |
|---|---|
| `deepcopy`, `compare` | helpers Factorio |
| `concat`, `insert`, `remove`, `sort`, `maxn`, `pack`, `unpack` | natifs Lua/Factorio |
| `pairs_concat` | ⚠ n'existe pas dans le runtime Factorio → **toujours `nil`** |

---

## Exemple d'usage

```lua
local table = require(ritnlib.defines.table)

if table.isNotEmpty(list) then
    local copy = table.deepcopy(list)
end

-- recherche d'une entité par champ (cf. RitnLibSurface:getEntity / RitnLibForce:getChartTag)
local i = table.index(tabEntities, "unit_number", unit_number)
local entity = tabEntities[i]
```

## Remarques

- **`pairs_concat` est toujours `nil`** — déclaré mais inexistant au runtime (voir [bugs connus](../../debt/known-bugs.md)).
- **`isPosition`** ne gère que la forme objet `{x=,y=}`.
- **`index` / `indexOf`** raisonnent en *ordre d'itération*, pas en clé.

## Voir aussi

- [Carte des classes](../overview.md)
- [`string-functions`](string-functions.md) · [`other-functions`](other-functions.md)
