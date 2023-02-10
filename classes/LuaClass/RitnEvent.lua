-- RitnEvent
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnPlayer = require(ritnlib.defines.class.luaClass.player)
local RitnForce = require(ritnlib.defines.class.luaClass.force)
local RitnSurface = require(ritnlib.defines.class.luaClass.surface)
local RitnTechnology = require(ritnlib.defines.class.luaClass.tech)
----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------

local function getEventName(event)
    for name,ev in pairs(defines.events) do
        if event.name == 0 then return "on_tick" end
        if defines.events[name] ==  event.name then 
            return name
        end
    end
end


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


local function getRecipe(event)
    if event.recipe then 
        return event.recipe
    end
    return nil
end


local function getTech(event)
    if event.research then 
        return event.research
    end
    return nil
end


local function getEntity(event)
    if event.created_entity then 
        return event.entity
    end
    if event.vehicle then 
        return event.vehicle
    end
    if event.entity then 
        return event.entity
    end
    return nil
end


local function getRobot(event)
    if event.robot then 
        return event.robot
    end
    return nil
end


local function getInventory(event)
    if event.buffer then 
        return event.buffer
    end
    if event.loot then 
        return event.loot
    end
    if event.items then 
        return event.items
    end
    if event.inventory then 
        return event.inventory
    end
    return nil
end


local function getGuiType(gui_type)
    for name,_ in pairs(defines.gui_type) do 
        if defines.gui_type[name] == gui_type then 
            return name
        end
    end
end


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnEvent = class.newclass(function(base, event, mod_name)
    local modName = "RitnLib"
    if event == nil then return end
    if mod_name ~= nil then modName = mod_name end
    base.object_name = "RitnEvent"
    ---------------------------------
    base.mod_name = modName
    base.event = event
    base.name = getEventName(event)
    base.index = event.name                 -- index
    ---------------------------------
    base.player = getPlayer(event)          -- (LuaPlayer)
    base.surface = getSurface(event)        -- (LuaSurface)
    base.force = getForce(event)            -- (LuaForce)
    base.recipe = getRecipe(event)          -- (LuaRecipe)
    base.technology = getTech(event)        -- (LuaTechnology)
    base.entity = getEntity(event)          -- (LuaEntity)
    base.robot = getRobot(event)            -- (LuaEntity)
    base.inventory = getInventory(event)    -- (LuaInventory)
    base.cause = event.cause                -- (LuaEntity)?
    ----
    base.reason = event.reason              -- defines.disconnect_reason
    base.queued_count = event.queued_count  -- (number)
    base.gui_type = getGuiType(event.gui_type)
    base.source = event.source              -- (LuaForce) -> on_forces_merging(event)
    base.area = event.area                  -- (area :: BoundingBox)
    base.element = event.element            -- (LuaGuiElement)
    base.setting_name = event.setting       -- (string)
    base.setting_type = event.setting_type  -- (string)
    --------------------------------------------------
end)
----------------------------------------------------------------


function RitnEvent:getSurface()
    return RitnSurface(self.surface)
end



function RitnEvent:getPlayer()
    return RitnPlayer(self.player)
end



function RitnEvent:getForce()
    return RitnForce(self.force)
end



function RitnEvent:getTechnology()
    return RitnTechnology(self.technology)
end


function RitnEvent:getReason()
    if self.reason == defines.disconnect_reason.quit then
        return "quit"
    elseif self.reason == defines.disconnect_reason.dropped then
        return "dropped"
    elseif self.reason == defines.disconnect_reason.reconnect then
        return "reconnect"
    elseif self.reason == defines.disconnect_reason.wrong_input then
        return "wrong_input"
    elseif self.reason == defines.disconnect_reason.desync_limit_reached	then
        return "desync_limit_reached"
    elseif self.reason == defines.disconnect_reason.cannot_keep_up	then
        return "cannot_keep_up"
    elseif self.reason == defines.disconnect_reason.afk then
        return "afk"
    elseif self.reason == defines.disconnect_reason.kicked	then
        return "kicked"
    elseif self.reason == defines.disconnect_reason.kicked_and_deleted then
        return "kicked_and_deleted"
    elseif self.reason == defines.disconnect_reason.banned	then
        return "banned"
    elseif self.reason == defines.disconnect_reason.switching_servers then
        return "switching_servers"
    end
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