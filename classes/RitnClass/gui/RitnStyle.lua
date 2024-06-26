-- RitnLibStyle
----------------------------------------------------------------
local color = require("__RitnLib__.core.constants").color
----------------------------------------------------------------


RitnLibStyle = ritnlib.classFactory.newclass(function(self, LuaGuiElement)
    if LuaGuiElement == nil then return end
    if LuaGuiElement.object_name ~= "LuaGuiElement" then return end

    self.object_name = "RitnLibStyle"
    self.style = LuaGuiElement.style
    ----
    self.stretch = true
    self.visible = false
    self.center = "center"
    ----
    self.color = color
    ----
    self.alignH = self.center 
    self.alignV = self.center
    --------------------------------------------------
end)



-- Preset : Label
function RitnLibStyle:label()
    self.style.minimal_height = 25
    return self
end


-- Preset : scrollpane
function RitnLibStyle:scrollpane()
    self.style.minimal_height = 220
    self.style.horizontally_stretchable = self.stretch
    return self
end


-- Preset : listbox
function RitnLibStyle:listbox()
    self.style.minimal_height = 220
    self.style.maximal_height = 220
    self.style.horizontally_stretchable = self.stretch
    return self
end


-- Preset : small button
function RitnLibStyle:smallButton()
    
    self.style.height = 30
    self.style.horizontally_stretchable = self.stretch
    self.style.minimal_width = 90
    self.style.maximal_width = 100

    return self
end

-- Preset : normal button
function RitnLibStyle:normalButton()

    self.style.horizontally_stretchable = self.stretch
    self.style.minimal_height = 45
    self.style.minimal_width = 200

    return self
end

-- Preset : normal button
function RitnLibStyle:menuButton()
    self:normalButton()
    self.style.minimal_width = 220
    self.style.font_color = self.color.darkgrey
    self.style.hovered_font_color = self.color.darkgrey
    self.style.clicked_font_color = self.color.darkgrey

    return self
end


function RitnLibStyle:fontColor(color, hovered, clicked)
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
function RitnLibStyle:spriteButton(size)

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
    self.style.maximal_width = width
    self.style.minimal_height = height
    self.style.maximal_height = height

    return self
end

-- Preset : button close
function RitnLibStyle:closeButton()

    self:smallButton()
    self.style.width = 100

    return self
end

-- Preset : standard frame
function RitnLibStyle:frame()

    self.style.left_padding = 4
    self.style.right_padding = 4
    self.style.bottom_padding = 4
    self.style.maximal_height = 338
    self.style.maximal_width = 220

    return self
end

-- Preset : strait Frame
function RitnLibStyle:straitFrame()
    self:standardFrame() 
    self.style.minimal_width = 220
    self.style.maximal_height = 310
    
    return self
end


function RitnLibStyle:visible(visible)
    log(self.gui_name .. ' > RitnLibStyle:visible()')
    if type(visible) ~= "boolean" then return self end 

    self.style.visible = visible

    return self
end


-- no padding -> padding = 0
function RitnLibStyle:noPadding()
    self.style.padding = 0
    
    return self
end

-- all stretchable
function RitnLibStyle:stretchable()

    self:horizontalStretch()
    self:verticalStretch()
    
    return self
end

-- horizontally stretchable
function RitnLibStyle:horizontalStretch(value)
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
function RitnLibStyle:verticalStretch(value)
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
function RitnLibStyle:horizontalSpacing(value)
    if value == nil then return self end
    if type(value) ~= "number" then return self end

    self.style.horizontal_spacing = value

    return self
end

-- vertically stretchable
function RitnLibStyle:verticalSpacing(value)
    if value == nil then return self end
    if type(value) ~= "number" then return self end

    self.style.vertical_spacing = value

    return self
end

function RitnLibStyle:spacing(horizontal, vertical)
    self:horizontalSpacing(horizontal)
    self:verticalSpacing(vertical)
    return self
end


-- alignment (default center)
function RitnLibStyle:align(valueH, valueV)
    if valueH ~= nil then self.alignH = valueH end
    if valueV ~= nil then self.alignV = valueV end

    self.style.horizontal_align = self.alignH
    self.style.vertical_align = self.alignV
    
    return self
end


--------------------------------

-- set value width & height
function RitnLibStyle:size(width, height)
    self:width(width)
    self:height(height)
    
    return self
end

-- set value width
function RitnLibStyle:width(width)
    if width == nil then return self end 
    if type(width) ~= 'number' then return self end 
    
    self.style.width = width
    
    return self
end

function RitnLibStyle:height(height)
    if height == nil then return self end 
    if type(height) ~= 'number' then return self end 
    
    self.style.height = height
    
    return self
end


-- set value max height
function RitnLibStyle:maxHeight(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.maximal_height = value
    
    return self
end

-- set value max width
function RitnLibStyle:maxWidth(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.maximal_width = value
    
    return self
end

-- set value max height
function RitnLibStyle:minHeight(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.minimal_height = value
    
    return self
end

-- set value max width
function RitnLibStyle:minWidth(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.minimal_width = value
    
    return self
end

-- set font
function RitnLibStyle:font(font)
    if font == nil then return self end 
    if type(font) ~= 'string' then return self end 
    
    self.style.font = font
    
    return self
end

-- set top_margin
function RitnLibStyle:margin(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self:topMargin(value)
    self:bottomMargin(value)
    self:leftMargin(value)
    self:rightMargin(value)
    
    return self
end

-- set top_margin
function RitnLibStyle:topMargin(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.top_margin = value
    
    return self
end

-- set bottom_margin
function RitnLibStyle:bottomMargin(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.bottom_margin = value
    
    return self
end

-- set left_margin
function RitnLibStyle:leftMargin(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.left_margin = value
    
    return self
end

-- set right_margin
function RitnLibStyle:rightMargin(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.right_margin = value
    
    return self
end


-- set padding
function RitnLibStyle:padding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self:topPadding(value)
    self:bottomPadding(value)
    self:leftPadding(value)
    self:rightPadding(value)
    
    return self
end


-- set top_padding
function RitnLibStyle:topPadding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.top_padding = value
    
    return self
end

-- set top_padding
function RitnLibStyle:bottomPadding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.bottom_padding = value
    
    return self
end

-- set top_padding
function RitnLibStyle:leftPadding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.left_padding = value
    
    return self
end

-- set top_padding
function RitnLibStyle:rightPadding(value)
    if value == nil then return self end 
    if type(value) ~= 'number' then return self end 
    
    self.style.right_padding = value
    
    return self
end


----------------------------------------------------------------
--return RitnLibStyle
