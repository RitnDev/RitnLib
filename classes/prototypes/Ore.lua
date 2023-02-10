-- RitnProtoOre
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local ores = require("__RitnLib__.lualib.vanilla.ores")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------


local RitnProtoOre = class.newclass(RitnProtoBase, function(base, resource)
    -- prototype init
    if resource == nil then return end
    RitnProtoBase.init(base, resource, "resource")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoOre"
    base.lua_prototype = data.raw[base.type][base.name]
    ----
    if base.lua_prototype == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
	--------------------------------------------------
end)



--REMOVE ORE
function RitnProtoOre:remove()
    if self.prototype == nil then return self end

    data.raw.resource[self.name] = nil
    data.raw["autoplace-control"][self.name] = nil

	for _, map_preset in pairs(data.raw["map-gen-presets"].default) do 
		if map_preset.basic_settings then 
			if map_preset.basic_settings.autoplace_controls then 
				map_preset.basic_settings.autoplace_controls[self.name] = nil
			end 
		end
	end

    if data.raw.resource["infinite-"..self.name] then
        data.raw.resource["infinite-"..self.name] = nil
		data.raw["autoplace-control"]["infinite-"..self.name] = nil

		for _, map_preset in pairs(data.raw["map-gen-presets"].default) do 
			if map_preset.basic_settings then 
				if map_preset.basic_settings.autoplace_controls then 
					map_preset.basic_settings.autoplace_controls["infinite-"..self.name] = nil
				end 
			end
		end
    end

    return self
end


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
	  autoplace = ores.resource_autoplace.resource_autoplace_settings
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



function RitnProtoOre.active(resource, bStart, bStandard)
	ores.resource_autoplace.initialize_patch_set(resource, bStart)
	local autoplace_control = ores[resource].autoplace_control
    local ore = {}
    if bStandard then 
		ore = resource(ores[resource])
    else 
		ore = ores[resource].resource 
	end
	
	data:extend({autoplace_control, ore})
end


return RitnProtoOre