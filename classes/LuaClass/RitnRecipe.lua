-- RitnRecipe
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------







----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnRecipe = class.newclass(function(base, LuaRecipe)
    base.object_name = "RitnRecipe"
    if LuaRecipe == nil then return end
    if LuaRecipe.valid == false then return end
    if LuaRecipe.object_name ~= "LuaRecipe" then return end
    --------------------------------------------------
    base.recipe = LuaRecipe
    base.prototype = LuaRecipe.prototype
    --------------------------------------------------
end)


----------------------------------------------------------------

-- GET VALUE Prototype
function RitnRecipe:getProperties(propertie) 
    return self.prototype[propertie]
end

-- GET VALUE
function RitnRecipe:get(propertie) 
    return self.recipe[propertie]
end


----------------------------------------------------------------

-- SET ENABLED
function RitnRecipe:setEnabled(value) 
    if self.recipe == nil then return self end
    if value == nil then return self end
    if type(value) ~= 'boolean' then return self end

    self.recipe.enabled = value

    return self
end


return RitnRecipe