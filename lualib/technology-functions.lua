-- INIT
local ritnlib = {}
--------------------------

--DISABLE TECHNOLOGY
local function disable(technology_name)
	if data.raw.technology[technology_name] then
		data.raw.technology[technology_name]["enabled"] = false
		data.raw.technology[technology_name]["hidden"] = true
	end
end


--ADD RECIPE UNLOCK
local function add_recipe_unlock(technology, recipe)
	if data.raw.technology[technology] and data.raw.recipe[recipe] then
	  local addit = true
	  if not data.raw.technology[technology].effects then
		data.raw.technology[technology].effects = {}
	  end
	  for i, effect in pairs(data.raw.technology[technology].effects) do
		if effect.type == "unlock-recipe" and effect.recipe == recipe then addit = false end
	  end
	  if addit then table.insert(data.raw.technology[technology].effects,{type = "unlock-recipe", recipe = recipe}) end
	end
end
  

--REMOVE RECIPE UNLOCK
local function remove_recipe_unlock(technology, recipe)
	if data.raw.technology[technology] and data.raw.technology[technology].effects then
	  for i, effect in pairs(data.raw.technology[technology].effects) do
		if effect.type == "unlock-recipe" and effect.recipe == recipe then
		  table.remove(data.raw.technology[technology].effects,i)
		end
	  end
	end
end


--ADD SCIENCE PACK
local function add_science_pack(technology, pack, amount)
	if data.raw.technology[technology] and data.raw.tool[pack] then
	  local addit = true
	  for i, ingredient in pairs(data.raw.technology[technology].unit.ingredients) do
		if ingredient[1] == pack then
		  addit = false
		  ingredient[2] = ingredient[2] + amount
		end
		if ingredient.name == pack then
		  addit = false
		  ingredient.amount = ingredient.amount + amount
		end
	  end
	  if addit then table.insert(data.raw.technology[technology].unit.ingredients,{pack, amount}) end
	end
end



--REMOVE SCIENCE PACK
local function remove_science_pack(technology, pack)
	if data.raw.technology[technology] then
	  for i, ingredient in pairs(data.raw.technology[technology].unit.ingredients) do
		if ingredient[1] == pack or ingredient.name == pack then
		  table.remove(data.raw.technology[technology].unit.ingredients, i)
		end
	  end
	end
  end




--ADD PRE-REQUIS
local function add_prerequisite(technology, prerequisite)
	if data.raw.technology[technology] and data.raw.technology[prerequisite] then
	  local addit = true
	  if data.raw.technology[technology].prerequisites then
		for i, check in ipairs(data.raw.technology[technology].prerequisites) do
		  if check == prerequisite then addit = false end
		end
	  else
		data.raw.technology[technology].prerequisites = {}
	  end
	  if addit then table.insert(data.raw.technology[technology].prerequisites, prerequisite) end
	end
end
  

--REMOVE PRE-REQUIS
local function remove_prerequisite(technology, prerequisite)
	if data.raw.technology[technology] then
	  for i, check in ipairs(data.raw.technology[technology].prerequisites) do
		if check == prerequisite then
		  table.remove(data.raw.technology[technology].prerequisites, i)
		end
	  end
	end
end


--REPLACE SCIENCE PACK
local function replace_science_pack(technology, old, new)
	if data.raw.technology[technology] and data.raw.tool[new] then
	  local doit = false
	  local amount = 0
	  for i, ingredient in pairs(data.raw.technology[technology].unit.ingredients) do
		if ingredient[1] == old then
		  doit = true
		  amount = ingredient[2] + amount
		end
		if ingredient.name == old then
		  doit = true
		  amount = ingredient.amount + amount
		end
	  end
	  if doit then
		remove_science_pack(technology, old)
		add_science_pack(technology, new, amount)
	  end
	end
end


--REPLACE ALL SCIENCE PACK
local function replace_all_science_pack(pack_old, pack_new)
	for _, techno in pairs(data.raw.technology) do
		replace_science_pack(techno.name, pack_old, pack_new)
	end
end


--MULTIPLIED SCIENCE PACK
local function multiplied_science_pack(technology, coeff)
	if data.raw.technology[technology] then
		data.raw.technology[technology].unit.count = data.raw.technology[technology].unit.count * coeff
	end
end


--SET COUNT SCIENCE PACK
local function set_count(technology, count)
	if data.raw.technology[technology] then
		data.raw.technology[technology].unit.count = count
	end
end


-- remove Science pack slot labs
local function remove_pack_lab(pack, lab)
	if lab == nil then
		for i, labo in pairs(data.raw.lab) do
			for j, input in pairs(labo.inputs) do
				if labo.inputs[input] == pack or input == pack then
					table.remove(labo.inputs, j)
				end
			end
		end
	else 
		for i, input in pairs(data.raw["lab"][lab].inputs) do
			if data.raw["lab"][lab].inputs[input] == pack or input == pack then
				table.remove(data.raw["lab"][lab].inputs, i)
			end
		end
	end
end

local function add_pack_lab(pack, index)
	for i, lab in pairs(data.raw.lab) do
		if index == nil then
			table.insert(lab.inputs, 1, pack)
		else 
			table.insert(lab.inputs, index, pack)
		end
	end
end


---------------------------------------------------
-- Chargement des fonctions

ritnlib.tech = {
	disable = disable,
	recipe = {
		add = add_recipe_unlock,
		remove = remove_recipe_unlock,
	},
	pack = {
		add = add_science_pack,
		remove = remove_science_pack,
		replace = replace_science_pack,
		replaceAll = replace_all_science_pack,
		multiplied = multiplied_science_pack,
		lab = {
			remove = remove_pack_lab,
			add = add_pack_lab,
		}
	},
	prerequisite = {
		add = add_prerequisite,
		remove = remove_prerequisite,
	},
	set = {count = set_count},
}
  
return ritnlib.tech