---
title: lualib/vanilla/ores
type: reference
lang: en
---

# `lualib/vanilla/ores`


Ore data and `resource_autoplace` taken from the Factorio engine, bundled for RitnLib use.

| | |
|---|---|
| **Source** | `lualib/vanilla/ores.lua` |
| **Origin** | fork of vanilla data / `resource_autoplace` |
| **Access** | direct-path require (internal) |

> **Nature** — A copy of the engine data with variables made **local** (optimization). Provides `resource_autoplace` (autoplace settings) and the ore payloads consumed by [`RitnProtoOre.active`](../prototype/RitnProtoOre.md). Excluded from LuaLS annotations, not re-documented function by function here.

## See also

- [`RitnProtoOre`](../prototype/RitnProtoOre.md) · [Class map](../overview.md) · [`vanilla/util`](util.md)
