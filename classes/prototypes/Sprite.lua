-- RitnProtoSprite
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["sprite"][<name>]`. Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua). Also provides shortcuts for injecting sprites into `data.raw["utility-sprites"].default` and for creating brand-new sprite prototypes via `data:extend({...})`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["sprite"][<name>]`. Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua). Fournit aussi des raccourcis pour injecter des sprites dans `data.raw["utility-sprites"].default` et pour créer de nouveaux prototypes sprite via `data:extend({...})`.
---@class RitnProtoSprite : RitnPrototype
---@field object_name "RitnProtoSprite"
---@operator call(string): RitnProtoSprite
---@type RitnProtoSprite
local RitnProtoSprite = class.newclass(RitnProtoBase, function(base, sprite_name)
    -- prototype init
    if sprite_name == nil then return end
    RitnProtoBase.init(base, sprite_name, "sprite")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoSprite"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end) --[[@as RitnProtoSprite]]


--ADD NEW SPRITE

---**EN**
---
---Description: Copies the sprite into `data.raw["utility-sprites"].default[<name>]` so it becomes available as a utility-sprite. Default `priority = "medium"`, default `flags = {"icon"}`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Copie le sprite dans `data.raw["utility-sprites"].default[<name>]` pour qu'il soit disponible comme utility-sprite. Défauts `priority = "medium"`, `flags = {"icon"}`.
---@param priority? string  e.g. "low", "medium", "high", "extra-high"
---@param flags? string[]   e.g. {"icon"}
---@return RitnProtoSprite self  Chainable
function RitnProtoSprite:createUtility(priority, flags)
    if self.prototype == nil then return self end

    -- default values
    local defaultPriority = "medium"
    local defaultFlags = { "icon" }

    -- priority present
    if priority ~= nil then
        if type(priority) == "string" then
            defaultPriority = priority
        end
    end

    --flags present
    if flags ~= nil then
        if type(flags) == "table" then
            defaultFlags = flags
        end
    end


    data.raw["utility-sprites"]["default"][self.name] = {
        filename = self.prototype.filename,
        priority = defaultPriority,
        width = self.prototype.width,
        height = self.prototype.height,
        flags = defaultFlags
    }

    return self
end


--ADD NEW SPRITE

---**EN**
---
---Description: Declares a brand-new sprite via `data:extend({...})` (data stage). `size` accepts a number (square) or a `{w, h}` table. Default 32x32.
---
---──────────────────────────────
---
---**FR**
---
---Description: Déclare un nouveau sprite via `data:extend({...})` (data stage). `size` accepte un number (carré) ou une table `{w, h}`. Défaut 32x32.
---@param name string
---@param file_name string  Sprite filepath
---@param size? number|number[]
function RitnProtoSprite:extend(name, file_name, size)
    if name == nil then return end
    if file_name == nil then return end

    local default_size = 32
    if type(size) == "number" then
        if size ~= nil then default_size = size end
    end
    local width = default_size
    local height = default_size

    if type(size) == "table" then
        width = size[1]
        height = size[2]
    end


    local sprite = {
        type = "sprite",
        name = name,
        filename = file_name,
        width = width,
        height = height,
        flags = { "gui-icon" },
        mipmap_count = 1,
    }

    data:extend({ sprite })
end



return RitnProtoSprite
