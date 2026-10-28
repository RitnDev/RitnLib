---------------------------------------------------------------------------------------------
-- MYMOD GUI PANEL
---------------------------------------------------------------------------------------------
-- FR : Fenêtre « panel » du mod, construite à partir de gui/panel.lua. Les actions (clic sur un bouton)
--      passent par l'interface remote du mod, fonction gui_action_<gui_name> (modules/gui.lua).
-- EN : "panel" window of the mod, built from gui/panel.lua. The actions (click on a button)
--      go through the mod remote interface, function gui_action_<gui_name> (modules/gui.lua).
---------------------------------------------------------------------------------------------
local fGui = require(ritnlib.defines.mymod.gui.panel)
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
---@class MyModGuiPanel : RitnLibGui
---@field object_name string   "MyModGuiPanel"
---@operator call(table): MyModGuiPanel
---@type MyModGuiPanel
MyModGuiPanel = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    -- FR : Interface remote = nom du mod ; élément racine = frame-main
    -- EN : Remote interface = mod name; root element = frame-main
    RitnLibGui.init(self, event, ritnlib.defines.mymod.name, "frame-main")
    self.object_name = "MyModGuiPanel"

    -- FR : Préfixe des noms, préfixé par le mod (les noms doivent être uniques dans player.gui)
    -- EN : Names prefix, prefixed by the mod (names must be unique inside player.gui)
    self.gui_name = "mymod_panel"

    -- FR : Actions autorisées, servies par remote gui_action_mymod_panel
    -- EN : Allowed actions, served by remote gui_action_mymod_panel
    self.gui_action = {
        [self.gui_name] = {
            ["button-close"] = true,
        },
    }

    -- FR : Conteneur de la fenêtre et chemins des éléments
    -- EN : Window container and element paths
    self.gui = { self.player.gui.screen }
    self.content = fGui.getContent()
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
    -- FR : Fenêtre déjà ouverte : rien à faire
    -- EN : Window already open: nothing to do
    if self:getElement("frame", "main") ~= nil then
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
