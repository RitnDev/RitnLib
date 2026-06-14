---
title: RitnProtoTech
type: reference
lang: en
---

# `RitnProtoTech`


**Data-stage** manipulator for `data.raw["technology"][<name>]`. A full toolkit for technologies: research cost, unlocked recipes, science packs (both in research **and** in labs), prerequisites, and disabling with cascade purge. Every setter writes back to `data.raw` (via `:update()`) and returns `self` (chainable).

> The actual class name is **`RitnProtoTech`** (not `RitnProtoTechnology`).

> **Warning — Factorio 1.x API**: this class hasn't been revised since Factorio 2.0; it keeps **1.x** API constructs. Usable at data stage, but **not validated for 2.0** — see [Factorio 2.0 migration](../../migration-2.0.md).

| | |
|---|---|
| **Source** | `classes/prototypes/Technology.lua` |
| **Stage** | data |
| **Access** | `require(ritnlib.defines.class.prototype.tech)` (alias `…prototype.technology`) |
| **Inherits from** | [`RitnPrototype`](RitnPrototype.md) |
| **`object_name`** | `"RitnProtoTech"` |

```lua
-- my-mod/data.lua
require("__RitnLib__.defines")
local RitnProtoTech = require(ritnlib.defines.class.prototype.tech)
```

---

## Constructor

#### `RitnProtoTech(tech_name)` → [`RitnProtoTech`](RitnProtoTech.md)

Sets the basics via `RitnPrototype.init` then **deep-copies** `data.raw["technology"][tech_name]` into [`prototype`](#prototype--table-read). If the technology doesn't exist, `prototype` stays `nil` (setters become no-ops).

**Parameters**
- `tech_name` :: `string` — technology name in `data.raw`.

---

## Attributes

#### `name` :: `string` `[Read]`
Technology name (inherited from [`RitnPrototype`](RitnPrototype.md)).

#### `type` :: `string` `[Read]`
Resolved type (`"technology"`).

#### `prototype` :: `table?` `[Read]`
Working copy of `data.raw["technology"][name]`. `nil` if the technology doesn't exist.

#### `object_name` :: `"RitnProtoTech"` `[Read]`
Type sentinel.

> **Note** — The class also keeps internal mutable flags (`addit`, `doit`, `disable_recipe`, `amount_pack`, `delete_prerequisite`) that methods reset between calls. These are implementation details, not public fields.

---

## Methods — research cost

#### `:setCount(count)` → [`RitnProtoTech`](RitnProtoTech.md)
Sets the cycle count (`prototype.unit.count`).

#### `:setTime(time)` → [`RitnProtoTech`](RitnProtoTech.md)
Sets the time per cycle (`prototype.unit.time`).

#### `:setIngredients(ingredients)` → [`RitnProtoTech`](RitnProtoTech.md)
Replaces the whole research ingredient list (`prototype.unit.ingredients`).

**Parameters**: `ingredients` :: `table[]` — ingredient list (`{ {"automation-science-pack", 1}, … }`).

#### `:multipliedPack(coeff)` → [`RitnProtoTech`](RitnProtoTech.md)
Multiplies `prototype.unit.count` by `coeff`.

---

## Methods — unlocked recipes

#### `:addRecipe(recipe_name)` → [`RitnProtoTech`](RitnProtoTech.md)
Adds an `{type = "unlock-recipe", recipe = recipe_name}` effect (unless duplicate). The recipe must exist in `data.raw.recipe`.

#### `:removeRecipe(recipe, complete?)` → [`RitnProtoTech`](RitnProtoTech.md)
Removes the matching `unlock-recipe` effect. If `complete == true`, also disables the recipe via `RitnProtoRecipe(recipe):disable()`.

---

## Methods — science packs (research)

#### `:addPack(pack, count?)` → [`RitnProtoTech`](RitnProtoTech.md)
Adds a pack to `prototype.unit.ingredients` (`count` defaults to 1). If the pack is already present, **increments** its amount by `count`. `pack` must exist in `data.raw.tool`.

#### `:removePack(pack)` → [`RitnProtoTech`](RitnProtoTech.md)
Removes every entry matching `pack`.

#### `:replacePack(old, new)` → [`RitnProtoTech`](RitnProtoTech.md)
Replaces `old` with `new`, preserving the total amount. `new` must exist in `data.raw.tool`.

---

## Methods — packs on labs

#### `:addPackLab(pack, index?)` → [`RitnProtoTech`](RitnProtoTech.md)
Adds `pack` to the `inputs` of every lab that doesn't already contain it (position `index`, default 1). `pack` must exist in `data.raw.tool`.

#### `:removePackLab(pack, lab?)` → [`RitnProtoTech`](RitnProtoTech.md)
Removes `pack` from every lab's `inputs`, or from a specific `lab` if provided.

---

## Methods — prerequisites

#### `:addPrerequisite(prerequisite)` → [`RitnProtoTech`](RitnProtoTech.md)
Adds `prerequisite` to `prototype.prerequisites` (unless duplicate). Must reference an existing technology.

#### `:removePrerequisite(prerequisite)` → [`RitnProtoTech`](RitnProtoTech.md)
Removes `prerequisite` from the list.

#### `:replacePrerequisite(remove_prerequisite, add_prerequisite)` → [`RitnProtoTech`](RitnProtoTech.md)
Shortcut: `:removePrerequisite(...)` then `:addPrerequisite(...)`.

---

## Methods — disabling

#### `:disable(delete_prerequisites?)` → [`RitnProtoTech`](RitnProtoTech.md)
Disables and hides the technology. If `delete_prerequisites == true`, **cascade-purges**: removes this tech from the `prerequisites` list of every other tech that references it.

```lua
RitnProtoTech('steel-axe'):disable(true)
```

---

## Methods inherited from `RitnPrototype`

`:changePrototype`, `:setPrototype`, `:changeSubPrototype`, `:getProperties`, `:update`, `:changeSubgroup` — see [`RitnPrototype`](RitnPrototype.md).

---

## Usage examples

**Unlock a recipe + tune the time** (`RetroFactorio/prototypes/technologies.lua`):

```lua
ProtoTech('light-armor'):addRecipe('light-armor')
ProtoTech('landfill'):setTime(25)
```

**Disable a tech and purge the prerequisites pointing to it** (`RetroFactorio/prototypes/technologies.lua`):

```lua
ProtoTech('steel-axe'):disable(true)
ProtoTech('logistic-science-pack'):disable(true)
```

**Chaining on a mod technology** (`RitnHiladdar/prototypes/robots/update-technology.lua`):

```lua
local rTech = RitnProtoTech("hsmd-logistic-robotics-2")
RitnProtoTech("hsmd-bot-recaller"):disable(true)
```

---

## Remarks

- **Data stage only** — use from `data.lua` / `data-updates.lua` / `data-final-fixes.lua`.
- **Copy + write-back** — mutations apply to `prototype`, written back by `:update()` (called by every setter). No manual `data:extend`.
- **Existence required** — `addRecipe`/`addPack`/`replacePack`/`addPrerequisite` check the target exists in `data.raw` (`recipe`, `tool`, `technology`) and are no-ops otherwise.

## See also

- [Class map](../overview.md)
- [`RitnPrototype`](RitnPrototype.md) (parent) · [`RitnProtoRecipe`](RitnProtoRecipe.md)
- [Factorio 2.0 migration](../../migration-2.0.md)
