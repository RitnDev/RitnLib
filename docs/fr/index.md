---
title: RitnLib — documentation
lang: fr
---

# RitnLib

> Bibliothèque de classes et fonctions pour les mods Factorio de Ritn.

🇬🇧 [English version](../en/index.md)

---

## Démarrer

Nouveau venu ? Commence par :

- 📦 [Démarrer avec RitnLib](getting-started.md) — installation + premier mod en 5 minutes
- 🧩 [Architecture en 4 couches](concepts/architecture-couches.md) — comment le mod est organisé
- ⚠ [Règle d'or des wrappers temporaires](concepts/wrappers-temporaires.md) — à lire **avant** d'utiliser les classes runtime

## Guides

Tutoriels orientés tâche :

- [Installation](guides/installation.md)
- [Mon premier prototype](guides/premier-prototype.md)
- [Mon premier handler runtime](guides/premier-handler.md)
- [Pattern GUI complet](guides/gui-pattern.md)
- [Snapshot et restauration d'inventaire](guides/inventory-snapshot.md)
- [Construire un setting](guides/settings-builder.md)
- [Interfaces remote](guides/remote-interfaces.md)

## Référence des classes

### Vue d'ensemble
- [Carte des classes](reference/overview.md)
- [Registre `ritnlib.defines`](reference/defines.md)

### Classes runtime (control stage)
| Classe | Wrappe | Usage |
|---|---|---|
| [`RitnLibEvent`](reference/runtime/RitnLibEvent.md) | n'importe quel event Factorio | normalisation de payload |
| [`RitnLibPlayer`](reference/runtime/RitnLibPlayer.md) | `LuaPlayer` | accès rapide |
| [`RitnLibSurface`](reference/runtime/RitnLibSurface.md) | `LuaSurface` | recherche d'entités |
| [`RitnLibForce`](reference/runtime/RitnLibForce.md) | `LuaForce` | recettes/techs/stats |
| [`RitnLibEntity`](reference/runtime/RitnLibEntity.md) | `LuaEntity` | manipulation entité |
| [`RitnLibRecipe`](reference/runtime/RitnLibRecipe.md) | `LuaRecipe` | activation runtime |
| [`RitnLibTechnology`](reference/runtime/RitnLibTechnology.md) | `LuaTechnology` | hook fin de recherche |
| [`RitnLibInventory`](reference/runtime/RitnLibInventory.md) | `LuaPlayer` + storage | snapshot/restore |
| [`RitnLibGui`](reference/runtime/RitnLibGui.md) | event GUI | dispatcher de clic |
| [`RitnLibInformatron`](reference/runtime/RitnLibInformatron.md) | event Informatron | intégration page |
| [`RitnLibGuiElement`](reference/runtime/RitnLibGuiElement.md) | payload `add{...}` | builder fluent |
| [`RitnLibStyle`](reference/runtime/RitnLibStyle.md) | `LuaStyle` | presets de style |

### Classes data (data stage)
| Classe | Manipule |
|---|---|
| [`RitnPrototype`](reference/prototype/RitnPrototype.md) | base de tous les manipulateurs |
| [`RitnProtoEntity`](reference/prototype/RitnProtoEntity.md) | `data.raw[entity-type]` |
| [`RitnProtoItem`](reference/prototype/RitnProtoItem.md) | `data.raw[item-type]` |
| [`RitnProtoRecipe`](reference/prototype/RitnProtoRecipe.md) | `data.raw.recipe` |
| [`RitnProtoTechnology`](reference/prototype/RitnProtoTechnology.md) | `data.raw.technology` |
| [`RitnProtoOre`](reference/prototype/RitnProtoOre.md) | `data.raw.resource` + autoplace |
| [`RitnProtoSprite`](reference/prototype/RitnProtoSprite.md) | `data.raw.sprite` |
| [`RitnProtoStyle`](reference/prototype/RitnProtoStyle.md) | `data.raw['gui-style']` |
| [`RitnProtoItemGroup`](reference/prototype/RitnProtoItemGroup.md) | `data.raw['item-group']` |
| [`RitnProtoItemSubgroup`](reference/prototype/RitnProtoItemSubgroup.md) | `data.raw['item-subgroup']` |
| [`RitnProtoRecipeCategory`](reference/prototype/RitnProtoRecipeCategory.md) | `data.raw['recipe-category']` |
| [`RitnProtoFuelCategory`](reference/prototype/RitnProtoFuelCategory.md) | `data.raw['fuel-category']` |
| [`RitnProtoCustomInput`](reference/prototype/RitnProtoCustomInput.md) | `data.raw['custom-input']` |
| [`RitnProtoUtilityConst`](reference/prototype/RitnProtoUtilityConst.md) | `data.raw['utility-constants']` |
| [`RitnIngredient`](reference/prototype/RitnIngredient.md) | normalisation d'ingrédient |

### Settings stage
- [`RitnLibSetting`](reference/settings/RitnLibSetting.md)

### Bibliothèques utilitaires
- [`lualib/other-functions`](reference/lualib/other-functions.md)
- [`lualib/table-functions`](reference/lualib/table-functions.md)
- [`lualib/string-functions`](reference/lualib/string-functions.md)
- [`lualib/json-functions`](reference/lualib/json-functions.md) — embarque [rxi/json.lua](https://github.com/rxi/json.lua) (MIT)
- [`lualib/entity-functions`](reference/lualib/entity-functions.md)
- [`lualib/gui-functions`](reference/lualib/gui-functions.md)
- [`lualib/LuaStyle-functions`](reference/lualib/LuaStyle-functions.md) ⚠ déprécié

### Vanilla helpers
- [`lualib/vanilla/util`](reference/vanilla/util.md)
- [`lualib/vanilla/crash-site`](reference/vanilla/crash-site.md)
- [`lualib/vanilla/ores`](reference/vanilla/ores.md)
- [`lualib/vanilla/types`](reference/vanilla/types.md)

### Couche fondation
- [`core/class.lua` — factory de classes orientée objet](reference/core/class-factory.md)
- [`core/constants.lua`](reference/core/constants.md)
- [`core/eventListener.lua` — fork](reference/core/event-listener.md) ⚠ statut expérimental
- [`core/interfaces.lua`](reference/core/interfaces.md)

## Concepts

- [Architecture en 4 couches](concepts/architecture-couches.md)
- [Cycle de vie (data → settings → control)](concepts/cycle-de-vie.md)
- [Wrappers temporaires (règle d'or)](concepts/wrappers-temporaires.md)
- [Factory de classes orientée objet maison](concepts/factory-oo.md)
- [Modèle d'events](concepts/event-model.md)
- [Persistance déléguée](concepts/persistance-deleguee.md)
- [Contrat remote consommateur](concepts/contrat-remote.md)

## Décisions d'architecture (ADR)

- [Index des ADR](adr/README.md)
- [ADR-0001 — Factory de classes orientée objet maison](adr/0001-class-factory.md)
- [ADR-0002 — Pollution `_G` vs modules retournés](adr/0002-globals-vs-modules.md)
- [ADR-0003 — Statut du fork `eventListener`](adr/0003-event-handler-fork.md)
- [ADR-0004 — Stratégie linguistique FR + EN](adr/0004-fr-en-strategie.md)

## Dette et migration

- 🐛 [Bugs connus](debt/known-bugs.md)
- 🕰 [Résidus API 1.x](debt/api-1.x-residuelle.md)
- ⚠ [APIs dépréciées](debt/deprecated.md)
- 🔧 [Migration Factorio 2.0](../migration-2.0.md)

## Pour les mainteneurs

- 🏗 [Architecture interne](../architecture.md) (FR uniquement)
- 🤝 [CONTRIBUTING](../../CONTRIBUTING.md) (EN uniquement)
- 📜 [CHANGELOG](../../CHANGELOG.md)
