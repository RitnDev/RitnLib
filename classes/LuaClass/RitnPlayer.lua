-- RitnLibPlayer
----------------------------------------------------------------
local util = require(ritnlib.defines.other)

----------------------------------------------------------------
--- FUNCTIONS
----------------------------------------------------------------

---**EN**
---
---Description: Resolves a `controller_type` integer into its symbolic name from `defines.controllers`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Résout un entier `controller_type` en son nom symbolique depuis `defines.controllers`.
---@param LuaPlayer LuaPlayer
---@return string?  Controller name (e.g. "character", "god", "editor"), or nil if not found
local function getControllerName(LuaPlayer)
    for name, _ in pairs(defines.controllers) do
        if defines.controllers[name] == LuaPlayer.controller_type then
            return name
        end
    end
end

----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Wraps a `LuaPlayer` into a short, accessor-rich view.
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate inside each event handler.
---
---If the input is not a valid `LuaPlayer`, the constructor sets `self.isPresent = false` and leaves every other field uninitialised.
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Encapsule un `LuaPlayer` dans une vue raccourcie et riche en accesseurs.
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler d'événement.
---
---Si l'entrée n'est pas un `LuaPlayer` valide, le constructeur met `self.isPresent = false` et laisse tous les autres champs non initialisés.
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md)
---@class RitnLibPlayer
---@field player LuaPlayer                          Wrapped LuaPlayer (live reference)
---@field index uint                                Player index (snapshot at instantiation)
---@field name string                               Player name (snapshot)
---@field surface LuaSurface                        Surface at instantiation time — may become stale
---@field force LuaForce                            Force at instantiation time — may become stale
---@field controller_type defines.controllers       Controller integer (snapshot)
---@field controller_name string?                   Symbolic name resolved from `controller_type`
---@field character LuaEntity?                      Player's character entity, `nil` in god/editor controllers
---@field admin boolean                             Snapshot — may change at runtime
---@field driving boolean                           Snapshot — may change at runtime
---@field vehicle LuaEntity?                        Vehicle being driven, `nil` otherwise
---@field connected boolean                         Snapshot — may change at runtime
---@field isPresent boolean                         `false` when the constructor rejected its input
---@field object_name "RitnLibPlayer"               Sentinel read by the custom `util.type()`
---@operator call(LuaPlayer): RitnLibPlayer
---@type RitnLibPlayer
RitnLibPlayer = ritnlib.classFactory.newclass(function(self, LuaPlayer)
    -- check input params
    self.isPresent = false
    if util.type(LuaPlayer) ~= "LuaPlayer" then
        log('not LuaPlayer !')
        return
    end
    if LuaPlayer.valid == false then
        log('not LuaPlayer valid !')
        return
    end
    if LuaPlayer.is_player() == false then
        log('not LuaPlayer !')
        return
    end
    ----
    self.isPresent = true
    self.object_name = "RitnLibPlayer"
    --------------------------------------------------
    self.player = LuaPlayer
    self.index = LuaPlayer.index
    self.surface = LuaPlayer.surface
    self.force = LuaPlayer.force
    self.controller_type = LuaPlayer.controller_type
    self.controller_name = getControllerName(LuaPlayer)
    self.character = LuaPlayer.character
    self.admin = LuaPlayer.admin
    self.driving = LuaPlayer.driving
    self.vehicle = LuaPlayer.vehicle
    ----
    self.name = LuaPlayer.name
    self.connected = LuaPlayer.connected
    --------------------------------------------------
end) --[[@as RitnLibPlayer]]

----------------------------------------------------------------

---**EN**
---
---Description: Prints text to the wrapped player.
---
---Tables are serialised via `serpent.block`. Non-string/non-table values fall back to `tostring` inside a `pcall`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Imprime un texte au joueur encapsulé.
---
---Les tables sont sérialisées via `serpent.block`. Les valeurs non-string/non-table tombent en `tostring` dans un `pcall`.
---@param text string|table
---@return RitnLibPlayer self  Chainable
function RitnLibPlayer:print(text)
    if type(text) == "table" then
        self.player.print(serpent.block(text))
        return self
    end
    if type(text) ~= "string" then
        pcall(function()
            self.player.print(tostring(text))
        end)
        return self
    end

    self.player.print(text)
    return self
end

---**EN**
---
---Description: Returns a `RitnLibForce` wrapping this player's force (snapshot).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibForce` encapsulant la force du joueur (snapshot).
---@return RitnLibForce
function RitnLibPlayer:getForce()
    return RitnLibForce(self.force)
end

---**EN**
---
---Description: Returns a `RitnLibSurface` wrapping this player's surface (snapshot).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibSurface` encapsulant la surface du joueur (snapshot).
---@return RitnLibSurface
function RitnLibPlayer:getSurface()
    return RitnLibSurface(self.surface)
end

---**EN**
---
---Description: Cancels every entry in the player's crafting queue.
---
---⚠ Wrapped in `pcall` — errors are silently swallowed.
---
---──────────────────────────────
---
---**FR**
---
---Description: Annule toutes les entrées de la file de craft du joueur.
---
---⚠ Encapsulé dans `pcall` — les erreurs sont silencieusement ignorées.
function RitnLibPlayer:cancel_all_crafting()
    pcall(function()
        while self.player.crafting_queue_size > 0 do
            self.player.cancel_crafting({
                index = self.player.crafting_queue[1].index,
                count = self.player.crafting_queue[1].count
            })
        end
    end)
end

---**EN**
---
---Description: Returns `true` if the player is currently on the `nauvis` surface.
---
---⚠ Returns `false` on Space Age planets (vulcanus/fulgora/gleba/aquilo) and on space platforms.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne `true` si le joueur est actuellement sur la surface `nauvis`.
---
---⚠ Retourne `false` sur les planètes Space Age (vulcanus/fulgora/gleba/aquilo) et sur les plateformes spatiales.
---@return boolean
function RitnLibPlayer:onNauvis()
    return self.surface.name == 'nauvis'
end
