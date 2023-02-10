-- RitnTechnology
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------






----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnTechnology = class.newclass(function(base, LuaTechnology)
    base.object_name = "RitnTechnology"
    if LuaTechnology == nil then return end
    if LuaTechnology.valid == false then return end
    if LuaTechnology.object_name ~= "LuaTechnology" then return end
    --------------------------------------------------
    base.technology = LuaTechnology
    ----
    base.name = LuaTechnology.name
    ----
    base.entity_type = "assembling-machine"
    ----
    return self
end)

----------------------------------------------------------------

------
-- updateRecipe
------
-- @param techFinished string - research name finished
-- @param disableTabRecipes teble[string] - list of disabled recipes
-- @param setRecipe string - recipe name to replace
-- @optional entityType string - Entity type (default = "assembling-machine")
------
function RitnTechnology:updateRecipe(techFinished, disableTabRecipes, setRecipe, entityType)
    if self.name ~= techFinished then return self end
    if entityType ~= nil then self.entity_type = entityType end


    for _, disableRecipe in pairs(disableTabRecipes) do
        self.technology.force.recipes[disableRecipe].enabled = false
    end

    -- Actualise la recette dans toutes les entités sur toutes les surfaces 
    for _, surface in pairs(game.surfaces) do 
        for _, machine in pairs(surface.find_entities_filtered{type=self.entity_type, force=self.technology.force.name}) do
            if machine.get_recipe() ~= nil then
                for _, disableRecipe in pairs(disableTabRecipes) do
                    if machine.get_recipe().name == disableRecipe then
                        machine.set_recipe(setRecipe)
                    end
                end
            end
        end
    end

    return self
end



----------------------------------------------------------------
return RitnTechnology