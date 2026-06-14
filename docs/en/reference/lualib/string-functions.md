---
title: lualib/string-functions
type: reference
lang: en
---

# `lualib/string-functions`

🇫🇷 [Version française](../../../fr/reference/lualib/string-functions.md)

**string** utility module. Re-exports the native `string.*` functions (with handy aliases) and adds **nil-safe helpers** (the `defaultValue` guard, `isEmptyString`/`isNil` tests…) used heavily across RitnLib.

| | |
|---|---|
| **Source** | `lualib/string-functions.lua` |
| **Type** | function module (returned table) |
| **Access** | `local string = require(ritnlib.defines.string)` |

> The returned table **doesn't replace** native `string` globally: you capture it in a local variable.

---

## Constant

#### `TOKEN_EMPTY_STRING` :: `""` `[Read]`
Empty-string marker, reused by the guards.

---

## RitnLib helpers

#### `defaultValue(value, default?)` → `string`
Standard nil-safe guard: returns `value` if it's a string, otherwise `default` (itself defaulting to `""`).

**Parameters**: `value` :: `any` · `default` :: `string?` (default `""`).

#### `isString(value)` → `boolean`
`true` if `value` is a string.

#### `isEmptyString(value)` → `boolean` · `isNotEmptyString(value)` → `boolean`
`isEmptyString`: `true` if `value` is the empty string, `nil`, or not a string. `isNotEmptyString` is its negation.

#### `isNil(value)` → `boolean` · `isNotNil(value)` → `boolean`
`== nil` test and its negation.

#### `equals(value1, value2)` → `boolean`
Plain `==` comparison.

#### `startsWith(str, value)` → `boolean`
`true` if `str` starts with `value` (via `string.find` position 1).

> **Warning** — `value` is interpreted as a **Lua pattern**, not a plain string: magic characters (`-`, `%`, `.`…) are active.

---

## Native `string.*` re-exports

Available as-is (see the [Lua/Factorio docs](https://lua-api.factorio.com/latest/)), plus a few **aliases**:

| Function | Alias |
|---|---|
| `byte`, `char`, `dump`, `find`, `format`, `gmatch`, `match`, `rep`, `reverse`, `sub` | — |
| `gsub` | `replace` |
| `len` | `length` |
| `lower` | `toLower` |
| `upper` | `toUpper` |

---

## Usage example

```lua
local string = require(ritnlib.defines.string)

local name = string.defaultValue(maybe_name, "anonymous")  -- nil-safe
if string.isNotEmptyString(input) then
    -- …
end
local upper = string.toUpper("ritn")
```

## See also

- [Class map](../overview.md)
- [`other-functions`](other-functions.md) · [`table-functions`](table-functions.md)
