-- RitnProtoTech
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
local RitnProtoRecipe = require("__RitnLib__.classes.prototypes.Recipe")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["technology"][<name>]`. Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua). Full toolkit for technologies: cost mutation (`setCount`, `setTime`, `setIngredients`, `multipliedPack`), recipe unlock add/remove, science pack add/remove/replace/lab-membership, prerequisite add/remove/replace, disable (with optional cascade purge of prerequisites referencing this tech).
---
---⚠ Mutable instance fields (`addit`, `doit`, `disable_recipe`, `amount_pack`, `delete_prerequisite`) are reset between methods to track per-operation state. Keep that in mind if chaining methods.
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["technology"][<name>]`. Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua). Boîte à outils complète pour les technologies : mutation des coûts (`setCount`, `setTime`, `setIngredients`, `multipliedPack`), add/remove de recette débloquée, add/remove/replace de pack de science et appartenance aux labs, add/remove/replace de pré-requis, disable (avec optionnellement purge en cascade des pré-requis qui pointent vers cette tech).
---
---⚠ Champs d'instance mutables (`addit`, `doit`, `disable_recipe`, `amount_pack`, `delete_prerequisite`) reset entre méthodes pour tracker l'état par opération. À noter si tu chaînes les méthodes.
---@class RitnProtoTech : RitnPrototype
---@field object_name "RitnProtoTech"
---@field delete_prerequisite boolean             Internal flag toggled by `:disable(true)` to cascade-purge prerequisites
---@field addit boolean                           Internal flag for "should add" — reset to true at end of each method
---@field doit boolean                            Internal flag for `:replacePack` — reset to false at end
---@field disable_recipe boolean                  Internal flag for `:removeRecipe(_, true)` cascade-disable
---@field amount_pack integer                     Internal pack-amount accumulator — defaults to 1, reset to 1 at end
---@operator call(string): RitnProtoTech
---@type RitnProtoTech
local RitnProtoTech = class.newclass(RitnProtoBase, function(base, tech_name)
    -- prototype init
    if tech_name == nil then return end
    RitnProtoBase.init(base, tech_name, 'technology')
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoTech"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
    -- object parameters
    base.delete_prerequisite = false
    base.addit = true
    base.doit = false
    base.disable_recipe = false
    base.amount_pack = 1
end) --[[@as RitnProtoTech]]



--SET COUNT SCIENCE PACK

---**EN**
---
---Description: Sets the research cost count (`prototype.unit.count`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le compte de coût de recherche (`prototype.unit.count`).
---@param count number
---@return RitnProtoTech self  Chainable
function RitnProtoTech:setCount(count)
    if self.prototype == nil then return self end

    if type(count) == "number" then
        self.prototype.unit.count = count
    end

    self:update()
    return self
end



--SET TIME SCIENCE PACK

---**EN**
---
---Description: Sets the research time per cycle (`prototype.unit.time`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le temps de recherche par cycle (`prototype.unit.time`).
---@param time number
---@return RitnProtoTech self  Chainable
function RitnProtoTech:setTime(time)
    if self.prototype == nil then return self end

    if type(time) == "number" then
        self.prototype.unit.time = time
    end

    self:update()
    return self
end



--SET INGREDIENTS SCIENCE PACK

---**EN**
---
---Description: Replaces the research ingredient list (`prototype.unit.ingredients`) with `ingredients`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace la liste d'ingrédients de recherche (`prototype.unit.ingredients`) par `ingredients`.
---@param ingredients table[]
---@return RitnProtoTech self  Chainable
function RitnProtoTech:setIngredients(ingredients)
    if self.prototype == nil then return self end

    if type(ingredients) == "table" then
        self.prototype.unit.ingredients = ingredients
    end

    self:update()
    return self
end


--DISABLE TECHNOLOGY

---**EN**
---
---Description: Disables and hides the technology. If `delete_prerequisites == true`, also purges every other technology's `prerequisites` list of any entry referencing this tech.
---
---──────────────────────────────
---
---**FR**
---
---Description: Désactive et cache la technologie. Si `delete_prerequisites == true`, purge aussi la liste `prerequisites` de chaque autre techno qui pointe vers cette tech.
---@param delete_prerequisites? boolean
---@return RitnProtoTech self  Chainable
function RitnProtoTech:disable(delete_prerequisites)
    if self.prototype == nil then return self end
    self.prototype.enabled = false
    self.prototype.hidden = true

    if type(delete_prerequisites) == 'boolean' then
        self.delete_prerequisite = delete_prerequisites
    end

    if self.delete_prerequisite then
        for _, tech in pairs(data.raw.technology) do
            if tech.prerequisites ~= nil then
                for i, check in ipairs(tech.prerequisites) do
                    if check == self.prototype.name then
                        table.remove(tech.prerequisites, i)
                    end
                end
            end
        end
    end

    self:update()
    return self
end


--------------------------- RECIPE ---------------------------
--ADD RECIPE UNLOCK

---**EN**
---
---Description: Appends an `{type = "unlock-recipe", recipe = recipe_name}` effect to `prototype.effects`, unless the same unlock is already present. Recipe must exist in `data.raw.recipe`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute un effet `{type = "unlock-recipe", recipe = recipe_name}` à `prototype.effects`, sauf si le même unlock est déjà présent. La recette doit exister dans `data.raw.recipe`.
---@param recipe_name string
---@return RitnProtoTech self  Chainable
function RitnProtoTech:addRecipe(recipe_name)
    if self.prototype == nil then return self end
    if data.raw.recipe[recipe_name] then
        if self.prototype.effects == nil then
            self.prototype.effects = {}
        end

        for i, effect in pairs(self.prototype.effects) do
            if effect.type == "unlock-recipe" and effect.recipe == recipe_name then self.addit = false end
        end

        if self.addit then
            table.insert(self.prototype.effects, { type = "unlock-recipe", recipe = recipe_name })
        end
    end
    self.addit = true
    self:update()
    return self
end


--REMOVE RECIPE UNLOCK

---**EN**
---
---Description: Removes the `unlock-recipe` effect matching `recipe` from `prototype.effects`. If `complete == true`, also disables the recipe via `RitnProtoRecipe(recipe):disable()`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retire l'effet `unlock-recipe` matchant `recipe` de `prototype.effects`. Si `complete == true`, désactive aussi la recette via `RitnProtoRecipe(recipe):disable()`.
---@param recipe string
---@param complete? boolean
---@return RitnProtoTech self  Chainable
function RitnProtoTech:removeRecipe(recipe, complete)
    if self.prototype == nil then return self end
    if complete ~= nil then self.disable_recipe = complete end

    if self.prototype.effects then
        for i, effect in pairs(self.prototype.effects) do
            if effect.type == "unlock-recipe" and effect.recipe == recipe then
                table.remove(self.prototype.effects, i)

                if self.disable_recipe then
                    RitnProtoRecipe(recipe):disable()
                end
            end
        end
    end

    self.disable_recipe = false
    self:update()
    return self
end


--------------------------- PACK ---------------------------

--ADD SCIENCE PACK

---**EN**
---
---Description: Adds a science pack to `prototype.unit.ingredients`, defaulting to amount 1. If the pack is already present (matched by `[1]` or `.name`), increments the existing amount by `count` instead. `pack` must exist in `data.raw.tool`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute un pack de science à `prototype.unit.ingredients`, amount 1 par défaut. Si le pack est déjà présent (matché par `[1]` ou `.name`), incrémente l'amount existant de `count`. `pack` doit exister dans `data.raw.tool`.
---@param pack string     Tool name (e.g. "automation-science-pack")
---@param count? integer  Default 1
---@return RitnProtoTech self  Chainable
function RitnProtoTech:addPack(pack, count)
    if self.prototype == nil then return self end
    if count ~= nil then self.amount_pack = count end

    if data.raw.tool[pack] then
        for i, ingredient in pairs(self.prototype.unit.ingredients) do
            if ingredient[1] == pack then
                self.addit = false
                ingredient[2] = ingredient[2] + self.amount_pack
            end
            if ingredient.name == pack then
                self.addit = false
                ingredient.amount = ingredient.amount + self.amount_pack
            end
        end
        if self.addit then
            table.insert(self.prototype.unit.ingredients, { pack, self.amount_pack })
        end
    end
    self.addit = true
    self.amount_pack = 1
    self:update()
    return self
end


--REMOVE SCIENCE PACK

---**EN**
---
---Description: Removes every entry matching `pack` from `prototype.unit.ingredients` (by either `[1]` or `.name`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retire chaque entrée matchant `pack` de `prototype.unit.ingredients` (via `[1]` ou `.name`).
---@param pack string
---@return RitnProtoTech self  Chainable
function RitnProtoTech:removePack(pack)
    if self.prototype == nil then return self end
    for i, ingredient in pairs(self.prototype.unit.ingredients) do
        if ingredient[1] == pack or ingredient.name == pack then
            table.remove(self.prototype.unit.ingredients, i)
        end
    end
    self:update()
    return self
end


--REPLACE SCIENCE PACK

---**EN**
---
---Description: Replaces every occurrence of `old` pack with `new` pack, preserving the total amount. `new` must exist in `data.raw.tool`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace chaque occurrence du pack `old` par le pack `new`, en préservant l'amount total. `new` doit exister dans `data.raw.tool`.
---@param old string
---@param new string
---@return RitnProtoTech self  Chainable
function RitnProtoTech:replacePack(old, new)
    if self.prototype == nil then return self end
    if data.raw.tool[new] then
        self.amount_pack = 0

        for i, ingredient in pairs(self.prototype.unit.ingredients) do
            if ingredient[1] == old then
                self.doit = true
                self.amount_pack = ingredient[2] + self.amount_pack
            end
            if ingredient.name == old then
                self.doit = true
                self.amount_pack = ingredient.amount + self.amount_pack
            end
        end

        if self.doit then
            self:removePack(old)
            self:addPack(new, self.amount_pack)
        end
    end

    self.amount_pack = 1
    self.doit = false
    self:update()
    return self
end


--MULTIPLIED SCIENCE PACK

---**EN**
---
---Description: Multiplies `prototype.unit.count` by `coeff`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Multiplie `prototype.unit.count` par `coeff`.
---@param coeff number
---@return RitnProtoTech self  Chainable
function RitnProtoTech:multipliedPack(coeff)
    if self.prototype == nil then return self end
    self.prototype.unit.count = self.prototype.unit.count * coeff
    self:update()
    return self
end


--REMOVE PACK ON LABS

---**EN**
---
---Description: Removes `pack` from the `inputs` list of every lab (or a specific one if `lab` is provided). `pack` must exist in `data.raw.tool`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retire `pack` de la liste `inputs` de chaque lab (ou d'un lab spécifique si `lab` est fourni). `pack` doit exister dans `data.raw.tool`.
---@param pack string
---@param lab? string
---@return RitnProtoTech self  Chainable
function RitnProtoTech:removePackLab(pack, lab)
    if pack == nil then return self end
    if data.raw.tool[pack] == nil then return self end

    if lab == nil then
        for i, labo in pairs(data.raw.lab) do
            for j, input in pairs(labo.inputs) do
                if labo.inputs[input] == pack or input == pack then
                    table.remove(labo.inputs, j)
                end
            end
        end
    else
        if data.raw.lab[lab] then
            for i, input in pairs(data.raw.lab[lab].inputs) do
                if data.raw.lab[lab].inputs[input] == pack or input == pack then
                    table.remove(data.raw.lab[lab].inputs, i)
                end
            end
        end
    end

    return self
end

--ADD PACK ON LABS

---**EN**
---
---Description: Adds `pack` to the `inputs` list of every lab that doesn't already contain it. `index` controls the insertion position (default 1, i.e. front). `pack` must exist in `data.raw.tool`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute `pack` à la liste `inputs` de chaque lab qui ne le contient pas déjà. `index` contrôle la position d'insertion (défaut 1, au début). `pack` doit exister dans `data.raw.tool`.
---@param pack string
---@param index? integer  Default 1
---@return RitnProtoTech self  Chainable
function RitnProtoTech:addPackLab(pack, index)
    if data.raw.tool[pack] == nil then return self end

    for i, lab in pairs(data.raw.lab) do
        local exist = false
        for _, science in pairs(lab.inputs) do
            if science == pack then exist = true end
        end
        if exist == false then
            if index == nil then
                table.insert(lab.inputs, 1, pack)
            else
                table.insert(lab.inputs, index, pack)
            end
        end
    end

    return self
end

--------------------------- PRE-REQUIS ---------------------------

--ADD PRE-REQUIS

---**EN**
---
---Description: Appends `prerequisite` to `prototype.prerequisites`, unless it's already present. Initialises the list if absent. `prerequisite` must reference an existing technology in `data.raw.technology`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute `prerequisite` à `prototype.prerequisites`, sauf s'il est déjà présent. Initialise la liste si absente. `prerequisite` doit référencer une technologie existante dans `data.raw.technology`.
---@param prerequisite string
---@return RitnProtoTech self  Chainable
function RitnProtoTech:addPrerequisite(prerequisite)
    if self.prototype == nil then return self end
    if type(prerequisite) == "string" then
        if data.raw.technology[prerequisite] then
            if self.prototype.prerequisites then
                for i, check in ipairs(self.prototype.prerequisites) do
                    if check == prerequisite then self.addit = false end
                end
            else
                self.prototype.prerequisites = {}
            end

            if self.addit then table.insert(self.prototype.prerequisites, prerequisite) end
        end
    end
    self:update()
    self.addit = true
    return self
end


--REMOVE PRE-REQUIS

---**EN**
---
---Description: Removes every entry matching `prerequisite` from `prototype.prerequisites`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retire chaque entrée matchant `prerequisite` de `prototype.prerequisites`.
---@param prerequisite string
---@return RitnProtoTech self  Chainable
function RitnProtoTech:removePrerequisite(prerequisite)
    if self.prototype == nil then return self end
    if type(prerequisite) == "string" then
        for i, check in ipairs(self.prototype.prerequisites) do
            if check == prerequisite then
                table.remove(self.prototype.prerequisites, i)
            end
        end
    end
    self:update()
    return self
end


--REPLACE PRE-REQUIS

---**EN**
---
---Description: Combines `:removePrerequisite(remove_prerequisite)` + `:addPrerequisite(add_prerequisite)` in one chained call.
---
---──────────────────────────────
---
---**FR**
---
---Description: Combine `:removePrerequisite(remove_prerequisite)` + `:addPrerequisite(add_prerequisite)` en un appel chaîné.
---@param remove_prerequisite string
---@param add_prerequisite string
---@return RitnProtoTech self  Chainable
function RitnProtoTech:replacePrerequisite(remove_prerequisite, add_prerequisite)
    if self.prototype == nil then return self end
    self:removePrerequisite(remove_prerequisite):addPrerequisite(add_prerequisite):update()
    return self
end



----------------------------
return RitnProtoTech
