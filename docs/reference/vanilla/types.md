---
title: lualib/vanilla/types
type: reference
lang: fr
---

# `lualib/vanilla/types` (`types_entity` / `types_item` / `types_equipment`)


Listes des types de prototypes Factorio (entités, items, équipements), utilisées pour la **résolution dynamique de type** au data stage.

| | |
|---|---|
| **Sources** | `lualib/vanilla/types_entity.lua`, `lualib/vanilla/types_item.lua`, `lualib/vanilla/types_equipment.lua` |
| **Origine** | listes de types issues du moteur (Factorio 2.x) |
| **Accès** | require par chemin direct (interne) |

> **Nature** — Recopies de listes moteur (variables **locales**, optimisation). Elles servent à [`RitnPrototype`](../prototype/RitnPrototype.md) `:getEntityType()` / `:getItemType()` / `:getEquipmentType()` : on itère ces listes pour trouver le `data.raw[type][name]` existant, ce qui permet aux constructeurs de [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) / [`RitnProtoItem`](../prototype/RitnProtoItem.md) d'**auto-détecter** le type. Exclu des annotations LuaLS, non détaillé ici.

| Liste | Contenu |
|---|---|
| `types_entity` | Types d'entité de Factorio 2.x. |
| `types_item` | Sous-types d'item, **dans l'ordre de résolution** (le premier type où le nom existe l'emporte). Depuis 0.10.5 : ajout de `space-platform-starter-pack`, retrait de `mining-tool`, `tool` remonté en 3e position. |
| `types_equipment` | Sous-types d'équipement (`battery-equipment`, `solar-panel-equipment`, `roboport-equipment`…). Ajoutée en 0.10.5. |

> Les types d'une liste absents de `data.raw` (ex : `item-with-label` en Factorio 2.1) sont ignorés par les méthodes de résolution.

## Voir aussi

- [`RitnPrototype`](../prototype/RitnPrototype.md) · [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) · [`RitnProtoItem`](../prototype/RitnProtoItem.md) · [Carte des classes](../overview.md)
