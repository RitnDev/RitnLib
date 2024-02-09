-- RitnSetting
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local json = require('__RitnLib__.lualib.json-functions')
----------------------------------------------------------------


----------------------------------------------------------------
local RitnSetting = class.newclass(function(base, name)
    base.object_name = "RitnSetting"
    -----------------------------------------
    base.name = "insert-setting-name-please"
    if name ~= nil then
        if type(name) == "string" then 
            base.name = name
        end
    end
    -----
    base.dataType = 'bool'
    -----
    base.typeForSetting = 'bool-setting'
    base.defaultValue = false
    -----
    base.data_setting = {
        type = base.dataType,
        name = name,
        default_value = base.defaultValue,
        setting_type = "startup",
    }
    --------------------------------------------------
end)
------------------ CONSTANTES -------------------
RitnSetting.TYPE = {
    bool = "bool",
    int = "int",
    double = "double",
    string = "string",
    color = "color",
}
RitnSetting.VALUE = {
    bool = false,
    int = 0,
    double = 0.0,
    string = "",
    color = {},
}
RitnSetting.SETTING_TYPE = {
    startup = "startup",
    runtime = "runtime-global",
    player = "runtime-per-user",
}
RitnSetting.SETTING_SUFFIX = "-setting"
--------------------------------------------------

function RitnSetting:getType()
    self.dataType = self.TYPE[self.dataType]
    return self.TYPE[self.dataType] .. self.SETTING_SUFFIX
end

function RitnSetting:setType()
    self.typeForSetting = self:getType()
    ----
    self.data_setting.type = self.typeForSetting
    self.data_setting.default_value = self:getDefaultValue()
    ---------------------------------------
    return self
end

--------------------------------------------------

function RitnSetting:getDefaultValue()
    log('> '..self.object_name..':getDefaultValue() -> dataType = '.. self.dataType)
    log('> '..self.object_name..':getDefaultValue() -> self.TYPE[self.dataType] = '.. self.TYPE[self.dataType])
    ---------------------------------------
    return self.VALUE[self.TYPE[self.dataType]]
end

--------------------------------------------------

function RitnSetting:setTypeBoolean()
    self.dataType = self.TYPE.BOOL
    ---------------------------------------
    return self:setType()
end

function RitnSetting:setTypeInteger()
    self.dataType = self.TYPE.INTEGER
    ---------------------------------------
    return self:setType()
end

function RitnSetting:setTypeDouble()
    self.dataType = self.TYPE.DOUBLE
    ---------------------------------------
    return self:setType()
end

function RitnSetting:setTypeString()
    self.dataType = self.TYPE.STRING
    ---------------------------------------
    return self:setType()
end

function RitnSetting:setTypeColor()
    self.dataType = self.TYPE.COLOR
    ---------------------------------------
    return self:setType()
end

--------------------------------------------------

function RitnSetting:setSettingStartup()
    self.data_setting.setting_type = self.SETTING_TYPE.startup
    ---------------------------------------
    return self
end

function RitnSetting:setSettingRuntime()
    self.data_setting.setting_type = self.SETTING_TYPE.runtime
    ---------------------------------------
    return self
end

function RitnSetting:setSettingPlayer()
    self.data_setting.setting_type = self.SETTING_TYPE.player
    ---------------------------------------
    return self
end

--------------------------------------------------

function RitnSetting:setDefaultValueBool(value)
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
function RitnSetting:setOrder(order)
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
function RitnSetting:new()
    self:setType()
    self.data_setting.default_value = self.defaultValue
    ---------------------------------------
    log('> '..self.object_name..':new() -> data_setting = ' .. json.encode(self.data_setting))
    ---------------------------------------
    return data:extend({ self.data_setting })
end



----------------------------------------------------------------
return RitnSetting