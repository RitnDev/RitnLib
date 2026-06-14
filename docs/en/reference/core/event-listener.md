---
title: core/eventListener.lua — fork
type: reference
lang: en
---

# `core/eventListener.lua` — event aggregator (fork)

🇫🇷 [Version française](../../../fr/reference/core/event-listener.md)

Event-handler aggregator — a **fork** of Factorio's `event_handler.lua` (modified by ZwerOxotnik). Lets several "libs" register their handlers through one shared dispatcher: each lib exposes optional members (`events`, `on_nth_tick`, `on_init`, `on_load`, `on_configuration_changed`, `add_remote_interface`, `add_commands`) that the aggregator wires to `script.*`.

| | |
|---|---|
| **Source** | `core/eventListener.lua` |
| **Stage** | control (runtime) |
| **Access** | `require("__RitnLib__.core.eventListener")` (opt-in, direct path) |
| **`object_name` (lib type)** | `"RitnLibEventLib"` |

> ⚠ **Experimental / opt-in status.**
> - **Not loaded** by RitnLib's own `control.lua` — it's an option for consumer mods. And `ritnlib.defines.event` points to the **vanilla** `__core__/lualib/event_handler`, *not* this fork.
> - **Side effects on require**: it immediately registers `script.on_init` / `script.on_load` / `script.on_configuration_changed`. A mod can only have **one** handler per `script.*` slot — don't mix this aggregator with direct `script.on_init(...)` in the same mod.
> - If the [`zk-lib`](https://mods.factorio.com/mod/zk-lib) mod is active, this file **fully delegates** to its optimized `event_handler_vZO` and returns that instead.

---

## A "lib" contract (`RitnLibEventLib`)

A lib passed to the aggregator exposes, all optional:

| Member | Type | Role |
|---|---|---|
| `events` | `table<defines.events\|string\|integer, fun(event)>` | handlers by event id |
| `on_nth_tick` | `table<integer, fun(event)>` | handlers by tick interval |
| `on_init` · `on_load` | `fun()` | lifecycle |
| `on_configuration_changed` | `fun(data)` | config change |
| `add_remote_interface` · `add_commands` | `fun()` | run once at setup |

The aggregator merges multiple handlers for the same event into a loop when needed.

## See also

- [Class map](../overview.md) · [`RitnLibEvent`](../runtime/RitnLibEvent.md) · [ADR-0003 — fork status (upcoming)](../../adr/README.md)
