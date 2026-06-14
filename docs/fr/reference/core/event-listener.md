---
title: core/eventListener.lua — fork
type: reference
lang: fr
---

# `core/eventListener.lua` — agrégateur d'events (fork)

🇬🇧 [English version](../../../en/reference/core/event-listener.md)

Agrégateur d'event-handlers — **fork** du `event_handler.lua` de Factorio (modifié par ZwerOxotnik). Permet à plusieurs « libs » d'enregistrer leurs handlers via un dispatcher partagé : chaque lib expose des membres optionnels (`events`, `on_nth_tick`, `on_init`, `on_load`, `on_configuration_changed`, `add_remote_interface`, `add_commands`) que l'agrégateur câble sur `script.*`.

| | |
|---|---|
| **Source** | `core/eventListener.lua` |
| **Stage** | control (runtime) |
| **Accès** | `require("__RitnLib__.core.eventListener")` (opt-in, chemin direct) |
| **`object_name` (type lib)** | `"RitnLibEventLib"` |

> ⚠ **Statut expérimental / opt-in.**
> - **Non chargé** par le `control.lua` de RitnLib — c'est une option pour les mods consommateurs. Et `ritnlib.defines.event` pointe vers le `__core__/lualib/event_handler` **vanilla**, *pas* vers ce fork.
> - **Effets de bord au require** : il enregistre immédiatement `script.on_init` / `script.on_load` / `script.on_configuration_changed`. Un mod ne peut avoir qu'**un** handler par slot `script.*` — ne pas mélanger cet agrégateur avec des `script.on_init(...)` directs dans le même mod.
> - Si le mod [`zk-lib`](https://mods.factorio.com/mod/zk-lib) est actif, ce fichier **délègue entièrement** à son `event_handler_vZO` optimisé et le retourne à la place.

---

## Contrat d'une « lib » (`RitnLibEventLib`)

Une lib passée à l'agrégateur expose, tous optionnels :

| Membre | Type | Rôle |
|---|---|---|
| `events` | `table<defines.events\|string\|integer, fun(event)>` | handlers par id d'event |
| `on_nth_tick` | `table<integer, fun(event)>` | handlers par intervalle de tick |
| `on_init` · `on_load` | `fun()` | cycle de vie |
| `on_configuration_changed` | `fun(data)` | changement de config |
| `add_remote_interface` · `add_commands` | `fun()` | exécutés une fois au setup |

L'agrégateur fusionne plusieurs handlers d'un même event dans une boucle si nécessaire.

## Voir aussi

- [Carte des classes](../overview.md) · [`RitnLibEvent`](../runtime/RitnLibEvent.md) · [ADR-0003 — statut du fork (à venir)](../../adr/README.md)
