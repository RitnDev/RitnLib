-- INIT
local ritnlib = {}
local store = {
	update = {},
	make = {}
}
--------------------------
local ressource_generator = require ("resource-generator")
--------------------------

--Create autoplace
local function make_resautoplace(input)
	data:extend({
		{
			type = "autoplace-control",
			name = input.name,
			richness = true,
			order="b-"..input.order,
			category = "resource",
		},
	})
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

end



--ADD RESOURCE TO CREATE OR UPDATE TO STORE
local function add_resource(action, input)
	if action == "update" and not store.update[input.name] then
		store.update[input.name] = {}
		store.update[input.name] = input
	end
	if action == "make" and not store.make[input.name] then
		store.make[input.name] = {}
		store.make[input.name] = input
	end
end



--CREATE RESOURCE FROM STORE
local function make_resource()
	for r, input in pairs(store.make) do
		if not data.raw.resource[input.name] then
			--Create Autopace for the resource
			make_resautoplace(input)
			--Set default yields according
			input.minimum = 300
			input.output_probability = 1
			--Set defaults for infinite resouces normal and maximum
			input.normal = 1500
			input.maximum = 6000
			--Set mining hardness
			if input.hardness == nil then input.hardness = 0.9 end
			--Set stages count according to resource type
			if input.type == "item" then
				if input.infinite == true then
					stages_count = {1}
				else
					stages_count = {15000, 8000, 4000, 2000, 1000, 500, 200, 80}
				end
			else
				stages_count = {0}
			end
			--Set if map grid will show
			if input.type == "item" then input.map_grid = true else input.map_grid = false end
			--Set resource category if resource yields fluids
			if not input.type == "fluid" then input.category = nil end
			--Set Boxes according to presets
			if input.type == "fluid" then
				input.highlight = true
				if input.sheet == 1 then
					input.collision_box = {{ -4.4, -4.4}, {4.4, 4.4}}
					input.selection_box = {{ -2.5, -2.5}, {2.5, 2.5}} 
				end
				if input.sheet == 2 or input.sheet == 3 then
					input.collision_box = {{ -1.4, -1.4}, {1.4, 1.4}}
					input.selection_box = {{ -0.5, -0.5}, {0.5, 0.5}}
				end
			else 
				input.highlight = false
				input.collision_box = {{ -0.1, -0.1}, {0.1, 0.1}} 
				input.selection_box = {{ -0.5, -0.5}, {0.5, 0.5}}
			end
			--Get map_color and icon from the regular resource
			data:extend({
				{
					type = "resource",
					name = input.name,
					icon = input.icon,
					icon_size = input.icon_size,
					flags = {"placeable-neutral"},
					category = input.category,
					order = input.order,
					tree_removal_probability = 0.8,
					tree_removal_max_distance = 32 * 32,
					infinite_depletion_amount = 10,
					resource_patch_search_radius = 12,
					highlight = input.highlight,
					infinite = input.infinite,
					minimum = input.minimum,
					normal = input.normal,
					maximum = input.maximum,
					minable =
					{
						hardness = input.hardness,
						mining_particle = input.particle,
						mining_time = input.mining_time,
						fluid_amount = input.fluid_amount,
						required_fluid = input.requiered_fluid,
						results = {
							{
								type = input.type,
								name = input.output_name,
								amount_min = input.output_min,
								amount_max = input.output_max,
								probability = input.output_probability,
							}
						},
					},
					collision_box = input.collision_box,
					selection_box = input.selection_box,
					stage_counts = stages_count,
					stages = input.stages,
					map_color = input.map_color,
					map_grid = input.map_grid
				}
			})
		end
		if input.get then
			input.alt_name = input.get
		else
			input.alt_name = input.name
		end	
		
		resource_generator.setup_resource_autoplace_data(input.name,
			{
			name = input.alt_name,
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
	end
end


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

--CHECK RESOURCE_INDEX FOR ALL RESOURCES
--DEBUG FUNCTION RUN IN UPDATES
local function index_check()
	--SET TABLE TO RETURN
	local test = {}
	--GET ALL RESOURCE INDEX' SET 
	for r, subdir in pairs(store) do
		for r, input in pairs(subdir) do
			if not input.inactive then
				test[input.name] = input.autoplace.resource_index
			end
		end
	end
	--RETURN TABLE
	log(serpent.block(test))
	--RETURN OTHER IMPORTANT VALUES
	log(serpent.block("regular_resource_count = "..regular_resource_count))
	log(serpent.block("starting_resource_count = "..starting_resource_count))
	log(serpent.block("starting_size = "..starting_size))
	log(serpent.block("region_size = "..region_size))
end



---------------------------------------------------
-- Chargement des fonctions

ritnlib.ore = {
	resource = {
		make = make_resource,
		remove = remove_resource,
		add = add_resource,
		autoplace = make_resautoplace,
		update = update_resource
	},
	update = update_autoplace,
	index = {
		set = set_index,
		check = index_check
	}
}
  
return ritnlib.ore