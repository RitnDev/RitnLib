-- RitnProtoRecipe
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
local RitnProtoItem = require("__RitnLib__.classes.prototypes.Item")
local RitnIngredient = require("__RitnLib__.classes.RitnClass.RitnIngredient")
local constants = require("__RitnLib__.core.constants")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["recipe"][<name>]`. Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua). Provides a full toolkit for mutating recipes: enable/disable, hide/show, ingredient add/remove/set/get/exists/combine, science-pack tint propagation, subgroup propagation to the item counterpart.
---
---Many methods walk the legacy `self.prototype.expensive` and `self.prototype.normal` sub-tables (Factorio 1.x recipe difficulty variants) **in addition to** the flat `self.prototype.ingredients` (Factorio 2.0 canonical). Branches that don't exist on the loaded prototype are simply no-ops.
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["recipe"][<name>]`. Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua). Fournit une boîte à outils complète pour muter les recettes : enable/disable, hide/show, add/remove/set/get/exists/combine d'ingrédients, propagation du tint des packs de science, propagation du subgroup vers l'item correspondant.
---
---Plusieurs méthodes parcourent les sous-tables legacy `self.prototype.expensive` et `self.prototype.normal` (variantes de difficulté Factorio 1.x) **en plus** du `self.prototype.ingredients` plat (canonique Factorio 2.0). Les branches qui n'existent pas sur le prototype chargé sont simplement no-op.
---@class RitnProtoRecipe : RitnPrototype
---@field object_name "RitnProtoRecipe"
---@field listTint string[]                         Ordered list of tint keys (e.g. "red", "automation", "logistic"…) from `core.constants.listTint`
---@field tint table<string, table>                 Tint palette (`{primary, secondary, tertiary, quaternary}` per key) from `core.constants.tint`
---@operator call(string): RitnProtoRecipe
---@type RitnProtoRecipe
local RitnProtoRecipe = class.newclass(RitnProtoBase, function(base, recipe_name)
    -- prototype init
    if recipe_name == nil then return end
    RitnProtoBase.init(base, recipe_name, 'recipe')
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoRecipe"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
    -- constants
    base.listTint = constants.listTint
    base.tint = constants.tint
    --------------------------------------------------
end) --[[@as RitnProtoRecipe]]



--DISABLE RECIPE

---**EN**
---
---Description: Disables and hides the recipe, then sets `flags = {"hidden"}` on the result item (via `RitnProtoItem`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Désactive et cache la recette, puis met `flags = {"hidden"}` sur l'item résultat (via `RitnProtoItem`).
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:disable()
    if self.prototype == nil then return self end
    self.prototype.enabled = false
    self.prototype.hidden = true

    RitnProtoItem(self.prototype.name):changePrototype("hidden", true)

    self:update()
    return self
end

--DISABLE RECIPE

---**EN**
---
---Description: Sets the `enabled` flag on `self.prototype` plus the legacy `normal` and `expensive` branches if present.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le flag `enabled` sur `self.prototype` plus les branches legacy `normal` et `expensive` si présentes.
---@param pValue? boolean   Default true
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:setEnabled(pValue)
    if self.prototype == nil then return self end

    local value = true
    if type(pValue) == 'boolean' then
        value = pValue
    end


    -- Factorio 2.x : la cle "enabled" est souvent absente (defaut true), on l'ecrit toujours
    self.prototype.enabled = value
    log("RitnProtoRecipe:setEnabled -> enabled")

    if self.prototype.normal ~= nil then
        self.prototype.normal.enabled = value
        log("RitnProtoRecipe:setEnabled -> normal.enabled")
    end

    if self.prototype.expensive ~= nil then
        self.prototype.expensive.enabled = value
        log("RitnProtoRecipe:setEnabled -> expensive.enabled")
    end

    self:update()
    return self
end

--DISABLE RECIPE

---**EN**
---
---Description: Sets the `hidden` flag (and optionally `hide_from_player_crafting` / `hide_from_player_stats`) on `self.prototype` and its legacy difficulty branches. If neither `hidden`, `normal`, nor `expensive` matched at the top level, falls back to setting `hidden` on the root prototype.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le flag `hidden` (et optionnellement `hide_from_player_crafting` / `hide_from_player_stats`) sur `self.prototype` et ses branches de difficulté legacy. Si ni `hidden`, `normal`, ni `expensive` ne matche au top level, fallback en définissant `hidden` sur le prototype racine.
---@param value boolean
---@param crafting? any   If non-nil, also sets `hide_from_player_crafting = value`
---@param stats? any      If non-nil, also sets `hide_from_player_stats = value`
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:setHidden(value, crafting, stats)
    log("RitnProtoRecipe:setHidden -> pass !")
    if value == nil then return self end
    if type(value) ~= 'boolean' then return self end
    if self.prototype == nil then return self end
    log("RitnProtoRecipe:setHidden -> prototype ok !")

    local hidden_ok = false

    if self.prototype.hidden ~= nil then
        self.prototype.hidden = value
        log("RitnProtoRecipe:setHidden -> hidden")
        hidden_ok = true
        if crafting ~= nil then
            self.prototype.hide_from_player_crafting = value
        end
        if stats ~= nil then
            self.prototype.hide_from_player_stats = value
        end
    end

    if self.prototype.normal ~= nil then
        self.prototype.normal.hidden = value
        log("RitnProtoRecipe:setHidden -> normal.hidden")
        hidden_ok = true
        if crafting ~= nil then
            self.prototype.normal.hide_from_player_crafting = value
        end
        if stats ~= nil then
            self.prototype.normal.hide_from_player_stats = value
        end
    end

    if self.prototype.expensive ~= nil then
        self.prototype.expensive.hidden = value
        hidden_ok = true
        log("RitnProtoRecipe:setHidden -> expensive.hidden")
        if crafting ~= nil then
            self.prototype.expensive.hide_from_player_crafting = value
        end
        if stats ~= nil then
            self.prototype.expensive.hide_from_player_stats = value
        end
    end

    if hidden_ok == false then
        self.prototype.hidden = value
        log("RitnProtoRecipe:setHidden -> hidden")
        if crafting ~= nil then
            self.prototype.hide_from_player_crafting = value
        end
        if stats ~= nil then
            self.prototype.hide_from_player_stats = value
        end
    end

    self:update()
    return self
end

--REMOVE INGREDIENT

---**EN**
---
---Description: Removes `ingredient` from each of the existing branches (`expensive`, `normal`, `ingredients`) via `RitnIngredient:remove`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retire `ingredient` de chacune des branches existantes (`expensive`, `normal`, `ingredients`) via `RitnIngredient:remove`.
---@param ingredient table|string  Ingredient form (array `{name, amount}` or table `{name=, amount=}` or string `"name"`)
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:removeIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        RitnIngredient(ingredient):remove(self.prototype.expensive.ingredients)
    end
    if self.prototype.normal then
        RitnIngredient(ingredient):remove(self.prototype.normal.ingredients)
    end
    if self.prototype.ingredients then
        RitnIngredient(ingredient):remove(self.prototype.ingredients)
    end

    self:update()
    return self
end

--REMOVE INGREDIENT

---**EN**
---
---Description: Empties every existing ingredient list (`expensive.ingredients`, `normal.ingredients`, root `ingredients`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Vide chaque liste d'ingrédients existante (`expensive.ingredients`, `normal.ingredients`, `ingredients` racine).
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:removeAllIngredient()
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        self.prototype.expensive.ingredients = {}
    end
    if self.prototype.normal then
        self.prototype.normal.ingredients = {}
    end
    if self.prototype.ingredients then
        self.prototype.ingredients = {}
    end

    self:update()
    return self
end

--ADD NEW INGREDIENT (ignores if exists)

---**EN**
---
---Description: Adds `ingredient` to each existing branch — **ignoring** the addition if the ingredient name already exists. Uses `RitnIngredient:addNew`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute `ingredient` à chaque branche existante — **ignore** l'ajout si l'ingrédient du même nom existe déjà. Utilise `RitnIngredient:addNew`.
---@param ingredient table|string
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:addNewIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        RitnIngredient(ingredient):addNew(self.prototype.expensive.ingredients)
    end
    if self.prototype.normal then
        RitnIngredient(ingredient):addNew(self.prototype.normal.ingredients)
    end
    if self.prototype.ingredients then
        RitnIngredient(ingredient):addNew(self.prototype.ingredients)
    end


    self:update()
    return self
end

--ADD INGREDIENT (increments amount if exists)

---**EN**
---
---Description: Adds `ingredient` to each existing branch — **combines** (sums amounts) if the ingredient name already exists. Uses `RitnIngredient:add`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute `ingredient` à chaque branche existante — **combine** (somme les amounts) si l'ingrédient du même nom existe déjà. Utilise `RitnIngredient:add`.
---@param ingredient table|string
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:addIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        RitnIngredient(ingredient):add(self.prototype.expensive.ingredients)
    end
    if self.prototype.normal then
        RitnIngredient(ingredient):add(self.prototype.normal.ingredients)
    end
    if self.prototype.ingredients then
        RitnIngredient(ingredient):add(self.prototype.ingredients)
    end

    self:update()
    return self
end

--SET INGREDIENT

---**EN**
---
---Description: Replaces in place every entry matching the ingredient's name across each existing branch. Uses `RitnIngredient:set`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace sur place chaque entrée matchant le nom de l'ingrédient dans chaque branche existante. Utilise `RitnIngredient:set`.
---@param ingredient table|string
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:setIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        RitnIngredient(ingredient):set(self.prototype.expensive.ingredients)
    end
    if self.prototype.normal then
        RitnIngredient(ingredient):set(self.prototype.normal.ingredients)
    end
    if self.prototype.ingredients then
        RitnIngredient(ingredient):set(self.prototype.ingredients)
    end


    self:update()
    return self
end

---**EN**
---
---Description: Returns the normalised `item` payload for the first ingredient matching `ingredient` (a name string) across the three branches.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le payload `item` normalisé du premier ingrédient matchant `ingredient` (un nom string) à travers les trois branches.
---@param ingredient string
---@return table?  RitnIngredient.item payload, or nil if not found
function RitnProtoRecipe:getIngredient(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        for _, ingredient1 in pairs(self.prototype.expensive.ingredients) do
            if RitnIngredient(ingredient1).name == ingredient then
                return RitnIngredient(ingredient1).item
            end
        end
    end
    if self.prototype.normal then
        for _, ingredient1 in pairs(self.prototype.expensive.normal) do
            if RitnIngredient(ingredient1).name == ingredient then
                return RitnIngredient(ingredient1).item
            end
        end
    end
    if self.prototype.ingredients then
        for _, ingredient1 in pairs(self.prototype.ingredients) do
            if RitnIngredient(ingredient1).name == ingredient then
                return RitnIngredient(ingredient1).item
            end
        end
    end

    return nil
end

--INGREDIENT EXISTE (return boolean)

---**EN**
---
---Description: Returns true if any ingredient matching `ingredient` (a name string) exists in any of the three branches.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si un ingrédient matchant `ingredient` (un nom string) existe dans n'importe laquelle des trois branches.
---@param ingredient string
---@return boolean
function RitnProtoRecipe:ingredientExiste(ingredient)
    if self.prototype == nil then return self end

    if self.prototype.expensive then
        for _, ingredient1 in pairs(self.prototype.expensive.ingredients) do
            if RitnIngredient(ingredient1).name == ingredient then
                return true
            end
        end
    end
    if self.prototype.normal then
        for _, ingredient1 in pairs(self.prototype.expensive.normal) do
            if RitnIngredient(ingredient1).name == ingredient then
                return true
            end
        end
    end
    if self.prototype.ingredients then
        for _, ingredient1 in pairs(self.prototype.ingredients) do
            if RitnIngredient(ingredient1).name == ingredient then
                return true
            end
        end
    end

    return false
end

---**EN**
---
---Description: Sets a tint-typed parameter on `self.prototype` (typically `"crafting_machine_tint"`) by name (`"red"`, `"green"`, `"automation"`, …) — looked up in `self.tint`. No-op if `tint` isn't a known key.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit un paramètre typé tint sur `self.prototype` (typiquement `"crafting_machine_tint"`) par nom (`"red"`, `"green"`, `"automation"`, …) — recherché dans `self.tint`. No-op si `tint` n'est pas une clé connue.
---@param parameter string   Prototype field name (e.g. "crafting_machine_tint")
---@param tint string        Tint key (e.g. "red", "automation")
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:changeTint(parameter, tint)
    if self.prototype == nil then return self end
    if self.prototype[parameter] == nil then return self end
    if type(tint) ~= "string" then return self end
    if self.listTint[tint] == nil then return self end

    self.prototype[parameter] = self.tint[tint]
    self:update()
    return self
end

---**EN**
---
---Description: Auto-detects whether the recipe is a science pack (name ending in `"-science-pack"`) and, if so, matches the leading word against `self.listTint` to apply `:changeTint("crafting_machine_tint", <tint>)`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Auto-détecte si la recette est un pack de science (nom finissant par `"-science-pack"`) et, si oui, matche le mot de tête contre `self.listTint` pour appliquer `:changeTint("crafting_machine_tint", <tint>)`.
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:updatePackTint()
    if self.prototype == nil then return self end
    local pack = self.prototype.name
    local id = string.len(pack) - 11

    if string.sub(pack, id) ~= "science-pack" then return self end

    for _, tint in pairs(self.listTint) do
        if pack:sub(1, #tint) == tint then
            self:changeTint("crafting_machine_tint", tint)
        end
    end

    return self
end

-- CHANGE SUBGROUP

---**EN**
---
---Description: Sets `prototype.subgroup` (and optionally `order`) on the recipe, and propagates the change to the corresponding item via `RitnProtoItem:changeSubgroup`. Uses `self.name` to find the item; falls back to `prototype.result` if no item is found at that name.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `prototype.subgroup` (et optionnellement `order`) sur la recette, et propage le changement à l'item correspondant via `RitnProtoItem:changeSubgroup`. Utilise `self.name` pour trouver l'item ; fallback sur `prototype.result` si aucun item n'est trouvé à ce nom.
---@param subgroup string
---@param order? string
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:changeSubgroup(subgroup, order)
    if self.prototype == nil then return self end

    self.prototype.subgroup = subgroup
    if order ~= nil then
        self.prototype.order = order
    end

    if RitnProtoItem(self.name).prototype then
        RitnProtoItem(self.name):changeSubgroup(subgroup, order)
    elseif self.prototype.result then
        RitnProtoItem(self.prototype.result):changeSubgroup(subgroup, order)
    end

    self:update()
    return self
end

-- CATEGORIES

---**EN**
---
---Description: Replaces `prototype.categories` (Factorio 2.1+, replaces the removed `category` / `additional_categories`). Accepts a single category name or a list. Also clears the legacy `category` / `additional_categories` keys if present.
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace `prototype.categories` (Factorio 2.1+, remplace `category` / `additional_categories` supprimés). Accepte un nom de catégorie seul ou une liste. Supprime aussi les clés legacy `category` / `additional_categories` si présentes.
---@param categories string|string[]
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:setCategories(categories)
    if self.prototype == nil then return self end
    if type(categories) == "string" then categories = { categories } end
    if type(categories) ~= "table" then return self end

    self.prototype.categories = table.deepcopy(categories)
    self.prototype.category = nil
    self.prototype.additional_categories = nil

    self:update()
    return self
end


---**EN**
---
---Description: Appends a category to `prototype.categories` if not already present. If the recipe has no `categories`, starts from `{"crafting"}` (the engine default).
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute une catégorie à `prototype.categories` si elle n'y est pas déjà. Si la recette n'a pas de `categories`, part de `{"crafting"}` (le défaut du moteur).
---@param category string
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:addCategory(category)
    if self.prototype == nil then return self end
    if type(category) ~= "string" then return self end

    local categories = self.prototype.categories or { "crafting" }
    for _, existing in pairs(categories) do
        if existing == category then return self end
    end
    table.insert(categories, category)

    return self:setCategories(categories)
end

--REPLACE INGREDIENT

---**EN**
---
---Description: Replaces the ingredient named `old_name` by `new_ingredient` in each existing branch. If `new_ingredient` is a string, the old entry's amount is kept and the type is detected from the new name (fluid or item); if it is a table, it is used as-is. If the new ingredient already exists in the list, amounts are combined (`RitnIngredient:add`). No-op on branches that don't contain `old_name`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace l'ingrédient nommé `old_name` par `new_ingredient` dans chaque branche existante. Si `new_ingredient` est une string, l'amount de l'ancienne entrée est conservé et le type est déduit du nouveau nom (fluide ou item) ; si c'est une table, elle est utilisée telle quelle. Si le nouvel ingrédient existe déjà dans la liste, les amounts sont combinés (`RitnIngredient:add`). No-op sur les branches qui ne contiennent pas `old_name`.
---@param old_name string
---@param new_ingredient table|string
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:replaceIngredient(old_name, new_ingredient)
    if self.prototype == nil then return self end

    local function replace(list)
        if list == nil then return end
        local old = nil
        for _, ingredient in pairs(list) do
            if RitnIngredient(ingredient).name == old_name then
                old = RitnIngredient(ingredient)
                break
            end
        end
        if old == nil then return end

        local new = new_ingredient
        if type(new) == "string" then
            new = { name = new, amount = old.amount, amount_min = old.amount_min, amount_max = old.amount_max }
        end

        old:remove(list)
        RitnIngredient(new):add(list)
    end

    if self.prototype.expensive then replace(self.prototype.expensive.ingredients) end
    if self.prototype.normal then replace(self.prototype.normal.ingredients) end
    replace(self.prototype.ingredients)

    self:update()
    return self
end

--RESULTS

---**EN**
---
---Description: Adds `result` to `prototype.results` — **combines** (sums amounts, averages `independent_probability`) if a result of the same name already exists. Creates `results` if missing. Uses `RitnIngredient:add`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute `result` à `prototype.results` — **combine** (somme les amounts, moyenne `independent_probability`) si un résultat du même nom existe déjà. Crée `results` s'il n'existe pas. Utilise `RitnIngredient:add`.
---@param result table|string  Product form (`{type=, name=, amount=, independent_probability=}` or `"name"`)
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:addResult(result)
    if self.prototype == nil then return self end

    self.prototype.results = self.prototype.results or {}
    RitnIngredient(result):add(self.prototype.results)

    self:update()
    return self
end


---**EN**
---
---Description: Removes every result matching `result`'s name from `prototype.results`. Uses `RitnIngredient:remove`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retire chaque résultat matchant le nom de `result` de `prototype.results`. Utilise `RitnIngredient:remove`.
---@param result table|string
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:removeResult(result)
    if self.prototype == nil then return self end
    if self.prototype.results == nil then return self end

    RitnIngredient(result):remove(self.prototype.results)

    self:update()
    return self
end


---**EN**
---
---Description: Replaces in place every result matching `result`'s name in `prototype.results` (no combine). Uses `RitnIngredient:set`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace sur place chaque résultat matchant le nom de `result` dans `prototype.results` (sans combine). Utilise `RitnIngredient:set`.
---@param result table|string
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:setResult(result)
    if self.prototype == nil then return self end
    if self.prototype.results == nil then return self end

    RitnIngredient(result):set(self.prototype.results)

    self:update()
    return self
end

--PRODUCTIVITY

---**EN**
---
---Description: Sets `prototype.allow_productivity` (Factorio 2.0+, replaces the removed module `limitation` lists). `value` defaults to `true`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `prototype.allow_productivity` (Factorio 2.0+, remplace les listes `limitation` des modules supprimées). `value` vaut `true` par défaut.
---@param value? boolean
---@return RitnProtoRecipe self  Chainable
function RitnProtoRecipe:setProductivity(value)
    if self.prototype == nil then return self end

    self.prototype.allow_productivity = value ~= false

    self:update()
    return self
end

return RitnProtoRecipe
