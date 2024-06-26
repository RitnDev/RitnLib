-- RitnLibEvent
----------------------------------------------------------------


----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------
local events_filter = {
    position = {
        ["on_chunk_charted"] = true,
        ["on_chunk_generated"] = true,
    }
}
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
    if event.name == defines.events.on_forces_merging then 
        return event.destination
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
        return event.created_entity
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


local function getRocket(event)
    if event.rocket then 
        return event.rocket
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


local function getPosition(event, name)
    if event.cursor_position then 
        return event.cursor_position
    end
    if not events_filter.position[name] then 
        return event.position
    end
end

local string = require(ritnlib.defines.string)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLibEvent = ritnlib.classFactory.newclass(function(self, event, mod_name)
    local modName = "RitnLib"
    if event == nil then return end
    if mod_name ~= nil then modName = mod_name end
    self.object_name = "RitnLibEvent"
    ---------------------------------
    self.mod_name = modName
    self.event = event
    self.name = string.defaultValue(getEventName(event), "on_tick") -- defines
    self.index = event.name                         -- index
    ---------------------------------
    self.player = getPlayer(event)                  -- (LuaPlayer)
    self.surface = getSurface(event)                -- (LuaSurface)
    self.force = getForce(event)                    -- (LuaForce)
    self.recipe = getRecipe(event)                  -- (LuaRecipe)
    self.technology = getTech(event)                -- (LuaTechnology)
    self.entity = getEntity(event)                  -- (LuaEntity)
    self.robot = getRobot(event)                    -- (LuaEntity)
    self.rocket = getRocket(event)                  -- (LuaEntity)
    self.inventory = getInventory(event)            -- (LuaInventory)
    self.cause = event.cause                        -- (LuaEntity)?
    ----
    self.reason = event.reason                      -- defines.disconnect_reason
    self.queued_count = event.queued_count          -- (number)
    self.gui_type = getGuiType(event.gui_type)
    self.source = event.source                      -- (LuaForce) -> on_forces_merging(event)
    self.source_name = event.source_name            -- (String) -> on_forces_merged(event)
    self.area = event.area                          -- (area :: BoundingBox)
    self.element = event.element                    -- (LuaGuiElement)
    self.setting_name = event.setting               -- (string)
    self.setting_type = event.setting_type          -- (string)
    self.position = getPosition(event, self.name)   -- (MapPosition)
    --------------------------------------------------
    log(string.defaultValue(self.object_name, "toto"))
    log(string.defaultValue(self.name, "tutu"))
end)
----------------------------------------------------------------


function RitnLibEvent:getSurface()
    return RitnLibSurface(self.surface)
end



function RitnLibEvent:getPlayer()
    return RitnLibPlayer(self.player)
end



function RitnLibEvent:getForce()
    return RitnLibForce(self.force)
end



function RitnLibEvent:getTechnology()
    return RitnLibTechnology(self.technology)
end


function RitnLibEvent:getReason()
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
function RitnLibEvent.setIngredientColor(ingredient, color)
    if type(ingredient) == "string" and type(color) == "table" then
        log("RitnLibEvent | setIngredientColor() : ingredient = " .. ingredient)

        if remote.interfaces["DiscoScience"] and remote.interfaces["DiscoScience"]["setIngredientColor"] then
            log("RitnLibEvent | remote call -> DiscoScience - setIngredientColor")
            remote.call("DiscoScience", "setIngredientColor", ingredient, color)
        end
    end
end


---------------------------------
--return RitnLibEvent