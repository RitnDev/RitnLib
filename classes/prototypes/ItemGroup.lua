-- RitnProtoItemGroup
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------


local RitnProtoItemGroup = class.newclass(RitnProtoBase, function(base, group_name)
    -- prototype init
    if group_name == nil then return end
    RitnProtoBase.init(base, group_name, "item-group")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoItemGroup"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end)


--ADD NEW ITEM-SUBGROUP
function RitnProtoItemGroup:extend(name, order, icon, icon_size)
    if name == nil then return end
    local newGroup = {
        type = "item-group",
        name = name,
        order = order,
        icon = icon,
        icon_size = icon_size,
    }
    data:extend({newGroup})
    return self
end



function RitnProtoItemGroup:setIcon(pathIcon, size) 
    if self.prototype == nil then return self end
    if type(size) ~= "number" then return self end

    self.prototype.icon = pathIcon
    self.prototype.icon_size = size
    self:update()
    return self
end


return RitnProtoItemGroup