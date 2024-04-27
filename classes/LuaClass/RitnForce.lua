-- RitnForce
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnRecipe = require(ritnlib.defines.class.luaClass.recipe)
local RitnTechnology = require(ritnlib.defines.class.luaClass.tech)
----------------------------------------------------------------

----------------------------------------------------------------
local RitnForce = class.newclass(function(base, LuaForce)
    base.object_name = "RitnForce"
    if LuaForce == nil then return end
    if LuaForce.valid == false then return end
    if LuaForce.object_name ~= "LuaForce" then return end
    --------------------------------------------------
    base.force = LuaForce
    base.name = LuaForce.name
    base.index = LuaForce.index
    -----
    base.stats = {
        production = {
            item = {
                input = LuaForce.item_production_statistics.input_counts,
                output= LuaForce.item_production_statistics.output_counts,
            },
            fluid = {
                input = LuaForce.fluid_production_statistics.input_counts,
                output= LuaForce.fluid_production_statistics.output_counts,
            },
        },
        count = {
            kill = {
                input = LuaForce.kill_count_statistics.input_counts,
                output= LuaForce.kill_count_statistics.output_counts,
            },
            build = {
                input = LuaForce.entity_build_count_statistics.input_counts,
                output= LuaForce.entity_build_count_statistics.output_counts,
            },
        }
    }
    base.items_launched = LuaForce.items_launched
    base.rockets_launched = LuaForce.rockets_launched
    ---- CONSTANTES ----
    base.FORCE_ENEMY_NAME = "enemy"
    base.FORCE_PLAYER_NAME = "player"
    base.FORCE_NEUTRAL_NAME = "neutral"
    --------------------------------------------------
end)
----------------------------------------------------------------

-- @param name = item name : "coal" or "water"
-- @param prodType = "item" or "fluid" : default = "item"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnForce:getStatsProduction(name, prodType, output) 
    local target = "input"
    local prod = "item"
    if output then target = "output" end
    if prodType == "fluid" then prod = "fluid" end

    if name == nil then return nil end
    if type(name) ~= "string" then return nil end

    if self.stats.production[prod][target][name] == nil then 
        return 0
    else 
        return self.stats.production[prod][target][name] 
    end

end


-- @param name = item name : "coal"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnForce:getStatsProductionItem(name, output) 
    return self:getStatsProduction(name, "item", output)
end


-- @param name = item name : "water"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnForce:getStatsProductionFluid(name, output) 
   return self:getStatsProduction(name, "fluid", output)
end


-- @param name = item name : "coal" or "water"
-- @param countType = "kill" or "build" : default = "kill"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnForce:getStatsCount(name, countType, output) 
    local target = "input"
    local count = "kill"
    if output then target = "output" end
    if countType == "build" then count = "build" end

    if name == nil then return nil end
    if type(name) ~= "string" then return nil end

    if self.stats.count[count][target][name] == nil then 
        return 0
    else 
        return self.stats.count[count][target][name] 
    end
end


-- @param name = item name : "coal" or "water"
-- @param countType = "kill" or "build" : default = "kill"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnForce:getStatsCountKill(name, output) 
    return self:getStatsCount(name, "kill", output) 
end

-- @param name = item name : "coal" or "water"
-- @param countType = "kill" or "build" : default = "kill"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnForce:getStatsCountBuild(name, output) 
    return self:getStatsCount(name, "build", output) 
end


-- Récupération d'une recette par son nom
-- @return RitnRecipe
function RitnForce:getRecipe(recipe_name)
    if self.force.recipes[recipe_name] then 
        return RitnRecipe(self.force.recipes[recipe_name])
    end
    error(recipe_name .. " : recipe not exist !")
end


-- Récupération d'une technologie par son nom
-- @return RitnTechnology
function RitnForce:getTechnology(tech_name)
    if self.force.technologies[tech_name] then 
        return RitnTechnology(self.force.technologies[tech_name])
    end
    error(tech_name .. " : technology not exist !")
end


function RitnForce:countPlayers()
    return #self.force.players
end


----------------------------------------------------------------
return RitnForce