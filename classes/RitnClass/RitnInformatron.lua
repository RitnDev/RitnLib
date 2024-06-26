-- RitnLibInformatron
----------------------------------------------------------------
local font = ritnlib.defines.names.font
local stringUtils = require(ritnlib.defines.constants).strings
local flib = require(ritnlib.defines.other)
local table = require(ritnlib.defines.table)
local string = require(ritnlib.defines.string)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLibInformatron = ritnlib.classFactory.newclass(RitnLibGui, function(self, mod_name, informatron_data)
    RitnLibGui.init(self, informatron_data, mod_name, "main-flow")
    self.object_name = "RitnLibInformatron"
    --------------------------------------------------
    self.gui_name = "informatron"  
    self.page_name = page_name
    --------------------------------------------------
    self.gui = { self.player.gui.screen }
    --------------------------------------------------
    self.content = {}
    self.content_origine = {
        "main-flow",
        "content-container",
        "content-pane",
    }
    --------------------------------------------------
    self.FLAG_PAGE_DISPLAY = true
    self.FLAG_PAGE_NOT_DISPLAY = false
end)

----------------------------------------------------------------


-- renvoie l'element souhaitez selon son nom
function RitnLibInformatron:getElement(element_type, element_name)
    local prefix = self.gui_name .. "-"
    
    local tmp_content = self.gui[self.gui_name]
    for i, gui in pairs(self.content_origine) do 
        if tmp_content[gui] == nil then 
            return
        else
            tmp_content = tmp_content[gui]
        end
    end

    local LuaGuiElement = tmp_content

    local element = {}

    -- get element
    if element_name ~= nil then 
        element = self.content[element_type][element_name]
    else
        element = self.content[element_type]
    end

    -- build LuaGui
    for _,name in pairs(element) do
        LuaGuiElement = LuaGuiElement[prefix..name]
    end

    return LuaGuiElement
end


function RitnLibInformatron:setPageContent(pageElements) 
    if self.page_name ~= self.mod_name then return self.FLAG_PAGE_NOT_DISPLAY or false end 
    if self.gui[self.gui_name] == nil then return self.FLAG_PAGE_NOT_DISPLAY or false end 
    local tmp_content = self.gui[self.gui_name]
    for i, gui in pairs(self.content_origine) do 
        if tmp_content[gui] == nil then 
            return self.FLAG_PAGE_NOT_DISPLAY or false
        else
            tmp_content = tmp_content[gui]
        end
    end

    local content = {}
    content["start"] = tmp_content

    for i, element in pairs(pageElements) do 
        log("> add GuiElement : ".. element.name .. stringUtils.special["right-arrow-decorator"] .. element.parent)
        content[element.name] = content[element.parent].add(element.gui)
    end

    return FLAG_PAGE_DISPLAY
end

