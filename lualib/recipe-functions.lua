-- INIT
local ritnlib = {}
--------------------------
ritnlib.item = require("item-functions")
--------------------------

--DISABLE RECIPE
local function disable(recipe_name)
	if data.raw.recipe[recipe_name] then
		data.raw.recipe[recipe_name]["enabled"] = false
		data.raw.recipe[recipe_name]["hidden"] = true
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
		ritnlib.item.remove(data.raw.recipe[recipe].expensive.ingredients, item)
	  end
	  if data.raw.recipe[recipe].normal then
		ritnlib.item.remove(data.raw.recipe[recipe].normal.ingredients, item)
	  end
	  if data.raw.recipe[recipe].ingredients then
		ritnlib.item.remove(data.raw.recipe[recipe].ingredients, item)
	  end
	  
	end
  end
  
  
--ADD NEW INGREDIENT
local function add_new_ingredient(recipe, item)
	if data.raw.recipe[recipe] and ritnlib.item.get.type(ritnlib.item.basic_item(item).name) then
	  if data.raw.recipe[recipe].expensive then
		ritnlib.item.add_new(data.raw.recipe[recipe].expensive.ingredients, ritnlib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].normal then
		ritnlib.item.add_new(data.raw.recipe[recipe].normal.ingredients, ritnlib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].ingredients then
		ritnlib.item.add_new(data.raw.recipe[recipe].ingredients, ritnlib.item.basic_item(item))
	  end
	end
end
  


  --ADD INGREDIENT
local function add_ingredient(recipe, item)
	if data.raw.recipe[recipe] and ritnlib.item.get.type(ritnlib.item.basic_item(item).name) then
	  if data.raw.recipe[recipe].expensive then
		ritnlib.item.add(data.raw.recipe[recipe].expensive.ingredients, ritnlib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].normal then
		ritnlib.item.add(data.raw.recipe[recipe].normal.ingredients, ritnlib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].ingredients then
		ritnlib.item.add(data.raw.recipe[recipe].ingredients, ritnlib.item.basic_item(item))
	  end
	end
end
  


 --SET INGREDIENT
local function set_ingredient(recipe, item)
	if data.raw.recipe[recipe] and ritnlib.item.get.type(ritnlib.item.basic_item(item).name) then
  
	  if data.raw.recipe[recipe].expensive then
		ritnlib.item.set(data.raw.recipe[recipe].expensive.ingredients, ritnlib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].normal then
		ritnlib.item.set(data.raw.recipe[recipe].normal.ingredients, ritnlib.item.basic_item(item))
	  end
	  if data.raw.recipe[recipe].ingredients then
		ritnlib.item.set(data.raw.recipe[recipe].ingredients, ritnlib.item.basic_item(item))
	  end
  
	else
	  if not data.raw.recipe[recipe] then
		log("Recipe " .. recipe .. " does not exist.")
	  end
	  if not ritnlib.item.get.basicType(ritnlib.item.basic_item(item).name) then
		log("Ingredient " .. ritnlib.item.basic_item(item).name .. " does not exist.")
	  end
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
	}
}
  
return ritnlib.recipe