---------------------------------------------------------------------------------------------
-- MODULE : GUI
---------------------------------------------------------------------------------------------
-- FR : Évènements de la fenêtre « panel » : raccourci et clics. MyModGui découpe le nom de l'élément
--      et appelle la méthode liée à l'action (gui_action).
-- EN : "panel" window events: shortcut and clicks. MyModGui splits the element name
--      and calls the method linked to the action (gui_action).
---------------------------------------------------------------------------------------------


---**EN**
---
---Description: Runs a handler in a protected way: an error is shown to the player and written to the log
---with the call stack, instead of stopping the game.
---
---──────────────────────────────
---
---**FR**
---
---Description: Exécute un handler de façon protégée : une erreur est affichée au joueur et écrite dans le log
---avec la pile d'appels, au lieu d'arrêter la partie.
---@param handler fun(event: table)
---@return fun(event: table)
local function protected(handler)
    return function(event)
        -- FR : Exécution protégée ; la pile d'appels est gardée pour le log
        -- EN : Protected run; the call stack is kept for the log
        local traceback = nil
        local success, message = xpcall(handler, function(error_message)
            traceback = debug.traceback(tostring(error_message), 2)
            return error_message
        end, event)

        if not success then
            -- FR : Message complet dans le log, message court au joueur
            -- EN : Full message inside the log, short message to the player
            log("[ERROR] MyMod GUI : " .. tostring(traceback or message))
            if event.player_index then
                game.get_player(event.player_index).print(tostring(message))
            end
        end
    end
end


---**EN**
---
---Description: Click: the window handles it if the element belongs to it (name prefix).
---
---──────────────────────────────
---
---**FR**
---
---Description: Clic : la fenêtre le traite si l'élément lui appartient (préfixe du nom).
---@param event EventData.on_gui_click
local function on_gui_click(event)
    MyModGuiPanel(event):on_gui_click()
end


---**EN**
---
---Description: Keyboard shortcut: opens / closes the window.
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci clavier : ouvre / ferme la fenêtre.
---@param event EventData.CustomInputEvent
local function on_toggle(event)
    MyModGuiPanel(event):toggle()
end


---@type MyModModule
local module = {events = {}}
module.events[defines.events.on_gui_click] = protected(on_gui_click)
module.events["mymod-toggle"] = protected(on_toggle)
return module
