-- RitnProtoEntity
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------


local RitnProtoEntity = class.newclass(RitnProtoBase, function(base, entity_name)
    -- prototype init
    if entity_name == nil then return end
    RitnProtoBase.init(base, entity_name, 'entity')
    -- prototype get type
    base:getEntityType()
    if base.type == nil then return end
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoEntity"
    base.lua_prototype = data.raw[base.type][base.name]
    ----
    if base.lua_prototype == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end)

----------------------------------------------------------------



-- ADD CATEGORY ON "crafting_categories"
function RitnProtoEntity:addCraftingCategories(category)
    if category == nil then return self end
    if type(category) ~= "string" then return self end
    if self.prototype == nil then return self end
    if self.prototype.crafting_categories == nil then return self end

    if type(self.prototype.crafting_categories) == "string" then 
        local categories = { self.prototype.crafting_categories }
        table.insert(categories, category)
        self.prototype.crafting_categories = categories
    elseif type(self.prototype.crafting_categories) == "table" then
        table.insert(self.prototype.crafting_categories, category)
    else return self end

    self:update()
    return self
end


----------------------------------------------------------------
return RitnProtoEntity