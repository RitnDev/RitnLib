---
title: lualib/json-functions
type: reference
lang: en
---

# `lualib/json-functions`

🇫🇷 [Version française](../../../fr/reference/lualib/json-functions.md)

Robust JSON encode / decode. The module **embeds** [rxi/json.lua](https://github.com/rxi/json.lua) v0.1.2 (MIT license) verbatim.

| | |
|---|---|
| **Source** | `lualib/json-functions.lua` |
| **Type** | function module (returned table) |
| **Access** | `local json = require(ritnlib.defines.json)` |
| **Origin** | [rxi/json.lua](https://github.com/rxi/json.lua) v0.1.2 (MIT) |

---

## Fields

#### `json._version` :: `"0.1.2"` `[Read]`
Version of the embedded rxi library.

---

## Functions

#### `json.encode(val)` → `string`
Serializes a Lua value to a JSON string.

**Parameters**
- `val` :: `any` — value to serialize (table, string, number, boolean, nil).

> **Warning** — Raises on: circular reference, sparse array table, mixed/invalid keys, unsupported type (e.g. `function`), `NaN`/`±inf` number.

```lua
local json = require(ritnlib.defines.json)
local str = json.encode({ name = "ritn", level = 3, tags = { "a", "b" } })
```

#### `json.decode(str)` → `any`
Parses a JSON string into Lua values.

**Parameters**
- `str` :: `string` — JSON string.

> **Warning** — Raises (with line/column) on malformed input or trailing garbage.

```lua
local data = json.decode('{"name":"ritn","level":3}')
-- data.name == "ritn", data.level == 3
```

---

## Remarks

- **Robust JSON** — for a fast but limited encoding (no escaping, objects only), see `toJson` in [`other-functions`](other-functions.md); for reliable JSON, use **this module**.
- **MIT license** — the rxi license block is kept at the top of the source file.

## See also

- [Class map](../overview.md)
- [`other-functions`](other-functions.md) · [`table-functions`](table-functions.md)
