-- RitnStyle
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local color = require("__RitnLib__.core.constants").color
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
    base.color = color
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
    self.style.font_color = self.color.darkgrey
    self.style.hovered_font_color = self.color.darkgrey
    self.style.clicked_font_color = self.color.darkgrey

    return self
end


function RitnStyle:fontColor(color, hovered, clicked)
    local defaultColor = self.color.white
    local optHovered = false
    local optClicked = false

    if type(color) == "string" then 
        if self.color[color] then 
            defaultColor = self.color[color]
        end
    elseif type(color) == "table" then 
        defaultColor = color
    else
        return self
    end

    self.style.font_color = defaultColor

    if hovered ~= nil and type(hovered) == "boolean" then
        optHovered = hovered
    end
    if clicked ~= nil and type(clicked) == "boolean" then
        optClicked = clicked
    end

    if optHovered then
        self.style.hovered_font_color = defaultColor
    end
    if optClicked then
        self.style.clicked_font_color = defaultColor
    end

    return self
end


-- Preset : normal button
function RitnStyle:spriteButton(size)

    local default_size = 32
    if type(size) == "number" then 
        if size ~= nil then default_size = size end
    end
    local width = default_size
    local height = default_size

    if type(size) == "table" then 
        width = size[1]
		height = size[2]
    end 

    self.style.padding = 0
    self.style.minimal_width = width
    self.style.maximal_width = height

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


function RitnStyle:visible(visible)
    log(self.gui_name .. ' > RitnStyle:visible()')
    if type(visible) ~= "boolean" then return self end 

    self.style.visible = visible

    return self
end


-- no padding -> padding = 0
function RitnStyle:noPadding()
    self.style.padding = 0
    
    return self
end

-- all stretchable
function RitnStyle:stretchable()

    self:horizontalStretch()
    self:verticalStretch()
    
    return self
end

-- horizontally stretchable
function RitnStyle:horizontalStretch(value)
    if value ~= nil then
        if type(value) == "boolean" then 
            self.stretch = value
        end
    end

    self.style.horizontally_stretchable = self.stretch
    
    self.stretch = true
    return self
end

-- vertically stretchable
function RitnStyle:verticalStretch(value)
    if value ~= nil then
        if type(value) == "boolean" then 
            self.stretch = value
        end
    end

    self.style.vertically_stretchable = self.stretch
    
    self.stretch = true
    return self
end


-- horizontally stretchable
function RitnStyle:horizontalSpacing(value)
    if value == nil then return self end
    if type(value) ~= "number" then return self end

    self.style.horizontal_spacing = value

    return self
end

-- vertically stretchable
function RitnStyle:verticalSpacing(value)
    if value == nil then return self end
    if type(value) ~= "number" then return self end

    self.style.vertical_spacing = value

    return self
end

function RitnStyle:spacing(horizontal, vertical)
    self:horizontalSpacing(horizontal)
    self:verticalSpacing(vertical)
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

-- set value max height
function RitnStyle:minHeight(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.minimal_height = value
    
    return self
end

-- set value max width
function RitnStyle:minWidth(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.minimal_width = value
    
    return self
end

-- set font
function RitnStyle:font(font)
    if font == nil then return self end 
    if type(font) ~= 'string' then return self end 
    
    self.style.font = font
    
    return self
end

-- set padding
function RitnStyle:padding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self:topPadding(value)
    self:bottomPadding(value)
    self:leftPadding(value)
    self:rightPadding(value)
    
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
