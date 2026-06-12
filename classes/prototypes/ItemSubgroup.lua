-- RitnProtoItemSubgroup
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["item-subgroup"][<name>]`. Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["item-subgroup"][<name>]`. Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---@class RitnProtoItemSubgroup : RitnPrototype
---@field object_name "RitnProtoItemSubgroup"
---@operator call(string): RitnProtoItemSubgroup
---@type RitnProtoItemSubgroup
local RitnProtoItemSubgroup = class.newclass(RitnProtoBase, function(base, subgroup_name)
    -- prototype init
    if subgroup_name == nil then return end
    RitnProtoBase.init(base, subgroup_name, "item-subgroup")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoItemSubgroup"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end) --[[@as RitnProtoItemSubgroup]]



--ADD NEW ITEM-SUBGROUP

---**EN**
---
---Description: Declares a brand-new item-subgroup via `data:extend({...})` (data stage). Does not require an existing prototype instance.
---
---──────────────────────────────
---
---**FR**
---
---Description: Déclare un nouveau item-subgroup via `data:extend({...})` (data stage). Pas besoin d'instance prototype existante.
---@param name string
---@param group string    Parent item-group name
---@param order string
---@return RitnProtoItemSubgroup self  Chainable
function RitnProtoItemSubgroup:extend(name, group, order)
    if name == nil then return end
    local newSubgroup = {
        type = "item-subgroup",
        name = name,
        group = group,
        order = order
    }
    data:extend({newSubgroup})
    return self
end


--Change group

---**EN**
---
---Description: Reassigns the subgroup to a different parent `group` (optionally also sets `order`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Réassigne le sous-groupe à un autre `group` parent (optionnellement met aussi à jour `order`).
---@param group string
---@param order? string
---@return RitnProtoItemSubgroup self  Chainable
function RitnProtoItemSubgroup:changeGroup(group, order)
    if self.prototype == nil then return self end

    self.prototype.group = group
    if order ~= nil then
        self.prototype.order = order
    end

    self:update()
    return self
end



--Change order

---**EN**
---
---Description: Updates the subgroup's `order` field.
---
---──────────────────────────────
---
---**FR**
---
---Description: Met à jour le champ `order` du sous-groupe.
---@param order string
---@return RitnProtoItemSubgroup self  Chainable
function RitnProtoItemSubgroup:changeOrder(order)
    if self.prototype == nil then return self end

    self.prototype.order = order

    self:update()
    return self
end



return RitnProtoItemSubgroup
