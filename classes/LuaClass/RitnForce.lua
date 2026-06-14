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
---ℹ `LuaForce.items_launched` (Read, dictionary item→count) and `LuaForce.rockets_launched` (Read|Write uint) are still available in Factorio 2.0; the constructor reads them directly.
---
---⚠ **`:getStats*` methods — incomplete, disabled pending the Factorio 2.0 migration**: `self.stats` is built from the 1.x statistics API (`LuaForce.item_production_statistics.input_counts` …), reworked in 2.0, so its constructor block is commented out — these methods would error on a base instance (`self.stats` is nil). The only intended consumer (RitnLeaderboard, which rebuilds `self.stats` in a subclass) is still in development. See migration-2.0.md.
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
---ℹ `LuaForce.items_launched` (Read, dictionnaire item→count) et `LuaForce.rockets_launched` (Read|Write uint) sont toujours disponibles en Factorio 2.0 ; le constructeur les lit directement.
---
---⚠ **Méthodes `:getStats*` — incomplètes, désactivées en attendant la migration Factorio 2.0** : `self.stats` est construit depuis l'API statistics 1.x (`LuaForce.item_production_statistics.input_counts` …), retravaillée en 2.0, donc son bloc constructeur est commenté — ces méthodes lèveraient une erreur sur une instance de base (`self.stats` est nil). Le seul consommateur prévu (RitnLeaderboard, qui reconstruit `self.stats` dans une sous-classe) est encore en développement. Cf. migration-2.0.md.
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md)
---@class RitnLibForce
---@field force LuaForce                            Wrapped LuaForce (live reference)
---@field name string                               Force name (snapshot, e.g. "player", "enemy")
---@field index uint                                Force index (snapshot)
---@field items_launched table<string, uint>?       Items launched in rockets (Read, dict item→count) — present in 2.0
---@field rockets_launched uint?                    Rockets launched (Read|Write uint) — present in 2.0
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
---⚠ Requires `self.stats`, built from the 1.x statistics API (disabled for the 2.0 migration — see class note). Relies on a subclass populating `self.stats`; returns 0 for unknown names.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le compteur de production/consommation d'un item ou fluide pour cette force.
---
---⚠ Requiert `self.stats`, construit depuis l'API statistics 1.x (désactivée pour la migration 2.0 — cf. note de classe). Repose sur une sous-classe qui peuple `self.stats` ; retourne 0 pour les noms inconnus.
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
---Description: Shortcut for `getStatsProduction(name, "item", output)`. ⚠ Depends on `self.stats` like its parent (see class note).
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour `getStatsProduction(name, "item", output)`. ⚠ Dépend de `self.stats` comme sa méthode parente (cf. note de classe).
---@param name string
---@param output? boolean
---@return integer?
function RitnLibForce:getStatsProductionItem(name, output)
    return self:getStatsProduction(name, "item", output)
end


---**EN**
---
---Description: Shortcut for `getStatsProduction(name, "fluid", output)`. ⚠ Depends on `self.stats` like its parent (see class note).
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour `getStatsProduction(name, "fluid", output)`. ⚠ Dépend de `self.stats` comme sa méthode parente (cf. note de classe).
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
---⚠ Requires `self.stats`, built from the 1.x statistics API (disabled for the 2.0 migration — see class note). Relies on a subclass populating `self.stats`; returns 0 for unknown names.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le nombre de kills ou de constructions d'une entité pour cette force.
---
---⚠ Requiert `self.stats`, construit depuis l'API statistics 1.x (désactivée pour la migration 2.0 — cf. note de classe). Repose sur une sous-classe qui peuple `self.stats` ; retourne 0 pour les noms inconnus.
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
---Description: Shortcut for `getStatsCount(name, "kill", output)`. ⚠ Depends on `self.stats` like its parent (see class note).
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour `getStatsCount(name, "kill", output)`. ⚠ Dépend de `self.stats` comme sa méthode parente (cf. note de classe).
---@param name string
---@param output? boolean
---@return integer?
function RitnLibForce:getStatsCountKill(name, output)
    return self:getStatsCount(name, "kill", output)
end

---**EN**
---
---Description: Shortcut for `getStatsCount(name, "build", output)`. ⚠ Depends on `self.stats` like its parent (see class note).
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour `getStatsCount(name, "build", output)`. ⚠ Dépend de `self.stats` comme sa méthode parente (cf. note de classe).
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
