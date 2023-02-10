-- RitnProtoTech
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
local RitnProtoRecipe = require("__RitnLib__.classes.prototypes.Recipe")
----------------------------------------------------------------


local RitnProtoTech = class.newclass(RitnProtoBase, function(base, tech_name)
    -- prototype init
    if tech_name == nil then return end
    RitnProtoBase.init(base, tech_name, 'technology')
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoTech"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
    -- object parameters
    base.delete_prerequisite = false
    base.addit = true
    base.doit = false
    base.disable_recipe = false
    base.amount_pack = 1
end)



--SET COUNT SCIENCE PACK
function RitnProtoTech:setCount(count)
    if self.prototype == nil then return self end

    if type(count) == "number" then 
        self.prototype.unit.count = count
    end

    self:update()
    return self
end



--SET TIME SCIENCE PACK
function RitnProtoTech:setTime(time)
    if self.prototype == nil then return self end

    if type(time) == "number" then 
        self.prototype.unit.time = time
    end
    
    self:update()
    return self
end



--SET INGREDIENTS SCIENCE PACK
function RitnProtoTech:setIngredients(ingredients)
    if self.prototype == nil then return self end

    if type(ingredients) == "table" then 
        self.prototype.unit.ingredients = ingredients
    end
    
    self:update()
    return self
end


--DISABLE TECHNOLOGY
function RitnProtoTech:disable(delete_prerequisites) 
    if self.prototype == nil then return self end
    self.prototype.enabled = false
	self.prototype.hidden= true

	if delete_prerequisites ~= nil then 
        self.delete_prerequisite = delete_prerequisites 
    end

	if self.delete_prerequisite then 
		for _,tech in pairs(data.raw.technology) do 
			if tech.prerequisites ~= nil then 
                for i, check in ipairs(tech.prerequisites) do
                    if check == self.prototype.name then
                        table.remove(tech.prerequisites, i)
                    end
                end
			end
		end
	end

    self:update()
    return self
end


--------------------------- RECIPE --------------------------- 
--ADD RECIPE UNLOCK
function RitnProtoTech:addRecipe(recipe_name)
    if self.prototype == nil then return self end
	if data.raw.recipe[recipe_name] then

        if self.prototype.effects == nil then
            self.prototype.effects = {}
        end

        for i, effect in pairs(self.prototype.effects) do
            if effect.type == "unlock-recipe" and effect.recipe == recipe_name then self.addit = false end
        end

	    if self.addit then 
            table.insert(self.prototype.effects, {type = "unlock-recipe", recipe = recipe_name}) 
        end
	end
    self.addit = true
    self:update()
    return self
end


--REMOVE RECIPE UNLOCK
function RitnProtoTech:removeRecipe(recipe, complete)
    if self.prototype == nil then return self end
	if complete ~= nil then self.disable_recipe = complete end

	if self.prototype.effects then
	  for i, effect in pairs(self.prototype.effects) do
		if effect.type == "unlock-recipe" and effect.recipe == recipe then
		  	table.remove(self.prototype.effects,i)

			if self.disable_recipe then 
                RitnProtoRecipe(recipe):disable()
			end
		end
	  end
	end

    self.disable_recipe = false
    self:update()
    return self
end


--------------------------- PACK --------------------------- 

--ADD SCIENCE PACK
function RitnProtoTech:addPack(pack, count)
    if self.prototype == nil then return self end
	if count ~= nil then self.amount_pack = count end

	if data.raw.tool[pack] then
	    for i, ingredient in pairs(self.prototype.unit.ingredients) do
            if ingredient[1] == pack then
                self.addit = false
                ingredient[2] = ingredient[2] + self.amount_pack
            end
            if ingredient.name == pack then
                self.addit = false
                ingredient.amount = ingredient.amount + self.amount_pack
            end
	    end
	    if self.addit then 
            table.insert(self.prototype.unit.ingredients, {pack, self.amount_pack}) 
        end
	end
    self.addit = true
    self.amount_pack = 1
    self:update()
    return self
end


--REMOVE SCIENCE PACK
function RitnProtoTech:removePack(pack)
    if self.prototype == nil then return self end
    for i, ingredient in pairs(self.prototype.unit.ingredients) do
        if ingredient[1] == pack or ingredient.name == pack then
            table.remove(self.prototype.unit.ingredients, i)
        end
    end
    self:update()
    return self
end


--REPLACE SCIENCE PACK
function RitnProtoTech:replacePack(old, new)
    if self.prototype == nil then return self end
	if data.raw.tool[new] then
        self.amount_pack = 0

        for i, ingredient in pairs(self.prototype.unit.ingredients) do
            if ingredient[1] == old then
                self.doit = true
                self.amount_pack = ingredient[2] + self.amount_pack
            end
            if ingredient.name == old then
                self.doit = true
                self.amount_pack = ingredient.amount + self.amount_pack
            end
        end

        if self.doit then
            self:removePack(old)
            self:addPack(new, self.amount_pack)     
        end
	end

    self.amount_pack = 1
    self.doit = false
    self:update()
    return self
end


--MULTIPLIED SCIENCE PACK
function RitnProtoTech:multipliedPack(coeff)
    if self.prototype == nil then return self end
	self.prototype.unit.count = self.prototype.unit.count * coeff
    self:update()
    return self
end


--REMOVE PACK ON LABS
function RitnProtoTech:removePackLab(pack, lab)
    if pack == nil then return self end
    if data.raw.tool[pack] == nil then return self end

    if lab == nil then
		for i, labo in pairs(data.raw.lab) do
			for j, input in pairs(labo.inputs) do
				if labo.inputs[input] == pack or input == pack then
					table.remove(labo.inputs, j)
				end
			end
		end
	else 
        if data.raw["lab"][lab] then 
            for i, input in pairs(data.raw["lab"][lab].inputs) do
                if data.raw["lab"][lab].inputs[input] == pack or input == pack then
                    table.remove(data.raw["lab"][lab].inputs, i)
                end
            end
        end
	end

    return self
end

--ADD PACK ON LABS
function RitnProtoTech:addPackLab(pack, index)
    if data.raw.tool[pack] == nil then return self end

	for i, lab in pairs(data.raw.lab) do
		if index == nil then
			table.insert(lab.inputs, 1, pack)
		else 
			table.insert(lab.inputs, index, pack)
		end
	end

    return self
end

--------------------------- PRE-REQUIS --------------------------- 

--ADD PRE-REQUIS
function RitnProtoTech:addPrerequisite(prerequisite)
    if self.prototype == nil then return self end
    if type(prerequisite) == "string" then
        if data.raw.technology[prerequisite] then
            if self.prototype.prerequisites then
                for i, check in ipairs(self.prototype.prerequisites) do
                    if check == prerequisite then self.addit = false end
                end
            else
                self.prototype.prerequisites = {}
            end
        
            if self.addit then table.insert(self.prototype.prerequisites, prerequisite) end  
        end
    end
    self:update()
    self.addit = true
    return self
end


--REMOVE PRE-REQUIS
function RitnProtoTech:removePrerequisite(prerequisite)
    if self.prototype == nil then return self end
    if type(prerequisite) == "string" then
        for i, check in ipairs(self.prototype.prerequisites) do
            if check == prerequisite then
            table.remove(self.prototype.prerequisites, i)
            end
        end
    end
    self:update()
    return self
end


--REPLACE PRE-REQUIS
function RitnProtoTech:replacePrerequisite(remove_prerequisite, add_prerequisite)
    if self.prototype == nil then return self end
    self:removePrerequisite(remove_prerequisite):addPrerequisite(add_prerequisite):update()
    return self
end



----------------------------
return RitnProtoTech