-- RitnProtoItem
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------


local RitnProtoItem = class.newclass(RitnProtoBase, function(base, item_name)
    -- prototype init
    if item_name == nil then return end
    RitnProtoBase.init(base, item_name, 'item')
    -- prototype get type
    base:getItemType()
    if base.type == nil then return end
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoItem"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end)



return RitnProtoItem