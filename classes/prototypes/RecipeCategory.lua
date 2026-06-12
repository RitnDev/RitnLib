-- RitnProtoRecipeCategory
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["recipe-category"][<name>]`. Calls `RitnProtoBase.init` to populate the basics (`object_name`, `name`, `type`, `prototype`).
---
---Note: the class declaration `class.newclass(function ...)` doesn't pass `RitnProtoBase` as the parent, so the generic mutators (`:changePrototype`, `:setPrototype`, `:update`, etc.) are **not** inherited on instances. Only the methods defined directly below are available. Use `RitnProto*` subclasses with proper inheritance for full mutator access.
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["recipe-category"][<name>]`. Appelle `RitnProtoBase.init` pour remplir les bases (`object_name`, `name`, `type`, `prototype`).
---
---Note : la déclaration `class.newclass(function ...)` ne passe pas `RitnProtoBase` en parent, donc les mutators génériques (`:changePrototype`, `:setPrototype`, `:update`, etc.) ne sont **pas** hérités sur les instances. Seules les méthodes définies directement ci-dessous sont disponibles. Utiliser les sous-classes `RitnProto*` avec héritage correct pour avoir accès aux mutators.
---@class RitnProtoRecipeCategory
---@field object_name "RitnProtoRecipeCategory"
---@field name string
---@field type "recipe-category"
---@field prototype table?
---@operator call(string): RitnProtoRecipeCategory
---@type RitnProtoRecipeCategory
local RitnProtoRecipeCategory = class.newclass(function(base, category_name)
    -- prototype init
    if category_name == nil then return end
    RitnProtoBase.init(base, category_name, "recipe-category")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoRecipeCategory"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end) --[[@as RitnProtoRecipeCategory]]


--ADD NEW ITEM-SUBGROUP

---**EN**
---
---Description: Declares a brand-new recipe-category via `data:extend({...})` (data stage).
---
---──────────────────────────────
---
---**FR**
---
---Description: Déclare une nouvelle recipe-category via `data:extend({...})` (data stage).
---@param name string
---@param order string
---@return RitnProtoRecipeCategory self  Chainable
function RitnProtoRecipeCategory:extend(name, order)
    if name == nil then return end
    local newCategory = {
        type = "recipe-category",
        name = name,
        order = order
    }
    data:extend({newCategory})
    return self
end



return RitnProtoRecipeCategory
