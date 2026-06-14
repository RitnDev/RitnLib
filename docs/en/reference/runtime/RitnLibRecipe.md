---
title: RitnLibRecipe
type: reference
lang: en
---

# `RitnLibRecipe`

🇫🇷 [Version française](../../../fr/reference/runtime/RitnLibRecipe.md)

A runtime view over a [`LuaRecipe`](https://lua-api.factorio.com/latest/classes/LuaRecipe.html) — the **per-force** instance, at control stage. Lets you read properties (prototype and instance) and enable/disable the recipe for the force.

> To **mutate a recipe at data stage** (ingredients, results…), use [`RitnProtoRecipe`](../prototype/RitnProtoRecipe.md) instead.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnRecipe.lua` |
| **Stage** | control (runtime) |
| **Access** | global — injected into `_G` by `core/setup-classes.lua`. No `require`. |
| **Inherits from** | — (base class) |
| **`object_name`** | `"RitnLibRecipe"` |

---

## Constructor

#### `RitnLibRecipe(recipe)` → [`RitnLibRecipe`](RitnLibRecipe.md)

Validates the input then stores the recipe and its prototype. Rejects an input that is not a valid `LuaRecipe`.

**Parameters**
- `recipe` :: [`LuaRecipe`](https://lua-api.factorio.com/latest/classes/LuaRecipe.html) — the runtime recipe to wrap.

**Return value** → [`RitnLibRecipe`](RitnLibRecipe.md). On invalid input, [`isPresent`](#ispresent--boolean-read) is `false`.

> **Note** — Most often obtained via [`RitnLibForce:getRecipe(name)`](RitnLibForce.md#getrecipename--ritnlibrecipe).

---

## Attributes

#### `recipe` :: [`LuaRecipe`](https://lua-api.factorio.com/latest/classes/LuaRecipe.html) `[Read]`
The wrapped `LuaRecipe` (live reference, per-force state).

#### `prototype` :: [`LuaRecipePrototype`](https://lua-api.factorio.com/latest/classes/LuaRecipePrototype.html) `[Read]`
The recipe's prototype (from `LuaRecipe.prototype`).

#### `isPresent` :: `boolean` `[Read]`
`false` if the constructor rejected its input. Test it as a guard.

---

## Methods

#### `:getProperties(propertie)` → `any`
Reads a property from the recipe's **prototype** (e.g. `"category"`, `"energy_required"`, `"hidden"`).

**Parameters**: `propertie` :: `string`.

#### `:get(propertie)` → `any`
Reads a property from the **runtime instance** (per-force state: `"enabled"`, `"hidden_from_flow_stats"`…).

**Parameters**: `propertie` :: `string`.

#### `:setEnabled(value)` → [`RitnLibRecipe`](RitnLibRecipe.md)
Enables or disables the recipe for its force. No-op if `value` is nil or not a boolean. Chainable.

**Parameters**: `value` :: `boolean`.

---

## Usage example

**Disable a recipe for the player's force** (`RitnElectronic/modules/electronic.lua`):

```lua
RitnLibEvent(e):getPlayer():getForce():getRecipe("radar"):setEnabled(false)
```

**Direct disable on known recipes** (`NoLogisticsChallenge/lualib/player.lua`):

```lua
RitnRecipe(recipes["burner-mining-drill"]):setEnabled(false)
```

---

## Remarks

- **Runtime vs data stage** — `RitnLibRecipe` acts on the **runtime** instance (per force). To change the definition (ingredients/results), use [`RitnProtoRecipe`](../prototype/RitnProtoRecipe.md) at data stage.
- **Temporary wrapper** — never store the instance in `storage`. See [Temporary wrappers](../../concepts/temporary-wrappers.md).

## See also

- [Class map](../overview.md)
- [`RitnLibForce`](RitnLibForce.md) · [`RitnProtoRecipe`](../prototype/RitnProtoRecipe.md)
- [Temporary wrappers (golden rule)](../../concepts/temporary-wrappers.md)
