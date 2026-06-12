-- RitnLibForce
----------------------------------------------------------------
local table = require(ritnlib.defines.table)
local util = require(ritnlib.defines.other)
----------------------------------------------------------------


---**EN**
---
---Description: Wraps a `LuaForce` into a short, accessor-rich view.
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate inside each event handler.
---
---⚠ **Factorio 2.0 incompatibility**: `LuaForce.items_launched` and `LuaForce.rockets_launched` were removed in 2.0. The constructor will fail to set those fields on a 2.0 install. To be fixed in R2 (replace with `LuaForce.get_item_launched(name)`).
---
---⚠ **Broken methods**: every `:getStats*` method below currently crashes because `self.stats` is never initialised (its constructor block is commented out). To be fixed in R1.
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Encapsule un `LuaForce` dans une vue raccourcie et riche en accesseurs.
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler d'événement.
---
---⚠ **Incompatibilité Factorio 2.0** : `LuaForce.items_launched` et `LuaForce.rockets_launched` ont été retirés en 2.0. Le constructeur échouera sur ces champs en 2.0. À corriger en R2 (remplacer par `LuaForce.get_item_launched(name)`).
---
---⚠ **Méthodes cassées** : chaque `:getStats*` ci-dessous plante actuellement car `self.stats` n'est jamais initialisé (le bloc constructeur est commenté). À corriger en R1.
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md)
---@class RitnLibForce
---@field force LuaForce                            Wrapped LuaForce (live reference)
---@field name string                               Force name (snapshot, e.g. "player", "enemy")
---@field index uint                                Force index (snapshot)
---@field items_launched table<string, uint>?       ⚠ Removed in Factorio 2.0
---@field rockets_launched uint?                    ⚠ Removed in Factorio 2.0
---@field FORCE_ENEMY_NAME "enemy"                  Constant
---@field FORCE_PLAYER_NAME "player"                Constant
---@field FORCE_NEUTRAL_NAME "neutral"              Constant
---@field isPresent boolean                         `false` when the constructor rejected its input
---@field object_name "RitnLibForce"                Sentinel read by the custom `util.type()`
---@operator call(LuaForce): RitnLibForce
---@type RitnLibForce
RitnLibForce = ritnlib.classFactory.newclass(function(self, LuaForce)
    self.isPresent = false
    if util.type(LuaForce) ~= "LuaForce" then log('not LuaForce !') return end
    if LuaForce.valid == false then return end
    ---
    self.isPresent = true
    self.object_name = "RitnLibForce"
    --------------------------------------------------
    self.force = LuaForce
    self.name = LuaForce.name
    self.index = LuaForce.index
    -----
    --[[ self.stats = {
        production = {
            item = {
                input = LuaForce.item_production_statistics.input_counts,
                output= LuaForce.item_production_statistics.output_counts,
            },
            fluid = {
                input = LuaForce.fluid_production_statistics.input_counts,
                output= LuaForce.fluid_production_statistics.output_counts,
            },
        },
        count = {
            kill = {
                input = LuaForce.kill_count_statistics.input_counts,
                output= LuaForce.kill_count_statistics.output_counts,
            },
            build = {
                input = LuaForce.entity_build_count_statistics.input_counts,
                output= LuaForce.entity_build_count_statistics.output_counts,
            },
        }
    } ]]
    self.items_launched = LuaForce.items_launched
    self.rockets_launched = LuaForce.rockets_launched
    ---- CONSTANTES ----
    self.FORCE_ENEMY_NAME = "enemy"
    self.FORCE_PLAYER_NAME = "player"
    self.FORCE_NEUTRAL_NAME = "neutral"
    --------------------------------------------------
end) --[[@as RitnLibForce]]
----------------------------------------------------------------

---**EN**
---
---Description: Returns the production/consumption count of an item or fluid for this force.
---
---⚠ **Broken** — accesses `self.stats` which is not initialised in this version. Will crash.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le compteur de production/consommation d'un item ou fluide pour cette force.
---
---⚠ **Cassée** — accède à `self.stats` qui n'est pas initialisé dans cette version. Plantera.
---@param name string                Item or fluid prototype name
---@param prodType? "item"|"fluid"   Statistic family (default: "item")
---@param output? boolean            `true` for output_counts, `false`/nil for input_counts (default)
---@return integer?
function RitnLibForce:getStatsProduction(name, prodType, output)
    local target = "input"
    local prod = "item"
    if output then target = "output" end
    if prodType == "fluid" then prod = "fluid" end

    if name == nil then return nil end
    if type(name) ~= "string" then return nil end

    if self.stats.production[prod][target][name] == nil then
        return 0
    else
        return self.stats.production[prod][target][name]
    end

end


---**EN**
---
---Description: Shortcut for `getStatsProduction(name, "item", output)`. ⚠ Broken, see parent method.
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour `getStatsProduction(name, "item", output)`. ⚠ Cassée, cf. méthode parente.
---@param name string
---@param output? boolean
---@return integer?
function RitnLibForce:getStatsProductionItem(name, output)
    return self:getStatsProduction(name, "item", output)
end


---**EN**
---
---Description: Shortcut for `getStatsProduction(name, "fluid", output)`. ⚠ Broken, see parent method.
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour `getStatsProduction(name, "fluid", output)`. ⚠ Cassée, cf. méthode parente.
---@param name string
---@param output? boolean
---@return integer?
function RitnLibForce:getStatsProductionFluid(name, output)
    return self:getStatsProduction(name, "fluid", output)
end


---**EN**
---
---Description: Returns the kill or build count of a given entity name for this force.
---
---⚠ **Broken** — accesses `self.stats` which is not initialised in this version. Will crash.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le nombre de kills ou de constructions d'une entité pour cette force.
---
---⚠ **Cassée** — accède à `self.stats` qui n'est pas initialisé dans cette version. Plantera.
---@param name string
---@param countType? "kill"|"build"    Statistic family (default: "kill")
---@param output? boolean              `true` for output_counts, `false`/nil for input_counts (default)
---@return integer?
function RitnLibForce:getStatsCount(name, countType, output)
    local target = "input"
    local count = "kill"
    if output then target = "output" end
    if countType == "build" then count = "build" end

    if name == nil then return nil end
    if type(name) ~= "string" then return nil end

    if self.stats.count[count][target][name] == nil then
        return 0
    else
        return self.stats.count[count][target][name]
    end
end


---**EN**
---
---Description: Shortcut for `getStatsCount(name, "kill", output)`. ⚠ Broken, see parent method.
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour `getStatsCount(name, "kill", output)`. ⚠ Cassée, cf. méthode parente.
---@param name string
---@param output? boolean
---@return integer?
function RitnLibForce:getStatsCountKill(name, output)
    return self:getStatsCount(name, "kill", output)
end

---**EN**
---
---Description: Shortcut for `getStatsCount(name, "build", output)`. ⚠ Broken, see parent method.
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour `getStatsCount(name, "build", output)`. ⚠ Cassée, cf. méthode parente.
---@param name string
---@param output? boolean
---@return integer?
function RitnLibForce:getStatsCountBuild(name, output)
    return self:getStatsCount(name, "build", output)
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

---**EN**
---
---Description: Marks a surface as hidden or visible for this force on the chart.
---
---──────────────────────────────
---
---**FR**
---
---Description: Marque une surface comme masquée ou visible pour cette force sur la carte.
---@param surfaceIdentification SurfaceIdentification
---@param value? boolean             `true` to hide (default), `false` to show
---@return RitnLibForce self  Chainable
function RitnLibForce:setHiddenSurface(surfaceIdentification, value)
    local default = true
    if type(value) == "boolean" then
        default = value
    end
    self.force.set_surface_hidden(surfaceIdentification, default)
    return self
end

---**EN**
---
---Description: Returns a `RitnLibRecipe` wrapping the named recipe.
---
---⚠ Errors if the recipe does not exist.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibRecipe` encapsulant la recette nommée.
---
---⚠ Lève une erreur si la recette n'existe pas.
---@param recipe_name string
---@return RitnLibRecipe
function RitnLibForce:getRecipe(recipe_name)
    if self.force.recipes[recipe_name] then
        return RitnLibRecipe(self.force.recipes[recipe_name])
    end
    error(recipe_name .. " : recipe not exist !")
end


---**EN**
---
---Description: Returns a `RitnLibTechnology` wrapping the named technology.
---
---⚠ Errors if the technology does not exist.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibTechnology` encapsulant la technologie nommée.
---
---⚠ Lève une erreur si la technologie n'existe pas.
---@param tech_name string
---@return RitnLibTechnology
function RitnLibForce:getTechnology(tech_name)
    if self.force.technologies[tech_name] then
        return RitnLibTechnology(self.force.technologies[tech_name])
    end
    error(tech_name .. " : technology not exist !")
end


---**EN**
---
---Description: Returns the number of players in this force.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le nombre de joueurs dans cette force.
---@return integer
function RitnLibForce:countPlayers()
    return #self.force.players
end


---**EN**
---
---Description: Looks up a chart tag by its tag_number at the given position on the given surface.
---
---⚠ Builds a degenerate area `{position, position}` for `find_chart_tags`. May miss tags due to float rounding.
---
---──────────────────────────────
---
---**FR**
---
---Description: Cherche un chart tag par son tag_number à la position donnée sur la surface donnée.
---
---⚠ Construit une zone dégénérée `{position, position}` pour `find_chart_tags`. Peut rater des tags à cause d'arrondis flottants.
---@param tag_number uint
---@param surface_name string|LuaSurface
---@param position MapPosition
---@return LuaCustomChartTag?
function RitnLibForce:getChartTag(tag_number, surface_name, position)
    local area = {
        {position.x, position.y},
        {position.x, position.y},
    }
    local tabTag = game.forces[self.name].find_chart_tags(surface_name, area)

    local tag = nil

    if table.length(tabTag) > 0 then
        log("> chart_tag found: ".. tostring(table.length(tabTag)))

        local index = table.index(tabTag, "tag_number", tag_number)

        if index > 0 then
            tag = tabTag[index]
        end
    else
        log("> chart_tag not find !")
    end

    return tag
end
