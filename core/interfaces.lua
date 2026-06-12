---**EN**
---
---Description: Remote interfaces registration for RitnLib — loaded by `control.lua` (flagged "beta"). Currently registers the `"RitnLib"` remote interface with an **empty** function table (`lib_interfaces`): no remote call is exposed yet.
---
---The `informatron_interfaces` block (menu + page-content callbacks consumed by the [Informatron](https://mods.factorio.com/mod/informatron) mod) is prepared but its `remote.add_interface` line is commented out — the Informatron integration is unfinished and inactive.
---
---──────────────────────────────
---
---**FR**
---
---Description: Enregistrement des interfaces remote de RitnLib — chargé par `control.lua` (marqué "beta"). Enregistre actuellement l'interface remote `"RitnLib"` avec une table de fonctions **vide** (`lib_interfaces`) : aucun remote call n'est encore exposé.
---
---Le bloc `informatron_interfaces` (callbacks menu + page-content consommés par le mod [Informatron](https://mods.factorio.com/mod/informatron)) est préparé mais sa ligne `remote.add_interface` est commentée — l'intégration Informatron est inachevée et inactive.

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
