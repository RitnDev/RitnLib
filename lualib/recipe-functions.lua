-- INIT
local ritnlib = {}
--------------------------
local flib = {item = require("item-functions")}
--------------------------

--DISABLE RECIPE
local function disable(recipe_name, type)
	local type_item = "item"
	if type ~= nil then type_item = type end

	if data.raw.recipe[recipe_name] then 
		data.raw.recipe[recipe_name]["enabled"] = false
		data.raw.recipe[recipe_name]["hidden"] = true
		
		if data.raw[type_item][recipe_name] then 
			data.raw[type_item][recipe_name].flags = {"hidden"}
		end
	end
end


--SET TIME, ENERGY REQUIERED
local function set_energy_required(recipe_name, time)
	if data.raw.recipe[item] then
        if data.raw.recipe[item].normal then
            data.raw.recipe[item].normal.energy_required = time
       		if data.raw.recipe[item].expansive then
                 data.raw.recipe[item].expansive.energy_required = time
       		end
    	else
            data.raw.recipe[item].energy_required = time
        end
    end
end



--REMOVE INGREDIENT
local function remove_ingredient(recipe, item)
	if data.raw.recipe[recipe] then
  
	  if data.raw.recipe[recipe].expensive then
		flib.item.remove(data.raw.recipe[recipe].expensive.ingredients, item)
	  end
	  if data.raw.recipe[recipe].normal then
		flib.item.remove(data.raw.recipe[recipe].normal.ingredients, item)
	  end
	  if data.raw.recipe[recipe].ingredients then
		flib.item.remove(data.raw.recipe[recipe].ingredients, item)
	  end
	  
	end
  end
  
  
--ADD NEW INGREDIENT
local function add_new_ingredient(recipe, item)
	if data.raw.recipe[recipe] and flib.item.get.type(flib.item.basic_item(item).name) then
	  if data.raw.recipe[recipe].expensive then
		flib.item.add_new(data.raw.recipe[recipe].expensive.ingredients, flib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].normal then
		flib.item.add_new(data.raw.recipe[recipe].normal.ingredients, flib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].ingredients then
		flib.item.add_new(data.raw.recipe[recipe].ingredients, flib.item.basic_item(item))
	  end
	end
end
  


  --ADD INGREDIENT
local function add_ingredient(recipe, item)
	if data.raw.recipe[recipe] and flib.item.get.type(flib.item.basic_item(item).name) then
	  if data.raw.recipe[recipe].expensive then
		flib.item.add(data.raw.recipe[recipe].expensive.ingredients, flib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].normal then
		flib.item.add(data.raw.recipe[recipe].normal.ingredients, flib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].ingredients then
		flib.item.add(data.raw.recipe[recipe].ingredients, flib.item.basic_item(item))
	  end
	end
end
  


 --SET INGREDIENT
local function set_ingredient(recipe, item)
	if data.raw.recipe[recipe] and flib.item.get.type(flib.item.basic_item(item).name) then
	  if data.raw.recipe[recipe].expensive then
		flib.item.set(data.raw.recipe[recipe].expensive.ingredients, flib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].normal then
		flib.item.set(data.raw.recipe[recipe].normal.ingredients, flib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].ingredients then
		flib.item.set(data.raw.recipe[recipe].ingredients, flib.item.basic_item(item))
	  end
	end
end


-- change subgroup
local function change_subgroup(item_name, subgroup, order)
	if data.raw.item[item_name] then 
		data.raw.item[item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw.item[item_name].order = order
		end
	end
	if data.raw["module"][item_name] then 
		data.raw["module"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["module"][item_name].order = order
		end
	end
	if data.raw["gun"][item_name] then 
		data.raw["gun"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["gun"][item_name].order = order
		end
	end
	if data.raw["rail-planner"][item_name] then 
		data.raw["rail-planner"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["rail-planner"][item_name].order = order
		end
	end
	if data.raw["tool"][item_name] then 
		data.raw["tool"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["tool"][item_name].order = order
		end
	end
	if data.raw["blueprint"][item_name] then 
		data.raw["blueprint"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["blueprint"][item_name].order = order
		end
	end
	if data.raw["deconstruction-item"][item_name] then 
		data.raw["deconstruction-item"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["deconstruction-item"][item_name].order = order
		end
	end
	if data.raw["upgrade-item"][item_name] then 
		data.raw["upgrade-item"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["upgrade-item"][item_name].order = order
		end
	end
	if data.raw["blueprint-book"][item_name] then 
		data.raw["blueprint-book"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["blueprint-book"][item_name].order = order
		end
	end
	if data.raw["capsule"][item_name] then 
		data.raw["capsule"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["capsule"][item_name].order = order
		end
	end
	if data.raw["spidertron-remote"][item_name] then 
		data.raw["spidertron-remote"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["spidertron-remote"][item_name].order = order
		end
	end
	if data.raw["item-with-entity-data"][item_name] then 
		data.raw["item-with-entity-data"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["item-with-entity-data"][item_name].order = order
		end
	end
	if data.raw["item-with-label"][item_name] then 
		data.raw["item-with-label"][item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw["item-with-label"][item_name].order = order
		end
	end
	if data.raw.recipe[item_name] then 
		data.raw.recipe[item_name].subgroup = subgroup
		if order ~= nil then 
			data.raw.recipe[item_name].order = order
		end
	end
end


local function change_group(subgroup, group, order)
    if data.raw["item-subgroup"][subgroup] then 
        data.raw["item-subgroup"][subgroup].group = group
    end
	if order ~= nil then 
		data.raw["item-subgroup"][subgroup].order = order
	end
end

local function change_recipe_category(recipe, category)
    if data.raw.recipe[recipe] then 
        data.raw.recipe[recipe].category = category
    end
end

---------------------------------------------------
-- Chargement des fonctions

ritnlib.recipe = {
	disable = disable,
	energy_required = {set = set_energy_required},
	ingredient = {
		add = add_ingredient,
		addNew = add_new_ingredient,
		remove = remove_ingredient,
		set = set_ingredient
	},
	change = {
		subgroup = change_subgroup,
		group = change_group,
		category = change_recipe_category
	}
}
  
return ritnlib.recipe