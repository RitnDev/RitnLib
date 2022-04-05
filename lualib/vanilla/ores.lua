--INITIALIZE
-----------------------------------------------------------------
local resource_autoplace = require("resource-autoplace")
local sounds = require ("__base__.prototypes.entity.sounds")

local function data_ore()
    return {
        autoplace_control = {},
        resource_parameters = {}, 
        autoplace_parameters = {},
        path_graphics = "__base__/graphics/",
        resource = {}
    }
end

local ores = {
    ["coal"] = data_ore(),
    ["iron-ore"] = data_ore(),
    ["copper-ore"] = data_ore(),
    ["stone"] = data_ore(),
    ["sand"] = data_ore(),
    ["crude-oil"] = data_ore(),
    ["uranium-ore"] = data_ore(),
    ["none"] = data_ore(),
}

-----------------------------------------------------------------
-- COAL
-----------------------------------------------------------------

ores["coal"].autoplace_control = {
    type = "autoplace-control",
    name = "coal",
    localised_name = {"", "[entity=coal] ", {"entity-name.coal"}},
    richness = true,
    order = "b-d",
    category = "resource"
}

ores["coal"].resource_parameters = {
    name = "coal",
    order = "b",
    map_color = {0, 0, 0},
    mining_time = 1,
    walking_sound = sounds.ore,
    mining_visualisation_tint = {r = 0.465, g = 0.465, b = 0.465, a = 1.000}, -- #767676ff
}

ores["coal"].autoplace_parameters = {
    base_density = 8,
    regular_rq_factor_multiplier = 1.0,
    starting_rq_factor_multiplier = 1.1
}



-----------------------------------------------------------------
-- STONE
-----------------------------------------------------------------

ores["stone"].autoplace_control = {
    type = "autoplace-control",
    name = "stone",
    localised_name = {"", "[entity=stone] ", {"entity-name.stone"}},
    richness = true,
    order = "b-c",
    category = "resource"
}

ores["stone"].resource_parameters = {
    name = "stone",
    order = "b",
    map_color = {0.690, 0.611, 0.427},
    mining_time = 1,
    walking_sound = sounds.ore,
    mining_visualisation_tint = {r = 0.984, g = 0.883, b = 0.646, a = 1.000}, -- #fae1a4ff
}

ores["stone"].autoplace_parameters = {
    base_density = 4,
    regular_rq_factor_multiplier = 1.0,
    starting_rq_factor_multiplier = 1.1
}



-----------------------------------------------------------------
-- IRON ORE
-----------------------------------------------------------------

ores["iron-ore"].autoplace_control = {
    type = "autoplace-control",
    name = "iron-ore",
    localised_name = {"", "[entity=iron-ore] ", {"entity-name.iron-ore"}},
    richness = true,
    order = "b-a",
    category = "resource"
}

ores["iron-ore"].resource_parameters = {
    name = "iron-ore",
    order = "b",
    map_color = {0.415, 0.525, 0.580},
    mining_time = 1,
    walking_sound = sounds.ore,
    mining_visualisation_tint = {r = 0.895, g = 0.965, b = 1.000, a = 1.000}, -- #e4f6ffff
}

ores["iron-ore"].autoplace_parameters = {
    base_density = 10,
    regular_rq_factor_multiplier = 1.10,
    starting_rq_factor_multiplier = 1.5,
    candidate_spot_count = 22,
}



-----------------------------------------------------------------
-- COPPER ORE
-----------------------------------------------------------------

ores["copper-ore"].autoplace_control = {
    type = "autoplace-control",
    name = "copper-ore",
    localised_name = {"", "[entity=copper-ore] ", {"entity-name.copper-ore"}},
    richness = true,
    order = "b-b",
    category = "resource"
}

ores["copper-ore"].resource_parameters = {
    name = "copper-ore",
    order = "b",
    map_color = {0.803, 0.388, 0.215},
    mining_time = 1,
    walking_sound = sounds.ore,
    mining_visualisation_tint = {r = 1.000, g = 0.675, b = 0.541, a = 1.000}, -- #ffac89ff
}

ores["copper-ore"].autoplace_parameters = {
    base_density = 8,
    regular_rq_factor_multiplier = 1.10,
    starting_rq_factor_multiplier = 1.2,
    candidate_spot_count = 22,
}



-----------------------------------------------------------------
-- URANIUM ORE
-----------------------------------------------------------------

ores["uranium-ore"].autoplace_control = {
    type = "autoplace-control",
    name = "uranium-ore",
    localised_name = {"", "[entity=uranium-ore] ", {"entity-name.uranium-ore"}},
    richness = true,
    order = "b-e",
    category = "resource"
}

ores["uranium-ore"].resource = {
    type = "resource",
    name = "uranium-ore",
    icon = "__base__/graphics/icons/uranium-ore.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral"},
    order="a-b-e",
    tree_removal_probability = 0.7,
    tree_removal_max_distance = 32 * 32,
    walking_sound = sounds.ore,
    minable =
    {
      mining_particle = "stone-particle",
      mining_time = 2,
      result = "uranium-ore",
      fluid_amount = 10,
      required_fluid = "sulfuric-acid"
    },
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = resource_autoplace.resource_autoplace_settings
    {
      name = "uranium-ore",
      order = "c",
      base_density = 0.9,
      base_spots_per_km2 = 1.25,
      has_starting_area_placement = false,
      random_spot_size_minimum = 2,
      random_spot_size_maximum = 4,
      regular_rq_factor_multiplier = 1
    },
    stage_counts = {10000, 6330, 3670, 1930, 870, 270, 100, 50},
    stages =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/uranium-ore/uranium-ore.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 8,
        variation_count = 8,
        hr_version =
        {
          filename = "__base__/graphics/entity/uranium-ore/hr-uranium-ore.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5
        }
      }
    },
    stages_effect =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/uranium-ore/uranium-ore-glow.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 8,
        variation_count = 8,
        blend_mode = "additive",
        flags = {"light"},
        hr_version =
        {
          filename = "__base__/graphics/entity/uranium-ore/hr-uranium-ore-glow.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5,
          blend_mode = "additive",
          flags = {"light"}
        }
      }
    },
    effect_animation_period = 5,
    effect_animation_period_deviation = 1,
    effect_darkness_multiplier = 3.6,
    min_effect_alpha = 0.2,
    max_effect_alpha = 0.3,
    mining_visualisation_tint = {r = 0.814, g = 1.000, b = 0.499, a = 1.000}, -- #cfff7fff
    map_color = {0, 0.7, 0}
}



-----------------------------------------------------------------
-- CRUDE OIL
-----------------------------------------------------------------

ores["crude-oil"].autoplace_control = {
    type = "autoplace-control",
    name = "crude-oil",
    localised_name = {"", "[entity=crude-oil] ", {"entity-name.crude-oil"}},
    richness = true,
    order = "b-f",
    category = "resource"
}

ores["crude-oil"].resource = {
    type = "resource",
    name = "crude-oil",
    icon = "__base__/graphics/icons/crude-oil-resource.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-neutral"},
    category = "basic-fluid",
    subgroup = "raw-resource",
    order="a-b-a",
    infinite = true,
    highlight = true,
    minimum = 60000,
    normal = 300000,
    infinite_depletion_amount = 10,
    resource_patch_search_radius = 12,
    tree_removal_probability = 0.7,
    tree_removal_max_distance = 32 * 32,
    minable =
    {
      mining_time = 1,
      results =
      {
        {
          type = "fluid",
          name = "crude-oil",
          amount_min = 10,
          amount_max = 10,
          probability = 1
        }
      }
    },
    walking_sound = sounds.oil,
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = resource_autoplace.resource_autoplace_settings
    {
      name = "crude-oil",
      order = "c", -- Other resources are "b"; oil won't get placed if something else is already there.
      base_density = 8.2,
      base_spots_per_km2 = 1.8,
      random_probability = 1/48,
      random_spot_size_minimum = 1,
      random_spot_size_maximum = 1, -- don't randomize spot size
      additional_richness = 220000, -- this increases the total everywhere, so base_density needs to be decreased to compensate
      has_starting_area_placement = false,
      regular_rq_factor_multiplier = 1
    },
    stage_counts = {0},
    stages =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/crude-oil/crude-oil.png",
        priority = "extra-high",
        width = 74,
        height = 60,
        frame_count = 4,
        variation_count = 1,
        shift = util.by_pixel(0, -2),
        hr_version =
        {
          filename = "__base__/graphics/entity/crude-oil/hr-crude-oil.png",
          priority = "extra-high",
          width = 148,
          height = 120,
          frame_count = 4,
          variation_count = 1,
          shift = util.by_pixel(0, -2),
          scale = 0.5
        }
      }
    },
    map_color = {0.78, 0.2, 0.77},
    map_grid = false
}




-----------------------------------------------------------------
-- SILICA SAND
-----------------------------------------------------------------


--sound for sand :
local sand_sounds =
{
  {
    filename = "__base__/sound/walking/sand-01.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/sand-02.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/sand-03.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/sand-04.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/sand-05.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/sand-06.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/sand-07.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/sand-08.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/sand-09.ogg",
    volume = 0.8
  }
}

local path_graphics = "__RitnGlass__/graphics/"
local resource_parameters = {
    name = "silica-sand",
    order="a-b-r",
    mining_time = 1,
    walking_sound = sand_sounds,
    map_color = {r=0.995, g=0.948, b=0.855},
    mining_visualisation_tint = {r = 0.838, g = 0.780, b = 0.653, a = 1.000}, -- #dd6c7a6ff
}
local autoplace_parameters = {
    base_density = 8,
    regular_rq_factor_multiplier = 1.10,
    starting_rq_factor_multiplier = 1.2,
    candidate_spot_count = 22, -- To match 0.17.50 placement
}

ores["sand"].path_graphics = path_graphics

ores["sand"].autoplace_control = {
    type = "autoplace-control",
    name = "silica-sand",
    localised_name = {"", "[entity=silica-sand] ", {"entity-name.silica-sand"}},
    richness = true,
    order = "a-a",
    category = "resource",
  }


ores["sand"].resource = {
    type = "resource",
    name = resource_parameters.name,
    icon = path_graphics .. "icons/" .. resource_parameters.name .. ".png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral"},
    order="a-b-"..resource_parameters.order,
    tree_removal_probability = 0.8,
    tree_removal_max_distance = 32 * 32,
    minable =
    {
        hardness = 1,
        mining_particle = "stone-particle",
        mining_time = 1,
        result = "item-silica-sand",
        fluid_amount = 5,
        required_fluid = "water"
    },
    walking_sound = resource_parameters.walking_sound,
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace =resource_autoplace.resource_autoplace_settings
    {
      name = resource_parameters.name,
      order = resource_parameters.order,
      base_density = autoplace_parameters.base_density,
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier,
      starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier,
      candidate_spot_count = autoplace_parameters.candidate_spot_count
    },
    stage_counts = {1500},
    stages =
    {
    sheet =
    {
        filename = path_graphics .. "ores/silica-sand/ore-silica-sand-unique_new.png",
        priority = "extra-high",
        width = 54,
        height = 54,
        frame_count = 1,
        variation_count = 1
    }
    },
    map_color = resource_parameters.map_color,
    mining_visualisation_tint = resource_parameters.mining_visualisation_tint
  }

-------------------------------------------------------------------------------------------------------------------

return ores