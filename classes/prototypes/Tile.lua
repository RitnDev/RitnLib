-- RitnProtoTile
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["tile"][<name>]`. Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["tile"][<name>]`. Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---@class RitnProtoTile : RitnPrototype
---@field object_name "RitnProtoTile"
---@operator call(string): RitnProtoTile
---@type RitnProtoTile
local RitnProtoTile = class.newclass(RitnProtoBase, function(base, tile_name)
    -- prototype init
    if tile_name == nil then return end
    RitnProtoBase.init(base, tile_name, "tile")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoTile"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end) --[[@as RitnProtoTile]]


--BLUEPRINT

---**EN**
---
---Description: Sets `prototype.can_be_part_of_blueprint`. `value` defaults to `true`; pass `false` to keep the tile out of blueprints.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `prototype.can_be_part_of_blueprint`. `value` vaut `true` par défaut ; passer `false` pour exclure la tuile des plans (blueprints).
---@param value? boolean
---@return RitnProtoTile self  Chainable
function RitnProtoTile:setBlueprintable(value)
    if self.prototype == nil then return self end

    self.prototype.can_be_part_of_blueprint = value ~= false

    self:update()
    return self
end



return RitnProtoTile
