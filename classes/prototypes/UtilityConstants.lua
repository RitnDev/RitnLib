-- RitnProtoUtilityConst
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

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
end)



--CHANGE VALUE ON PARAMERS OF PROTOTYPE
function RitnProtoUtilityConst:setValue(value) 
    if self.prototype == nil then return self end

    self.prototype = value
    self:update()
    return self
end



-- UPDATE PROTOTYPE
function RitnProtoUtilityConst:update()
    if data.raw[self.type].default[self.name] == nil then return self end
    if self.prototype == nil then return self end
    data.raw[self.type].default[self.name] = self.prototype
end



return RitnProtoUtilityConst