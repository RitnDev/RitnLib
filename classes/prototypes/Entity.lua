-- RitnProtoEntity
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw[<entity-type>][<name>]`. The constructor auto-detects the entity type via `getEntityType()` (iterates `lualib.vanilla.types_entity`) and deep-copies the prototype into `self.prototype`. Inherits all generic mutators from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw[<entity-type>][<name>]`. Le constructeur auto-détecte le type d'entité via `getEntityType()` (itère `lualib.vanilla.types_entity`) et fait un deep-copy du prototype dans `self.prototype`. Hérite de tous les mutators génériques de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---@class RitnProtoEntity : RitnPrototype
---@field object_name "RitnProtoEntity"
---@field lua_prototype table?                Direct reference to `data.raw[type][name]` (not the deepcopy)
---@operator call(string): RitnProtoEntity
---@type RitnProtoEntity
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
end) --[[@as RitnProtoEntity]]

----------------------------------------------------------------



-- ADD CATEGORY ON "crafting_categories"

---**EN**
---
---Description: Appends `category` to the entity's `crafting_categories`. Normalises the field to a table first if it was stored as a single string.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute `category` à `crafting_categories` de l'entité. Normalise d'abord le champ en table s'il était stocké comme une string unique.
---@param category string
---@return RitnProtoEntity self  Chainable
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
