-- RitnLibEvent
----------------------------------------------------------------


----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------
local events_filter = {
    position = {
        ["on_chunk_charted"] = true,
        ["on_chunk_generated"] = true,
    }
}
----------------------------------------------------------------


---**EN**
---
---Description: Resolves a Factorio event integer name to its symbolic name via `defines.events`. Special-cases `event.name == 0` as `"on_tick"`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Résout l'entier d'event Factorio en son nom symbolique via `defines.events`. Cas particulier : `event.name == 0` est mappé sur `"on_tick"`.
---@param event EventData
---@return string?
local function getEventName(event)
    for name,ev in pairs(defines.events) do
        if event.name == 0 then return "on_tick" end
        if defines.events[name] ==  event.name then
            return name
        end
    end
end


---**EN**
---
---Description: Extracts `LuaPlayer` from an event using `event.player_index`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Extrait `LuaPlayer` d'un event via `event.player_index`.
---@param event EventData
---@return LuaPlayer?
local function getPlayer(event)
    if event.player_index then
        return game.get_player(event.player_index)
    end
    return nil
end


---**EN**
---
---Description: Extracts a `LuaSurface` from an event using `event.surface_index` or `event.surface`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Extrait une `LuaSurface` d'un event via `event.surface_index` ou `event.surface`.
---@param event EventData
---@return LuaSurface?
local function getSurface(event)
    if event.surface_index then
        return game.get_surface(event.surface_index)
    end
    if event.surface then
        return event.surface
    end
    return nil
end


---**EN**
---
---Description: Extracts a `LuaForce` from an event. Special case for `on_forces_merging`: returns `event.destination`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Extrait une `LuaForce` d'un event. Cas particulier `on_forces_merging` : retourne `event.destination`.
---@param event EventData
---@return LuaForce?
local function getForce(event)
    if event.force then
        return event.force
    end
    if event.name == defines.events.on_forces_merging then
        return event.destination
    end
    return nil
end


---**EN**
---
---Description: Returns `event.recipe` if present.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne `event.recipe` si présent.
---@param event EventData
---@return LuaRecipe?
local function getRecipe(event)
    if event.recipe then
        return event.recipe
    end
    return nil
end


---**EN**
---
---Description: Returns `event.research` if present (technology research events).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne `event.research` si présent (events de recherche de technologies).
---@param event EventData
---@return LuaTechnology?
local function getTech(event)
    if event.research then
        return event.research
    end
    return nil
end


---**EN**
---
---Description: Extracts a `LuaEntity` from an event. Checks `created_entity` first (legacy 1.x), then `vehicle`, then `entity`.
---
---⚠ `event.created_entity` was removed in Factorio 2.0 — only the `event.entity` fallback path is active there.
---
---──────────────────────────────
---
---**FR**
---
---Description: Extrait un `LuaEntity` d'un event. Vérifie `created_entity` (legacy 1.x), puis `vehicle`, puis `entity`.
---
---⚠ `event.created_entity` a été retiré en Factorio 2.0 — seule la branche `event.entity` est active là-bas.
---@param event EventData
---@return LuaEntity?
local function getEntity(event)
    if event.created_entity then
        return event.created_entity
    end
    if event.vehicle then
        return event.vehicle
    end
    if event.entity then
        return event.entity
    end
    return nil
end


---**EN**
---
---Description: Returns `event.robot` if present (robot-built/mined events).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne `event.robot` si présent (events de construction/minage robot).
---@param event EventData
---@return LuaEntity?
local function getRobot(event)
    if event.robot then
        return event.robot
    end
    return nil
end


---**EN**
---
---Description: Returns `event.rocket` if present.
---
---⚠ The Factorio 1.x `on_rocket_launched` payload's `rocket` field was reworked in 2.0.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne `event.rocket` si présent.
---
---⚠ Le champ `rocket` du payload `on_rocket_launched` 1.x a été retravaillé en 2.0.
---@param event EventData
---@return LuaEntity?
local function getRocket(event)
    if event.rocket then
        return event.rocket
    end
    return nil
end


---**EN**
---
---Description: Extracts a `LuaInventory`-like value from an event. Checks `buffer`, `loot`, `items`, `inventory` in that order.
---
---──────────────────────────────
---
---**FR**
---
---Description: Extrait une valeur `LuaInventory` d'un event. Vérifie `buffer`, `loot`, `items`, `inventory` dans cet ordre.
---@param event EventData
---@return LuaInventory?
local function getInventory(event)
    if event.buffer then
        return event.buffer
    end
    if event.loot then
        return event.loot
    end
    if event.items then
        return event.items
    end
    if event.inventory then
        return event.inventory
    end
    return nil
end


---**EN**
---
---Description: Resolves a `defines.gui_type` integer to its symbolic name.
---
---──────────────────────────────
---
---**FR**
---
---Description: Résout un entier `defines.gui_type` en son nom symbolique.
---@param gui_type defines.gui_type
---@return string?
local function getGuiType(gui_type)
    for name,_ in pairs(defines.gui_type) do
        if defines.gui_type[name] == gui_type then
            return name
        end
    end
end


---**EN**
---
---Description: Returns the most relevant position from the event payload (`cursor_position` first, then `position`). Returns nil for events listed in `events_filter.position` (e.g. chunk events where `position` is not the user-relevant one).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne la position la plus pertinente du payload (`cursor_position` en priorité, puis `position`). Retourne nil pour les events listés dans `events_filter.position` (ex: events de chunk où `position` n'est pas la position utilisateur attendue).
---@param event EventData
---@param name? string  Resolved event name (used to apply per-event filtering)
---@return MapPosition?
local function getPosition(event, name)
    if event.cursor_position then
        return event.cursor_position
    end
    if not events_filter.position[name] then
        return event.position
    end
end


local string = require(ritnlib.defines.string)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Normalises any Factorio event payload into a uniform view, exposing the most commonly accessed fields as direct properties.
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate inside each event handler.
---
---⚠ Some fields are 1.x-only (`created_entity`, `rocket`, …). See the individual extractor warnings.
---
---⚠ Does not yet cover Space Age events (`on_space_platform_*`, `on_player_changed_planet`, `on_segment_*`, `on_object_destroyed`, …).
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Normalise n'importe quel payload d'event Factorio en une vue uniforme, exposant les champs les plus consultés comme propriétés directes.
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler d'événement.
---
---⚠ Certains champs sont 1.x uniquement (`created_entity`, `rocket`, …). Voir les warnings des extracteurs individuels.
---
---⚠ Ne couvre pas encore les events Space Age (`on_space_platform_*`, `on_player_changed_planet`, `on_segment_*`, `on_object_destroyed`, …).
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md)
---@class RitnLibEvent
---@field isPresent boolean                         `false` if the constructor received `nil`
---@field mod_name string                           Name of the consuming mod (defaults to "RitnLib")
---@field event EventData                           Original event payload (preserved verbatim)
---@field name string                               Symbolic event name (e.g. "on_player_created"), or `"on_tick"` if `event.name == 0`
---@field index uint                                Numeric event id (alias for `event.name`)
---@field object_name "RitnLibEvent"                Sentinel read by the custom `util.type()`
---@field player LuaPlayer?                         Extracted via `event.player_index`
---@field surface LuaSurface?                       Extracted via `event.surface_index` or `event.surface`
---@field force LuaForce?                           Extracted via `event.force` (or `event.destination` for `on_forces_merging`)
---@field recipe LuaRecipe?                         Extracted via `event.recipe`
---@field technology LuaTechnology?                 Extracted via `event.research`
---@field entity LuaEntity?                         Extracted via `event.created_entity` (1.x) / `vehicle` / `entity`
---@field robot LuaEntity?                          Extracted via `event.robot`
---@field rocket LuaEntity?                         Extracted via `event.rocket` (legacy 1.x)
---@field inventory LuaInventory?                   Extracted via `buffer` / `loot` / `items` / `inventory`
---@field cause LuaEntity?                          `event.cause` (death events)
---@field reason defines.disconnect_reason?         `event.reason` (player-left events)
---@field queued_count number?                      `event.queued_count` (chunk requests)
---@field gui_type string?                          Symbolic name resolved from `event.gui_type`
---@field source LuaForce?                          `event.source` (force-merging source)
---@field source_name string?                       `event.source_name` (forces-merged source name)
---@field area BoundingBox?                         `event.area` (area-selection events)
---@field element LuaGuiElement?                    `event.element` (GUI events)
---@field setting_name string?                      `event.setting` (mod setting changed)
---@field setting_type string?                      `event.setting_type` (startup / runtime-global / runtime-per-user)
---@field position MapPosition?                     Filtered position (`cursor_position` else `event.position`, except for chunk events)
---@operator call(EventData, string?): RitnLibEvent
---@type RitnLibEvent
RitnLibEvent = ritnlib.classFactory.newclass(function(self, event, mod_name)
    self.isPresent = false
    local modName = "RitnLib"
    if event == nil then return end
    self.isPresent = true
    if mod_name ~= nil then modName = mod_name end
    self.object_name = "RitnLibEvent"
    ---------------------------------
    self.mod_name = modName
    self.event = event
    self.name = string.defaultValue(getEventName(event), "on_tick") -- defines
    self.index = event.name                         -- index
    ---------------------------------
    self.player = getPlayer(event)                  -- (LuaPlayer)
    self.surface = getSurface(event)                -- (LuaSurface)
    self.force = getForce(event)                    -- (LuaForce)
    self.recipe = getRecipe(event)                  -- (LuaRecipe)
    self.technology = getTech(event)                -- (LuaTechnology)
    self.entity = getEntity(event)                  -- (LuaEntity)
    self.robot = getRobot(event)                    -- (LuaEntity)
    self.rocket = getRocket(event)                  -- (LuaEntity)
    self.inventory = getInventory(event)            -- (LuaInventory)
    self.cause = event.cause                        -- (LuaEntity)?
    ----
    self.reason = event.reason                      -- defines.disconnect_reason
    self.queued_count = event.queued_count          -- (number)
    self.gui_type = getGuiType(event.gui_type)
    self.source = event.source                      -- (LuaForce) -> on_forces_merging(event)
    self.source_name = event.source_name            -- (String) -> on_forces_merged(event)
    self.area = event.area                          -- (area :: BoundingBox)
    self.element = event.element                    -- (LuaGuiElement)
    self.setting_name = event.setting               -- (string)
    self.setting_type = event.setting_type          -- (string)
    self.position = getPosition(event, self.name)   -- (MapPosition)
    ----
end) --[[@as RitnLibEvent]]
----------------------------------------------------------------


---**EN**
---
---Description: Returns a `RitnLibSurface` wrapping `self.surface`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibSurface` encapsulant `self.surface`.
---@return RitnLibSurface
function RitnLibEvent:getSurface()
    return RitnLibSurface(self.surface)
end



---**EN**
---
---Description: Returns a `RitnLibPlayer` wrapping `self.player`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibPlayer` encapsulant `self.player`.
---@return RitnLibPlayer
function RitnLibEvent:getPlayer()
    return RitnLibPlayer(self.player)
end



---**EN**
---
---Description: Returns a `RitnLibForce` wrapping `self.force`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibForce` encapsulant `self.force`.
---@return RitnLibForce
function RitnLibEvent:getForce()
    return RitnLibForce(self.force)
end



---**EN**
---
---Description: Returns a `RitnLibTechnology` wrapping `self.technology`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibTechnology` encapsulant `self.technology`.
---@return RitnLibTechnology
function RitnLibEvent:getTechnology()
    return RitnLibTechnology(self.technology)
end


---**EN**
---
---Description: Returns the symbolic name of `self.reason` (the `defines.disconnect_reason` enum value) for player-left events.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le nom symbolique de `self.reason` (la valeur de l'enum `defines.disconnect_reason`) pour les events player-left.
---@return string?  Symbolic name e.g. "quit", "kicked", "banned", "switching_servers", or nil if not matched
function RitnLibEvent:getReason()
    if self.reason == defines.disconnect_reason.quit then
        return "quit"
    elseif self.reason == defines.disconnect_reason.dropped then
        return "dropped"
    elseif self.reason == defines.disconnect_reason.reconnect then
        return "reconnect"
    elseif self.reason == defines.disconnect_reason.wrong_input then
        return "wrong_input"
    elseif self.reason == defines.disconnect_reason.desync_limit_reached	then
        return "desync_limit_reached"
    elseif self.reason == defines.disconnect_reason.cannot_keep_up	then
        return "cannot_keep_up"
    elseif self.reason == defines.disconnect_reason.afk then
        return "afk"
    elseif self.reason == defines.disconnect_reason.kicked	then
        return "kicked"
    elseif self.reason == defines.disconnect_reason.kicked_and_deleted then
        return "kicked_and_deleted"
    elseif self.reason == defines.disconnect_reason.banned	then
        return "banned"
    elseif self.reason == defines.disconnect_reason.switching_servers then
        return "switching_servers"
    end
end


---**EN**
---
---Description: Static helper — calls `remote.call("DiscoScience", "setIngredientColor", ingredient, color)` if the DiscoScience mod is loaded and exposes that interface.
---
---⚠ Despite being declared on `RitnLibEvent`, this is a static utility — call it as `RitnLibEvent.setIngredientColor(...)` not `instance:setIngredientColor(...)`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Helper static — appelle `remote.call("DiscoScience", "setIngredientColor", ingredient, color)` si le mod DiscoScience est chargé et expose cette interface.
---
---⚠ Bien que déclaré sur `RitnLibEvent`, c'est un utilitaire static — appeler comme `RitnLibEvent.setIngredientColor(...)`, pas `instance:setIngredientColor(...)`.
---@param ingredient string  Item name passed to DiscoScience
---@param color Color        Color table (r, g, b, a) passed to DiscoScience
function RitnLibEvent.setIngredientColor(ingredient, color)
    if type(ingredient) == "string" and type(color) == "table" then
        log("RitnLibEvent | setIngredientColor() : ingredient = " .. ingredient)

        if remote.interfaces["DiscoScience"] and remote.interfaces["DiscoScience"]["setIngredientColor"] then
            log("RitnLibEvent | remote call -> DiscoScience - setIngredientColor")
            remote.call("DiscoScience", "setIngredientColor", ingredient, color)
        end
    end
end


---------------------------------
--return RitnLibEvent
