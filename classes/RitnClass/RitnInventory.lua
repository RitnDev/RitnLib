-- RitnInventory
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------



----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnInventory = class.newclass(function(base, LuaPlayer, inventoryGlobal)
    base.object_name = "RitnInventory"
    if LuaPlayer == nil then return end
    if LuaPlayer.valid == false then return end
    if LuaPlayer.is_player() == false then return end
    if LuaPlayer.object_name ~= "LuaPlayer" then return end
    if LuaPlayer.character == nil then return end
    if inventoryGlobal == nil then log('inventoryGlobal is nil') return end
    --------------------------------------------------
    base.data = inventoryGlobal
    base.player = LuaPlayer
    base.name = LuaPlayer.name
    ---
    base.INVENTORY_SIZE_MAX = 65535
    base.inventory_size = base.INVENTORY_SIZE_MAX
    --------------------------------------------------
end)
----------------------------------------------------------------


-- init data inventory
function RitnInventory:init()
    if self.data[self.name] ~= nil then return self end
    log('> '..self.object_name..':init() -> '..self.name)


    self.data[self.name] = {
        [defines.inventory.character_main] = game.create_inventory(self.inventory_size),
        [defines.inventory.character_guns] = game.create_inventory(self.inventory_size),
        [defines.inventory.character_ammo] = game.create_inventory(self.inventory_size),
        [defines.inventory.character_armor] = game.create_inventory(self.inventory_size),
        [defines.inventory.character_trash] = game.create_inventory(self.inventory_size),
        ["cursor"] = game.create_inventory(1),
        ["logistic_param"] = {
            {name="slot_count", value = 0},
            {name="character_personal_logistic_requests_enabled", value = false}
        }
    }

    return self
end


----------------------------------------------------------------
-- INVENTORY
----------------------------------------------------------------

-- SaveInventory
function RitnInventory:saveInventory(define)
    if self.data[self.name] == nil then self:init() end

    local inventory = self.player.get_inventory(define)
    if inventory ~= nil then
        for i=1, #inventory do 
            local stack = inventory[i]
            if stack.valid then
                self.data[self.name][define][i].swap_stack(stack)
            end
        end
    end

    return self
end
  
--LoadInventory
function RitnInventory:loadInventory(define)
    if self.data[self.name] == nil then return self end

    local inventory1 = self.player.get_inventory(define)
    local inventory = self.data[self.name][define]
    if inventory1 ~= nil then
      for i=1, #inventory1 do 
        local stack = inventory[i]
        if stack.valid then
          inventory1[i].swap_stack(stack)
        end
      end
    end
    
    return self
end
  
  
----------------------------------------------------------------
-- SAVE ALL INVENTORY
function RitnInventory:save_all_inventory()
    self:saveInventory(defines.inventory.character_main)
    self:saveInventory(defines.inventory.character_guns)
    self:saveInventory(defines.inventory.character_ammo)
    self:saveInventory(defines.inventory.character_armor)
    self:saveInventory(defines.inventory.character_trash)

    return self
end
  
-- LOAD ALL INVENTORY
function RitnInventory:load_all_inventory()
    self:loadInventory(defines.inventory.character_armor) -- /!\ priority armor
    self:loadInventory(defines.inventory.character_main)
    self:loadInventory(defines.inventory.character_guns)
    self:loadInventory(defines.inventory.character_ammo)
    self:loadInventory(defines.inventory.character_trash)

    return self
end


----------------------------------------------------------------
-- LOGISTIC
----------------------------------------------------------------

-- Save Logistic
function RitnInventory:saveLogistic()
    if self.data[self.name] == nil then self:init() end

    -- Demande logistique
    local slot_count = self.player.character.request_slot_count
    self.data[self.name]["logistic_param"] = {
        {
            name="slot_count", 
            value = slot_count
        },
        {
            name = "character_personal_logistic_requests_enabled", 
            value = self.player.character_personal_logistic_requests_enabled
        }
    }
    self.data[self.name]["logistic_inv"] = {}
    if slot_count > 0 then 
        for slot_index=1, slot_count do 
            local logistic_slot = self.player.get_personal_logistic_slot(slot_index)
            table.insert(self.data[self.name]["logistic_inv"], logistic_slot)
            self.player.clear_personal_logistic_slot(slot_index)
        end
    else 
        self.data[self.name]["logistic_inv"] = nil
    end

    return self
end
  

-- Load Logistic
function RitnInventory:loadLogistic()
    if self.data[self.name] == nil then return self end

    local slot_count = 0
    if self.data[self.name]["logistic_param"] ~= nil then
        self.player.character_personal_logistic_requests_enabled = self.data[self.name]["logistic_param"][2].value
        if self.data[self.name]["logistic_param"][1].value ~= 0 then
            slot_count = self.data[self.name]["logistic_param"][1].value
        end
    end
    if self.data[self.name]["logistic_inv"] ~= nil then 
        if slot_count ~= 0 then
            local inv = self.data[self.name]["logistic_inv"]
            for slot_index, slot in pairs(inv) do
                local value = {name = slot.name, min = slot.min, max = slot.max}
                local result = self.player.set_personal_logistic_slot(slot_index, value)
            end
        end
    end

    return self
end


----------------------------------------------------------------
-- CURSOR
----------------------------------------------------------------

-- Save Cursor
function RitnInventory:saveCursor()
    if self.data[self.name] == nil then self:init() end

    local stack = self.player.cursor_stack
    if stack.valid then
        self.data[self.name]["cursor"][1].swap_stack(stack)
    end

    return self
end
  
-- Load Cursor
function RitnInventory:loadCursor()
    if self.data[self.name] == nil then return self end

    local stack = self.data[self.name]["cursor"][1]
    if stack.valid then
        self.player.cursor_stack.swap_stack(stack)
    end

    return self
end


----------------------------------------------------------------

--- MASTER SAVE
function RitnInventory:save(cursor)
    if self.data[self.name] == nil then self:init() end
    local option = false 
    if cursor ~= nil then option = cursor end
    log('> '..self.object_name..':save('.. tostring(option) ..') -> '..self.name)

    self:save_all_inventory():saveLogistic()
    if option then self:saveCursor() end

    return self
end

--- MASTER LOAD
function RitnInventory:load(cursor)
    if self.data[self.name] == nil then return self end
    local option = false 
    if cursor ~= nil then option = cursor end
    log('> '..self.object_name..':load('.. tostring(option) ..') -> '..self.name)

    self:load_all_inventory():loadLogistic()
    if option then self:saveCursor() end

    return self
end

----------------------------------------------------------------
return RitnInventory