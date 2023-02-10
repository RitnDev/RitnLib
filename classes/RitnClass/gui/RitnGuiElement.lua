-- RitnGuiElement
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------
local pattern = "([^-]*)-?([^-]*)-?([^-]*)"


local RitnGuiElement = class.newclass(function(base, ui_name, element_type, element_name)
    -- GuiElement base
    base.object_name = "RitnGuiElement"

    local elementType = element_type
    if element_type == "sprite-button" then elementType = "button" end
    if element_type == "text-box" then elementType = "textbox" end
    if element_type == "list-box" then elementType = "listbox" end
    if element_type == "drop-down" then elementType = "dropdown" end
    if element_type == "choose-elem-button" then elementType = "button" end
    if element_type == "entity-preview" then elementType = "preview" end
    if element_type == "empty-widget" then elementType = "empty" end
    if element_type == "scroll-pane" then elementType = "pane" end
    if element_type == "tabbed-pane" then elementType = "tabbed" end
    
    base.gui_name = ui_name .. "-" .. elementType .. "-" .. element_name
    base.pattern = pattern
    ----
    base.name = element_name
    base.type = element_type
    base.ui = ui_name
    base.action = element_type .. "-" .. element_name
    ----
    base.hsp = "never"
    base.hsp_valid = {
        auto = true,
        never = true,
        always = true, 
        ["auto-and-reserve-space"] = true,
        ["dont-show-but-allow-scrolling"] = true,
    }
    base.string_valid = {
        string = true,
        table = true,
    }
    base.orientation_valid = {
        frame = true,
        flow = true,
        line = true,
    }
    base.text_valid = {
        textfield = true,
        ["text-box"] = true,
    }
    base.sprite_valid = {
        sprite = true,
        ["sprite-button"] = true,
    }
    base.check_valid = {
        checkbox = true,
        radiobutton = true,
    }
    ----
    base.gui_element = {
        type = base.type,
        name = base.gui_name,
        visible = true
    }

    if element_type == "scroll-pane" then 
        base.gui_element.horizontal_scroll_policy = base.hsp 
    end
    --------------------------------------------------
end)



function RitnGuiElement:add(parent)
    log(self.gui_name .. ' > RitnGuiElement:add('.. parent.name ..')')
    if parent == nil then return end
    return parent.add(self.gui_element)
end

function RitnGuiElement:get()
    log(self.gui_name .. ' > RitnGuiElement:getGuiElement()')
    return self.gui_element
end


--frame or flow or line
function RitnGuiElement:horizontal()
    log(self.gui_name .. ' > RitnGuiElement:horizontal()')
    if self.orientation_valid[self.type] then
        self.gui_element.direction = "horizontal"
    end
    return self
end

function RitnGuiElement:vertical()
    log(self.gui_name .. ' > RitnGuiElement:vertical()')
    if self.orientation_valid[self.type] then 
        self.gui_element.direction = "vertical"
    end
    return self
end

function RitnGuiElement:visible(visible)
    log(self.gui_name .. ' > RitnGuiElement:visible()')
    if type(visible) ~= "boolean" then return self end 

    self.gui_element.visible = visible

    return self
end

function RitnGuiElement:enabled(enabled)
    log(self.gui_name .. ' > RitnGuiElement:enabled()')
    if type(enabled) ~= "boolean" then return self end 

    self.gui_element.enabled = enabled

    return self
end

function RitnGuiElement:caption(caption)
    log(self.gui_name .. ' > RitnGuiElement:caption()')
    if self.string_valid[type(caption)] then 
        self.gui_element.caption = caption
    end 
   
    return self
end

function RitnGuiElement:tooltip(tooltip)
    log(self.gui_name .. ' > RitnGuiElement:tooltip()')
    if not self.string_valid[type(tooltip)] then return self end  

    self.gui_element.tooltip = tooltip

    return self
end

function RitnGuiElement:index(index)
    log(self.gui_name .. ' > RitnGuiElement:index()')
    if type(index) ~= "number" then return self end 

    self.gui_element.index = index

    return self
end

function RitnGuiElement:text(text)
    log(self.gui_name .. ' > RitnGuiElement:text()')
    if type(tooltip) ~= "string" then return self end 

    if self.text_valid[self.type] then
        self.gui_element.text = text
    end

    return self
end

function RitnGuiElement:style(style)
    log(self.gui_name .. ' > RitnGuiElement:style()')
    if type(style) ~= "string" then return self end 

    self.gui_element.style = style

    return self
end


function RitnGuiElement:spritePath(sprite)
    log(self.gui_name .. ' > RitnGuiElement:spritePath()')
    if type(sprite) ~= "string" then return self end 

    if self.sprite_valid[self.type] then
        self.gui_element.sprite = sprite
    end

    return self
end


function RitnGuiElement:horizontalScrollPolicy(hsp)
    log(self.gui_name .. ' > RitnGuiElement:horizontalScrollPolicy()')
    if type(hsp) ~= "string" then return self end 

    if self.hsp_valid[hsp] then
        if self.type == "scroll-pane" then
            self.gui_element.horizontal_scroll_policy = hsp
        end
    end

    return self
end

function RitnGuiElement:verticalScrollPolicy(vsp)
    log(self.gui_name .. ' > RitnGuiElement:verticalScrollPolicy()')
    if type(vsp) ~= "string" then return self end 

    if self.hsp_valid[vsp] then
        if self.type == "scroll-pane" then
            self.gui_element.vertical_scroll_policy = vsp
        end
    end

    return self
end


function RitnGuiElement:resizeSprite(resize)
    log(self.gui_name .. ' > RitnGuiElement:resizeSprite()')
    if type(resize) ~= "boolean" then return self end 

    if self.type == "sprite" then
        self.gui_element.resize_to_sprite = resize
    end

    return self
end

function RitnGuiElement:checked(check)
    log(self.gui_name .. ' > RitnGuiElement:checked()')
    local state = true
    if check ~= nil then 
        if type(check) ~= "boolean" then return self end
        state = check
    end

    if self.check_valid[self.type] then
        self.gui_element.state = state
    end

    return self
end


function RitnGuiElement:progress(value)
    log(self.gui_name .. ' > RitnGuiElement:progress()')
    local valueDefault = 0
    if value ~= nil then 
        if type(value) ~= "number" then return self end
        if value > 100 or value < 0 then return self end
        valueDefault = value
    end

    if self.type == "progressbar" then
        self.gui_element.value = valueDefault
    end

    return self
end

----------------------------------------------------------------
return RitnGuiElement