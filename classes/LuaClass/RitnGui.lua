-- RitnLibGui
----------------------------------------------------------------
local modGui = require("mod-gui")
----------------------------------------------------------------


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLibGui = ritnlib.classFactory.newclass(RitnLibPlayer, function(self, event, mod_name, main_gui)
    local LuaPlayer = RitnLibEvent(event).player
    if mod_name == nil then log('not mod_name !') return end

    RitnLibPlayer.init(self, LuaPlayer)
    
    self.object_name = "RitnLibGui"
    self.mod_name = mod_name
    self.event = event
    --------------------------------------------------
    self.element = RitnLibEvent(event).element
    self.gui_action = {}
    self.content = {}
    self.gui_name = ""
    self.main_gui = main_gui
    ----
    self.gui = {
        --screen = LuaPlayer.gui.screen,
        --center = LuaPlayer.gui.center,
        --top = modGui.get_button_flow(LuaPlayer),
        --left = modGui.get_frame_flow(LuaPlayer),
        --goal = LuaPlayer.gui.goal,
    }
    ----
    self.pattern = "([^-]*)-?([^-]*)-?([^-]*)"  
    --------------------------------------------------
end)

----------------------------------------------------------------


-- @return object: RitnEvent
function RitnLibGui:getEvent()
    return RitnLibEvent(self.event)
end


function RitnLibGui:setMainGui(main_gui) 
    if type(main_gui) ~= "string" then return self end
    self.main_gui = main_gui
    return self
end



-- renvoie l'element souhaitez selon son nom
function RitnLibGui:getElement(element_type, element_name)
    local prefix = self.gui_name .. "-"
    local LuaGui = self.gui[1]
    local element = {}

    -- get element
    if element_name ~= nil then 
        element = self.content[element_type][element_name]
    else
        element = self.content[element_type]
    end

    -- build LuaGui
    for _,name in pairs(element) do
        LuaGui = LuaGui[prefix..name]
    end

    return LuaGui
end


-- renvoie l'element souhaitez selon son nom
function RitnLibGui:getListSelectedItem(element_type, element_name)
    log('> '..self.object_name..':getListSelectedItem('.. tostring(element_type) .. ', ' .. tostring(element_name) ..')')
    if type(element_type) ~= 'string' then 
        log('element_type is not a string')
        return 
    end
    if type(element_name) ~= 'string' then 
        log('element_name is not a string')
        return 
    end

    local list = self:getElement(element_type, element_name)
    
    -- verifications
    if list == nil then log('getElement is nil') return end 
    if list.valid == false then log('list is not valid') return end 
    if list.type ~= 'list-box' and list.type ~= 'drop-down' then 
        log('list is not list-box or drop-down => ' .. tostring(list.type))
        return 
    end

    local selected_index = list.selected_index

    -- On vérifie qu'il y a bien un élément sélectionné
    if selected_index == nil then return nil end 
    if selected_index == 0 then return nil end 
    log('selected_index == ' .. tostring(selected_index))
        
    return list.get_item(selected_index)
end



function RitnLibGui:actionGui(action, ...)
    if self.gui_action[self.gui_name] == nil then return self end 
    if self.gui_action[self.gui_name][action] == nil then return self end 
    log('> '.. self.object_name ..':actionGui('.. action..')')

    -- it's necessary to create the interface functions for operation.
    remote.call(self.mod_name, "gui_action_"..self.gui_name, action, self.event, ...)
    
    return self
end



-- Fonction : on_gui_click
function RitnLibGui:on_gui_click(...)
    if not self.element.valid then return end
    if self.main_gui == nil then log('not main_gui !') return end
    if self.main_gui == "" then log('not main_gui !') return end
    if self.gui[1] == nil then --[[ log('not gui !') ]] return end
    

    local LuaGui = self.gui[1][self.gui_name .. "-" .. self.main_gui]
    local click = {
      ui, element, name, action
    }
  
    -- getGui
    if LuaGui == nil then return end
    --log('> ('..self.mod_name..') -> '.. self.object_name ..':on_gui_click('.. self.gui_name ..", " .. self.main_gui ..')')

    if LuaGui.name ~= self.gui_name .. "-" .. self.main_gui then return end
    if self.element == nil then return end
    if self.element.valid == false then return end

    -- récupération des informations lors du clique
    click.ui, click.element, click.name = string.match(self.element.name, self.pattern)
    click.action = click.element .. "-" .. click.name

    -- Actions
    if click.ui == self.gui_name then
        self:actionGui(click.action, ...)
    end

end



-- Fonction : on_gui_selection_state_changed
function RitnLibGui:on_gui_selection_state_changed(...)
    if not self.element.valid then log('element invalid !') return end
    if self.main_gui == nil then log('not main_gui !') return end
    if self.main_gui == "" then log('not main_gui !') return end
    if self.gui[1] == nil then --[[ log('not gui !') ]] return end
    

    local LuaGui = self.gui[1][self.gui_name .. "-" .. self.main_gui]
    local list = {
      ui, element, name, action
    }
  
    -- getGui
    if LuaGui == nil then return end
    if LuaGui.name ~= self.gui_name .. "-" .. self.main_gui then return end
    if self.element == nil then return end
    if self.element.valid == false then return end

    -- récupération des informations lors du clique
    list.ui, list.element, list.name = string.match(self.element.name, self.pattern)
    list.action = list.element .. "-" .. list.name .. "-selection_state_changed" 

    if list.element ~= "listbox" then log('element invalid !') return end
    if list.element ~= "dropdown" then log('element invalid !') return end

    -- Actions
    if list.ui == self.gui_name then
        self:actionGui(list.action, ...)
    end

end



------------------------------------------------------------
--return RitnLibGui