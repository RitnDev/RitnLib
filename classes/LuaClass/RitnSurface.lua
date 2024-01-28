-- RitnSurface
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------



----------------------------------------------------------------
local RitnSurface = class.newclass(function(base, LuaSurface)
    base.object_name = "RitnSurface"
    if LuaSurface == nil then return end
    if LuaSurface.valid == false then return end
    if LuaSurface.object_name ~= "LuaSurface" then return end
    --------------------------------------------------
    base.surface = LuaSurface
    base.name = LuaSurface.name
    base.index = LuaSurface.index
    --------------------------------------------------
    --log('> [RITNLIB] > RitnSurface')
end)
----------------------------------------------------------------


function RitnSurface:print(text)
    if type(text) == "table" then 
        self.surface.print(serpent.block(text))
        return self
    end
    if type(text) ~= "string" then 
        pcall(function()
            self.surface.print(tostring(text))
        end)
        return self
    end

    self.surface.print(text)
    return self
end




----------------------------------------------------------------
return RitnSurface