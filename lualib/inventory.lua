---
-- Fonction "player"
---
local flib = {}
local inventory_size = 65535

-- Init structure
local function initInventory()
    local invGlobal = {}

    invGlobal[defines.inventory.character_main] = game.create_inventory(65535)
    invGlobal[defines.inventory.character_guns] = game.create_inventory(65535)
    invGlobal[defines.inventory.character_ammo] = game.create_inventory(65535)
    invGlobal[defines.inventory.character_armor] = game.create_inventory(65535)
    invGlobal[defines.inventory.character_trash] = game.create_inventory(65535)
    invGlobal["cursor"] = game.create_inventory(1)
    invGlobal["logistic_param"] = {
      {name="slot_count", value = 0},
      {name="character_personal_logistic_requests_enabled", value = false}
    }

    return invGlobal
end



-- SaveInventory
local function saveInventory(LuaPlayer, invGlobal, define)
  local inventory = LuaPlayer.get_inventory(define)
    if inventory ~= nil then
      for i=1, #inventory do 
        local stack = inventory[i]
        if stack.valid then
          invGlobal[define][i].swap_stack(stack)
        end
      end
    end
end

--LoadInventory
local function loadInventory(LuaPlayer, invGlobal, define)
  local inventory1 = LuaPlayer.get_inventory(define)
  local inventory = invGlobal[define]
  if inventory1 ~= nil then
    for i=1, #inventory1 do 
      local stack = inventory[i]
      if stack.valid then
        inventory1[i].swap_stack(stack)
      end
    end
  end
end



--New Save
local function save_all_inventory(LuaPlayer, invGlobal)
  saveInventory(LuaPlayer, invGlobal, defines.inventory.character_main)
  saveInventory(LuaPlayer, invGlobal, defines.inventory.character_guns)
  saveInventory(LuaPlayer, invGlobal, defines.inventory.character_ammo)
  saveInventory(LuaPlayer, invGlobal, defines.inventory.character_armor)
  saveInventory(LuaPlayer, invGlobal, defines.inventory.character_trash)
end

--New Get
local function load_all_inventory(LuaPlayer, invGlobal)
  loadInventory(LuaPlayer, invGlobal, defines.inventory.character_armor) -- fix 0.2.1
  loadInventory(LuaPlayer, invGlobal, defines.inventory.character_main)
  loadInventory(LuaPlayer, invGlobal, defines.inventory.character_guns)
  loadInventory(LuaPlayer, invGlobal, defines.inventory.character_ammo)
  loadInventory(LuaPlayer, invGlobal, defines.inventory.character_trash)
end


------------------------------------------------------------------------------------------
-- LOGISTIC
------------------------------------------------------------------------------------------
-- Save Logistic
local function saveLogistic(LuaPlayer, invGlobal)
  -- Demande logistique
  local slot_count = LuaPlayer.character.request_slot_count -- Correctif pour la v1.1
  invGlobal["logistic_param"] = {
    {name="slot_count", value = slot_count},
    {name="character_personal_logistic_requests_enabled", value = LuaPlayer.character_personal_logistic_requests_enabled}
  }
  invGlobal["logistic_inv"] = {}
  if slot_count > 0 then 
    for slot_index=1,slot_count do 
      local logistic_slot = LuaPlayer.get_personal_logistic_slot(slot_index)
      table.insert(invGlobal["logistic_inv"], logistic_slot)
      LuaPlayer.clear_personal_logistic_slot(slot_index)
    end
  else 
    invGlobal["logistic_inv"] = nil
  end
end

-- Load Logistic
local function loadLogistic(LuaPlayer, invGlobal)
  local slot_count = 0
  if invGlobal["logistic_param"] ~= nil then
    LuaPlayer.character_personal_logistic_requests_enabled = invGlobal["logistic_param"][2].value
    if invGlobal["logistic_param"][1].value ~= 0 then
      slot_count = invGlobal["logistic_param"][1].value
    end
  end
  if invGlobal["logistic_inv"] ~= nil then 
    if slot_count ~= 0 then
      local inv = invGlobal["logistic_inv"]
      for slot_index,slot in pairs(inv) do
        local value = {name = slot.name, min = slot.min, max = slot.max}
        local result = LuaPlayer.set_personal_logistic_slot(slot_index, value)
      end
    end
  end
end

------------------------------------------------------------------------------------------
-- CURSOR
------------------------------------------------------------------------------------------
-- Save Cursor
local function saveCursor(LuaPlayer, invGlobal)
  local stack = LuaPlayer.cursor_stack
  if stack.valid then
    invGlobal["cursor"][1].swap_stack(stack)
  end
end

-- Load Cursor
local function loadCursor(LuaPlayer, invGlobal)
  local stack = invGlobal["cursor"][1]
  if stack.valid then
    LuaPlayer.cursor_stack.swap_stack(stack)
  end
end

------------------------------------------------------------------------------------------
-- Cancel All Crafting
local function cancel_all_crafting(LuaPlayer)
  local len = LuaPlayer.crafting_queue_size
  if len > 0 then
    pcall(function()
      for i,craft in pairs(LuaPlayer.crafting_queue) do
        local options = {index=craft.index, count=craft.count}
        LuaPlayer.cancel_crafting(options)
      end
    end)
  end
end

------------------------------------------------------------------------------------------

--- SAVE
local function save(LuaPlayer, invGlobal)
  -- No characters
  if LuaPlayer.character == nil then return end

  -- init data inventory (global)
  if not invGlobal then
    initInventory(LuaPlayer, invGlobal)
  end

  --cancel_all_crafting(LuaPlayer)
  save_all_inventory(LuaPlayer, invGlobal)
  --saveCursor(LuaPlayer, invGlobal)
  saveLogistic(LuaPlayer, invGlobal)
end

--- LOAD
local function load(LuaPlayer, invGlobal)
  -- No characters
  if LuaPlayer.character == nil then return end

  -- init data inventory (global)
  if not invGlobal["cursor"] then
    invGlobal = initInventory(invGlobal)
  end

  load_all_inventory(LuaPlayer, invGlobal)
  --loadCursor(LuaPlayer, invGlobal)
  loadLogistic(LuaPlayer, invGlobal)
end


-- fonction non local, renvoie le curseur dans l'invenataire principale
-- selon un nom de l'item et la surface où le joueur se trouve.
local function clearCursor(LuaPlayer, itemName)
  if LuaPlayer.surface.name == LuaPlayer.name then return end
  if LuaPlayer.cursor_stack.count == 0 then return end
  
  local LuaItemStack = LuaPlayer.cursor_stack
  if LuaItemStack.name ~= itemName then 
    return
  else 
    LuaPlayer.clear_cursor()
    LuaPlayer.print(ritnmods.teleport.defines.name.caption.frame.cursor)
  end
end


----------------------------
-- Chargement des fonctions
flib.init = initInventory
flib.save = save
flib.get = load
flib.clearCursor = clearCursor

-- Retourne la liste des fonctions
return flib