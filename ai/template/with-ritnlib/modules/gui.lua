---------------------------------------------------------------------------------------------
-- MODULE : GUI
---------------------------------------------------------------------------------------------
-- FR : Évènements de la fenêtre « panel » : raccourci, clics, et interface remote des actions
--      (RitnLibGui appelle remote.call(<mod>, "gui_action_<gui_name>", action, event)).
-- EN : "panel" window events: shortcut, clicks, and the actions remote interface
--      (RitnLibGui calls remote.call(<mod>, "gui_action_<gui_name>", action, event)).
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
---Description: Click: RitnLibGui splits the element name and calls the remote action if it is allowed.
---
---──────────────────────────────
---
---**FR**
---
---Description: Clic : RitnLibGui découpe le nom de l'élément et appelle l'action remote si elle est autorisée.
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


-- FR : Interface remote des actions de la fenêtre (nom de l'interface = nom du mod)
-- EN : Remote interface of the window actions (interface name = mod name)
remote.add_interface(ritnlib.defines.mymod.name, {
    gui_action_mymod_panel = function(action, event)
        -- FR : Bouton fermer
        -- EN : Close button
        if action == "button-close" then
            MyModGuiPanel(event):close()
        end
    end,
})


---@type MyModModule
local module = {events = {}}
module.events[defines.events.on_gui_click] = protected(on_gui_click)
module.events["mymod-toggle"] = protected(on_toggle)
return module
