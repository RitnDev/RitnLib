---------------------------------------------------------------------------------------------
-- LUALIB : ENTITY INFO
---------------------------------------------------------------------------------------------
-- FR : Lecture de ce qu'une entité sait faire, sans liste de types : inventaires rangés par rôle (carburant, entrée,
--      sortie, modules…), état du jeu (texte et couleur), progression, santé, fluides, recettes acceptées. Une entité
--      d'un autre mod fonctionne donc sans code dédié. Étape control uniquement.
-- EN : Reads what an entity can do, without a list of types: inventories sorted by role (fuel, input, output,
--      modules…), game state (text and colour), progress, health, fluids, accepted recipes. An entity of another mod
--      thus works without dedicated code. Control stage only.
---------------------------------------------------------------------------------------------

---**EN**
---
---Description: One inventory of an entity, with its role.
---
---──────────────────────────────
---
---**FR**
---
---Description: Un inventaire d'une entité, avec son rôle.
---@class RitnLibEntityInventory
---@field id defines.inventory       Inventory index
---@field name string                Key of defines.inventory (e.g. "assembling_machine_input")
---@field role string                "fuel", "burnt", "input", "output", "modules", "ammo", "main" or "trash"
---@field inventory LuaInventory

---**EN**
---
---Description: One fluid storage of an entity.
---
---──────────────────────────────
---
---**FR**
---
---Description: Un stockage de fluide d'une entité.
---@class RitnLibEntityFluid
---@field index integer      Index of the storage (LuaEntity.get_fluid)
---@field name? string       Fluid inside, nil if empty
---@field amount number      Amount inside
---@field capacity number    Capacity of the storage

---**EN**
---
---Description: Game state of an entity, ready to show.
---
---──────────────────────────────
---
---**FR**
---
---Description: État du jeu d'une entité, prêt à afficher.
---@class RitnLibEntityStatus
---@field name string              Key of defines.entity_status (e.g. "no_power")
---@field caption LocalisedString  Text of the game
---@field level string             "ok", "warning" or "alert"
---@field color Color              Colour of the level

---**EN**
---
---Description: Reads what an entity can do.
---
---──────────────────────────────
---
---**FR**
---
---Description: Lecture de ce qu'une entité sait faire.
---@class RitnLibEntityInfo
---@field ROLES string[]                  Roles of the inventories, in display order
---@field COLORS table<string, Color>     Colour of each status level
local entityInfo = {}

-- FR : Rôles des inventaires, dans l'ordre d'affichage
-- EN : Roles of the inventories, in display order
entityInfo.ROLES = { "fuel", "burnt", "input", "output", "modules", "ammo", "main", "trash" }

-- FR : Couleur de chaque niveau d'état
-- EN : Colour of each status level
entityInfo.COLORS = {
    ok = { r = 0.35, g = 0.9, b = 0.35 },
    warning = { r = 1, g = 0.67, b = 0.24 },
    alert = { r = 1, g = 0.3, b = 0.25 },
}

-- FR : Rôle selon le nom de l'inventaire : premier motif trouvé dans le nom, "main" sinon
-- EN : Role by the inventory name: first pattern found in the name, "main" otherwise
local ROLE_PATTERNS = {
    { pattern = "burnt", role = "burnt" },
    { pattern = "fuel", role = "fuel" },
    { pattern = "trash", role = "trash" },
    { pattern = "dump", role = "trash" },
    { pattern = "modules", role = "modules" },
    { pattern = "ammo", role = "ammo" },
    { pattern = "source", role = "input" },
    { pattern = "input", role = "input" },
    { pattern = "result", role = "output" },
    { pattern = "output", role = "output" },
}

-- FR : États qui vont bien, états d'alerte (la machine ne peut plus travailler) ; les autres sont des avertissements
-- EN : States that are fine, alert states (the machine cannot work any more); the others are warnings
local STATUS_OK = {
    working = true,
    normal = true,
    charging = true,
    fully_charged = true,
    discharging = true,
    armed = true,
}
local STATUS_ALERT = {
    no_power = true,
    no_fuel = true,
    broken = true,
    frozen = true,
    no_minable_resources = true,
    not_plugged_in_eletric_network = true,
    no_research_in_progress = true,
    missing_required_fluid = true,
}


---**EN**
---
---Description: Role of an inventory from its name.
---
---──────────────────────────────
---
---**FR**
---
---Description: Rôle d'un inventaire d'après son nom.
---@param name string   Key of defines.inventory
---@return string role
function entityInfo.role(name)
    for _, entry in ipairs(ROLE_PATTERNS) do
        if name:find(entry.pattern, 1, true) then
            return entry.role
        end
    end
    return "main"
end


---**EN**
---
---Description: Inventories of the entity that have at least one slot, sorted by role (ROLES order), then by index.
---
---──────────────────────────────
---
---**FR**
---
---Description: Inventaires de l'entité qui ont au moins une case, rangés par rôle (ordre de ROLES), puis par numéro.
---@param entity LuaEntity
---@return RitnLibEntityInventory[]
function entityInfo.inventories(entity)
    local rank = {}
    for position, role in ipairs(entityInfo.ROLES) do
        rank[role] = position
    end

    local list = {}
    for id = 1, entity.get_max_inventory_index() do
        local inventory = entity.get_inventory(id)

        -- FR : Inventaire absent ou sans case (ex. machine sans recette)
        -- EN : Missing inventory or without a slot (e.g. machine without a recipe)
        if inventory ~= nil and #inventory > 0 then
            local name = entity.get_inventory_name(id) or ""
            list[#list + 1] = { id = id, name = name, role = entityInfo.role(name), inventory = inventory }
        end
    end
    table.sort(list, function(a, b)
        if rank[a.role] ~= rank[b.role] then
            return rank[a.role] < rank[b.role]
        end
        return a.id < b.id
    end)
    return list
end


---**EN**
---
---Description: Game state of the entity (text of the game, level and colour), or nil if it has none.
---
---──────────────────────────────
---
---**FR**
---
---Description: État du jeu de l'entité (texte du jeu, niveau et couleur), ou nil si elle n'en a pas.
---@param entity LuaEntity
---@return RitnLibEntityStatus?
function entityInfo.status(entity)
    local status = entity.status

    -- FR : Entité sans état
    -- EN : Entity without a state
    if status == nil then
        return nil
    end

    -- FR : Nom de l'état : la clé de defines.entity_status qui a cette valeur
    -- EN : State name: the key of defines.entity_status that has this value
    local name = nil
    for key, value in pairs(defines.entity_status) do
        if value == status then
            name = key
        end
    end
    if name == nil then
        return nil
    end

    local level = "warning"
    if STATUS_OK[name] then
        level = "ok"
    elseif STATUS_ALERT[name] then
        level = "alert"
    end
    return {
        name = name,
        caption = { "entity-status." .. name:gsub("_", "-") },
        level = level,
        color = entityInfo.COLORS[level],
    }
end


---**EN**
---
---Description: Progress of the entity in [0, 1] (crafting machine, mining drill), or nil if it has none.
---
---──────────────────────────────
---
---**FR**
---
---Description: Progression de l'entité dans [0, 1] (machine de fabrication, foreuse), ou nil si elle n'en a pas.
---@param entity LuaEntity
---@return number?
function entityInfo.progress(entity)
    -- FR : Machine de fabrication
    -- EN : Crafting machine
    if entity.prototype.crafting_categories ~= nil then
        return entity.crafting_progress
    end

    -- FR : Foreuse : temps de minage de sa cible, 0 sans cible
    -- EN : Mining drill: mining time of its target, 0 without a target
    if entity.type == "mining-drill" then
        local target = entity.mining_target
        if target == nil then
            return 0
        end
        return math.min(1, entity.mining_progress / target.prototype.mineable_properties.mining_time)
    end
    return nil
end


---**EN**
---
---Description: Health of the entity in [0, 1], or nil if it has none.
---
---──────────────────────────────
---
---**FR**
---
---Description: Santé de l'entité dans [0, 1], ou nil si elle n'en a pas.
---@param entity LuaEntity
---@return number?
function entityInfo.health(entity)
    -- FR : Entité sans santé
    -- EN : Entity without health
    if not entity.is_entity_with_health then
        return nil
    end
    return entity.get_health_ratio()
end


---**EN**
---
---Description: Fluid storages of the entity that have a capacity. A crafting machine has some only for its recipe.
---
---──────────────────────────────
---
---**FR**
---
---Description: Stockages de fluide de l'entité qui ont une capacité. Une machine de fabrication n'en a que pour sa recette.
---@param entity LuaEntity
---@return RitnLibEntityFluid[]
function entityInfo.fluids(entity)
    local list = {}
    for index = 1, entity.fluids_count do
        local capacity = entity.get_fluid_capacity(index)

        -- FR : Stockage sans capacité : rien à montrer
        -- EN : Storage without a capacity: nothing to show
        if capacity > 0 then
            local fluid = entity.get_fluid(index)
            list[#list + 1] = {
                index = index,
                name = fluid and fluid.name or nil,
                amount = fluid and fluid.amount or 0,
                capacity = capacity,
            }
        end
    end
    return list
end


---**EN**
---
---Description: True if a player can choose the recipe of this entity (assembling machine without a fixed recipe; the
---game chooses the recipe of a furnace).
---
---──────────────────────────────
---
---**FR**
---
---Description: Vrai si un joueur peut choisir la recette de cette entité (machine d'assemblage sans recette fixe ; le
---jeu choisit la recette d'un four).
---@param entity LuaEntity
---@return boolean
function entityInfo.hasRecipeChoice(entity)
    return entity.type == "assembling-machine" and entity.prototype.fixed_recipe == nil
end


---**EN**
---
---Description: True if the entity prototype accepts the recipe (a crafting category in common).
---
---──────────────────────────────
---
---**FR**
---
---Description: Vrai si le prototype de l'entité accepte la recette (une catégorie de fabrication en commun).
---@param entity LuaEntity
---@param recipe LuaRecipePrototype
---@return boolean
function entityInfo.acceptsRecipe(entity, recipe)
    local categories = entity.prototype.crafting_categories

    -- FR : Pas une machine de fabrication
    -- EN : Not a crafting machine
    if categories == nil then
        return false
    end
    for key, value in pairs(recipe.categories) do
        local category = type(key) == "string" and key or value
        if categories[category] then
            return true
        end
    end
    return false
end


---**EN**
---
---Description: Recipes already unlocked by the force and accepted by the entity, not hidden.
---
---──────────────────────────────
---
---**FR**
---
---Description: Recettes déjà débloquées par la force et acceptées par l'entité, non cachées.
---@param entity LuaEntity
---@param force LuaForce
---@return LuaRecipePrototype[]
function entityInfo.recipes(entity, force)
    local list = {}
    for _, recipe in pairs(force.recipes) do
        if recipe.enabled and not recipe.hidden and entityInfo.acceptsRecipe(entity, recipe.prototype) then
            list[#list + 1] = recipe.prototype
        end
    end
    return list
end


---@type RitnLibEntityInfo
return entityInfo
