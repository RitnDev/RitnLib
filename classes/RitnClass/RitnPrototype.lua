-- RitnProtoBase
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local entity_types = require("__RitnLib__.lualib.vanilla.types_entity")
local item_types = require("__RitnLib__.lualib.vanilla.types_item")
----------------------------------------------------------------

---**EN**
---
---Description: Base class for every `RitnProto*` prototype manipulator. Wraps a single `data.raw[<type>][<name>]` entry as `self.prototype` (deep-copied by the derived classes) and provides generic mutate-and-write methods.
---
---Used at the **data stage** only. Each derived class (`RitnProtoRecipe`, `RitnProtoTechnology`, `RitnProtoEntity`, etc.) calls `RitnPrototype.init(base, name, type)` to set up the basics, then `deepcopy`'s `data.raw[type][name]` into `self.prototype`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Classe de base de chaque manipulateur de prototype `RitnProto*`. Encapsule une entrée `data.raw[<type>][<name>]` dans `self.prototype` (deep-copy par les classes dérivées) et fournit des méthodes génériques mutate-and-write.
---
---À utiliser au **data stage** uniquement. Chaque classe dérivée (`RitnProtoRecipe`, `RitnProtoTechnology`, `RitnProtoEntity`, etc.) appelle `RitnPrototype.init(base, name, type)` pour poser les bases, puis fait un `deepcopy` de `data.raw[type][name]` dans `self.prototype`.
---@class RitnPrototype
---@field object_name "RitnProtoBase"            Sentinel
---@field name string                            Prototype name (e.g. "automation-science-pack")
---@field type string                            Resolved prototype type (e.g. "recipe", "item", "assembling-machine")
---@field prototype table?                       Working copy of `data.raw[type][name]` (set by derived classes)
---@operator call(string, string): RitnPrototype
---@type RitnPrototype
local RitnPrototype = class.newclass(function(self, prototype_name, prototype_type)
    -- prototype self
    self.object_name = "RitnProtoBase"
    self.name = prototype_name
    self.type = prototype_type
    self.prototype = nil
    --------------------------------------------------
end) --[[@as RitnPrototype]]


-- Recupère le type parmis tous les types d'items possible

---**EN**
---
---Description: Iterates over `lualib.vanilla.types_item` and returns the first item-type for which `data.raw[type_name][self.name]` exists. Sets `self.type` as a side effect.
---
---──────────────────────────────
---
---**FR**
---
---Description: Itère sur `lualib.vanilla.types_item` et retourne le premier type-item pour lequel `data.raw[type_name][self.name]` existe. Met à jour `self.type` au passage.
---@return string?  Resolved item type or nil if no match
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

---**EN**
---
---Description: Iterates over `lualib.vanilla.types_entity` and returns the first entity-type for which `data.raw[type_name][self.name]` exists. Sets `self.type` as a side effect.
---
---──────────────────────────────
---
---**FR**
---
---Description: Itère sur `lualib.vanilla.types_entity` et retourne le premier type-entity pour lequel `data.raw[type_name][self.name]` existe. Met à jour `self.type` au passage.
---@return string?  Resolved entity type or nil if no match
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

---**EN**
---
---Description: Sets `prototype.subgroup` (and optionally `prototype.order`), then calls `:update()` to write back to `data.raw`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `prototype.subgroup` (et optionnellement `prototype.order`), puis appelle `:update()` pour réécrire dans `data.raw`.
---@param subgroup string
---@param order? string
---@return RitnPrototype self  Chainable
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

---**EN**
---
---Description: Sets `prototype[parameter] = value`, then writes back via `:update()`. The internal log statement is currently commented out.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `prototype[parameter] = value`, puis réécrit via `:update()`. Le log interne est actuellement commenté.
---@param parameter string
---@param value any
---@return RitnPrototype self  Chainable
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

---**EN**
---
---Description: Sets `prototype[parameter][subParameter] = value`, then writes back via `:update()`. No-op if `parameter` doesn't already exist on the prototype.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `prototype[parameter][subParameter] = value`, puis réécrit via `:update()`. No-op si `parameter` n'existe pas déjà sur le prototype.
---@param parameter string
---@param subParameter string
---@param value any
---@return RitnPrototype self  Chainable
function RitnPrototype:changeSubPrototype(parameter, subParameter, value)
    if self.prototype == nil then return self end
    if self.prototype[parameter] == nil then return self end

    self.prototype[parameter][subParameter] = value
    self:update()
    return self
end


-- SET VALUE

---**EN**
---
---Description: Alias for `:changePrototype` without the value-logging branch. Sets `prototype[parameter] = value` and writes back.
---
---──────────────────────────────
---
---**FR**
---
---Description: Alias de `:changePrototype` sans la branche de log de valeur. Définit `prototype[parameter] = value` et réécrit.
---@param parameter string
---@param value any
---@return RitnPrototype self  Chainable
function RitnPrototype:setPrototype(parameter, value)
    if self.prototype == nil then return self end

    self.prototype[parameter] = value

    self:update()
    return self
end


-- GET VALUE

---**EN**
---
---Description: Reads a property directly from `self.prototype` (no `data.raw` round-trip).
---
---──────────────────────────────
---
---**FR**
---
---Description: Lit une propriété directement depuis `self.prototype` (sans aller-retour `data.raw`).
---@param propertie string
---@return any
function RitnPrototype:getProperties(propertie)
    return self.prototype[propertie]
end


-- UPDATE PROTOTYPE

---**EN**
---
---Description: Writes `self.prototype` back into `data.raw[self.type][self.name]`. Auto-called by every setter. No-op if either the target slot or `self.prototype` is nil.
---
---──────────────────────────────
---
---**FR**
---
---Description: Réécrit `self.prototype` dans `data.raw[self.type][self.name]`. Appelé automatiquement par chaque setter. No-op si le slot cible ou `self.prototype` est nil.
function RitnPrototype:update()
    log('RitnPrototype:update() -> name : ' .. self.name)
    if data.raw[self.type][self.name] == nil then return self end
    if self.prototype == nil then return self end
    data.raw[self.type][self.name] = self.prototype
end


----------------------------------------------------------------
return RitnPrototype
