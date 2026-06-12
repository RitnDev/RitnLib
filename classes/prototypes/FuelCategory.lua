-- RitnProtoFuelCategory
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["fuel-category"][<name>]`. Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["fuel-category"][<name>]`. Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---@class RitnProtoFuelCategory : RitnPrototype
---@field object_name "RitnProtoFuelCategory"
---@operator call(string): RitnProtoFuelCategory
---@type RitnProtoFuelCategory
local RitnProtoFuelCategory = class.newclass(RitnProtoBase, function(base, category_name)
    -- prototype init
    if category_name == nil then return end
    RitnProtoBase.init(base, category_name, "fuel-category")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoFuelCategory"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end) --[[@as RitnProtoFuelCategory]]


--ADD NEW ITEM-SUBGROUP

---**EN**
---
---Description: Declares a brand-new fuel-category via `data:extend({...})` (data stage).
---
---──────────────────────────────
---
---**FR**
---
---Description: Déclare une nouvelle fuel-category via `data:extend({...})` (data stage).
---@param name string
---@param order string
---@return RitnProtoFuelCategory self  Chainable
function RitnProtoFuelCategory:extend(name, order)
    if name == nil then return end
    local newCategory = {
        type = "fuel-category",
        name = name,
        order = order
    }
    data:extend({newCategory})
    return self
end



return RitnProtoFuelCategory
