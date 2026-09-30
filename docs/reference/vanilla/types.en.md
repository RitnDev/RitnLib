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

> **Entries with no table** — Both lists name types `data.raw` has no table for on a vanilla game, either because the engine dropped the type or because no prototype of it is loaded. Measured on 2.0.77 and 2.1.20: `item-with-label`, `item-with-inventory`, `item-with-tags`, `mining-tool` on the item side (plus `tool` on 2.1, where science packs are ordinary items), and `flying-text`, `player-port`, `flame-thrower-explosion`, `curved-rail`, `particle`, `leaf-particle`, `smoke` on the entity side. Both resolvers skip them; `types_entity` also lists `trivial-smoke` twice, harmlessly.

## See also

- [`RitnPrototype`](../prototype/RitnPrototype.md) · [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) · [`RitnProtoItem`](../prototype/RitnProtoItem.md) · [Class map](../overview.md)
