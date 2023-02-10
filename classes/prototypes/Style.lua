-- RitnProtoStyle
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------



----------------------------------------------------------------
local RitnProtoStyle = class.newclass(RitnProtoBase, function(base, style_name)
    -- prototype init
    RitnProtoBase.init(base, "default", "gui-style")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoStyle"
    base.style_name = style_name
    ----
    if data.raw[base.type][base.name] == nil then return end
    if base.style_name ~= nil then
        if data.raw[base.type][base.name][base.style_name] == nil then return end
        base.prototype = table.deepcopy(data.raw[base.type][base.name][base.style_name])
    else
        base.prototype = table.deepcopy(data.raw[base.type][base.name])
    end
    ----
    base.style = {
        type = "",
        name = "",
        parent = "",
        padding = 0,
        size = {40, 40}
    }
    --------------------------------------------------
end)


function RitnProtoStyle:setType(type_gui)
    if type(type_gui) ~= 'string' then return self end
    self.style.type = type_gui

    return self
end

function RitnProtoStyle:setName(name)
    if type(name) ~= 'string' then return self end
    self.style.name = name

    return self
end

function RitnProtoStyle:setParent(parent)
    if type(parent) ~= 'string' then return self end
    self.style.parent = parent

    return self
end

function RitnProtoStyle:setPadding(padding)
    if type(padding) ~= 'number' then return self end
    self.style.padding = padding

    return self
end



function RitnProtoStyle:extend()
    if self.type == '' then error('style not init ! (type)') return end
    if self.name == '' then error('style not init ! (name)') return end

    self.prototype[self.style.name] = self.style

    self:update()
end


function RitnProtoStyle:extendButton(name, parent, size)
    if type(name) ~= 'string' then return self end
    if type(parent) ~= 'string' then return self end

    if size ~= nil then 
        if type(size) == 'number' then self.style.size = {size, size} end
        if type(size) == 'table' then self.style.size = size end
    end 

    self.style.type = 'button_style'
    self.style.name = name
    self.style.parent = parent
 
    self:extend()
end


-- UPDATE PROTOTYPE
function RitnProtoStyle:update()
    if data.raw[self.type][self.name] == nil then return self end
    if self.prototype == nil then return self end
    if self.style_name ~= nil then 
        data.raw[self.type][self.name][self.style_name] = self.prototype
    else
        data.raw[self.type][self.name] = self.prototype
    end
end



return RitnProtoStyle