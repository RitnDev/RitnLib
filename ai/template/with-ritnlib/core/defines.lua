---------------------------------------------------------------------------------------------
-- DEFINES
---------------------------------------------------------------------------------------------
-- FR : Registre des chemins du mod, ajouté au registre partagé de RitnLib (ritnlib.defines.mymod).
--      Aucun fichier n'écrit un chemin de require en dur : tout passe par ce registre.
-- EN : Path registry of the mod, added to RitnLib's shared registry (ritnlib.defines.mymod).
--      No file writes a hard-coded require path: everything goes through this registry.
---------------------------------------------------------------------------------------------

-- FR : Registre de RitnLib (crée le global ritnlib)
-- EN : RitnLib registry (creates the ritnlib global)
if not ritnlib then require("__RitnLib__.defines") end

-- FR : Nom du mod et dossier racine
-- EN : Mod name and root folder
local name = "MyMod"
local directory = "__" .. name .. "__"

local defines = {
    name = name,
    directory = directory,

    -- FR : Chargement des classes (core/setup-classes.lua)
    -- EN : Classes loading (core/setup-classes.lua)
    setup = directory .. ".core.setup-classes",
    migrations = directory .. ".core.migrations",

    -- FR : Classes du mod
    -- EN : Mod classes
    class = {
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

    -- FR : Prototypes (data stage)
    -- EN : Prototypes (data stage)
    prototypes = {
        custom_inputs = directory .. ".prototypes.custom-inputs",
    },
}

-- FR : Clé courte du mod dans le registre partagé
-- EN : Short key of the mod inside the shared registry
ritnlib.defines.mymod = defines
