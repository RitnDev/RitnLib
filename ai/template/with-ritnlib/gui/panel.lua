---------------------------------------------------------------------------------------------
-- GUI : PANEL
---------------------------------------------------------------------------------------------
-- FR : Description de la fenêtre « panel » : éléments (getElement) et chemins (getContent).
--      Noms en jeu : <gui_name>-<type>-<name>, ex. mymod_panel-button-close.
-- EN : Description of the "panel" window: elements (getElement) and paths (getContent).
--      In-game names: <gui_name>-<type>-<name>, e.g. mymod_panel-button-close.
---------------------------------------------------------------------------------------------


---**EN**
---
---Description: Description of each element of the window (specs given to `LuaGuiElement.add`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Description de chaque élément de la fenêtre (specs passées à `LuaGuiElement.add`).
---@param gui_name string  Names prefix (e.g. "mymod_panel")
---@return table
local function getElement(gui_name)
    local element = {
        -- FR : Cadre principal
        -- EN : Main frame
        frame = {
            main = RitnLibGuiElement(gui_name, "frame", "main"):vertical():caption({"mymod.panel-title"}):get(),
        },
        -- FR : Bouton fermer
        -- EN : Close button
        button = {
            close = RitnLibGuiElement(gui_name, "button", "close"):caption({"mymod.close"}):get(),
        },
    }
    return element
end


---**EN**
---
---Description: Path of each element from `gui[1]`, without the `gui_name-` prefix (added by `getElement`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Chemin de chaque élément depuis `gui[1]`, sans le préfixe `gui_name-` (ajouté par `getElement`).
---@return table
local function getContent()
    local content = {
        frame = {
            main = { "frame-main" },
        },
        button = {
            close = { "frame-main", "button-close" },
        },
    }
    return content
end


return {
    getElement = getElement,
    getContent = getContent,
}
