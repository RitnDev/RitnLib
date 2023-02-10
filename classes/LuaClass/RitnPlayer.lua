-- RitnPlayer
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnForce = require(ritnlib.defines.class.luaClass.force)
local RitnSurface = require(ritnlib.defines.class.luaClass.surface)
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
    base.controller_type = LuaPlayer.controller_type
    ----
    base.name = LuaPlayer.name
    base.connected = LuaPlayer.connected
    --------------------------------------------------
end)

----------------------------------------------------------------

function RitnPlayer:print(text)
    if type(text) == "table" then 
        self.player.print(serpent.block(text))
        return self
    end
    if type(text) ~= "string" then 
        pcall(function()
            self.player.print(tostring(text))
        end)
        return self
    end

    self.player.print(text)
    return self
end




function RitnPlayer:getForce()
    return RitnForce(self.force)
end



function RitnPlayer:getSurface()
    return RitnSurface(self.surface)
end 



-- Cancel All Crafting
function RitnPlayer:cancel_all_crafting()
    pcall(function()
        while self.player.crafting_queue_size > 0 do
            self.player.cancel_crafting({
                index = self.player.crafting_queue[1].index, 
                count = self.player.crafting_queue[1].count
            })
        end
    end)
end





return RitnPlayer