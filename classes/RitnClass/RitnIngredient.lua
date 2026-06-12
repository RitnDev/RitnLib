-- RitnIngredient
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------

---**EN**
---
---Description: Normalises a Factorio recipe ingredient (item or fluid) into a uniform `{name, type, amount, amount_min, amount_max, probability}` shape, and provides list operations: `:add`, `:addNew`, `:set`, `:remove`, `:combine`.
---
---Accepts both ingredient forms in input:
---- Array form: `{"iron-plate", 2}` (Factorio 1.x legacy)
---- Object form: `{name = "iron-plate", amount = 2, type = "item"}` (canonical in 2.0)
---- Plain string: `"iron-plate"` (sugar for `{name = "iron-plate"}`)
---
---For items, fractional amounts in `(0, 1)` are normalised to 1, larger amounts are floored.
---
---⚠ **Known bug in `getItem` helper (P0)**: `item.probability = ingredient.inputs.probability` assumes `ingredient.inputs` is a sub-table, which is not part of the standard ingredient shape. Crashes with "attempt to index a nil value" when the `ingredient.probability` branch is entered. The intended code was likely `item.probability = ingredient.probability`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Normalise un ingrédient de recette Factorio (item ou fluide) en une forme uniforme `{name, type, amount, amount_min, amount_max, probability}`, et fournit des opérations de liste : `:add`, `:addNew`, `:set`, `:remove`, `:combine`.
---
---Accepte les deux formes d'ingrédient en entrée :
---- Forme array : `{"iron-plate", 2}` (legacy Factorio 1.x)
---- Forme objet : `{name = "iron-plate", amount = 2, type = "item"}` (canonique en 2.0)
---- String simple : `"iron-plate"` (sucre pour `{name = "iron-plate"}`)
---
---Pour les items, les amounts fractionnaires dans `(0, 1)` sont normalisés à 1, les amounts plus grands sont floorés.
---
---⚠ **Bug connu dans le helper `getItem` (P0)** : `item.probability = ingredient.inputs.probability` suppose que `ingredient.inputs` est une sous-table, ce qui ne fait pas partie de la forme d'ingrédient standard. Plante avec "attempt to index a nil value" quand la branche `ingredient.probability` est entrée. Le code voulu était probablement `item.probability = ingredient.probability`.
---@class RitnIngredient
---@field object_name "RitnIngredient"
---@field ingredient table|string                   Original input (raw)
---@field name string                               Resolved ingredient name
---@field type? "item"|"fluid"                      Resolved type (auto-detected via `data.raw.fluid[name]` if not provided)
---@field amount? number                            Resolved amount (floored for items)
---@field amount_min? number                        Range lower bound
---@field amount_max? number                        Range upper bound
---@field probability? number                       Probability factor
---@field item table                                Normalised `{name, type, amount, amount_min, amount_max, probability}` payload
---@field addit boolean                             Internal flag used by `:add` / `:addNew` to track "already present"
---@operator call(table|string): RitnIngredient
---@type RitnIngredient
local RitnIngredient = class.newclass(function(self, ingredient)
    if type(ingredient) ~= "table" and type(ingredient) ~= "string" then return end
    -- prototype self
    self.object_name = "RitnIngredient"
    self.ingredient = ingredient
    self.name = ingredient.name or ingredient[1]

    if type(ingredient) == "string" then
        self.name = ingredient
    end

    log("RitnIngredient.name = " .. self.name)

    self.type = ingredient.type
    self.amount = ingredient.amount or ingredient[2]
    self.amount_min = ingredient.amount_min
    self.amount_max = ingredient.amount_max
    self.probability = ingredient.probability
    -- get basic type
    if not self.type then
        local item_type = "item"
        if data.raw.fluid[self.name] then item_type = "fluid" end
        self.type = item_type
    end
    -- get amount if not integer value
    if self.type == "item" then
        if self.amount then
            if self.amount > 0 and self.amount < 1 then
                self.amount = 1
            else
                self.amount = math.floor(self.amount)
            end
        end
    end
    --------------------------------------------------
    self.item = {
        name = self.name,
        type = self.type,
        amount = self.amount,
        amount_min = self.amount_min,
        amount_max = self.amount_max,
        probability = self.probability
    }
    self.addit = true
    --------------------------------------------------
end) --[[@as RitnIngredient]]


---**EN**
---
---Description: Internal: builds a normalised `{name, type, amount, ...}` payload from a raw ingredient. Used by list operations.
---
---⚠ Contains one known bug (see class-level doc): reads `ingredient.inputs.probability` (undefined sub-table) on the probability branch.
---
---──────────────────────────────
---
---**FR**
---
---Description: Interne : construit un payload normalisé `{name, type, amount, ...}` à partir d'un ingrédient brut. Utilisé par les opérations de liste.
---
---⚠ Contient un bug connu (cf. doc classe) : lit `ingredient.inputs.probability` (sous-table indéfinie) sur la branche probability.
---@param ingredient table
---@return table item   Normalised payload
local function getItem(ingredient)
    local item = {}

    if ingredient.name then
        item.name = ingredient.name
    else
        item.name = ingredient[1]
    end

    if ingredient.amount then
        item.amount = ingredient.amount
    else
        if ingredient[2] then item.amount = ingredient[2] end
    end

    if not item.amount then
        if ingredient.amount_min and ingredient.amount_max then
            item.amount_min = ingredient.amount_min
            item.amount_max = ingredient.amount_max
        else
            item.amount = 1
        end
    end

    if ingredient.probability then item.probability = ingredient.inputs.probability end

    if ingredient.type then
        item.type = ingredient.type
    else
        local item_type = "item"
        if data.raw.fluid[item.name] then item_type = "fluid" end
        item.type = item_type
    end

    if item.type == "item" then
        if item.amount > 0 and item.amount < 1 then
            item.amount = 1
        else
            item.amount = math.floor(item.amount)
        end
    end

    return item
end



---**EN**
---
---Description: Combines `self` with another ingredient (same name) by summing amounts and averaging probability. Updates `self.item` with the result and returns it.
---
---──────────────────────────────
---
---**FR**
---
---Description: Combine `self` avec un autre ingrédient (même nom) en sommant les amounts et en moyennant la probability. Met à jour `self.item` avec le résultat et le retourne.
---@param ingredient table
---@return table item  The combined payload
function RitnIngredient:combine(ingredient)
    --log("RitnIngredient - combine() - ingredient -> " .. ingredient.name)
    local item = {}
    local item1 = getItem(ingredient)

    item.name = item1.name
    item.type = item1.type

    if item1.amount and self.amount then
        item.amount = item1.amount + self.amount
    elseif item1.amount_min and item1.amount_max and self.amount_min and self.amount_max then
        item.amount_min = item1.amount_min + self.amount_min
        item.amount_max = item1.amount_max + self.amount_max
    else
        if item1.amount_min and item1.amount_max and self.amount then
            item.amount_min = item1.amount_min + self.amount
            item.amount_max = item1.amount_max + self.amount
        elseif item1.amount and self.amount_min and self.amount_max then
            item.amount_min = item1.amount + self.amount_min
            item.amount_max = item1.amount + self.amount_max
        end
    end

    if item1.probability and self.probability then
        item.probability = (item1.probability + self.probability) / 2
    elseif item1.probability then
        item.probability = (item1.probability + 1) / 2
    elseif self.probability then
        item.probability = (self.probability + 1) / 2
    end

    self.item = item
    return item
end

---**EN**
---
---Description: Inserts `self` into `listIngredients`, combining (summing amounts) if an entry with the same name already exists.
---
---──────────────────────────────
---
---**FR**
---
---Description: Insère `self` dans `listIngredients`, en combinant (sommant les amounts) si une entrée du même nom existe déjà.
---@param listIngredients table[]
function RitnIngredient:add(listIngredients)
    log("RitnIngredient - add() -> " .. self.name)
    for i, ingredient in pairs(listIngredients) do
        if ingredient[1] == self.name or ingredient.name == self.name then
            self.addit = false
            listIngredients[i] = self:combine(ingredient)
        end
    end

    if self.addit then table.insert(listIngredients, self.item) end
end

---**EN**
---
---Description: Inserts `self` into `listIngredients`, but only if no entry with the same name already exists.
---
---──────────────────────────────
---
---**FR**
---
---Description: Insère `self` dans `listIngredients`, mais seulement si aucune entrée du même nom n'existe déjà.
---@param listIngredients table[]
function RitnIngredient:addNew(listIngredients)
    log("RitnIngredient - addNew() -> " .. self.name)
    for i, ingredient in pairs(listIngredients) do
        if self.name == getItem(ingredient).name then self.addit = false end
    end
    if self.addit then table.insert(listIngredients, self.item) end
end

---**EN**
---
---Description: Removes every entry matching `self.name` from `listIngredients` (by either `[1]` or `.name`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Supprime chaque entrée matchant `self.name` de `listIngredients` (via `[1]` ou `.name`).
---@param listIngredients table[]
function RitnIngredient:remove(listIngredients)
    log("RitnIngredient - remove() -> " .. self.name)
    for i, ingredient in ipairs(listIngredients) do
        if ingredient[1] == self.name or ingredient.name == self.name then
            table.remove(listIngredients, i)
        end
    end
end

---**EN**
---
---Description: Replaces every entry matching `self.name` in `listIngredients` by `self.item` (overwrites in place, no combine).
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace chaque entrée matchant `self.name` dans `listIngredients` par `self.item` (écrase sur place, sans combine).
---@param listIngredients table[]
function RitnIngredient:set(listIngredients)
    log("RitnIngredient - set() -> " .. self.name)
    for i, ingredient in pairs(listIngredients) do
        if ingredient[1] == self.name or ingredient.name == self.name then
            listIngredients[i] = self.item
        end
    end
end

------------------------
return RitnIngredient
