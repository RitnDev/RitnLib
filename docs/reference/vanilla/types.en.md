---
title: lualib/vanilla/types
type: reference
lang: en
---

# `lualib/vanilla/types` (`types_entity` / `types_item`)


Lists of Factorio prototype types (entities and items), used for **dynamic type resolution** at data stage.

| | |
|---|---|
| **Sources** | `lualib/vanilla/types_entity.lua`, `lualib/vanilla/types_item.lua` |
| **Origin** | engine type lists |
| **Access** | direct-path require (internal) |

> **Nature** — Copies of engine lists (variables made **local**, optimization). They feed [`RitnPrototype:getEntityType`](../prototype/RitnPrototype.md) / `:getItemType`: iterating these lists to find the existing `data.raw[type][name]` lets [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) / [`RitnProtoItem`](../prototype/RitnProtoItem.md) constructors **auto-detect** the type. Excluded from LuaLS annotations, not detailed here.

## See also

- [`RitnPrototype`](../prototype/RitnPrototype.md) · [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) · [`RitnProtoItem`](../prototype/RitnProtoItem.md) · [Class map](../overview.md)
