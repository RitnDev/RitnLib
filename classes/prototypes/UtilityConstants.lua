-- RitnProtoUtilityConst
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["utility-constants"].default[<key>]`. Note the indirection through `.default[]` — unlike other prototypes which live at `data.raw[type][name]`, utility-constants are nested under a `default` table. This class overrides `:update()` to reflect that.
---
---Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["utility-constants"].default[<key>]`. À noter l'indirection via `.default[]` — contrairement aux autres prototypes qui vivent à `data.raw[type][name]`, les utility-constants sont imbriquées sous une table `default`. Cette classe override `:update()` pour en tenir compte.
---
---Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---@class RitnProtoUtilityConst : RitnPrototype
---@field object_name "RitnProtoUtilityConst"
---@operator call(string): RitnProtoUtilityConst
---@type RitnProtoUtilityConst
local RitnProtoUtilityConst = class.newclass(RitnProtoBase, function(base, constant_name)
    -- prototype init
    if constant_name == nil then return end
    RitnProtoBase.init(base, constant_name, "utility-constants")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoUtilityConst"
    ----
    if data.raw[base.type].default[base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type].default[base.name])
    --------------------------------------------------
end) --[[@as RitnProtoUtilityConst]]



--CHANGE VALUE ON PARAMERS OF PROTOTYPE

---**EN**
---
---Description: Replaces the constant's full value with `value` (overwrites `self.prototype` entirely), then writes back via `:update()`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace la valeur complète de la constante par `value` (écrase intégralement `self.prototype`), puis réécrit via `:update()`.
---@param value any
---@return RitnProtoUtilityConst self  Chainable
function RitnProtoUtilityConst:setValue(value)
    if self.prototype == nil then return self end

    self.prototype = value
    self:update()
    return self
end



-- UPDATE PROTOTYPE

---**EN**
---
---Description: Overridden `:update()` that writes `self.prototype` back into `data.raw["utility-constants"].default[<name>]` (note the `.default[]` indirection vs base `RitnPrototype:update`).
---
---──────────────────────────────
---
---**FR**
---
---Description: `:update()` overridé qui réécrit `self.prototype` dans `data.raw["utility-constants"].default[<name>]` (noter l'indirection `.default[]` vs `RitnPrototype:update` de base).
function RitnProtoUtilityConst:update()
    if data.raw[self.type].default[self.name] == nil then return self end
    if self.prototype == nil then return self end
    data.raw[self.type].default[self.name] = self.prototype
end



return RitnProtoUtilityConst
