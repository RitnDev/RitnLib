-- RitnLibSurface
----------------------------------------------------------------
local table = require(ritnlib.defines.table)
local string = require(ritnlib.defines.string)
local util = require(ritnlib.defines.other)
----------------------------------------------------------------
local entity_types = require("__RitnLib__.lualib.vanilla.types_entity")
----------------------------------------------------------------


---**EN**
---
---Description: Wraps a `LuaSurface` into a short, accessor-rich view.
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate inside each event handler.
---
---If the input is not a valid `LuaSurface`, the constructor sets `self.isPresent = false` and leaves every other field uninitialised.
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Encapsule un `LuaSurface` dans une vue raccourcie et riche en accesseurs.
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler d'événement.
---
---Si l'entrée n'est pas un `LuaSurface` valide, le constructeur met `self.isPresent = false` et laisse tous les autres champs non initialisés.
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md)
---@class RitnLibSurface
---@field surface LuaSurface                Wrapped LuaSurface (live reference)
---@field name string                       Surface name (snapshot, e.g. "nauvis", "vulcanus")
---@field index uint                        Surface index (snapshot)
---@field isNauvis boolean                  `true` if `name == "nauvis"` at instantiation (Space Age planets return `false`)
---@field isPresent boolean                 `false` when the constructor rejected its input
---@field object_name "RitnLibSurface"      Sentinel read by the custom `util.type()`
---@operator call(LuaSurface): RitnLibSurface
---@type RitnLibSurface
RitnLibSurface = ritnlib.classFactory.newclass(function(self, LuaSurface)
    self.isPresent = false
    if util.type(LuaSurface) ~= "LuaSurface" then
        log('not LuaSurface !')
        return
    end
    if LuaSurface.valid == false then return end
    ----
    self.isPresent = true
    self.object_name = "RitnLibSurface"
    --------------------------------------------------
    self.surface = LuaSurface
    self.name = LuaSurface.name
    self.index = LuaSurface.index
    self.isNauvis = (LuaSurface.name == "nauvis")
    --------------------------------------------------
    --log('> [RITNLIB] > RitnLibSurface')
end) --[[@as RitnLibSurface]]
----------------------------------------------------------------


---**EN**
---
---Description: Prints text broadcast to every player on the surface.
---
---Tables are serialised via `serpent.block`. Non-string/non-table values fall back to `tostring` inside a `pcall`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Imprime un texte diffusé à chaque joueur présent sur la surface.
---
---Les tables sont sérialisées via `serpent.block`. Les valeurs non-string/non-table tombent en `tostring` dans un `pcall`.
---@param text string|table
---@return RitnLibSurface self  Chainable
function RitnLibSurface:print(text)
    if type(text) == "table" then
        self.surface.print(serpent.block(text))
        return self
    end
    if type(text) ~= "string" then
        pcall(function()
            self.surface.print(tostring(text))
        end)
        return self
    end

    self.surface.print(text)
    return self
end

---**EN**
---
---Description: Finds a specific entity on the surface by position and unit_number, with optional name/type filters.
---
---Strategy: `find_entities_filtered{position, name?, type?}` → look up `unit_number` in the result list → fall back to first match → fall back to `find_entity(name, position)`.
---
---⚠ This method writes the result to the **global** variable `LuaEntity` (no `local`). Side effect to be aware of. To be fixed in a future refactor.
---
---⚠ On Factorio 2.0, prefer `game.get_entity_by_unit_number(n)` when you already have the `unit_number` — it's O(1) instead of O(entities-in-area).
---
---──────────────────────────────
---
---**FR**
---
---Description: Trouve une entité précise sur la surface par position et unit_number, avec filtres optionnels par nom/type.
---
---Stratégie : `find_entities_filtered{position, name?, type?}` → recherche du `unit_number` dans la liste → fallback sur le premier match → fallback sur `find_entity(name, position)`.
---
---⚠ Cette méthode écrit le résultat dans la variable **globale** `LuaEntity` (pas de `local`). Effet de bord à prendre en compte. À corriger lors d'un refactor futur.
---
---⚠ Sur Factorio 2.0, préférer `game.get_entity_by_unit_number(n)` quand on a déjà le `unit_number` — c'est O(1) au lieu de O(entités-dans-la-zone).
---@param position MapPosition           Centre de la recherche (doit avoir `.x` et `.y`)
---@param unit_number uint               Unit number
---@param name? string                   Optional: filter by entity name
---@param entityType? string             Optional: filter by entity type (must be in `lualib.vanilla.types_entity`)
---@return LuaEntity?                    The matching entity, or nil if nothing was found
function RitnLibSurface:getEntity(position, unit_number, name, entityType)
    log('> ' ..
    self.object_name ..
    ':getEntity(unit_number: ' ..
    tostring(unit_number) .. ', name: ' .. tostring(name) .. ', entityType: ' .. tostring(entityType) .. ')')
    if not table.isPosition(position) then
        log("not position or nil")
        return nil
    end
    if type(unit_number) == "nil" then
        log("unit_number is't an number, is: " .. type(unit_number))
        return nil
    end

    -- enregistrement des valeurs de recherche, par défaut seulement la position
    local search = {
        position = position,
    }

    -- si le nom de l'entité est renseigné, on l'ajoute au critère de recherche
    if type(name) == "string" then search.name = name end
    -- si le type est renseigné et exite, on l'ajoute au critère de recherche
    local vEntityType = string.defaultValue(entityType)
    if vEntityType ~= string.TOKEN_EMPTY_STRING then
        if table.indexOf(entity_types, vEntityType) > 0 then
            search.type = vEntityType
        else
            log("not entityType available")
        end
    end

    -- on lance la recherche -> retourne un tableau d'entité
    local tabEntities = self.surface.find_entities_filtered(search)

    -- On récupère l'entité avec son unit_number dans la liste
    if table.length(tabEntities) > 0 then
        log("> LuaEntity found: " .. tostring(table.length(tabEntities)))

        local index = table.index(tabEntities, "unit_number", unit_number)

        if index > 0 then
            LuaEntity = tabEntities[index]
        else
            -- au cas où on retourne le premier de la liste
            LuaEntity = tabEntities[1] or self.surface.find_entity(name, position)
        end
    else
        log("> LuaEntity not find !")
    end

    return LuaEntity
end

----------------------------------------------------------------
--return RitnLibSurface
