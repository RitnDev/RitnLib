---------------------------------------------------------------------------------------------
-- DEFINES
---------------------------------------------------------------------------------------------
-- FR : Registre des chemins du mod (global mymod.defines). Aucun fichier n'écrit un chemin de require
--      en dur : tout passe par ce registre. Chargé au data stage et au control stage.
-- EN : Path registry of the mod (global mymod.defines). No file writes a hard-coded require path:
--      everything goes through this registry. Loaded at the data stage and the control stage.
---------------------------------------------------------------------------------------------

-- FR : Nom du mod et dossier racine
-- EN : Mod name and root folder
local name = "MyMod"
local directory = "__" .. name .. "__"

local defines = {
    name = name,
    directory = directory,

    -- FR : Démarrage du mod (control stage)
    -- EN : Mod bootstrap (control stage)
    setup = directory .. ".core.setup-classes",
    migrations = directory .. ".core.migrations",
    event = "__core__.lualib.event_handler",

    -- FR : Factory de classes et classes du mod
    -- EN : Class factory and mod classes
    class = {
        core = directory .. ".core.class",
        player = directory .. ".classes.MyModPlayer",
        gui = directory .. ".classes.MyModGui",
        gui_element = directory .. ".classes.MyModGuiElement",
        gui_panel = directory .. ".classes.MyModGuiPanel",
    },

    -- FR : Description des fenêtres (getElement / getContent)
    -- EN : Windows description (getElement / getContent)
    gui = {
        panel = directory .. ".gui.panel",
    },

    -- FR : Modules envoyés à l'event handler
    -- EN : Modules sent to the event handler
    modules = {
        core = directory .. ".core.modules",
        events = directory .. ".modules.events",
        gui = directory .. ".modules.gui",
    },

    -- FR : Bibliothèque du mod
    -- EN : Mod library
    lualib = {
        common = {
            check = directory .. ".lualib.common.check",
        },
    },

    -- FR : Prototypes (data stage)
    -- EN : Prototypes (data stage)
    prototypes = {
        custom_inputs = directory .. ".prototypes.custom-inputs",
    },
}

-- FR : Global du mod
-- EN : Mod global
if not mymod then mymod = {} end
mymod.defines = defines
