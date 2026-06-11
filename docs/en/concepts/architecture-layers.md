---
title: 4-layer architecture
type: concept
lang: en
---

# 4-layer architecture

RitnLib is organized in **4 stacked layers**. Understanding where each piece lives lets you `require` the right file at the right stage and avoid unnecessary loads.

```
┌────────────────────────────────────────────────────────────────┐
│  4. Data assets                  prototypes/                   │
│  (require from your data.lua)    fonts.lua, gui-style.lua      │
├────────────────────────────────────────────────────────────────┤
│  3. Classes                      classes/                      │
│  ┌─────────────────┬─────────────────┬─────────────────────┐  │
│  │  prototypes/    │  RitnClass/     │  LuaClass/          │  │
│  │  (data stage)   │  (hybrid)       │  (control stage)    │  │
│  │                 │                 │                     │  │
│  │  RitnProto*     │  Setting,       │  Player, Surface,   │  │
│  │  (recipe,       │  Inventory,     │  Force, Entity,     │  │
│  │   technology,   │  Ingredient,    │  Event, Recipe,     │  │
│  │   item, ore…)   │  Prototype,     │  Technology, Gui    │  │
│  │                 │  Informatron,   │                     │  │
│  │                 │  gui/Element,   │                     │  │
│  │                 │  gui/Style      │                     │  │
│  └─────────────────┴─────────────────┴─────────────────────┘  │
├────────────────────────────────────────────────────────────────┤
│  2. Utilities                    lualib/                       │
│  table, string, json, other, gui, entity, LuaStyle             │
│  vanilla/{util, crash-site, ores, types_*}                     │
│  informatron/{menu, pages}                                     │
├────────────────────────────────────────────────────────────────┤
│  1. Foundation                   core/                         │
│  class.lua          → class factory                            │
│  constants.lua      → tints, colors, strings                   │
│  eventListener.lua  → event_handler fork (status uncertain)    │
│  interfaces.lua     → remote.add_interface("RitnLib", …)       │
│  setup-classes.lua  → runtime classes loader                   │
├────────────────────────────────────────────────────────────────┤
│  Bootstrap                       defines.lua + control.lua     │
│  ritnlib global + ritnlib.classFactory                         │
└────────────────────────────────────────────────────────────────┘
```

## Layer 1 — Foundation (`core/`)

Lowest level. Three essential bricks:

- **`core/class.lua`** — the `ritnlib.classFactory.newclass(super, init)` factory used to build **every** class in the library. Single inheritance, `:is_a()`, constructor via `__call`.
- **`core/constants.lua`** — shared tables of colour tints (for `science-pack` recolouring), UI colours, string markers, enemy size names.
- **`core/setup-classes.lua`** — invoked by `control.lua`; instantiates all runtime classes in `_G`.

You hardly ever interact with this layer directly. It backs layer 3.

## Layer 2 — Utilities (`lualib/`)

Pure stateless function libraries:

- `other-functions.lua` — custom `type()` that recognizes `LuaPlayer`/`LuaEntity`, `ifElse`, `tryCatch`, `uuid`, freeplay helpers.
- `table-functions.lua`, `string-functions.lua` — augmented wrappers over standard `table` and `string`.
- `json-functions.lua` — [rxi/json.lua](https://github.com/rxi/json.lua) (MIT) verbatim.
- `entity-functions.lua`, `gui-functions.lua`, `LuaStyle-functions.lua` — graphical prototype helpers.
- `vanilla/util.lua`, `crash-site.lua`, `ores.lua`, `types_*.lua` — forks of the engine's files (`util`, `crash-site`) and type lists for dynamic resolution.
- `informatron/menu.lua`, `pages.lua` — skeletons for Informatron integration (⚠ unfinished).

Used by layer 3, but a consumer mod can also `require` them directly.

## Layer 3 — Classes (`classes/`)

The public API core. Three families:

### 3a — `classes/LuaClass/` (control stage)
Runtime wrappers around Factorio objects:

| Class | Wraps | Speciality |
|---|---|---|
| `RitnLibEvent` | any Factorio event | normalises any event (player, surface, force, entity…) |
| `RitnLibPlayer` | `LuaPlayer` | print, force, surface, character |
| `RitnLibSurface` | `LuaSurface` | entity search |
| `RitnLibForce` | `LuaForce` | recipes, techs, stats, chart tags |
| `RitnLibEntity` | `LuaEntity` | driver/passenger, destruction |
| `RitnLibRecipe` | `LuaRecipe` | runtime activation |
| `RitnLibTechnology` | `LuaTechnology` | research-finished hook |
| `RitnLibGui` | GUI event | click dispatcher |

All of these are **injected into `_G`** by `core/setup-classes.lua` when RitnLib loads. You use them without `require`.

### 3b — `classes/RitnClass/` (mixed data/control)
Hybrid or more complex classes:

- `RitnPrototype` — base of every prototype manipulator.
- `RitnIngredient` — ingredient normalisation.
- `RitnLibInventory` — inventory snapshot/restore (control).
- `RitnLibSetting` — settings builder (settings stage).
- `RitnLibInformatron` — Informatron GUI extension (inherits from `RitnLibGui`).
- `gui/RitnGuiElement`, `gui/RitnStyle` — GUI builders.

### 3c — `classes/prototypes/` (data stage)
`data.raw` manipulators:

| Class | Manipulates |
|---|---|
| `RitnProtoEntity` | `data.raw[<entity-type>]` (auto-detected) |
| `RitnProtoItem` | `data.raw[<item-type>]` (auto-detected) |
| `RitnProtoRecipe` | `data.raw.recipe` |
| `RitnProtoTechnology` | `data.raw.technology` |
| `RitnProtoOre` | `data.raw.resource` + `data.raw["autoplace-control"]` |
| `RitnProtoSprite` | `data.raw.sprite` + `utility-sprites.default` |
| `RitnProtoStyle` | `data.raw["gui-style"].default[<style>]` |
| `RitnProtoItemGroup`, `RitnProtoItemSubgroup` | groups |
| `RitnProtoRecipeCategory`, `RitnProtoFuelCategory` | categories |
| `RitnProtoCustomInput` | `data.raw["custom-input"]` |
| `RitnProtoUtilityConst` | `data.raw["utility-constants"].default[<key>]` |

All `RitnProto*` classes inherit from `RitnPrototype` and expose the common methods (`:changePrototype`, `:changeSubgroup`, `:setPrototype`, `:update`).

## Layer 4 — Data assets (`prototypes/`)

Data-stage files **ready to `require`** from a consuming mod's `data.lua`:

- `prototypes/fonts.lua` — `data:extend({...})` for the `ritn-default-{12..20}` fonts (regular + bold).
- `prototypes/gui-style.lua` — mutations on `data.raw['gui-style'].default` producing a set of `*-ritngui` styles (flow, frame, label, scroll-pane).

These files are **not** loaded automatically by RitnLib. Require them explicitly:

```lua
-- my-mod/data.lua
require("__RitnLib__.defines")
require(ritnlib.defines.fonts)      -- loads prototypes/fonts.lua
require(ritnlib.defines.gui_styles) -- loads prototypes/gui-style.lua
```

## Bootstrap

When Factorio loads RitnLib, this is what runs:

```
RitnLib/control.lua
   ├─► require('core.setup-classes')
   │     ├─► require('__RitnLib__.defines')      ← creates the ritnlib global
   │     │     └─► require(ritnlib.defines.class.core)  ← classFactory
   │     └─► require(...) × N runtime classes    ← register themselves into _G
   ├─► require('core.interfaces')
   │     └─► remote.add_interface("RitnLib", {})  ← remote interface (currently empty)
   └─► require("__gvv__.gvv")()                   ← only if gvv is active
```

**Important**: no `script.on_event` is registered, no `storage` access. RitnLib is **passive** at runtime. You register your own handlers as usual — RitnLib helps you write them short.

## See also

- [Life cycle: data → settings → control](life-cycle.md)
- [Temporary wrappers](temporary-wrappers.md)
- [Custom object-oriented class factory](oo-factory.md)
- [Class map](../reference/overview.md)
