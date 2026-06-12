-- RitnProtoItemGroup
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["item-group"][<name>]`. Deep-copies the existing group into `self.prototype` if found. Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["item-group"][<name>]`. Deep-copie le groupe existant dans `self.prototype` s'il est trouvé. Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---@class RitnProtoItemGroup : RitnPrototype
---@field object_name "RitnProtoItemGroup"
---@operator call(string): RitnProtoItemGroup
---@type RitnProtoItemGroup
local RitnProtoItemGroup = class.newclass(RitnProtoBase, function(base, group_name)
    -- prototype init
    if group_name == nil then return end
    RitnProtoBase.init(base, group_name, "item-group")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoItemGroup"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end) --[[@as RitnProtoItemGroup]]


--ADD NEW ITEM-SUBGROUP

---**EN**
---
---Description: Declares a brand-new item-group via `data:extend({...})` (data stage). Does not require an existing prototype instance.
---
---──────────────────────────────
---
---**FR**
---
---Description: Déclare un nouveau item-group via `data:extend({...})` (data stage). Pas besoin d'instance prototype existante.
---@param name string
---@param order string
---@param icon string  Sprite path
---@param icon_size integer
---@return RitnProtoItemGroup self  Chainable
function RitnProtoItemGroup:extend(name, order, icon, icon_size)
    if name == nil then return end
    local newGroup = {
        type = "item-group",
        name = name,
        order = order,
        icon = icon,
        icon_size = icon_size,
    }
    data:extend({newGroup})
    return self
end



---**EN**
---
---Description: Sets the group's `icon` and `icon_size` in one call.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `icon` et `icon_size` du groupe en un appel.
---@param pathIcon string
---@param size integer
---@return RitnProtoItemGroup self  Chainable
function RitnProtoItemGroup:setIcon(pathIcon, size)
    if self.prototype == nil then return self end
    if type(size) ~= "number" then return self end

    self.prototype.icon = pathIcon
    self.prototype.icon_size = size
    self:update()
    return self
end


return RitnProtoItemGroup
