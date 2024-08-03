-- RitnLibPlayer
----------------------------------------------------------------
local util = require(ritnlib.defines.other)

----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------

local function getControllerName(LuaPlayer)
    for name,_ in pairs(defines.controllers) do
        if defines.controllers[name] == LuaPlayer.controller_type then 
            return name
        end
    end
end

----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLibPlayer = ritnlib.classFactory.newclass(function(self, LuaPlayer)
    -- check input params
    if util.type(LuaPlayer) ~= "LuaPlayer" then log('not LuaPlayer !') return end
    if LuaPlayer.valid == false then log('not LuaPlayer valid !') return end
    if LuaPlayer.is_player() == false then log('not LuaPlayer !') return end
    ----
    self.object_name = "RitnLibPlayer"
    --------------------------------------------------
    self.player = LuaPlayer
    self.index = LuaPlayer.index
    self.surface = LuaPlayer.surface
    self.force = LuaPlayer.force
    self.controller_type = LuaPlayer.controller_type
    self.controller_name = getControllerName(LuaPlayer)
    self.character = LuaPlayer.character
    self.admin = LuaPlayer.admin
    self.driving = LuaPlayer.driving
    self.vehicle = LuaPlayer.vehicle
    ----
    self.name = LuaPlayer.name
    self.connected = LuaPlayer.connected
    --------------------------------------------------
end)

----------------------------------------------------------------

function RitnLibPlayer:print(text)
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




function RitnLibPlayer:getForce()
    return RitnLibForce(self.force)
end



function RitnLibPlayer:getSurface()
    return RitnLibSurface(self.surface)
end 



-- Cancel All Crafting
function RitnLibPlayer:cancel_all_crafting()
    pcall(function()
        while self.player.crafting_queue_size > 0 do
            self.player.cancel_crafting({
                index = self.player.crafting_queue[1].index, 
                count = self.player.crafting_queue[1].count
            })
        end
    end)
end


-- Player on Nauvis surface
function RitnLibPlayer:onNauvis() 
    return self.surface.name == 'nauvis'
end