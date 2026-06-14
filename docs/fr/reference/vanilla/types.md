---
title: lualib/vanilla/types
type: reference
lang: fr
---

# `lualib/vanilla/types` (`types_entity` / `types_item`)

🇬🇧 [English version](../../../en/reference/vanilla/types.md)

Listes des types de prototypes Factorio (entités et items), utilisées pour la **résolution dynamique de type** au data stage.

| | |
|---|---|
| **Sources** | `lualib/vanilla/types_entity.lua`, `lualib/vanilla/types_item.lua` |
| **Origine** | listes de types issues du moteur |
| **Accès** | require par chemin direct (interne) |

> **Nature** — Recopies de listes moteur (variables **locales**, optimisation). Elles servent à [`RitnPrototype:getEntityType`](../prototype/RitnPrototype.md) / `:getItemType` : on itère ces listes pour trouver le `data.raw[type][name]` existant, ce qui permet aux constructeurs de [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) / [`RitnProtoItem`](../prototype/RitnProtoItem.md) d'**auto-détecter** le type. Exclu des annotations LuaLS, non détaillé ici.

## Voir aussi

- [`RitnPrototype`](../prototype/RitnPrototype.md) · [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) · [`RitnProtoItem`](../prototype/RitnProtoItem.md) · [Carte des classes](../overview.md)
