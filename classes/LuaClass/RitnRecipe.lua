-- RitnLibRecipe
----------------------------------------------------------------
local util = require(ritnlib.defines.other)


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Wraps a `LuaRecipe` (the runtime, per-force recipe instance — not the data-stage prototype).
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate inside each event handler.
---
---For data-stage recipe mutation (changing ingredients, results, etc.) use [`RitnProtoRecipe`](../../docs/en/reference/prototype/RitnProtoRecipe.md) instead.
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Encapsule un `LuaRecipe` (l'instance runtime, par force — pas le prototype data-stage).
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler d'événement.
---
---Pour modifier la recette au data stage (ingrédients, résultats, etc.) utiliser [`RitnProtoRecipe`](../../docs/fr/reference/prototype/RitnProtoRecipe.md) à la place.
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md)
---@class RitnLibRecipe
---@field recipe LuaRecipe                  Wrapped LuaRecipe (live reference)
---@field prototype LuaRecipePrototype      Live prototype reference (from `LuaRecipe.prototype`)
---@field isPresent boolean                 `false` when the constructor rejected its input
---@field object_name "RitnLibRecipe"       Sentinel read by the custom `util.type()`
---@operator call(LuaRecipe): RitnLibRecipe
---@type RitnLibRecipe
RitnLibRecipe = ritnlib.classFactory.newclass(function(self, LuaRecipe)
    self.isPresent = false
    if util.type(LuaRecipe) ~= "LuaRecipe" then log('not LuaRecipe !') return end
    if LuaRecipe.valid == false then return end
    self.isPresent = true
    ----
    self.object_name = "RitnLibRecipe"
    --------------------------------------------------
    self.recipe = LuaRecipe
    self.prototype = LuaRecipe.prototype
    --------------------------------------------------
end) --[[@as RitnLibRecipe]]


----------------------------------------------------------------

---**EN**
---
---Description: Reads a property from the recipe's prototype.
---
---──────────────────────────────
---
---**FR**
---
---Description: Lit une propriété sur le prototype de la recette.
---@param propertie string  Property key (e.g. "category", "energy_required", "hidden")
---@return any
function RitnLibRecipe:getProperties(propertie)
    return self.prototype[propertie]
end

---**EN**
---
---Description: Reads a property from the runtime recipe instance (per-force state).
---
---──────────────────────────────
---
---**FR**
---
---Description: Lit une propriété sur l'instance runtime de la recette (état par force).
---@param propertie string  Property key (e.g. "enabled", "hidden_from_flow_stats")
---@return any
function RitnLibRecipe:get(propertie)
    return self.recipe[propertie]
end


----------------------------------------------------------------

---**EN**
---
---Description: Enables or disables the recipe for the recipe's force.
---
---No-op if `value` is nil or not a boolean.
---
---──────────────────────────────
---
---**FR**
---
---Description: Active ou désactive la recette pour la force de cette recette.
---
---No-op si `value` est nil ou pas un booléen.
---@param value boolean
---@return RitnLibRecipe self  Chainable
function RitnLibRecipe:setEnabled(value)
    if self.recipe == nil then return self end
    if value == nil then return self end
    if type(value) ~= 'boolean' then return self end

    self.recipe.enabled = value

    return self
end


----------------------------------------------------------------
--return RitnLibRecipe
