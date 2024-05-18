------------------------------------------------------------------------------------
-- Fonction "GUI"
------------------------------------------------------------------------------------


-- Retourne une copie une copie d'un élément "source" dans le default_gui de Factorio
local function copyDefaultGui(dupl, source)
    local default_gui = data.raw['gui-style'].default
    default_gui[dupl] = table.deepcopy(source)
    return default_gui[dupl]
end


-- Convertion en empty-widget
local function convertEmpty(dupl)
    local default_gui = data.raw['gui-style'].default
    default_gui[dupl] = {type = 'empty_widget_style', graphical_set = {}}
    return default_gui[dupl]
end



------------------------------------------------------------------------------------
local flib = {}
------------------------------------------------------------------------------------
-- Chargement des fonctions
flib.SUFFIX =  '-ritngui'
flib.copyDefaultGui = copyDefaultGui
flib.convertEmpty = convertEmpty
------------------------------------------------------------------------------------
return flib
------------------------------------------------------------------------------------