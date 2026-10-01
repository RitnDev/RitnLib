---
title: lualib/vanilla/types
type: reference
lang: en
---

# `lualib/vanilla/types` (`types_entity` / `types_item` / `types_equipment`)


Lists of Factorio prototype types (entities, items, equipment), used for **dynamic type resolution** at data stage.

| | |
|---|---|
| **Sources** | `lualib/vanilla/types_entity.lua`, `lualib/vanilla/types_item.lua`, `lualib/vanilla/types_equipment.lua` |
| **Origin** | engine type lists (Factorio 2.x) |
| **Access** | direct-path require (internal) |

> **Nature** — Copies of engine lists (variables made **local**, optimization). They feed [`RitnPrototype`](../prototype/RitnPrototype.md) `:getEntityType()` / `:getItemType()` / `:getEquipmentType()`: iterating these lists to find the existing `data.raw[type][name]` lets [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) / [`RitnProtoItem`](../prototype/RitnProtoItem.md) constructors **auto-detect** the type. Excluded from LuaLS annotations, not detailed here.

| List | Content |
|---|---|
| `types_entity` | Factorio 2.x entity types. |
| `types_item` | Item sub-types, **in resolution order** (the first type where the name exists wins). Since 0.10.5: added `space-platform-starter-pack`, removed `mining-tool`, `tool` moved up to 3rd position. |
| `types_equipment` | Equipment sub-types (`battery-equipment`, `solar-panel-equipment`, `roboport-equipment`…). Added in 0.10.5. |

> List types missing from `data.raw` (e.g. `item-with-label` in Factorio 2.1) are skipped by the resolution methods.

## See also

- [`RitnPrototype`](../prototype/RitnPrototype.md) · [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) · [`RitnProtoItem`](../prototype/RitnProtoItem.md) · [Class map](../overview.md)
