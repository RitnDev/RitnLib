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
function RitnProtoSprite:createUtility(priority, flags) 
    if self.prototype == nil then return self end 

    -- default values
    local defaultPriority = "medium"
    local defaultFlags = {"icon"}

    -- priority present
    if priority ~= nil then 
        if type(priority) == "string" then 
            defaultPriority = priority
        end
    end
    
    --flags present
    if flags ~= nil then 
        if type(flags) == "table" then
            defaultFlags = flags
        end
    end


    data.raw["utility-sprites"]["default"][self.name] = {
        filename = self.prototype.filename,
        priority = defaultPriority,
        width = self.prototype.width,
        height = self.prototype.height,
        flags = defaultFlags
    }

    return self
end


--ADD NEW SPRITE
function RitnProtoSprite:extend(name, file_name, size)
    if name == nil then return end
    if file_name == nil then return end
    
    local default_size = 32
    if type(size) == "number" then 
        if size ~= nil then default_size = size end
    end
    local width = default_size
    local height = default_size

    if type(size) == "table" then 
        width = size[1]
		height = size[2]
    end 

    
    local sprite = {
		type = "sprite",
		name = name,
		filename = file_name,
		width = width,
		height = height,
		flags = {"gui-icon"},
		mipmap_count = 1,
	}

    data:extend({sprite})
end



return RitnProtoSprite