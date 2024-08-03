-- RitnLibTechnology
----------------------------------------------------------------
local util = require(ritnlib.defines.other)


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLibTechnology = ritnlib.classFactory.newclass(function(self, LuaTechnology)
    if util.type(LuaTechnology) ~= "LuaTechnology" then log('not LuaTechnology !') return end
    if LuaTechnology.valid == false then return end
    ----
    self.object_name = "RitnLibTechnology"
    --------------------------------------------------
    self.technology = LuaTechnology
    ----
    self.name = LuaTechnology.name
    self.force = LuaTechnology.force
    ----
    self.entity_type = "assembling-machine"
    --------------------------------------------------
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
function RitnLibTechnology:updateRecipe(techFinished, disableTabRecipes, setRecipe, entityType)
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
--return RitnLibTechnology