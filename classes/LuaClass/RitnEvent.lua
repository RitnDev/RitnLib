-- RitnEvent
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnPlayer = require(ritnlib.defines.class.luaClass.player)
local RitnForce = require(ritnlib.defines.class.luaClass.force)
local RitnTechnology = require(ritnlib.defines.class.luaClass.tech)
----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------

local function getPlayer(event)
    if event.player_index then 
        return game.players[event.player_index]
    end
    return nil
end

local function getSurface(event)
    if event.surface_index then 
        return game.surfaces[event.surface_index]
    end
    if event.surface then 
        return event.surface
    end
    return nil
end

local function getForce(event)
    if event.force then 
        return event.force
    end
    return nil
end

local function getTech(event)
    if event.research then 
        return event.research
    end
    return nil
end

----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnEvent = class.newclass(function(base, event)
    if event == nil then return end
    base.object_name = "RitnEvent"
    ---------------------------------
    base.event = event
    ---------------------------------
    base.player = getPlayer(event)
    base.surface = getSurface(event)
    base.force = getForce(event)
    base.technology = getTech(event)
    ---------------------------------
    return self
end)
----------------------------------------------------------------

--[[
function RitnEvent:getSurface()
    return RitnSurface(self.surface)
end
]]



function RitnEvent:getPlayer()
    return RitnPlayer(self.player)
end



function RitnEvent:getForce()
    return RitnForce(self.force)
end



function RitnEvent:getTechnology()
    return RitnTechnology(self.technology)
end



-- DiscoScience remote call setIngredient
function RitnEvent.setIngredientColor(ingredient, color)
    if type(ingredient) == "string" and type(color) == "table" then
        log("RitnEvent | setIngredientColor() : ingredient = " .. ingredient)
        
        if remote.interfaces["DiscoScience"] and remote.interfaces["DiscoScience"]["setIngredientColor"] then
            log("RitnEvent | remote call -> DiscoScience - setIngredientColor")
            remote.call("DiscoScience", "setIngredientColor", ingredient, color)
        end
    end
end


---------------------------------
return RitnEvent