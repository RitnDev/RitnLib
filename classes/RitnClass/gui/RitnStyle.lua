-- RitnStyle
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------


local RitnStyle = class.newclass(function(base, LuaGuiElement)
    -- base
    base.object_name = "RitnStyle"
    base.style = LuaGuiElement.style
    ----
    base.stretch = true
    base.visible = false
    base.center = "center"
    ----
    base.color = {
        darkGrey = {0.109804, 0.109804, 0.109804}
    }
    ----
    base.alignH = base.center 
    base.alignV = base.center
    --------------------------------------------------
end)



-- Preset : Label
function RitnStyle:label()
    self.style.minimal_height = 25
    return self
end


-- Preset : scrollpane
function RitnStyle:scrollpane()
    self.style.minimal_height = 220
    self.style.horizontally_stretchable = self.stretch
    return self
end


-- Preset : listbox
function RitnStyle:listbox()
    self.style.minimal_height = 220
    self.style.maximal_height = 220
    self.style.horizontally_stretchable = self.stretch
    return self
end


-- Preset : small button
function RitnStyle:smallButton()
    
    self.style.height = 30
    self.style.horizontally_stretchable = self.stretch
    self.style.minimal_width = 90
    self.style.maximal_width = 100

    return self
end

-- Preset : normal button
function RitnStyle:normalButton()

    self.style.horizontally_stretchable = self.stretch
    self.style.minimal_height = 45
    self.style.minimal_width = 200

    return self
end

-- Preset : normal button
function RitnStyle:menuButton()
    self:normalButton()
    self.style.minimal_width = 220
    self.style.font_color = color
    self.style.hovered_font_color = color
    self.style.clicked_font_color = color

    return self
end


-- Preset : normal button
function RitnStyle:spriteButton()

    self.style.padding = 0
    self.style.minimal_width = 32
    self.style.maximal_width = 32

    return self
end

-- Preset : button close
function RitnStyle:closeButton()

    self:smallButton()
    self.style.width = 100

    return self
end

-- Preset : standard frame
function RitnStyle:frame()

    self.style.left_padding = 4
    self.style.right_padding = 4
    self.style.bottom_padding = 4
    self.style.maximal_height = 338
    self.style.maximal_width = 220

    return self
end

-- Preset : strait Frame
function RitnStyle:straitFrame()
    self:standardFrame() 
    self.style.minimal_width = 220
    self.style.maximal_height = 310
    
    return self
end

-- no padding -> padding = 0
function RitnStyle:noPadding()
    self.style.padding = 0
    
    return self
end

-- all stretchable
function RitnStyle:stretchable()
    self.style.horizontally_stretchable = self.stretch
    self.style.vertically_stretchable = self.stretch
    
    return self
end

-- alignment (default center)
function RitnStyle:align(valueH, valueV)
    if valueH ~= nil then self.alignH = valueH end
    if valueV ~= nil then self.alignV = valueV end

    self.style.horizontal_align = self.alignH
    self.style.vertical_align = self.alignV
    
    return self
end


--------------------------------

-- set value width & height
function RitnStyle:size(width, height)
    self:width(width)
    self:height(height)
    
    return self
end

-- set value width
function RitnStyle:width(width)
    if width == nil then return self end 
    if type(width) ~= 'number' then return self end 
    
    self.style.width = width
    
    return self
end

function RitnStyle:height(height)
    if height == nil then return self end 
    if type(height) ~= 'number' then return self end 
    
    self.style.height = height
    
    return self
end


-- set value max height
function RitnStyle:maxHeight(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.maximal_height = value
    
    return self
end

-- set value max width
function RitnStyle:maxWidth(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.maximal_width = value
    
    return self
end

-- set font
function RitnStyle:font(font)
    if font == nil then return self end 
    if type(font) ~= 'string' then return self end 
    
    self.style.font = font
    
    return self
end

-- set top_padding
function RitnStyle:topPadding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.top_padding = value
    
    return self
end

-- set top_padding
function RitnStyle:bottomPadding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.bottom_padding = value
    
    return self
end

-- set top_padding
function RitnStyle:leftPadding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.left_padding = value
    
    return self
end

-- set top_padding
function RitnStyle:rightPadding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.right_padding = value
    
    return self
end


----------------------------------------------------------------
return RitnStyle
