---
title: lualib/vanilla/types
type: reference
lang: fr
---

# `lualib/vanilla/types` (`types_entity` / `types_item`)


Listes des types de prototypes Factorio (entités et items), utilisées pour la **résolution dynamique de type** au data stage.

| | |
|---|---|
| **Sources** | `lualib/vanilla/types_entity.lua`, `lualib/vanilla/types_item.lua` |
| **Origine** | listes de types issues du moteur |
| **Accès** | require par chemin direct (interne) |

> **Nature** — Recopies de listes moteur (variables **locales**, optimisation). Elles servent à [`RitnPrototype:getEntityType`](../prototype/RitnPrototype.md) / `:getItemType` : on itère ces listes pour trouver le `data.raw[type][name]` existant, ce qui permet aux constructeurs de [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) / [`RitnProtoItem`](../prototype/RitnProtoItem.md) d'**auto-détecter** le type. Exclu des annotations LuaLS, non détaillé ici.

> **Entrées sans table** — Les deux listes nomment des types dont `data.raw` n'a aucune table sur une partie vanilla, soit parce que le moteur a supprimé le type, soit parce qu'aucun prototype de ce type n'est chargé. Mesuré sur 2.0.77 et 2.1.20 : `item-with-label`, `item-with-inventory`, `item-with-tags`, `mining-tool` côté items (plus `tool` sur 2.1, où les packs de science sont des items ordinaires), et `flying-text`, `player-port`, `flame-thrower-explosion`, `curved-rail`, `particle`, `leaf-particle`, `smoke` côté entités. Les deux résolveurs les sautent ; `types_entity` contient aussi `trivial-smoke` deux fois, sans conséquence.

## Voir aussi

- [`RitnPrototype`](../prototype/RitnPrototype.md) · [`RitnProtoEntity`](../prototype/RitnProtoEntity.md) · [`RitnProtoItem`](../prototype/RitnProtoItem.md) · [Carte des classes](../overview.md)
