-- RitnProtoCustomInput
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

local RitnProtoCustomInput = class.newclass(RitnProtoBase, function(base, input_name)
    -- prototype init
    if constant_name == nil then return end
    RitnProtoBase.init(base, input_name, "custom-input")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoCustomInput"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end)


--ADD NEW CUSTOM-INPUT
function RitnProtoCustomInput:extend(name, key_sequence, consuming)
    if name == nil then return end
    local consumingDefault = "game-only"
    if consuming ~= nil then consumingDefault = consuming end

    local input = {
        type = 'custom-input',
        name = name,
        consuming = consumingDefault,
        key_sequence = key_sequence,
    }
    data:extend({input})
    return self
end



return RitnProtoCustomInput