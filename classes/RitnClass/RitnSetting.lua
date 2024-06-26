-- RitnLibSetting
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------
local json = require('__RitnLib__.lualib.json-functions')
----------------------------------------------------------------
-- CLASSE DEFINES
----------------------------------------------------------------
local RitnLibSetting = class.newclass(function(self, name)
    self.object_name = "RitnLibSetting"
    -----------------------------------------
    self.name = "insert-setting-name-please"
    if name ~= nil then
        if type(name) == "string" then 
            self.name = name
        end
    end
    -----
    self.dataType = 'bool'
    -----
    self.typeForSetting = 'bool-setting'
    self.defaultValue = false
    -----
    self.data_setting = {
        type = self.dataType,
        name = name,
        default_value = self.defaultValue,
        setting_type = "startup",
    }
    --------------------------------------------------
end)
------------------ CONSTANTES -------------------
RitnLibSetting.TYPE = {
    bool = "bool",
    int = "int",
    double = "double",
    string = "string",
    color = "color",
}
RitnLibSetting.VALUE = {
    bool = false,
    int = 0,
    double = 0.0,
    string = "",
    color = {},
}
RitnLibSetting.SETTING_TYPE = {
    startup = "startup",
    runtime = "runtime-global",
    player = "runtime-per-user",
}
RitnLibSetting.SETTING_SUFFIX = "-setting"
--------------------------------------------------

function RitnLibSetting:getType()
    self.dataType = self.TYPE[self.dataType]
    return self.TYPE[self.dataType] .. self.SETTING_SUFFIX
end

function RitnLibSetting:setType()
    self.typeForSetting = self:getType()
    ----
    self.data_setting.type = self.typeForSetting
    self.data_setting.default_value = self:getDefaultValue()
    ---------------------------------------
    return self
end

--------------------------------------------------

function RitnLibSetting:getDefaultValue()
    log('> '..self.object_name..':getDefaultValue() -> dataType = '.. self.dataType)
    log('> '..self.object_name..':getDefaultValue() -> self.TYPE[self.dataType] = '.. self.TYPE[self.dataType])
    ---------------------------------------
    return self.VALUE[self.TYPE[self.dataType]]
end

--------------------------------------------------

function RitnLibSetting:setTypeBoolean()
    self.dataType = self.TYPE.BOOL
    ---------------------------------------
    return self:setType()
end

function RitnLibSetting:setTypeInteger()
    self.dataType = self.TYPE.INTEGER
    ---------------------------------------
    return self:setType()
end

function RitnLibSetting:setTypeDouble()
    self.dataType = self.TYPE.DOUBLE
    ---------------------------------------
    return self:setType()
end

function RitnLibSetting:setTypeString()
    self.dataType = self.TYPE.STRING
    ---------------------------------------
    return self:setType()
end

function RitnLibSetting:setTypeColor()
    self.dataType = self.TYPE.COLOR
    ---------------------------------------
    return self:setType()
end

--------------------------------------------------

function RitnLibSetting:setSettingStartup()
    self.data_setting.setting_type = self.SETTING_TYPE.startup
    ---------------------------------------
    return self
end

function RitnLibSetting:setSettingRuntime()
    self.data_setting.setting_type = self.SETTING_TYPE.runtime
    ---------------------------------------
    return self
end

function RitnLibSetting:setSettingPlayer()
    self.data_setting.setting_type = self.SETTING_TYPE.player
    ---------------------------------------
    return self
end

--------------------------------------------------

function RitnLibSetting:setDefaultValueBool(value)
    log('> '..self.object_name..':setDefaultValueBool() -> value = ' .. tostring(value))
    if self.dataType ~= self.TYPE.bool then return self end
    if type(value) ~= "boolean" then return self end 
    ---------------------------------------
    self.defaultValue = value
    ---------------------------------------
    return self
end

--------------------------------------------------
-- Setter du champ 'order' du settings
function RitnLibSetting:setOrder(order)
    if order == nil then return self end 
    if type(order) ~= "string" then return self end 

    self.data_setting.order = order
    ---------------------------------------
    log('> '..self.object_name..':setOrder('.. order ..')') 
    ---------------------------------------

    return self
end

--------------------------------------------------
-- création du nouveau setting
function RitnLibSetting:new()
    self:setType()
    self.data_setting.default_value = self.defaultValue
    ---------------------------------------
    log('> '..self.object_name..':new() -> data_setting = ' .. json.encode(self.data_setting))
    ---------------------------------------
    return data:extend({ self.data_setting })
end



----------------------------------------------------------------
return RitnLibSetting