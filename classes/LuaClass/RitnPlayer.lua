-- RitnPlayer
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnForce = require(ritnlib.defines.class.luaClass.force)
----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------






----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnPlayer = class.newclass(function(base, LuaPlayer)
    base.object_name = "RitnPlayer"
    if LuaPlayer == nil then return end
    if LuaPlayer.valid == false then return end
    if LuaPlayer.is_player() == false then return end
    if LuaPlayer.object_name ~= "LuaPlayer" then return end
    --------------------------------------------------
    base.player = LuaPlayer
    base.index = LuaPlayer.index
    base.surface = LuaPlayer.surface
    base.force = LuaPlayer.force
    ----
    base.name = LuaPlayer.name
    base.connected = LuaPlayer.connected
    ----
    return self
end)

----------------------------------------------------------------

function RitnPlayer:print(text)
    if type(text) ~= "string" then return self end
    self.player.print(text)
    return self
end


function RitnPlayer:getForce()
    return RitnForce(self.force)
end


--[[ 
function RitnPlayer:getSurface()
    return RitnSurface(self.surface)
end 
]]




return RitnPlayer