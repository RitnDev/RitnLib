-- RitnProtoRecipe
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
local RitnProtoItem = require("__RitnLib__.classes.prototypes.Item")
local RitnIngredient = require("__RitnLib__.classes.RitnClass.RitnIngredient")
local constants = require("__RitnLib__.core.constants")
----------------------------------------------------------------


local RitnProtoRecipe = class.newclass(RitnProtoBase, function(base, recipe_name)
    -- prototype init
    if recipe_name == nil then return end
    RitnProtoBase.init(base, recipe_name, 'recipe')
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoRecipe"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
    -- constants
    base.listTint = constants.listTint
    base.tint = constants.tint
    --------------------------------------------------
end)



--DISABLE RECIPE
function RitnProtoRecipe:disable() 
    if self.prototype == nil then return self end
    self.prototype.enabled = false
    self.prototype.hidden = true
    
    RitnProtoItem(self.prototype.name):changePrototype("flags", {"hidden"})

    self:update()
    return self
end


--DISABLE RECIPE
function RitnProtoRecipe:setEnabled(value) 
	if value == nil then return self end
    if type(value) ~= 'boolean' then return self end
    if self.prototype == nil then return self end
    log('RitnProtoRecipe:setEnabled()')
    
    if self.prototype.enabled ~= nil then
        self.prototype.enabled = value
        log('-> self.prototype.enabled')
    end

    if self.prototype.normal ~= nil then
        self.prototype.normal.enabled = value
        log('-> self.prototype.normal.enabled')
    end

    if self.prototype.expensive ~= nil then
        self.prototype.expensive.enabled = value
        log('-> self.prototype.expensive.enabled')
    end

    self:update()
    return self
end



--REMOVE INGREDIENT
function RitnProtoRecipe:removeIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        RitnIngredient(ingredient):remove(self.prototype.expensive.ingredients)
    end
    if self.prototype.normal then
        RitnIngredient(ingredient):remove(self.prototype.normal.ingredients)
    end
    if self.prototype.ingredients then
        RitnIngredient(ingredient):remove(self.prototype.ingredients)
    end

    self:update()
    return self
end

--REMOVE INGREDIENT
function RitnProtoRecipe:removeAllIngredient()
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        self.prototype.expensive.ingredients = {}
    end
    if self.prototype.normal then
        self.prototype.normal.ingredients = {}
    end
    if self.prototype.ingredients then
        self.prototype.ingredients = {}
    end

    self:update()
    return self
end


--ADD NEW INGREDIENT (ignores if exists)
function RitnProtoRecipe:addNewIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then 
        RitnIngredient(ingredient):addNew(self.prototype.expensive.ingredients)
    end
    if self.prototype.normal then 
        RitnIngredient(ingredient):addNew(self.prototype.normal.ingredients)
    end
    if self.prototype.ingredients then 
        RitnIngredient(ingredient):addNew(self.prototype.ingredients)
    end


    self:update()
    return self
end


--ADD INGREDIENT (increments amount if exists)
function RitnProtoRecipe:addIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then 
        RitnIngredient(ingredient):add(self.prototype.expensive.ingredients)
    end
    if self.prototype.normal then  
        RitnIngredient(ingredient):add(self.prototype.normal.ingredients)
    end
    if self.prototype.ingredients then   
        RitnIngredient(ingredient):add(self.prototype.ingredients)
    end

    self:update()
    return self
end


 --SET INGREDIENT
function RitnProtoRecipe:setIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then 
        RitnIngredient(ingredient):set(self.prototype.expensive.ingredients)
    end
    if self.prototype.normal then   
        RitnIngredient(ingredient):set(self.prototype.normal.ingredients)
    end
    if self.prototype.ingredients then      
        RitnIngredient(ingredient):set(self.prototype.ingredients)
    end


    self:update()
    return self
end


function RitnProtoRecipe:changeTint(parameter, tint) 
    if self.prototype == nil then return self end
    if self.prototype[parameter] == nil then return self end
    if type(tint) ~= "string" then return self end
    if self.listTint[tint] == nil then return self end

    self.prototype[parameter] = self.tint[tint]
    self:update()
    return self
end


function RitnProtoRecipe:updatePackTint()
    if self.prototype == nil then return self end
    local pack = self.prototype.name
    local id = string.len(pack) - 11

    if string.sub(pack, id) ~= "science-pack" then return self end

    for _,tint in pairs(self.listTint) do
        if pack:sub(1, #tint) == tint then 
            self:changeTint("crafting_machine_tint", tint)
        end
    end
    
    return self
end


-- CHANGE SUBGROUP
function RitnProtoRecipe:changeSubgroup(subgroup, order) 
    if self.prototype == nil then return self end

    self.prototype.subgroup = subgroup
    if order ~= nil then 
        self.prototype.order = order
    end

    if RitnProtoItem(self.name).prototype then
        RitnProtoItem(self.name):changeSubgroup(subgroup, order)
    elseif self.prototype.result then
        RitnProtoItem(self.prototype.result):changeSubgroup(subgroup, order)
    end

    self:update()
    return self
end



return RitnProtoRecipe