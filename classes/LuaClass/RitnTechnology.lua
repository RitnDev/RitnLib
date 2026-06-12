-- RitnLibTechnology
----------------------------------------------------------------
local util = require(ritnlib.defines.other)


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Wraps a `LuaTechnology` (the runtime, per-force technology instance — not the data-stage prototype).
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate inside each event handler.
---
---For data-stage technology mutation (changing science packs, prerequisites, unlocked recipes) use [`RitnProtoTechnology`](../../docs/en/reference/prototype/RitnProtoTechnology.md) instead.
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Encapsule une `LuaTechnology` (l'instance runtime, par force — pas le prototype data-stage).
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler d'événement.
---
---Pour modifier la techno au data stage (packs de science, pré-requis, recettes débloquées) utiliser [`RitnProtoTechnology`](../../docs/fr/reference/prototype/RitnProtoTechnology.md) à la place.
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md)
---@class RitnLibTechnology
---@field technology LuaTechnology              Wrapped LuaTechnology (live reference)
---@field name string                           Technology name (snapshot)
---@field force LuaForce                        Force the technology belongs to (snapshot)
---@field entity_type string                    Default entity type targeted by `:updateRecipe` (default: "assembling-machine")
---@field isPresent boolean                     `false` when the constructor rejected its input
---@field object_name "RitnLibTechnology"       Sentinel read by the custom `util.type()`
---@operator call(LuaTechnology): RitnLibTechnology
---@type RitnLibTechnology
RitnLibTechnology = ritnlib.classFactory.newclass(function(self, LuaTechnology)
    self.isPresent = false
    if util.type(LuaTechnology) ~= "LuaTechnology" then log('not LuaTechnology !') return end
    if LuaTechnology.valid == false then return end
    ----
    self.isPresent = true
    self.object_name = "RitnLibTechnology"
    --------------------------------------------------
    self.technology = LuaTechnology
    ----
    self.name = LuaTechnology.name
    self.force = LuaTechnology.force
    ----
    self.entity_type = "assembling-machine"
    --------------------------------------------------
end) --[[@as RitnLibTechnology]]

----------------------------------------------------------------

---**EN**
---
---Description: On research finish, disables a set of recipes and reassigns crafting machines that were using one of those recipes to a replacement recipe.
---
---Used in this pattern:
---```lua
---script.on_event(defines.events.on_research_finished, function(event)
---    RitnLibTechnology(event.research):updateRecipe(
---        "automation-2",
---        { "old-recipe-1", "old-recipe-2" },
---        "new-recipe"
---    )
---end)
---```
---
---⚠ **Performance**: walks every surface and every entity of the matching type. O(surfaces × entities). On Space Age with multiple planets, this iterates across all of them — consider scoping by surface in a future refactor.
---
---⚠ **Factorio 2.0**: `LuaEntity.set_recipe` now accepts a quality parameter. This method does not yet pass quality through.
---
---──────────────────────────────
---
---**FR**
---
---Description: Sur fin de recherche, désactive un ensemble de recettes et reassigne les machines qui utilisaient l'une de ces recettes vers une recette de remplacement.
---
---Pattern d'usage :
---```lua
---script.on_event(defines.events.on_research_finished, function(event)
---    RitnLibTechnology(event.research):updateRecipe(
---        "automation-2",
---        { "old-recipe-1", "old-recipe-2" },
---        "new-recipe"
---    )
---end)
---```
---
---⚠ **Performance** : parcourt chaque surface et chaque entité du type ciblé. O(surfaces × entités). En Space Age avec plusieurs planètes, parcourt toutes les planètes — à scoper par surface dans un refactor futur.
---
---⚠ **Factorio 2.0** : `LuaEntity.set_recipe` accepte maintenant un paramètre de qualité. Cette méthode ne le transmet pas encore.
---@param techFinished string                  Technology name to match against `self.name` — no-op if mismatch
---@param disableTabRecipes string[]           List of recipe names to disable
---@param setRecipe string                     Replacement recipe name to set on matching entities
---@param entityType? string                   Optional: override `self.entity_type` (default: "assembling-machine")
---@return RitnLibTechnology self  Chainable
function RitnLibTechnology:updateRecipe(techFinished, disableTabRecipes, setRecipe, entityType)
    if self.name ~= techFinished then return self end
    if entityType ~= nil then self.entity_type = entityType end


    for _, disableRecipe in pairs(disableTabRecipes) do
        self.technology.force.recipes[disableRecipe].enabled = false
    end

    -- Actualise la recette dans toutes les entités sur toutes les surfaces
    for _, surface in pairs(game.surfaces) do
        for _, machine in pairs(surface.find_entities_filtered{type=self.entity_type, force=self.technology.force.name}) do
            if machine.get_recipe() ~= nil then
                for _, disableRecipe in pairs(disableTabRecipes) do
                    if machine.get_recipe().name == disableRecipe then
                        machine.set_recipe(setRecipe)
                    end
                end
            end
        end
    end

    return self
end




----------------------------------------------------------------
--return RitnLibTechnology
