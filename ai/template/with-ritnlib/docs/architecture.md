---
title: Architecture interne MyMod
audience: mainteneur
status: living
---

# Architecture interne — MyMod

> FR : Document vivant : à mettre à jour à chaque changement de structure (couche, module, famille de classes,
> évènement, clé de `storage`).  
> EN : Living document: update it on every structural change (layer, module, class family, event, `storage` key).

## Couches / Layers

| Dossier | Rôle |
|---|---|
| `core/` | registre `ritnlib.defines.mymod`, chargement des classes, modules, migrations |
| `classes/` | `MyModGuiPanel` (hérite de `RitnLibGui`) |
| `gui/` | `panel.lua` : description de la fenêtre |
| `modules/` | `events` (cycle de vie), `gui` (raccourci, clics, remote `gui_action_mymod_panel`) |
| `prototypes/` | `custom-inputs` |

## Évènements / Events

| Évènement | Module |
|---|---|
| `on_init`, `on_configuration_changed` | `modules/events.lua` |
| `on_gui_click`, `mymod-toggle` | `modules/gui.lua` |

## Persistance / Persistence

| Clé | Contenu |
|---|---|
| `storage.players` | données par joueur (vide au départ) |

## Interfaces remote

| Interface | Fonctions |
|---|---|
| `MyMod` | `gui_action_mymod_panel(action, event)` (appelée par RitnLibGui) |
