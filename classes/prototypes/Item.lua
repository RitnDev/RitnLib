-- RitnProtoItem
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw[<item-type>][<name>]`. The constructor auto-detects the item type via `getItemType()` (iterates `lualib.vanilla.types_item`) and deep-copies the prototype into `self.prototype`. Inherits all generic mutators from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---No item-specific methods of its own — extend `RitnPrototype`'s `:changePrototype`, `:setPrototype`, `:changeSubgroup`, etc.
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw[<item-type>][<name>]`. Le constructeur auto-détecte le type d'item via `getItemType()` (itère `lualib.vanilla.types_item`) et fait un deep-copy du prototype dans `self.prototype`. Hérite de tous les mutators génériques de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---Pas de méthodes spécifiques aux items — utiliser `:changePrototype`, `:setPrototype`, `:changeSubgroup` etc. de `RitnPrototype`.
---@class RitnProtoItem : RitnPrototype
---@field object_name "RitnProtoItem"
---@operator call(string): RitnProtoItem
---@type RitnProtoItem
local RitnProtoItem = class.newclass(RitnProtoBase, function(base, item_name)
    -- prototype init
    if item_name == nil then return end
    RitnProtoBase.init(base, item_name, 'item')
    -- prototype get type
    base:getItemType()
    if base.type == nil then return end
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoItem"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end) --[[@as RitnProtoItem]]


--FUEL EMISSIONS

---**EN**
---
---Description: Sets `prototype.fuel_emissions_multiplier` (pollution multiplier when the item is burnt as fuel). No-op if the item has no `fuel_value` (not a fuel).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `prototype.fuel_emissions_multiplier` (multiplicateur de pollution quand l'item est brûlé comme carburant). No-op si l'item n'a pas de `fuel_value` (pas un carburant).
---@param value number
---@return RitnProtoItem self  Chainable
function RitnProtoItem:setFuelEmissionsMultiplier(value)
    if self.prototype == nil then return self end
    if self.prototype.fuel_value == nil then return self end
    if type(value) ~= "number" then return self end

    self.prototype.fuel_emissions_multiplier = value

    self:update()
    return self
end



return RitnProtoItem
