-- RitnLibRecipe
----------------------------------------------------------------
local util = require(ritnlib.defines.other)


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLibRecipe = ritnlib.classFactory.newclass(function(self, LuaRecipe)
    if util.type(LuaRecipe) ~= "LuaRecipe" then log('not LuaRecipe !') return end
    if LuaRecipe.valid == false then return end
    ----
    self.object_name = "RitnLibRecipe"
    --------------------------------------------------
    self.recipe = LuaRecipe
    self.prototype = LuaRecipe.prototype
    --------------------------------------------------
end)


----------------------------------------------------------------

-- GET VALUE Prototype
function RitnLibRecipe:getProperties(propertie) 
    return self.prototype[propertie]
end

-- GET VALUE
function RitnLibRecipe:get(propertie) 
    return self.recipe[propertie]
end


----------------------------------------------------------------

-- SET ENABLED
function RitnLibRecipe:setEnabled(value) 
    if self.recipe == nil then return self end
    if value == nil then return self end
    if type(value) ~= 'boolean' then return self end

    self.recipe.enabled = value

    return self
end


--return RitnLibRecipe