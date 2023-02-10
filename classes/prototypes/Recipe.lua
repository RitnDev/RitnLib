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
    
    if self.prototype.enabled ~= nil then
        self.prototype.enabled = value
        log("RitnProtoRecipe:setEnabled -> enabled")
    end

    if self.prototype.normal ~= nil then
        self.prototype.normal.enabled = value
        log("RitnProtoRecipe:setEnabled -> normal.enabled")
    end

    if self.prototype.expensive ~= nil then
        self.prototype.expensive.enabled = value
        log("RitnProtoRecipe:setEnabled -> expensive.enabled")
    end

    self:update()
    return self
end


--DISABLE RECIPE
function RitnProtoRecipe:setHidden(value, crafting, stats) 
    log("RitnProtoRecipe:setHidden -> pass !")
	if value == nil then return self end
    if type(value) ~= 'boolean' then return self end
    if self.prototype == nil then return self end
    log("RitnProtoRecipe:setHidden -> prototype ok !")

    local hidden_ok = false
    
    if self.prototype.hidden ~= nil then
        self.prototype.hidden = value
        log("RitnProtoRecipe:setHidden -> hidden")
        hidden_ok = true
        if crafting ~= nil then 
            self.prototype.hide_from_player_crafting = value
        end
        if stats ~= nil then
            self.prototype.hide_from_player_stats = value
        end
    end

    if self.prototype.normal ~= nil then
        self.prototype.normal.hidden = value
        log("RitnProtoRecipe:setHidden -> normal.hidden")
        hidden_ok = true
        if crafting ~= nil then 
            self.prototype.normal.hide_from_player_crafting = value
        end
        if stats ~= nil then
            self.prototype.normal.hide_from_player_stats = value
        end
    end

    if self.prototype.expensive ~= nil then
        self.prototype.expensive.hidden = value
        hidden_ok = true
        log("RitnProtoRecipe:setHidden -> expensive.hidden")
        if crafting ~= nil then 
            self.prototype.expensive.hide_from_player_crafting = value
        end
        if stats ~= nil then
            self.prototype.expensive.hide_from_player_stats = value
        end
    end

    if hidden_ok == false then 
        self.prototype.hidden = value
        log("RitnProtoRecipe:setHidden -> hidden")
        if crafting ~= nil then 
            self.prototype.hide_from_player_crafting = value
        end
        if stats ~= nil then
            self.prototype.hide_from_player_stats = value
        end
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


function RitnProtoRecipe:getIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then 
        for _, ingredient1 in pairs(self.prototype.expensive.ingredients) do 
            if RitnIngredient(ingredient1).name == ingredient then 
                return RitnIngredient(ingredient1).item
            end
        end
    end
    if self.prototype.normal then   
        for _, ingredient1 in pairs(self.prototype.expensive.normal) do 
            if RitnIngredient(ingredient1).name == ingredient then 
                return RitnIngredient(ingredient1).item
            end
        end
    end
    if self.prototype.ingredients then      
        for _, ingredient1 in pairs(self.prototype.ingredients) do 
            if RitnIngredient(ingredient1).name == ingredient then 
                return RitnIngredient(ingredient1).item
            end
        end
    end

    return nil
end


 --INGREDIENT EXISTE (return boolean)
 function RitnProtoRecipe:ingredientExiste(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then 
        for _, ingredient1 in pairs(self.prototype.expensive.ingredients) do 
            if RitnIngredient(ingredient1).name == ingredient then 
                return true
            end
        end
    end
    if self.prototype.normal then   
        for _, ingredient1 in pairs(self.prototype.expensive.normal) do 
            if RitnIngredient(ingredient1).name == ingredient then 
                return true
            end
        end
    end
    if self.prototype.ingredients then      
        for _, ingredient1 in pairs(self.prototype.ingredients) do 
            if RitnIngredient(ingredient1).name == ingredient then 
                return true
            end
        end
    end

    return false
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