--------------------------------------------------
--------------------------------------------------

-- Fonction d'envoie sur la console serveur
local function trace_event(output)
    --Envoie en console serveur
    print("[RITNLOG] > " .. game.table_to_json(output))
end


-- Fonction de récupération du nom de l'event
local function event_name(e)
    for index,value in pairs(defines.events) do 
        if value == e.name then 
            return index
        end
    end
    return ""
end


-- boolean to String
local function get_boolean(bool)
    if bool then return "true" else return "false" end 
end


-- Récupération du nom du dernier utilisateur de l'entité
local function get_LastUser(LuaEntity) 
    if LuaEntity.last_user then 
        return LuaEntity.last_user.name 
    else 
        return "" 
    end
end


----------------------------------------

-- renvoie un tableau typé event
local function get_event(event, category)
    local data = {
            type = "event",
            name = event_name(event),
            category=category,
        }
    return data
end


-- renvoie un tableau typé position
local function get_position(position)
    local data = {
        type = "position",
        x=math.floor(position.x),
        y=math.floor(position.y),
    }
    return data
end


-- renvoie un tableau typé player
local function get_player(e)
    local LuaPlayer = game.players[e.player_index]
    local data = {
        type = "player",
        index = LuaPlayer.index,
        name = LuaPlayer.name,
        force = LuaPlayer.force.name,
        surface = LuaPlayer.surface.name,
    }
    return data
end


local function get_entity(LuaEntity)
    local data = {
        type = "entity",
        name = LuaEntity.name,
        position = get_position(LuaEntity.position)
    }
    return data
end

local function get_ItemStack(ItemStack)
    local data = {
        type = "stack",
    }
    if ItemStack ~= nil and ItemStack.valid and ItemStack.valid_for_read then
        data.name = ItemStack.name
        data.count = ItemStack.count
    else
        data.name = ""
        data.count = 0
    end
    return data
end



---
local flib = {
    trace_event = trace_event,
    get_event = get_event,
    get_boolean = get_boolean,
    get_LastUser = get_LastUser,
    get_position = get_position,
    get_player = get_player,
    get_entity = get_entity,
    get_ItemStack = get_ItemStack,
}

return flib