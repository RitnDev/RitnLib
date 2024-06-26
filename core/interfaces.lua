if not ritnlib then require("__RitnLib__/defines") end
-----------------------------------------------------------------------------------------------------------------
local Informatron = {
    menu = require("__RitnLib__/lualib/informatron/menu"),
    pages = require("__RitnLib__/lualib/informatron/pages"),
}


local informatron_interfaces = {

    ------------------------------------------------------------------------------------------
    -- INFORMATRON
    ------------------------------------------------------------------------------------------
    -- menu informatron
    informatron_menu = function(data)
        return {} --Informatron.menu(data.player_index)
    end,
    -- display_page_content
    informatron_page_content = function(data) 
        log('> remote.call.informatron_page_content -> page_name: ' .. data.page_name)
        local pageElements = Informatron.pages[data.page_name]
        RitnLibInformatron("RitnLib", data):setPageContent(pageElements)
    end,
    ------------------------------------------------------------------------------------------
}
-----------------------------------------------------------------------------------------------------------------
local lib_interfaces = {}
-----------------------------------------------------------------------------------------------------------------
remote.add_interface("RitnLib", lib_interfaces)
--remote.add_interface("RitnLib", informatron_interfaces)