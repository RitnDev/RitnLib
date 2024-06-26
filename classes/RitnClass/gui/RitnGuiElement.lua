-- RitnLibGuiElement
----------------------------------------------------------------
-- CLASSES DEFINES
----------------------------------------------------------------
RitnLibGuiElement = ritnlib.classFactory.newclass(function(self, ui_name, element_type, element_name)
    -- GuiElement self
    self.object_name = "RitnLibGuiElement"

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
    
    self.gui_name = ui_name .. "-" .. elementType .. "-" .. element_name
    self.pattern = "([^-]*)-?([^-]*)-?([^-]*)"
    ----
    self.name = element_name
    self.type = element_type
    self.ui = ui_name
    self.action = element_type .. "-" .. element_name
    ----
    self.hsp = "never"
    self.hsp_valid = {
        auto = true,
        never = true,
        always = true, 
        ["auto-and-reserve-space"] = true,
        ["dont-show-but-allow-scrolling"] = true,
    }
    self.string_valid = {
        string = true,
        table = true,
    }
    self.orientation_valid = {
        frame = true,
        flow = true,
        line = true,
    }
    self.text_valid = {
        textfield = true,
        ["text-box"] = true,
    }
    self.button_valid = {
        button = true,
        ["sprite-button"] = true,
    }
    self.sprite_valid = {
        sprite = true,
        ["sprite-button"] = true,
    }
    self.check_valid = {
        checkbox = true,
        radiobutton = true,
    }
    ----
    self.gui_element = {
        type = self.type,
        name = self.gui_name,
        visible = true,
    }

    if element_type == "scroll-pane" then 
        self.gui_element.horizontal_scroll_policy = self.hsp 
    end
    --------------------------------------------------
end)



function RitnLibGuiElement:add(parent)
    log(self.gui_name .. ' > RitnLibGuiElement:add('.. parent.name ..')')
    if parent == nil then return end
    return parent.add(self.gui_element)
end

function RitnLibGuiElement:get()
    log(self.gui_name .. ' > RitnLibGuiElement:getGuiElement()')
    return self.gui_element
end


--frame or flow or line
function RitnLibGuiElement:horizontal()
    log(self.gui_name .. ' > RitnLibGuiElement:horizontal()')
    if self.orientation_valid[self.type] then
        self.gui_element.direction = "horizontal"
    end
    return self
end

function RitnLibGuiElement:vertical()
    log(self.gui_name .. ' > RitnLibGuiElement:vertical()')
    if self.orientation_valid[self.type] then 
        self.gui_element.direction = "vertical"
    end
    return self
end



--> auto_center = true (frame)
function RitnLibGuiElement:autoCenter()
    log(self.gui_name .. ' > RitnLibGuiElement:autoCenter()')
    if self.type == "frame" then 
        self.gui_element.auto_center = true
    end
    return self
end


function RitnLibGuiElement:visible(visible)
    log(self.gui_name .. ' > RitnLibGuiElement:visible()')
    if type(visible) ~= "boolean" then return self end 

    self.gui_element.visible = visible

    return self
end

function RitnLibGuiElement:enabled(enabled)
    log(self.gui_name .. ' > RitnLibGuiElement:enabled()')
    if type(enabled) ~= "boolean" then return self end 

    self.gui_element.enabled = enabled

    return self
end

function RitnLibGuiElement:caption(caption)
    log(self.gui_name .. ' > RitnLibGuiElement:caption()')
    if self.string_valid[type(caption)] then 
        self.gui_element.caption = caption
    end 
   
    return self
end

function RitnLibGuiElement:tooltip(tooltip)
    log(self.gui_name .. ' > RitnLibGuiElement:tooltip()')
    if not self.string_valid[type(tooltip)] then return self end  

    self.gui_element.tooltip = tooltip

    return self
end

function RitnLibGuiElement:index(index)
    log(self.gui_name .. ' > RitnLibGuiElement:index()')
    if type(index) ~= "number" then return self end 

    self.gui_element.index = index

    return self
end

function RitnLibGuiElement:text(text)
    log(self.gui_name .. ' > RitnLibGuiElement:text()')
    if type(tooltip) ~= "string" then return self end 

    if self.text_valid[self.type] then
        self.gui_element.text = text
    end

    return self
end

function RitnLibGuiElement:style(style)
    log(self.gui_name .. ' > RitnLibGuiElement:style()')
    if type(style) ~= "string" then return self end 

    self.gui_element.style = style

    return self
end


function RitnLibGuiElement:spritePath(sprite)
    log(self.gui_name .. ' > RitnLibGuiElement:spritePath()')
    if type(sprite) ~= "string" then return self end 

    if self.sprite_valid[self.type] then
        self.gui_element.sprite = sprite
    end

    return self
end


function RitnLibGuiElement:horizontalScrollPolicy(hsp)
    log(self.gui_name .. ' > RitnLibGuiElement:horizontalScrollPolicy()')
    if type(hsp) ~= "string" then return self end 

    if self.hsp_valid[hsp] then
        if self.type == "scroll-pane" then
            self.gui_element.horizontal_scroll_policy = hsp
        end
    end

    return self
end

function RitnLibGuiElement:verticalScrollPolicy(vsp)
    log(self.gui_name .. ' > RitnLibGuiElement:verticalScrollPolicy()')
    if type(vsp) ~= "string" then return self end 

    if self.hsp_valid[vsp] then
        if self.type == "scroll-pane" then
            self.gui_element.vertical_scroll_policy = vsp
        end
    end

    return self
end


function RitnLibGuiElement:resizeSprite(resize)
    log(self.gui_name .. ' > RitnLibGuiElement:resizeSprite()')
    if type(resize) ~= "boolean" then return self end 

    if self.type == "sprite" then
        self.gui_element.resize_to_sprite = resize
    end

    return self
end

function RitnLibGuiElement:checked(check)
    log(self.gui_name .. ' > RitnLibGuiElement:checked()')
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


function RitnLibGuiElement:progress(value)
    log(self.gui_name .. ' > RitnLibGuiElement:progress()')
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


function RitnLibGuiElement:mouseButtonFilter(value)
    log(self.gui_name .. ' > RitnLibGuiElement:mouseButtonFilter()')
    local valueDefault = {'left'}
    if value ~= nil then 
        if type(value) ~= "table" then return self end
        valueDefault = value
    end

    if self.button_valid[self.type] then
        self.gui_element.mouse_button_filter = valueDefault
    end

    return self
end 

----------------------------------------------------------------
--return RitnLibGuiElement