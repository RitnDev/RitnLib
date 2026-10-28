---------------------------------------------------------------------------------------------
-- MYMOD GUI PANEL
---------------------------------------------------------------------------------------------
-- FR : Fenêtre « panel » du mod, construite à partir de gui/panel.lua. Chaque action
--      (« type-name » de l'élément) appelle directement une méthode (gui_action).
-- EN : "panel" window of the mod, built from gui/panel.lua. Each action
--      (element "type-name") directly calls a method (gui_action).
---------------------------------------------------------------------------------------------
local fGui = require(mymod.defines.gui.panel)
---------------------------------------------------------------------------------------------


---**EN**
---
---Description: "panel" window of MyMod (in `player.gui.screen`).
---
---⚠ Temporary wrapper, created on each event. Do not store the instance in `storage`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Fenêtre « panel » de MyMod (dans `player.gui.screen`).
---
---⚠ Wrapper temporaire, créé à chaque évènement. Ne pas stocker l'instance dans `storage`.
---@class MyModGuiPanel : MyModGui
---@field object_name string   "MyModGuiPanel"
---@operator call(table): MyModGuiPanel
---@type MyModGuiPanel
MyModGuiPanel = mymod.classFactory.newclass(MyModGui, function(self, event)
    -- FR : Fenêtre « mymod_panel » (préfixé par le mod), élément racine frame-main
    -- EN : "mymod_panel" window (prefixed by the mod), root element frame-main
    MyModGui.init(self, event, "mymod_panel", "frame-main")
    self.object_name = "MyModGuiPanel"

    -- FR : Conteneur de la fenêtre et chemins des éléments
    -- EN : Window container and element paths
    if self.isPresent then
        self.gui = { self.player.gui.screen }
    end
    self.content = fGui.getContent()

    -- FR : Actions : élément (type-name) -> méthode
    -- EN : Actions: element (type-name) -> method
    self.gui_action = {
        ["button-close"] = "action_close",
    }
end) --[[@as MyModGuiPanel]]


---**EN**
---
---Description: Builds and opens the window, centred on screen. Does nothing if it is already open.
---
---──────────────────────────────
---
---**FR**
---
---Description: Construit et ouvre la fenêtre, centrée à l'écran. Ne fait rien si elle est déjà ouverte.
---@return MyModGuiPanel self  Chainable
function MyModGuiPanel:open()
    -- FR : Joueur absent, ou fenêtre déjà ouverte : rien à faire
    -- EN : Missing player, or window already open: nothing to do
    if not self.isPresent or self:getElement("frame", "main") ~= nil then
        return self
    end

    -- FR : Construction à partir de la description
    -- EN : Building from the description
    local element = fGui.getElement(self.gui_name)
    local frame = self.gui[1].add(element.frame.main)
    frame.add(element.button.close)

    -- FR : Centrage, une fois le contenu ajouté
    -- EN : Centring, once the content is added
    frame.auto_center = true
    return self
end


---**EN**
---
---Description: Closes the window if it is open.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ferme la fenêtre si elle est ouverte.
---@return MyModGuiPanel self  Chainable
function MyModGuiPanel:close()
    local frame = self:getElement("frame", "main")

    -- FR : Fenêtre ouverte : détruite
    -- EN : Window open: destroyed
    if frame ~= nil then
        frame.destroy()
    end
    return self
end


---**EN**
---
---Description: Opens the window if it is closed, closes it if it is open.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ouvre la fenêtre si elle est fermée, la ferme si elle est ouverte.
---@return MyModGuiPanel self  Chainable
function MyModGuiPanel:toggle()
    if self:getElement("frame", "main") ~= nil then
        return self:close()
    end
    return self:open()
end


---**EN**
---
---Description: Close button.
---
---──────────────────────────────
---
---**FR**
---
---Description: Bouton fermer.
function MyModGuiPanel:action_close()
    self:close()
end
