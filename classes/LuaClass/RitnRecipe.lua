-- RitnLibRecipe
----------------------------------------------------------------


----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------



----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLibRecipe = ritnlib.classFactory.newclass(function(self, LuaRecipe)
    self.object_name = "RitnLibRecipe"
    if LuaRecipe == nil then return end
    if LuaRecipe.valid == false then return end
    if LuaRecipe.object_name ~= "LuaRecipe" then return end
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