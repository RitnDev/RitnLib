-- RitnProtoOre
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local ores = require("__RitnLib__.lualib.vanilla.ores")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["resource"][<name>]` (ore patches). Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua). Provides ore-specific helpers: `:remove()` to fully purge an ore from the game (resource + autoplace + map-gen presets), and the static `.active(...)` helper to register vanilla-template ores from [`lualib/vanilla/ores.lua`](../../lualib/vanilla/ores.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["resource"][<name>]` (gisements de minerai). Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua). Fournit des helpers spécifiques aux minerais : `:remove()` pour purger complètement un minerai du jeu (resource + autoplace + map-gen presets), et le helper static `.active(...)` pour enregistrer des minerais vanilla-template depuis [`lualib/vanilla/ores.lua`](../../lualib/vanilla/ores.lua).
---@class RitnProtoOre : RitnPrototype
---@field object_name "RitnProtoOre"
---@field lua_prototype table?              Direct reference to `data.raw["resource"][name]` (not the deepcopy)
---@operator call(string): RitnProtoOre
---@type RitnProtoOre
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
end) --[[@as RitnProtoOre]]



-- Retire un minerai des map-gen-presets et du map_gen_settings de chaque planète
local function remove_from_map_gen(name)
    for _, map_preset in pairs(data.raw["map-gen-presets"].default) do
        if type(map_preset) == "table" and map_preset.basic_settings and map_preset.basic_settings.autoplace_controls then
            map_preset.basic_settings.autoplace_controls[name] = nil
        end
    end

    for _, planet in pairs(data.raw.planet or {}) do
        local map_gen = planet.map_gen_settings
        if map_gen then
            if map_gen.autoplace_controls then
                map_gen.autoplace_controls[name] = nil
            end
            local entity = map_gen.autoplace_settings and map_gen.autoplace_settings.entity
            if entity and entity.settings then
                entity.settings[name] = nil
            end
        end
    end
end


-- Ajoute un minerai au map_gen_settings des planètes données
local function add_to_planets(control_name, resource_name, planets)
    for _, planet_name in pairs(planets) do
        local planet = data.raw.planet and data.raw.planet[planet_name]
        local map_gen = planet and planet.map_gen_settings
        if map_gen then
            map_gen.autoplace_controls = map_gen.autoplace_controls or {}
            map_gen.autoplace_controls[control_name] = map_gen.autoplace_controls[control_name] or {}

            map_gen.autoplace_settings = map_gen.autoplace_settings or {}
            map_gen.autoplace_settings.entity = map_gen.autoplace_settings.entity or {}
            map_gen.autoplace_settings.entity.settings = map_gen.autoplace_settings.entity.settings or {}
            map_gen.autoplace_settings.entity.settings[resource_name] =
                map_gen.autoplace_settings.entity.settings[resource_name] or {}
        end
    end
end


--REMOVE ORE

---**EN**
---
---Description: Full ore purge. Removes the resource prototype, the autoplace-control, the entry in every map-gen-preset's `autoplace_controls` and in every planet's `map_gen_settings` (`autoplace_controls` + `autoplace_settings.entity.settings`, Factorio 2.0+), and also removes the optional `"infinite-<name>"` companion if it exists.
---
---──────────────────────────────
---
---**FR**
---
---Description: Suppression complète du minerai. Retire le prototype resource, l'autoplace-control, l'entrée dans `autoplace_controls` de chaque map-gen-preset et dans le `map_gen_settings` de chaque planète (`autoplace_controls` + `autoplace_settings.entity.settings`, Factorio 2.0+), et retire aussi le compagnon optionnel `"infinite-<name>"` s'il existe.
---@return RitnProtoOre self  Chainable
function RitnProtoOre:remove()
    if self.prototype == nil then return self end

    data.raw.resource[self.name] = nil
    data.raw["autoplace-control"][self.name] = nil
    remove_from_map_gen(self.name)

    local infinite = "infinite-" .. self.name
    if data.raw.resource[infinite] then
        data.raw.resource[infinite] = nil
        data.raw["autoplace-control"][infinite] = nil
        remove_from_map_gen(infinite)
    end

    return self
end


-- ressource
local function make_resource(ore)
    if coverage == nil then coverage = 0.02 end
    if path_graphics == nil then path_graphics = "__base__/graphics/" end

    return
    {
        type = "resource",
        name = ore.resource_parameters.name,
        icon = ore.path_graphics .. "icons/" .. ore.resource_parameters.name .. ".png",
        icon_size = 64,
        icon_mipmaps = 4,
        flags = { "placeable-neutral" },
        order = "a-b-" .. ore.resource_parameters.order,
        tree_removal_probability = 0.8,
        tree_removal_max_distance = 32 * 32,
        minable =
        {
            mining_particle = ore.resource_parameters.name .. "-particle",
            mining_time = ore.resource_parameters.mining_time,
            result = ore.resource_parameters.name
        },
        walking_sound = ore.resource_parameters.walking_sound,
        collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
        selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
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
        stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
        stages = {
            sheet =
            {
                filename = ore.path_graphics ..
                "entity/" .. ore.resource_parameters.name .. "/" .. ore.resource_parameters.name .. ".png",
                priority = "extra-high",
                size = 64,
                frame_count = 8,
                variation_count = 8,
                hr_version =
                {
                    filename = ore.path_graphics ..
                    "entity/" .. ore.resource_parameters.name .. "/hr-" .. ore.resource_parameters.name .. ".png",
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



---**EN**
---
---Description: Static activator — pulls the named ore's autoplace_control (and either a custom resource payload via the local `make_resource()` helper if `bStandard == true`, or the precomputed `ores[resource].resource`) from `lualib/vanilla/ores.lua`, then registers both via `data:extend({autoplace_control, ore})`. Also initialises the patch set via `ores.resource_autoplace.initialize_patch_set(resource, bStart)`, and adds the ore to the `map_gen_settings` of the given planets (Factorio 2.0+; defaults to `{"nauvis"}`).
---
---⚠ Static method — call as `RitnProtoOre.active(...)`, not on an instance.
---
---──────────────────────────────
---
---**FR**
---
---Description: Activateur static — récupère l'autoplace_control du minerai nommé (et soit un payload resource construit via le helper local `make_resource()` si `bStandard == true`, soit le `ores[resource].resource` précalculé) depuis `lualib/vanilla/ores.lua`, puis enregistre les deux via `data:extend({autoplace_control, ore})`. Initialise aussi le patch set via `ores.resource_autoplace.initialize_patch_set(resource, bStart)`, et ajoute le minerai au `map_gen_settings` des planètes données (Factorio 2.0+ ; par défaut `{"nauvis"}`).
---
---⚠ Méthode static — appeler comme `RitnProtoOre.active(...)`, pas sur une instance.
---@param resource string   Ore key in `lualib/vanilla/ores.lua` (e.g. "iron-ore", "copper-ore")
---@param bStart boolean    Whether to seed the patch set near the starting area
---@param bStandard boolean If true, build the resource payload via the local `make_resource()` template; else use `ores[resource].resource` as-is
---@param planets? string[] Planets whose `map_gen_settings` receive the ore (default `{"nauvis"}`)
function RitnProtoOre.active(resource, bStart, bStandard, planets)
    ores.resource_autoplace.initialize_patch_set(resource, bStart)
    local autoplace_control = ores[resource].autoplace_control
    local ore = {}
    if bStandard then
        ore = make_resource(ores[resource])
    else
        ore = ores[resource].resource
    end

    data:extend({ autoplace_control, ore })
    add_to_planets(autoplace_control.name, ore.name, planets or { "nauvis" })
end


return RitnProtoOre
