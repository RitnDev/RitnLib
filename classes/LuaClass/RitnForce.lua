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
    --------------------------------------------------
end)
----------------------------------------------------------------



function RitnForce:getRecipe(recipe_name)
    if self.force.recipes[recipe_name] then 
        return RitnRecipe(self.force.recipes[recipe_name])
    end
    error(recipe_name .. " : recipe not exist !")
end


function RitnForce:getTechnology(tech_name)
    if self.force.technologies[tech_name] then 
        return RitnTechnology(self.force.technologies[tech_name])
    end
    error(tech_name .. " : technology not exist !")
end


return RitnForce