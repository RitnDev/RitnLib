-- RitnLibForce
----------------------------------------------------------------
local table = require(ritnlib.defines.table)
local util = require(ritnlib.defines.other)
----------------------------------------------------------------

----------------------------------------------------------------
RitnLibForce = ritnlib.classFactory.newclass(function(self, LuaForce)
    if util.type(LuaForce) ~= "LuaForce" then log('not LuaForce !') return end
    if LuaForce.valid == false then return end
    ---
    self.object_name = "RitnLibForce"
    --------------------------------------------------
    self.force = LuaForce
    self.name = LuaForce.name
    self.index = LuaForce.index
    -----
    --[[ self.stats = {
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
    } ]]
    self.items_launched = LuaForce.items_launched
    self.rockets_launched = LuaForce.rockets_launched
    ---- CONSTANTES ----
    self.FORCE_ENEMY_NAME = "enemy"
    self.FORCE_PLAYER_NAME = "player"
    self.FORCE_NEUTRAL_NAME = "neutral"
    --------------------------------------------------
end)
----------------------------------------------------------------

-- @param name = item name : "coal" or "water"
-- @param prodType = "item" or "fluid" : default = "item"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnLibForce:getStatsProduction(name, prodType, output) 
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
function RitnLibForce:getStatsProductionItem(name, output) 
    return self:getStatsProduction(name, "item", output)
end


-- @param name = item name : "water"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnLibForce:getStatsProductionFluid(name, output) 
    return self:getStatsProduction(name, "fluid", output)
end


-- @param name = item name : "coal" or "water"
-- @param countType = "kill" or "build" : default = "kill"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnLibForce:getStatsCount(name, countType, output) 
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
function RitnLibForce:getStatsCountKill(name, output) 
    return self:getStatsCount(name, "kill", output) 
end

-- @param name = item name : "coal" or "water"
-- @param countType = "kill" or "build" : default = "kill"
-- @param output (boolean) : select output_counts, by default = false -> input_counts
function RitnLibForce:getStatsCountBuild(name, output) 
    return self:getStatsCount(name, "build", output) 
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

function RitnLibForce:setHiddenSurface(surfaceIdentification, value)
    local default = true
    if type(value) == "boolean" then 
        default = value
    end
    self.force.set_surface_hidden(surfaceIdentification, default)
    return self
end

-- Récupération d'une recette par son nom
-- @return RitnRecipe
function RitnLibForce:getRecipe(recipe_name)
    if self.force.recipes[recipe_name] then 
        return RitnLibRecipe(self.force.recipes[recipe_name])
    end
    error(recipe_name .. " : recipe not exist !")
end


-- Récupération d'une technologie par son nom
-- @return RitnTechnology
function RitnLibForce:getTechnology(tech_name)
    if self.force.technologies[tech_name] then 
        return RitnLibTechnology(self.force.technologies[tech_name])
    end
    error(tech_name .. " : technology not exist !")
end


function RitnLibForce:countPlayers()
    return #self.force.players
end


function RitnLibForce:getChartTag(tag_number, surface_name, position) 
    local area = {
        {position.x, position.y},
        {position.x, position.y},
    }
    local tabTag = game.forces[self.name].find_chart_tags(surface_name, area)

    local tag = nil 

    if table.length(tabTag) > 0 then 
        log("> chart_tag found: ".. tostring(table.length(tabTag)))

        local index = table.index(tabTag, "tag_number", tag_number)

        if index > 0 then 
            tag = tabTag[index]
        end
    else 
        log("> chart_tag not find !")
    end

    return tag
end
