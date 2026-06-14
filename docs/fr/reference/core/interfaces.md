---
title: core/interfaces.lua
type: reference
lang: fr
---

# `core/interfaces.lua`

🇬🇧 [English version](../../../en/reference/core/interfaces.md)

Enregistrement des interfaces remote de RitnLib, chargé par `control.lua` (marqué « beta »). C'est un fichier **interne** : un mod consommateur ne le require pas.

| | |
|---|---|
| **Source** | `core/interfaces.lua` |
| **Stage** | control (runtime) |
| **Chargement** | par `control.lua` de RitnLib (interne) |

---

## État actuel

- **Interface `"RitnLib"`** enregistrée via `remote.add_interface("RitnLib", lib_interfaces)` — mais `lib_interfaces` est une **table vide** : aucun remote call n'est exposé pour l'instant (emplacement réservé).
- **Bloc Informatron** (`informatron_interfaces` : callbacks `informatron_menu` / `informatron_page_content`) **préparé mais inactif** — sa ligne `remote.add_interface(...)` est commentée. L'intégration [Informatron](https://mods.factorio.com/mod/informatron) est inachevée.

> **Note** — Comme RitnLib n'expose encore aucun remote call, il n'y a rien à appeler côté consommateur. Ce fichier documente surtout l'emplacement réservé pour de futures interfaces.

## Voir aussi

- [Carte des classes](../overview.md) · [`RitnLibInformatron`](../runtime/RitnLibInformatron.md) (beta) · [`RitnLibGui`](../runtime/RitnLibGui.md)
