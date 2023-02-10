-- RitnProtoSprite
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

local RitnProtoSprite = class.newclass(RitnProtoBase, function(base, sprite_name)
    -- prototype init
    if sprite_name == nil then return end
    RitnProtoBase.init(base, sprite_name, "sprite")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoSprite"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end)


--ADD NEW SPRITE
function RitnProtoSprite:extend(name, file_name)
    if name == nil then return end
    if file_name == nil then return end
    
    local sprite = {
		type = "sprite",
		name = name,
		filename = file_name,
		width = 32,
		height = 32,
		flags = {"gui-icon"},
		mipmap_count = 1,
	}

    data:extend({sprite})
end



return RitnProtoSprite