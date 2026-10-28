---------------------------------------------------------------------------------------------
-- SETUP CLASSES
---------------------------------------------------------------------------------------------
-- FR : Factory de classes, puis les classes du mod, parent avant enfant.
-- EN : Class factory, then the mod classes, parent before child.
---------------------------------------------------------------------------------------------

-- FR : Factory de classes (copie locale, le mod reste autonome)
-- EN : Class factory (local copy, the mod stays standalone)
mymod.classFactory = require(mymod.defines.class.core)

require(mymod.defines.class.player)         -- MyModPlayer : joueur / player
require(mymod.defines.class.gui)            -- MyModGui : base des fenêtres (hérite de MyModPlayer) / windows base (inherits MyModPlayer)
require(mymod.defines.class.gui_element)    -- MyModGuiElement : description d'un élément GUI / GUI element description
require(mymod.defines.class.gui_panel)      -- MyModGuiPanel : fenêtre panel (hérite de MyModGui) / panel window (inherits MyModGui)
