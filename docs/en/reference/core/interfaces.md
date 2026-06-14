---
title: core/interfaces.lua
type: reference
lang: en
---

# `core/interfaces.lua`

🇫🇷 [Version française](../../../fr/reference/core/interfaces.md)

RitnLib's remote-interface registration, loaded by `control.lua` (flagged "beta"). It's an **internal** file: a consumer mod doesn't require it.

| | |
|---|---|
| **Source** | `core/interfaces.lua` |
| **Stage** | control (runtime) |
| **Loading** | by RitnLib's `control.lua` (internal) |

---

## Current state

- **`"RitnLib"` interface** registered via `remote.add_interface("RitnLib", lib_interfaces)` — but `lib_interfaces` is an **empty table**: no remote call is exposed yet (reserved slot).
- **Informatron block** (`informatron_interfaces`: `informatron_menu` / `informatron_page_content` callbacks) **prepared but inactive** — its `remote.add_interface(...)` line is commented out. The [Informatron](https://mods.factorio.com/mod/informatron) integration is unfinished.

> **Note** — Since RitnLib exposes no remote call yet, there's nothing to call from the consumer side. This file mainly documents the reserved slot for future interfaces.

## See also

- [Class map](../overview.md) · [`RitnLibInformatron`](../runtime/RitnLibInformatron.md) (beta) · [`RitnLibGui`](../runtime/RitnLibGui.md)
