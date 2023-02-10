-- RitnProtoRecipeCategory
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

local RitnProtoRecipeCategory = class.newclass(function(base, category_name)
    -- prototype init
    if category_name == nil then return end
    RitnProtoBase.init(base, category_name, "recipe-category")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoRecipeCategory"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end)


--ADD NEW ITEM-SUBGROUP
function RitnProtoRecipeCategory:extend(name, order)
    if name == nil then return end
    local newCategory = {
        type = "recipe-category",
        name = name,
        order = order
    }
    data:extend({newCategory})
    return self
end



return RitnProtoRecipeCategory