-- RitnLibEntity
----------------------------------------------------------------
local util = require(ritnlib.defines.other)
local stringUtils = require(ritnlib.defines.constants).strings
local colors = require(ritnlib.defines.constants).color
local string = require(ritnlib.defines.string)
----------------------------------------------------------------

local function getPlayer(isCharacter, LuaEntity) 
    local player
    pcall(function() 
        player = util.ifElse(isCharacter, LuaEntity.player, nil) 
    end)
    return player
end

local function getDriver(isCar, LuaEntity) 
    local driver
    pcall(function() 
        driver = util.ifElse(isCar, LuaEntity.get_driver(), nil) 
    end)
    return driver
end

local function getPassenger(allowsPassenger, LuaEntity) 
    local  passenger
    pcall(function() 
        passenger = util.ifElse(allowsPassenger, LuaEntity.get_passenger(), nil) 
    end)
    return passenger
end

----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLibEntity = ritnlib.classFactory.newclass(function(self, LuaEntity)
    -- check input params
    if util.type(LuaEntity) ~= "LuaEntity" then 
        --log('LuaEntity parameter is not type LuaEntity -> ( type = ' .. util.type(LuaEntity) .. ')')
        return 
    end
    if LuaEntity.valid == false then log('not LuaEntity valid !') return end
    ----
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
end)

----------------------------------------------------------------


--Retourne l'objet RitnSurface d'où le portail est posé
function RitnLibEntity:getSurface()
    return RitnlibSurface(self.surface)
end



--Retourne l'objet RitnSurface d'où le portail est posé
function RitnLibEntity:getForce()
    return RitnlibForce(self.force)
end



-- Vérification que RitnLibEntity existe sous ce nom (name)
function RitnLibEntity:existByName(name)
    if self.entity == nil then return false end 
    if self.name ~= name then log("entity.name is't " .. tostring(name) .. " -> (".. self.name ..")") return false end

    return true
end


-- Y a-t-il un conducteur au volant ?
-- @return true -> if the vehicle contains a driver.
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



-- Y a-t-il un conducteur au volant ?
-- @return true -> if the vehicle contains a passenger.
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



-- LuaPlayer is driver of this entity
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



-- LuaPlayer is passenger of this entity
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


-- Sets the passenger of this LuaEntity if possible
function RitnLibEntity:setPassenger(LuaPlayer) 
    if util.type(LuaPlayer) == 'LuaPlayer' then 
        if self.allowsPassenger then 
            self.entity.set_passenger(LuaPlayer)
        end
    end 
end


function RitnLibEntity:setMinable(value) 
    local default = true
    if util.type(value) == 'boolean' then
        default = value
    end

    self.entity.minable = default
end


function RitnLibEntity:setDestructible(value) 
    local default = true
    if util.type(value) == 'boolean' then
        default = value
    end

    self.entity.destructible = default
end


function RitnLibEntity:destroy() 
    self:setMinable() 
    self:setDestructible() 
    self.entity.destroy()
end