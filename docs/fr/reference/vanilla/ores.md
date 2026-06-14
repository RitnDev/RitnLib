---
title: lualib/vanilla/ores
type: reference
lang: fr
---

# `lualib/vanilla/ores`

🇬🇧 [English version](../../../en/reference/vanilla/ores.md)

Données de minerais et `resource_autoplace` issues du moteur Factorio, regroupées pour usage par RitnLib.

| | |
|---|---|
| **Source** | `lualib/vanilla/ores.lua` |
| **Origine** | fork des données / `resource_autoplace` vanilla |
| **Accès** | require par chemin direct (interne) |

> **Nature** — Recopie des données moteur avec variables rendues **locales** (optimisation). Fournit `resource_autoplace` (settings d'autoplacement) et les payloads de minerais consommés par [`RitnProtoOre.active`](../prototype/RitnProtoOre.md). Exclu des annotations LuaLS, non re-documenté fonction par fonction ici.

## Voir aussi

- [`RitnProtoOre`](../prototype/RitnProtoOre.md) · [Carte des classes](../overview.md) · [`vanilla/util`](util.md)
