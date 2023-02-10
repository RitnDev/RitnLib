-- RitnGui
----------------------------------------------------------------
local class = require(ritnlib.defines.class.core)
local modGui = require("mod-gui")
----------------------------------------------------------------
local RitnPlayer = require(ritnlib.defines.class.luaClass.player)
local RitnEvent = require(ritnlib.defines.class.luaClass.event)
----------------------------------------------------------------



----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnGui = class.newclass(RitnPlayer, function(base, event, mod_name, main_gui)
    local LuaPlayer = RitnEvent(event).player
    if mod_name == nil then log('not mod_name !') return end
    if LuaPlayer == nil then log('not LuaPlayer !') return end
    if LuaPlayer.valid == false then log('not LuaPlayer valid !') return end
    if LuaPlayer.is_player() == false then log('not LuaPlayer !') return end
    if LuaPlayer.object_name ~= "LuaPlayer" then log('not LuaPlayer !') return end
    RitnPlayer.init(base, LuaPlayer)
    base.object_name = "RitnGui"
    base.mod_name = mod_name
    base.event = event
    --------------------------------------------------
    base.element = RitnEvent(event).element
    base.gui_action = {}
    base.content = {}
    base.gui_name = ""
    base.main_gui = main_gui
    ----
    base.gui = {
        --screen = LuaPlayer.gui.screen,
        --center = LuaPlayer.gui.center,
        --top = modGui.get_button_flow(LuaPlayer),
        --left = modGui.get_frame_flow(LuaPlayer),
        --goal = LuaPlayer.gui.goal,
    }
    ----
    base.pattern = "([^-]*)-?([^-]*)-?([^-]*)"  
    --------------------------------------------------
end)

----------------------------------------------------------------


function RitnGui:setMainGui(main_gui) 
    if type(main_gui) ~= "string" then return self end
    self.main_gui = main_gui
    return self
end



-- renvoie l'element souhaitez selon son nom
function RitnGui:getElement(element_type, element_name)
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
    for index,name in pairs(element) do 
        LuaGui = LuaGui[prefix..name]
    end

    return LuaGui
end



function RitnGui:actionGui(action, ...)
    if self.gui_action[self.gui_name] == nil then return self end 
    if self.gui_action[self.gui_name][action] == nil then return self end 
    log('> '.. self.object_name ..':actionGui('.. action..')')

    -- it's necessary to create the interface functions for operation.
    remote.call(self.mod_name, "gui_action_"..self.gui_name, action, self.event, ...)
    
    return self
end



-- Fonction : on_gui_click
function RitnGui:on_gui_click(...)
    if not self.element.valid then log('element invalid !') return end
    if self.main_gui == nil then log('not main_gui !') return end
    if self.main_gui == "" then log('not main_gui !') return end
    if self.gui[1] == nil then log('not gui !') return end
    log('> '.. self.object_name ..':on_gui_click('.. self.gui_name ..", " .. self.main_gui ..')')

    local LuaGui = self.gui[1][self.gui_name .. "-" .. self.main_gui]
    local click = {
      ui, element, name, action
    }
  
    -- Action de la frame
    if LuaGui == nil then log('not LuaGui !') return end

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



------------------------------------------------------------
return RitnGui