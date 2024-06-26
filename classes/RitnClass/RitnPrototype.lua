-- RitnProtoBase
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local entity_types = require("__RitnLib__.lualib.vanilla.types_entity")
local item_types = require("__RitnLib__.lualib.vanilla.types_item")
----------------------------------------------------------------

local RitnPrototype = class.newclass(function(self, prototype_name, prototype_type)
    -- prototype self
    self.object_name = "RitnProtoBase"
    self.name = prototype_name
    self.type = prototype_type
    self.prototype = nil
    --------------------------------------------------
end)


-- Recupère le type parmis tous les types d'items possible
function RitnPrototype:getItemType()
    for i, type_name in pairs(item_types) do
        if data.raw[type_name][self.name] then 
            self.type = type_name
            return type_name 
        end
    end
    return nil
end



-- Recupère le type parmis tous les types d'entité possible
function RitnPrototype:getEntityType()
    for i, type_name in pairs(entity_types) do
        if data.raw[type_name][self.name] then 
            self.type = type_name
            return type_name 
        end
    end
    return nil
end




-- CHANGE SUBGROUP
function RitnPrototype:changeSubgroup(subgroup, order) 
    if self.prototype == nil then return self end

    self.prototype.subgroup = subgroup
    if order ~= nil then 
        self.prototype.order = order
    end

    self:update()
    return self
end



-- CHANGE VALUE IN PARAMETER OF PROTOTYPE
function RitnPrototype:changePrototype(parameter, value) 
    if self.prototype == nil then return self end

    self.prototype[parameter] = value

    local log_value
    if value ~= nil then 
        if type(value) == "table" then 
            log_value = serpent.block(value) 
        else
            log_value = value
        end 
    else
        log_value = "nil"
    end
    --log(self.object_name .. ":changePrototype -> " .. parameter .. ", " .. log_value)

    self:update()
    return self
end


--CHANGE VALUE ON PARAMERS OF PROTOTYPE
function RitnPrototype:changeSubPrototype(parameter, subParameter , value) 
    if self.prototype == nil then return self end
    if self.prototype[parameter] == nil then return self end

    self.prototype[parameter][subParameter] = value
    self:update()
    return self
end


-- SET VALUE
function RitnPrototype:setPrototype(parameter, value) 
    if self.prototype == nil then return self end

    self.prototype[parameter] = value

    self:update()
    return self
end


-- GET VALUE
function RitnPrototype:getProperties(propertie) 
    return self.prototype[propertie]
end


-- UPDATE PROTOTYPE
function RitnPrototype:update()
    log('RitnPrototype:update() -> name : ' .. self.name)
    if data.raw[self.type][self.name] == nil then return self end
    if self.prototype == nil then return self end
    data.raw[self.type][self.name] = self.prototype
end


----------------------------------------------------------------
return RitnPrototype