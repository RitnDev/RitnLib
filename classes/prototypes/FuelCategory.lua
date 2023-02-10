-- RitnProtoFuelCategory
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

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
end)


--ADD NEW ITEM-SUBGROUP
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