---
title: lualib/other-functions
type: reference
lang: en
---

# `lualib/other-functions`

🇫🇷 [Version française](../../../fr/reference/lualib/other-functions.md)

The "misc" utility module. Its central member is **`type`** — the extended type resolver (`object_name`-based) used by **every** RitnLib wrapper class to validate its inputs. It also holds flow-control, item, debug and serialization helpers.

| | |
|---|---|
| **Source** | `lualib/other-functions.lua` |
| **Type** | function module (returned table) |
| **Access** | `local util = require(ritnlib.defines.other)` |

---

## Type & flow control

#### `type(value)` → `string`
**Extended** type resolver: like native `type()`, but additionally recognizes Factorio objects (`"LuaPlayer"`, `"LuaEntity"`, `"LuaSurface"`…) and RitnLib classes via their `object_name`. It's the basis of every constructor guard (`util.type(x) ~= "LuaPlayer"`…).

**Parameters**: `value` :: `any`.

#### `isType(value, pType)` → `boolean`
`true` if `type(value) == pType`.

#### `ifElse(Condition, Then, Else)` → `any`
Returns `Then` if `Condition` is truthy, otherwise `Else`.

> **Warning** — Not a real ternary: `Then` **and** `Else` are **both evaluated** at call time (Lua evaluates arguments). Don't pass expressions with side effects.

#### `tryCatch(funcTry, funcCatch?)`
Runs `funcTry`; on error, calls `funcCatch` if provided.

---

## Strings & tables

#### `split(inputstr, sep?)` → `string[]`
Splits `inputstr` by the `sep` separator.

#### `str_start(str, start)` → `boolean`
`true` if `str` starts with `start`.
> **Warning** — **Deprecated** — use [`string-functions.startsWith`](string-functions.md) instead.

#### `getn(tab?)` → `number`
Number of entries in a table (nil-safe).

---

## Items

#### `give_item(LuaPlayer, item)` · `give_item_list(LuaPlayer, items)`
Gives an item (or a list of items) to a player.

**Parameters**: `LuaPlayer` :: `LuaPlayer` · `item` :: `table` / `items` :: `table[]`.

---

## Serialization & ids

#### `table_to_json(table)` → `string`
Fast JSON serialization of a table.
> **Warning** — No escaping of special characters, no array support (everything is serialized as an object). For robust JSON, use [`json-functions`](json-functions.md).

#### `uuid()` → `string`
Generates a unique identifier.
> **Note** — Based on Factorio's `math.random` (deterministic per map seed, multiplayer-synced): UUIDs are **reproducible across clients** (desync-safe, **not** cryptographically random).

---

## Debug

#### `ritnPrint(txt)` · `ritnLog(txt)`
Personal debug helpers.
> **Warning** — `ritnPrint` crashes if no player named "Ritn" exists. Don't use in shipped consumer code.

---

## Output & remote

#### `writeToOutput(output, appendContent?)` → `string?` · `writeToProductionStats(identifierer, appendContent)`
Writes to output files (`script-output`).
> **Warning** — Depend on globals **the consumer must define** before calling, otherwise a `nil` concatenation error.

#### `callRemoteFreeplay(function_call, value?)`
Calls a function of the freeplay remote interface.

#### `build_clock_string(time)` → `string`
Formats a tick/second count into a readable clock.

---

## Graphics prototypes (legacy)

#### `assembler1pipepictures(path)` · `pipecoverspictures(path)` → `table` · `addFluidBoxes(entity)` → `table?`
Graphics-prototype helpers (data stage).
> **Warning — 1.x** — `assembler1pipepictures` / `pipecoverspictures` use the `hr_version` sprite layout (1.x), **ignored in 2.0**. See [Factorio 2.0 migration](../../../migration-2.0.md).

---

## Always-`nil` members

> **Warning** — `spairs` and `clearOutput` are **exported but never defined** → always `nil`. Misleading API surface. See [known bugs](../../debt/known-bugs.md).

---

## Usage example

```lua
local util = require(ritnlib.defines.other)

if util.type(entity) ~= "LuaEntity" then return end   -- standard guard
local id = util.uuid()
local parts = util.split("a.b.c", ".")
```

## See also

- [Class map](../overview.md)
- [`string-functions`](string-functions.md) · [`table-functions`](table-functions.md) · [`json-functions`](json-functions.md)
- [Known bugs](../../debt/known-bugs.md) · [2.0 migration](../../../migration-2.0.md)
