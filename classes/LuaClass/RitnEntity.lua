-- RitnLibEntity
----------------------------------------------------------------
local util = require(ritnlib.defines.other)
local stringUtils = require(ritnlib.defines.constants).strings
local colors = require(ritnlib.defines.constants).color
local string = require(ritnlib.defines.string)
----------------------------------------------------------------

---**EN**
---
---Description: Returns the `LuaPlayer` controlling the entity if it is a character, nil otherwise.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le `LuaPlayer` qui contrôle l'entité si c'est un character, nil sinon.
---@param isCharacter boolean
---@param LuaEntity LuaEntity
---@return LuaPlayer?
local function getPlayer(isCharacter, LuaEntity)
    local player
    pcall(function()
        player = util.ifElse(isCharacter, LuaEntity.player, nil)
    end)
    return player
end

---**EN**
---
---Description: Returns the driver of the entity if it is a car, nil otherwise.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le conducteur de l'entité si c'est une car, nil sinon.
---@param isCar boolean
---@param LuaEntity LuaEntity
---@return LuaEntity|LuaPlayer|nil
local function getDriver(isCar, LuaEntity)
    local driver
    pcall(function()
        driver = util.ifElse(isCar, LuaEntity.get_driver(), nil)
    end)
    return driver
end

---**EN**
---
---Description: Returns the passenger of the entity if it allows passengers, nil otherwise.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le passager de l'entité si elle accepte des passagers, nil sinon.
---@param allowsPassenger boolean
---@param LuaEntity LuaEntity
---@return LuaEntity|LuaPlayer|nil
local function getPassenger(allowsPassenger, LuaEntity)
    local passenger
    pcall(function()
        passenger = util.ifElse(allowsPassenger, LuaEntity.get_passenger(), nil)
    end)
    return passenger
end

----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Wraps a `LuaEntity` into a short, accessor-rich view.
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate inside each event handler.
---
---⚠ **Known bugs**: `:getSurface()` and `:getForce()` call `RitnlibSurface(...)` / `RitnlibForce(...)` with the wrong casing (lowercase `lib` instead of `Lib`). Both currently crash. To be fixed in R1.
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Encapsule un `LuaEntity` dans une vue raccourcie et riche en accesseurs.
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler d'événement.
---
---⚠ **Bugs connus** : `:getSurface()` et `:getForce()` appellent `RitnlibSurface(...)` / `RitnlibForce(...)` avec la mauvaise casse (`lib` minuscule au lieu de `Lib`). Les deux plantent actuellement. À corriger en R1.
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md)
---@class RitnLibEntity
---@field entity LuaEntity                          Wrapped LuaEntity (live reference)
---@field name string                               Entity prototype name (snapshot)
---@field id uint?                                  Alias for `unit_number`
---@field unit_number uint?                         Entity unit number (nil for entities without one)
---@field type string                               Entity type (snapshot, e.g. "character", "car", "assembling-machine")
---@field prototype LuaEntityPrototype              Live prototype reference
---@field surface LuaSurface                        Surface at instantiation time
---@field force LuaForce                            Force at instantiation time
---@field position MapPosition                      Position at instantiation time (snapshot)
---@field backer_name string?                       Backer name if applicable
---@field isCharacter boolean                       `true` if `type == "character"`
---@field isCar boolean                             `true` if `type == "car"`
---@field isSpiderVehicle boolean                   `true` if `type == "spider-vehicle"`
---@field allowsPassenger boolean                   `true` if the entity can carry a passenger (car or spider-vehicle)
---@field player LuaPlayer?                         Player controlling the entity if it is a character
---@field drive LuaEntity|LuaPlayer|nil             Driver if isCar (entity or player)
---@field passenger LuaEntity|LuaPlayer|nil         Passenger if allowsPassenger
---@field TOKEN_EMPTY_STRING string                 Constant
---@field isPresent boolean                         `false` when the constructor rejected its input
---@field object_name "RitnLibEntity"               Sentinel read by the custom `util.type()`
---@operator call(LuaEntity): RitnLibEntity
---@type RitnLibEntity
RitnLibEntity = ritnlib.classFactory.newclass(function(self, LuaEntity)
    self.isPresent = false
    -- check input params
    if util.type(LuaEntity) ~= "LuaEntity" then
        --log('LuaEntity parameter is not type LuaEntity -> ( type = ' .. util.type(LuaEntity) .. ')')
        return
    end
    if LuaEntity.valid == false then log('not LuaEntity valid !') return end
    ----
    self.isPresent = true
    self.object_name = "RitnLibEntity"
    --------------------------------------------------
    self.entity = LuaEntity
    ----
    self.name = LuaEntity.name
    self.id = LuaEntity.unit_number
    self.unit_number = LuaEntity.unit_number
    self.type = LuaEntity.type
    ----
    self.prototype = LuaEntity.prototype
    self.surface = LuaEntity.surface
    self.force = LuaEntity.force
    self.position = LuaEntity.position
    self.backer_name = LuaEntity.backer_name
    ----
    self.isCharacter = (self.type == 'character')
    self.isCar = (self.type == 'car')
    self.isSpiderVehicle = (self.type == 'spider-vehicle')
    self.allowsPassenger = self.isCar or self.isSpiderVehicle
    ----
    self.player = getPlayer(self.isCharacter, LuaEntity)                -- nil or (LuaPlayer) LuaEntity is character of LuaPlayer
    self.drive = getDriver(self.isCar, LuaEntity)                       -- nil or (LuaEntity) or (LuaPlayer ?)
    self.passenger = getPassenger(self.allowsPassenger, LuaEntity)      -- nil or (LuaEntity) or (LuaPlayer ?)
    --------------------------------------------------
    self.TOKEN_EMPTY_STRING = stringUtils.empty
end) --[[@as RitnLibEntity]]

----------------------------------------------------------------


---**EN**
---
---Description: Returns a `RitnLibSurface` wrapping this entity's surface.
---
---⚠ **Broken** — calls `RitnlibSurface(...)` (lowercase `lib`) which is not a global. Will crash. To be fixed in R1.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibSurface` encapsulant la surface de l'entité.
---
---⚠ **Cassée** — appelle `RitnlibSurface(...)` (`lib` minuscule) qui n'est pas un global. Plantera. À corriger en R1.
---@return RitnLibSurface
function RitnLibEntity:getSurface()
    return RitnlibSurface(self.surface)
end


---**EN**
---
---Description: Returns a `RitnLibForce` wrapping this entity's force.
---
---⚠ **Broken** — calls `RitnlibForce(...)` (lowercase `lib`) which is not a global. Will crash. To be fixed in R1.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibForce` encapsulant la force de l'entité.
---
---⚠ **Cassée** — appelle `RitnlibForce(...)` (`lib` minuscule) qui n'est pas un global. Plantera. À corriger en R1.
---@return RitnLibForce
function RitnLibEntity:getForce()
    return RitnlibForce(self.force)
end


---**EN**
---
---Description: Returns true if the wrapped entity exists and is named exactly `name`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si l'entité existe et porte exactement le nom `name`.
---@param name string
---@return boolean
function RitnLibEntity:existByName(name)
    if self.entity == nil then return false end
    if self.name ~= name then log("entity.name is't " .. tostring(name) .. " -> (".. self.name ..")") return false end

    return true
end


---**EN**
---
---Description: Returns true if the vehicle currently has a driver (entity or player).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si le véhicule a un conducteur (entité ou joueur).
---@return boolean
function RitnLibEntity:isDriver()
    local rFlag = false

    if (util.type(self.drive) == "LuaEntity") then
        rFlag = true
    elseif (util.type(self.drive) == "LuaPlayer") then
        log('driver is LuaPlayer')
        rFlag = true
    end

    log('LuaEntity has a driver ? ' .. tostring(rFlag))

    return rFlag
end



---**EN**
---
---Description: Returns true if the vehicle currently has a passenger.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si le véhicule a un passager.
---@return boolean
function RitnLibEntity:isPassenger()
    local rFlag = false

    if (util.type(self.passenger) == "LuaEntity") then
        rFlag = true
    elseif (util.type(self.passenger) == "LuaPlayer") then
        log('passenger is LuaPlayer')
        rFlag = true
    end

    log('LuaEntity has a passenger ? ' .. tostring(rFlag))

    return rFlag
end



---**EN**
---
---Description: Returns true if the given LuaPlayer is the driver of this entity.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si le LuaPlayer donné est le conducteur de cette entité.
---@param LuaPlayer LuaPlayer
---@return boolean
function RitnLibEntity:playerIsDriver(LuaPlayer)
    local rFlag = false

    if (util.type(LuaPlayer) == 'LuaPlayer') then
        if LuaPlayer.driving and self:isDriver() then
            if self.drive.name == LuaPlayer.name then
                rFlag = true
            elseif self.drive.type == "character" then
                if self.drive.player.name == LuaPlayer.name then
                    rFlag = true
                end
            end
        end
    else
        log("RitnLibEntity:playerIsDriver(param) -> param is't LuaPlayer => (" .. util.type(LuaPlayer) .. ")")
    end

    log('LuaPlayer is driver ? -> ' .. tostring(rFlag))

    return rFlag
end



---**EN**
---
---Description: Returns true if the given LuaPlayer is the passenger of this entity.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si le LuaPlayer donné est le passager de cette entité.
---@param LuaPlayer LuaPlayer
---@return boolean
function RitnLibEntity:playerIsPassenger(LuaPlayer)
    local rFlag = false

    if (util.type(LuaPlayer) == 'LuaPlayer') then
        if LuaPlayer.driving and self:isPassenger() then
            if self.passenger.name == LuaPlayer.name then
                rFlag = true
            elseif self.passenger.type == "character" then
                if self.passenger.player.name == LuaPlayer.name then
                    rFlag = true
                end
            end
        end
    else
        log("RitnLibEntity:playerIsPassenger(param) -> param is't LuaPlayer => (" .. util.type(LuaPlayer) .. ")")
    end

    log('LuaPlayer is passenger ? -> ' .. tostring(rFlag))

    return rFlag
end


---**EN**
---
---Description: Sets the LuaPlayer as the passenger of this entity if it allows passengers.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le LuaPlayer comme passager de cette entité si elle l'autorise.
---@param LuaPlayer LuaPlayer
function RitnLibEntity:setPassenger(LuaPlayer)
    if util.type(LuaPlayer) == 'LuaPlayer' then
        if self.allowsPassenger then
            self.entity.set_passenger(LuaPlayer)
        end
    end
end


---**EN**
---
---Description: Sets the `minable` flag on the entity.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le flag `minable` sur l'entité.
---@param value? boolean    `true` to allow mining (default), `false` to forbid
function RitnLibEntity:setMinable(value)
    local default = true
    if util.type(value) == 'boolean' then
        default = value
    end

    self.entity.minable = default
end


---**EN**
---
---Description: Sets the `destructible` flag on the entity.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le flag `destructible` sur l'entité.
---@param value? boolean    `true` to allow destruction (default), `false` to forbid
function RitnLibEntity:setDestructible(value)
    local default = true
    if util.type(value) == 'boolean' then
        default = value
    end

    self.entity.destructible = default
end


---**EN**
---
---Description: Destroys the entity after restoring `minable` and `destructible` to `true`.
---
---⚠ The `setMinable/setDestructible` calls are redundant since `destroy()` ignores both flags. Legacy from a previous use case.
---
---──────────────────────────────
---
---**FR**
---
---Description: Détruit l'entité après avoir restauré `minable` et `destructible` à `true`.
---
---⚠ Les appels `setMinable/setDestructible` sont redondants car `destroy()` ignore ces flags. Héritage d'un ancien cas d'usage.
function RitnLibEntity:destroy()
    self:setMinable()
    self:setDestructible()
    self.entity.destroy()
end
