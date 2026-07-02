---
title: My first prototype
type: guide
lang: en
---

# My first prototype

This guide shows how to create Factorio prototypes (recipes, technologies, entities, items) using RitnLib's `RitnProto*` classes at the **data stage**.

## Prerequisites

RitnLib declared as a dependency in `info.json`. See the [installation guide](installation.en.md).

## Basic structure

At the data stage, always start by importing the defines:

```lua
-- my-mod/data.lua
require("__RitnLib__.defines")
```

This injects `ritnlib.defines` as a global, which holds paths to all RitnLib classes. You can then require what you need.

## Recipe — `RitnProtoRecipe`

```lua
-- my-mod/data.lua
require("__RitnLib__.defines")

local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)

RitnProtoRecipe("my-mod-my-recipe")
    :setIngredients({
        { "iron-plate", 5 },
        { "copper-plate", 2 },
    })
    :setResult("iron-gear-wheel", 3)
    :setTime(5)
    :new()
```

`:new()` is the final call that registers the prototype in `data.raw`. Without `:new()`, nothing is created.

## Technology — `RitnProtoTech`

```lua
local RitnProtoTech = require(ritnlib.defines.class.prototype.technology)

RitnProtoTech("my-mod-my-tech")
    :setPrerequisites({ "automation" })
    :setResearchUnit({ { "automation-science-pack", 1 } }, 10, 30)
    :addUnlockedRecipe("my-mod-my-recipe")
    :new()
```

## Item — `RitnProtoItem`

```lua
local RitnProtoItem = require(ritnlib.defines.class.prototype.item)

RitnProtoItem("my-mod-my-item")
    :setStack(50)
    :setGroup("combat")
    :setSubGroup("ammo")
    :new()
```

## Entity — `RitnProtoEntity`

```lua
local RitnProtoEntity = require(ritnlib.defines.class.prototype.entity)

RitnProtoEntity("my-mod-my-entity")
    :setMaxHealth(200)
    :new()
```

> `RitnProtoEntity` is a generic wrapper. For complex types (assembling-machine, furnace…), it may be simpler to manipulate `data.raw` directly after `:new()`.

## Ingredients — `RitnIngredient`

For recipes requiring fluid ingredients or complex formulas:

```lua
local RitnIngredient = require(ritnlib.defines.class.prototype.ingredient)

local ing_water = RitnIngredient("water"):setFluid(100):build()
local ing_iron  = RitnIngredient("iron-plate"):setAmount(5):build()

RitnProtoRecipe("my-mod-fluid-recipe")
    :setIngredients({ ing_water, ing_iron })
    :setResult("my-mod-my-item", 1)
    :new()
```

## Important rules

| ✅ Do | ❌ Avoid |
|---|---|
| `require("__RitnLib__.defines")` at the very top | Using `RitnLibPlayer` or `game` at the data stage |
| Call `:new()` at the end of each chain | Forgetting `:new()` (no error, but nothing is created) |
| Use `data.raw` for fine-grained adjustments | Calling `storage` or `script` at the data stage |

## data-updates.lua

`data-updates.lua` runs under the same conditions as `data.lua`: `RitnProto*` classes are available in exactly the same way. You can create new prototypes **and** modify existing ones via `data.raw`:

```lua
-- my-mod/data-updates.lua
require("__RitnLib__.defines")

local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)

-- Create a new recipe (same pattern as data.lua)
RitnProtoRecipe("my-mod-my-other-recipe")
    :setIngredients({ { "steel-plate", 3 } })
    :setResult("my-mod-my-item", 1)
    :new()

-- Modify a vanilla prototype directly via data.raw
data.raw.recipe["iron-gear-wheel"].energy_required = 1
```

## See also

- [Life cycle](../concepts/life-cycle.en.md)
- [My first runtime handler](first-handler.md)
- [Reference: RitnPrototype](../reference/prototype/RitnPrototype.md)
