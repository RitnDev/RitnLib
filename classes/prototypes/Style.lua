-- RitnProtoStyle
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------



----------------------------------------------------------------
local RitnProtoStyle = class.newclass(RitnProtoBase, function(base, style_name)
    -- prototype init
    if style_name == nil then return end
    RitnProtoBase.init(base, style_name, "gui-style")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoStyle"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end)




-- UPDATE PROTOTYPE
function RitnProtoStyle:update()
    if data.raw["gui-style"].default[self.name] == nil then return self end
    if self.prototype == nil then return self end
    data.raw["gui-style"].default[self.name] = self.prototype
end



return RitnProtoStyle