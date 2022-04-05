-- INIT
local resource_autoplace = require("resource-autoplace")
local sounds = require ("__base__.prototypes.entity.sounds")
local ores = require("__RitnLib__.lualib.vanilla.ores")


local ritnlib = {}
local store = {
	update = {},
	make = {}
}
--------------------------


--SET DYNAMIC RESOURCE_INDEX
--set new index if not .get, set same index if .get
local function set_index()
	for r, subdir in pairs(store) do
		for r, input in pairs(subdir) do
			if not input.get then
				input.autoplace.resource_index = get_next_resource_index()
			end
		end
		for r, input in pairs(subdir) do
			if input.get then
				if store.update[input.get] then
					input.autoplace.resource_index = store.update[input.get].autoplace.resource_index
				else
					input.autoplace.resource_index = store.make[input.get].autoplace.resource_index
				end
			end
		end
	end
end

--UPDATE AUTOPLACE FROM STORE
local function update_autoplace()
	for r, subdir in pairs(store) do
		for r, input in pairs(subdir) do
			if not input.inactive then
				if input.infinite then
					input.richness_post_multiplier = 1/20
				else
					input.richness_post_multiplier = 1
				end
				--Add autoplace to resource
				if data.raw.resource[input.name] then
					data.raw.resource[input.name].order = "a-"..input.order
						resource_generator.setup_resource_autoplace_data(input.name,
						{
						name = input.name,
						order = input.order,
						base_density = input.autoplace.base_density,
						has_starting_area_placement = input.autoplace.starting_area,
						resource_index = input.autoplace.resource_index,
						regular_rq_factor_multiplier = input.autoplace.regular_rq_factor_multiplier;
						starting_rq_factor_multiplier = input.autoplace.starting_rq_factor_multiplier;
						base_spots_per_km2 = input.autoplace.base_spots_per_km2,
						random_probability = input.autoplace.random_probability,
						random_spot_size_minimum = input.autoplace.random_spot_size_minimum,
						random_spot_size_maximum = input.autoplace.random_spot_size_maximum,
						additional_richness = input.autoplace.additional_richness,
						richness_post_multiplier = input.richness_post_multiplier
						}
						)
					if input.acid_to_mine then
						if angelsmods.petrochem then
							if angelsmods.trigger.enableacids then
								input.acid_req = input.acid_to_mine
							else
								input.acid_req = "liquid-sulfuric-acid"
							end
						else
							if data.raw.fluid[input.acid_to_mine] then
								input.acid_req = input.acid_to_mine
							else
								input.acid_req = "sulfuric-acid"
							end
						end
						data.raw.resource[input.name].minable.required_fluid = input.acid_req
						log(serpent.block(input.acid_req))
						log(serpent.block(data.raw.resource[input.name].minable.required_fluid))
					end
				end
			end
		end
	end
end

--UPDATE RESOURCES FROM STORE
--RUN IN UPDATES
local function update_resource()
	--ZELOS GARBAGE COUNT
	local totalcount = 0
	local startcount = 0
	local regioncount = 1024
	for r, subdir in pairs(store) do
		for _, garbage in pairs(subdir) do
			if not garbage.inactive then
				if garbage.name then
					totalcount = totalcount+1
				end
				if garbage.autoplace.starting_area then
					startcount = startcount+1
				end
				if regioncount <= 1536 then
					regioncount = regioncount + 32
				else
					regioncount = regioncount + 16
				end
			end
		end
	end
	set_index()
	--SET RESOURCE COUNT TO THE RIGHT VALUE
	regular_resource_count = totalcount
	starting_resource_count = startcount
	starting_size = startcount * 30
	region_size = regioncount
	--UPDATE AUTOPLACE FOR UPDATE_RESOURCES 
	update_autoplace()
end



--REMOVE RESOURCE
local function remove_resource(resource)
	if data.raw.resource[resource] then
		data.raw.resource[resource] = nil
		data.raw["autoplace-control"][resource] = nil
		if resource_generator and resource_generator.resource_indexes[resource] then
			resource_generator.resource_indexes[resource] = nil
			resource_generator.resource_autoplace_data[resource] = nil
		end
		data.raw["map-gen-presets"].default["rich-resources"].basic_settings.autoplace_controls[resource] = nil
		data.raw["map-gen-presets"].default["death-world"].basic_settings.autoplace_controls[resource] = nil
		data.raw["map-gen-presets"].default["death-world-marathon"].basic_settings.autoplace_controls[resource] = nil
		data.raw["map-gen-presets"].default["rail-world"].basic_settings.autoplace_controls[resource] = nil
		data.raw["map-gen-presets"].default["ribbon-world"].basic_settings.autoplace_controls[resource] = nil
		data.raw["map-gen-presets"].default["island"].basic_settings.autoplace_controls[resource] = nil
	end
	if data.raw.resource["infinite-"..resource] then
		data.raw.resource["infinite-"..resource] = nil
		data.raw["autoplace-control"]["infinite-"..resource] = nil
		if resource_generator and resource_generator.resource_indexes["infinite-"..resource] then
			resource_generator.resource_indexes["infinite-"..resource] = nil
			resource_generator.resource_autoplace_data["infinite-"..resource] = nil
		end
		data.raw["map-gen-presets"].default["rich-resources"].basic_settings.autoplace_controls["infinite-"..resource] = nil
		data.raw["map-gen-presets"].default["death-world"].basic_settings.autoplace_controls["infinite-"..resource] = nil
		data.raw["map-gen-presets"].default["death-world-marathon"].basic_settings.autoplace_controls["infinite-"..resource] = nil
		data.raw["map-gen-presets"].default["rail-world"].basic_settings.autoplace_controls["infinite-"..resource] = nil
		data.raw["map-gen-presets"].default["ribbon-world"].basic_settings.autoplace_controls["infinite-"..resource] = nil
		data.raw["map-gen-presets"].default["island"].basic_settings.autoplace_controls["infinite-"..resource] = nil
	end
	for r, subdir in pairs(store) do
		for r, input in pairs(subdir) do
			if input == resource then
				input.inactive = true
			end
		end
	end
	update_resource()
end




---------------------------------------------------


-- ressource 
local function resource(ore)
	if coverage == nil then coverage = 0.02 end
	if path_graphics == nil then path_graphics = "__base__/graphics/" end
  
	return
	{
	  type = "resource",
	  name = ore.resource_parameters.name,
	  icon = ore.path_graphics .. "icons/" .. ore.resource_parameters.name .. ".png",
	  icon_size = 64,
	  icon_mipmaps = 4,
	  flags = {"placeable-neutral"},
	  order="a-b-".. ore.resource_parameters.order,
	  tree_removal_probability = 0.8,
	  tree_removal_max_distance = 32 * 32,
	  minable =
	  {
		mining_particle = ore.resource_parameters.name .. "-particle",
		mining_time = ore.resource_parameters.mining_time,
		result = ore.resource_parameters.name
	  },
	  walking_sound = ore.resource_parameters.walking_sound,
	  collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
	  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	  autoplace = resource_autoplace.resource_autoplace_settings
	  {
		name = ore.resource_parameters.name,
		order = ore.resource_parameters.order,
		base_density = ore.autoplace_parameters.base_density,
		has_starting_area_placement = true,
		regular_rq_factor_multiplier = ore.autoplace_parameters.regular_rq_factor_multiplier,
		starting_rq_factor_multiplier = ore.autoplace_parameters.starting_rq_factor_multiplier,
		candidate_spot_count = ore.autoplace_parameters.candidate_spot_count
	  },
	  stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
	  stages = {
		sheet =
		{
		  filename = ore.path_graphics .. "entity/" .. ore.resource_parameters.name .. "/" .. ore.resource_parameters.name .. ".png",
		  priority = "extra-high",
		  size = 64,
		  frame_count = 8,
		  variation_count = 8,
		  hr_version =
		  {
			filename = ore.path_graphics .. "entity/" .. ore.resource_parameters.name .. "/hr-" .. ore.resource_parameters.name .. ".png",
			priority = "extra-high",
			size = 128,
			frame_count = 8,
			variation_count = 8,
			scale = 0.5
		  }
		}
	  },
	  map_color = ore.resource_parameters.map_color,
	  mining_visualisation_tint = ore.resource_parameters.mining_visualisation_tint
	}
  end

---------------------------------------------------


--active coal
local function active_coal()
	resource_autoplace.initialize_patch_set("coal", true)
	local autoplace_control = ores["coal"].autoplace_control
	local coal = resource(ores["coal"])
	data:extend({autoplace_control,coal})
end

--active stone
local function active_stone()
	resource_autoplace.initialize_patch_set("stone", true)
	local autoplace_control = ores["stone"].autoplace_control
	local stone = resource(ores["stone"])
	data:extend({autoplace_control,stone})
end


--active iron-ore
local function active_iron()
	resource_autoplace.initialize_patch_set("iron-ore", true)
	local autoplace_control = ores["iron-ore"].autoplace_control
	local iron = resource(ores["iron-ore"])
	data:extend({autoplace_control,iron})
end

--active copper-ore
local function active_copper()
	resource_autoplace.initialize_patch_set("copper-ore", true)
	local autoplace_control = ores["copper-ore"].autoplace_control
	local copper = resource(ores["copper-ore"])
	data:extend({autoplace_control,copper})
end

--active copper-ore
local function active_uranium()
	resource_autoplace.initialize_patch_set("uranium-ore", false)
	local autoplace_control = ores["uranium-ore"].autoplace_control
	local uranium = ores["uranium-ore"].resource
	data:extend({autoplace_control,uranium})
end

--active crude-oil
local function active_crudeOil()
	resource_autoplace.initialize_patch_set("crude-oil", false)
	local autoplace_control = ores["uranium-ore"].autoplace_control
	local crudeOil = ores["uranium-ore"].resource
	data:extend({autoplace_control,crudeOil})
end

-- active silica-sand
local function active_sand()
	resource_autoplace.initialize_patch_set("silica-sand", true)
	local autoplace_control = ores["sand"].autoplace_control
	local sand = ores["sand"].resource
	data:extend({autoplace_control,sand})
end


---------------------------------------------------
-- Chargement des fonctions

ritnlib.ore = {
	resource = {
		remove = remove_resource,
		update = update_resource,
	},
	remove = remove_resource,
	active = {
		coal = active_coal,
		stone = active_stone,
		sand = active_sand,
		crudeOil = active_crudeOil,
		copper = active_copper,
		iron = active_iron,
		uranium = active_uranium,
	},
}
  
return ritnlib.ore