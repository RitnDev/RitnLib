---------------------------------------------------------------------------------------------
-- PROTOTYPES : CUSTOM INPUTS
---------------------------------------------------------------------------------------------
-- FR : Raccourcis clavier du mod (noms préfixés par le mod, à ne plus changer une fois publiés).
-- EN : Mod keyboard shortcuts (names prefixed by the mod, not to be changed once published).
---------------------------------------------------------------------------------------------

data:extend({
    -- FR : Ouvrir / fermer la fenêtre « panel »
    -- EN : Open / close the "panel" window
    {
        type = "custom-input",
        name = "mymod-toggle",
        key_sequence = "CONTROL + SHIFT + M",
    },
})
