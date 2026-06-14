---
title: lualib/table-functions
type: reference
lang: en
---

# `lualib/table-functions`


**table** utility module. Re-exports the native/Factorio `table.*` functions (`deepcopy`, `compare`, `insert`…) and adds helpers (emptiness tests, index lookup, position…).

| | |
|---|---|
| **Source** | `lualib/table-functions.lua` |
| **Type** | function module (returned table) |
| **Access** | `local table = require(ritnlib.defines.table)` |

---

## RitnLib helpers

#### `isEmpty(pTable)` → `boolean` · `empty(pTable)` → `boolean` · `isNotEmpty(pTable)` → `boolean`
Emptiness tests. `empty` is an **alias** of `isEmpty`; `isNotEmpty` is its negation.

#### `length(pTable)` → `integer`
Number of entries in the table (counts via `pairs`, handles non-sequential tables).

#### `isTable(value)` → `boolean`
`true` if `value` is a table.

#### `isPosition(value)` → `boolean`
`true` if `value` looks like a `MapPosition`.

> **Warning** — Only recognizes the **object form** `{x = …, y = …}`. The array form `{x, y}` (also accepted by Factorio APIs) is **rejected**.

#### `containsKey(pTable, key)` → `boolean`
`true` if `key` exists in `pTable`.

#### `indexOf(pTable, pValue)` → `integer`
Position of `pValue` in the table.

> **Warning** — Returns the **iteration-order position** (the Nth pair visited by `pairs`), not necessarily the key. For pure array tables both coincide.

#### `index(pTable, key, value)` → `any`
Finds the entry (sub-table) where `[key] == value` and returns its iteration position.

#### `getIndex(pTable, pPosition)` → `any?`
Returns the element at the `pPosition`-th iteration position.

#### `getRandom(pTable)` → `any?`
Returns a random element of the table.

#### `busy(pTable)` → `boolean`
Busy indicator (non-empty table).

#### `removeByValue(pTable, value)`
Removes from `pTable` the entry/entries equal to `value`.

---

## Native `table.*` re-exports

| Function | Note |
|---|---|
| `deepcopy`, `compare` | Factorio helpers |
| `concat`, `insert`, `remove`, `sort`, `maxn`, `pack`, `unpack` | native Lua/Factorio |
| `pairs_concat` | ⚠ doesn't exist in the Factorio runtime → **always `nil`** |

---

## Usage example

```lua
local table = require(ritnlib.defines.table)

if table.isNotEmpty(list) then
    local copy = table.deepcopy(list)
end

-- find an entity by field (cf. RitnLibSurface:getEntity / RitnLibForce:getChartTag)
local i = table.index(tabEntities, "unit_number", unit_number)
local entity = tabEntities[i]
```

## Remarks

- **`pairs_concat` is always `nil`** — declared but nonexistent at runtime (see [known bugs](../../debt/known-bugs.md)).
- **`isPosition`** only handles the object form `{x=,y=}`.
- **`index` / `indexOf`** reason in *iteration order*, not by key.

## See also

- [Class map](../overview.md)
- [`string-functions`](string-functions.md) · [`other-functions`](other-functions.md)
