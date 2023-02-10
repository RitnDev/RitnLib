-- RitnProtoItemSubgroup
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------


local RitnProtoItemSubgroup = class.newclass(RitnProtoBase, function(base, subgroup_name)
    -- prototype init
    if subgroup_name == nil then return end
    RitnProtoBase.init(base, subgroup_name, "item-subgroup")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoItemSubgroup"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end)



--ADD NEW ITEM-SUBGROUP
function RitnProtoItemSubgroup:extend(name, group, order)
    if name == nil then return end
    local newSubgroup = {
        type = "item-subgroup",
        name = name,
        group = group,
        order = order
    }
    data:extend({newSubgroup})
    return self
end


--Change group
function RitnProtoItemSubgroup:changeGroup(group, order)
    if self.prototype == nil then return self end

    self.prototype.group = group
    if order ~= nil then 
		self.prototype.order = order
	end

    self:update()
    return self
end



--Change order
function RitnProtoItemSubgroup:changeOrder(order)
    if self.prototype == nil then return self end

	self.prototype.order = order

    self:update()
    return self
end



return RitnProtoItemSubgroup