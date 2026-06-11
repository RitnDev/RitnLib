---
title: RitnLib — documentation
lang: en
---

# RitnLib

> Classes and functions library for Ritn Factorio mods.

🇫🇷 [Version française](../fr/index.md)

---

## Get started

New here? Start with:

- 📦 [Getting started](getting-started.md) — install + first mod in 5 minutes
- 🧩 [The 4-layer architecture](concepts/architecture-layers.md) — how the mod is organized
- ⚠ [Temporary wrappers golden rule](concepts/temporary-wrappers.md) — read **before** using runtime classes

## Guides

Task-oriented tutorials:

- [Installation](guides/installation.md)
- [Your first prototype](guides/first-prototype.md)
- [Your first runtime handler](guides/first-handler.md)
- [Complete GUI pattern](guides/gui-pattern.md)
- [Inventory snapshot & restore](guides/inventory-snapshot.md)
- [Building a setting](guides/settings-builder.md)
- [Remote interfaces](guides/remote-interfaces.md)

## Class reference

### Overview
- [Class map](reference/overview.md)
- [`ritnlib.defines` registry](reference/defines.md)

### Runtime classes (control stage)
| Class | Wraps | Use |
|---|---|---|
| [`RitnLibEvent`](reference/runtime/RitnLibEvent.md) | any Factorio event | payload normalization |
| [`RitnLibPlayer`](reference/runtime/RitnLibPlayer.md) | `LuaPlayer` | fast access |
| [`RitnLibSurface`](reference/runtime/RitnLibSurface.md) | `LuaSurface` | entity search |
| [`RitnLibForce`](reference/runtime/RitnLibForce.md) | `LuaForce` | recipes/techs/stats |
| [`RitnLibEntity`](reference/runtime/RitnLibEntity.md) | `LuaEntity` | entity manipulation |
| [`RitnLibRecipe`](reference/runtime/RitnLibRecipe.md) | `LuaRecipe` | runtime activation |
| [`RitnLibTechnology`](reference/runtime/RitnLibTechnology.md) | `LuaTechnology` | research-finished hook |
| [`RitnLibInventory`](reference/runtime/RitnLibInventory.md) | `LuaPlayer` + storage | snapshot/restore |
| [`RitnLibGui`](reference/runtime/RitnLibGui.md) | GUI event | click dispatcher |
| [`RitnLibInformatron`](reference/runtime/RitnLibInformatron.md) | Informatron event | page integration |
| [`RitnLibGuiElement`](reference/runtime/RitnLibGuiElement.md) | `add{...}` payload | fluent builder |
| [`RitnLibStyle`](reference/runtime/RitnLibStyle.md) | `LuaStyle` | style presets |

### Data classes (data stage)
| Class | Manipulates |
|---|---|
| [`RitnPrototype`](reference/prototype/RitnPrototype.md) | base of all manipulators |
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
| [`RitnIngredient`](reference/prototype/RitnIngredient.md) | ingredient normalization |

### Settings stage
- [`RitnLibSetting`](reference/settings/RitnLibSetting.md)

### Utility libraries
- [`lualib/other-functions`](reference/lualib/other-functions.md)
- [`lualib/table-functions`](reference/lualib/table-functions.md)
- [`lualib/string-functions`](reference/lualib/string-functions.md)
- [`lualib/json-functions`](reference/lualib/json-functions.md) — embeds [rxi/json.lua](https://github.com/rxi/json.lua) (MIT)
- [`lualib/entity-functions`](reference/lualib/entity-functions.md)
- [`lualib/gui-functions`](reference/lualib/gui-functions.md)
- [`lualib/LuaStyle-functions`](reference/lualib/LuaStyle-functions.md) ⚠ deprecated

### Vanilla helpers
- [`lualib/vanilla/util`](reference/vanilla/util.md)
- [`lualib/vanilla/crash-site`](reference/vanilla/crash-site.md)
- [`lualib/vanilla/ores`](reference/vanilla/ores.md)
- [`lualib/vanilla/types`](reference/vanilla/types.md)

### Foundation layer
- [`core/class.lua` — Object-oriented class factory](reference/core/class-factory.md)
- [`core/constants.lua`](reference/core/constants.md)
- [`core/eventListener.lua` — fork](reference/core/event-listener.md) ⚠ experimental
- [`core/interfaces.lua`](reference/core/interfaces.md)

## Concepts

- [4-layer architecture](concepts/architecture-layers.md)
- [Life cycle (data → settings → control)](concepts/life-cycle.md)
- [Temporary wrappers (golden rule)](concepts/temporary-wrappers.md)
- [Custom object-oriented class factory](concepts/oo-factory.md)
- [Event model](concepts/event-model.md)
- [Delegated persistence](concepts/delegated-persistence.md)
- [Consumer remote contract](concepts/remote-contract.md)

## Architecture decisions (ADR)

- [ADR index](adr/README.md)
- [ADR-0001 — Custom object-oriented class factory](adr/0001-class-factory.md)
- [ADR-0002 — `_G` globals vs returned modules](adr/0002-globals-vs-modules.md)
- [ADR-0003 — Status of the `eventListener` fork](adr/0003-event-handler-fork.md)
- [ADR-0004 — FR + EN language strategy](adr/0004-fr-en-strategy.md)

## Debt & migration

- 🐛 [Known bugs](debt/known-bugs.md)
- 🕰 [1.x API leftovers](debt/api-1.x-leftover.md)
- ⚠ [Deprecated APIs](debt/deprecated.md)
- 🔧 [Factorio 2.0 migration](../migration-2.0.md)

## For maintainers

- 🏗 [Internal architecture](../architecture.md) (FR only)
- 🤝 [CONTRIBUTING](../../CONTRIBUTING.md) (EN only)
- 📜 [CHANGELOG](../../CHANGELOG.md)
