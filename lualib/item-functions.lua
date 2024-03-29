-- INIT
--------------------------


--[[
            FOR RECIPE FUNCTION
  ]]


-- Recupère le type parmis tous les types d'items possible
local function get_type(name)
  local item_types = {"ammo", "armor", "capsule", "fluid", "gun", "item", "mining-tool", "module", "tool", "item-with-entity-data"}
  for i, type_name in pairs(item_types) do
    if data.raw[type_name][name] then
      return type_name end
  end
  return nil
end


-- Recupère le type entre item et fluid
local function get_basic_type(name)
  local item_type = "item"
  if data.raw.fluid[name] then item_type = "fluid" end
  return item_type
end


local function basic_item(inputs)
    local item = {}

    if inputs.name then
        item.name = inputs.name
    else
        item.name = inputs[1]
    end

    if inputs.amount then
        item.amount = inputs.amount
    else
        if inputs[2] then item.amount = inputs[2] end
    end
    
    if not item.amount then item.amount = 1 end

    if inputs.type then
        item.type = inputs.type
    else
        item.type = get_basic_type(item.name)
    end

    if item.type == "item" then
        if item.amount > 0 and item.amount < 1 then
            item.amount = 1
        else
            item.amount = math.floor(item.amount)
        end
    end

    return item
end



local function item(inputs)
    local item = {}

    if inputs.name then
        item.name = inputs.name
    else
        item.name = inputs[1]
    end

    if inputs.amount then
        item.amount = inputs.amount
    else
        if inputs[2] then item.amount = inputs[2] end
    end

    if not item.amount then
        if inputs.amount_min and inputs.amount_max then
            item.amount_min = inputs.amount_min
            item.amount_max = inputs.amount_max
        else
            item.amount = 1
        end
    end

    if inputs.probability then item.probability = inputs.probability end

    if inputs.type then
        item.type = inputs.type
    else
        item.type = get_basic_type(item.name)
    end

    return item
end


local function itemV2(inputs)
    local item = {}

    if inputs.name then
        item.name = inputs.name
    else
        item.name = inputs[1]
    end

    if inputs.amount then
        item.amount = inputs.amount
    else
        if inputs[2] then item.amount = inputs[2] end
    end

    if not item.amount then
        if inputs.amount_min and inputs.amount_max then
            item.amount_min = inputs.amount_min
            item.amount_max = inputs.amount_max
        else
            item.amount = 1
        end
    end

    if inputs.probability then item.probability = inputs.probability end

    if inputs.type then
        item.type = inputs.type
    else
        item.type = get_basic_type(item.name)
    end


    if item.type == "item" then
        if item.amount > 0 and item.amount < 1 then
            item.amount = 1
        else
            item.amount = math.floor(item.amount)
        end
    end

    return item
end




local function combine(item1_in, item2_in)
  local item = {}
  local item1 = itemV2(item1_in)
  local item2 = itemV2(item2_in)

  item.name = item1.name
  item.type = item1.type

  if item1.amount and item2.amount then
    item.amount = item1.amount + item2.amount
  elseif item1.amount_min and item1.amount_max and item2.amount_min and item2.amount_max then
    item.amount_min = item1.amount_min + item2.amount_min
    item.amount_max = item1.amount_max + item2.amount_max
  else
    if item1.amount_min and item1.amount_max and item2.amount then
      item.amount_min = item1.amount_min + item2.amount
      item.amount_max = item1.amount_max + item2.amount
    elseif item1.amount and item2.amount_min and item2.amount_max then
      item.amount_min = item1.amount + item2.amount_min
      item.amount_max = item1.amount + item2.amount_max
    end
  end

  if item1.probability and item2.probability then
    item.probability = (item1.probability + item2.probability) / 2
  elseif item1.probability then
    item.probability = (item1.probability + 1) / 2
  elseif item2.probability then
    item.probability = (item2.probability + 1) / 2
  end

  return item
end



local function add(list, item_in) --increments amount if exists
  local item = item(item_in)
  local addit = true
  for i, object in pairs(list) do
    if object[1] == item.name or object.name == item.name then
      addit = false
      list[i] = combine(object, item)
    end
  end
  if addit then table.insert(list, item) end
end



local function add_new(list, item_in) --ignores if exists
  local item = item(item_in)
  local addit = true
  for i, object in pairs(list) do
    if item.name == basic_item(object).name then addit = false end
  end
  if addit then table.insert(list, item) end
end



local function remove(list, item)
  for i, object in ipairs(list) do
    if object[1] == item or object.name == item then
      table.remove(list, i)
    end
  end
end



local function set(list, item_in)
  local item = item(item_in)
  for i, object in pairs(list) do
    if object[1] == item.name or object.name == item.name then
      list[i] = item
    end
  end
end





local function disable(item_name, entity_type)
  local entity_name = data.raw.item[item_name].place_result
  data.raw.item[item_name] = nil
  if entity_type ~= nil then 
    if entity_name ~= nil then 
      if data.raw[entity_type] then 
        if data.raw[entity_type][entity_name] then 
          data.raw[entity_type][entity_name] = nil
        end
      end
    end
  end
end


---------------------------------------------------
-- Chargement des fonctions

return {
  --get = {
  --  type = get_type,
  --  basicType = get_basic_type
  --},
  getType = get_type,
  --basic_item = basic_item,
  item = itemV2,
  --combine = combine,
  add = add,
  addNew = add_new,
  remove = remove,
  set = set,
  --disable = disable
}


