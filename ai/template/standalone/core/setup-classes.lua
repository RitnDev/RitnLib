---------------------------------------------------------------------------------------------
-- SETUP CLASSES
---------------------------------------------------------------------------------------------
-- FR : Factory de classes, puis les classes du mod, parent avant enfant.
-- EN : Class factory, then the mod classes, parent before child.
---------------------------------------------------------------------------------------------

-- FR : Factory de classes (copie locale, le mod reste autonome)
-- EN : Class factory (local copy, the mod stays standalone)
mymod.classFactory = require(mymod.defines.class.core)

-- FR : MyModPlayer : joueur
-- EN : MyModPlayer: player
require(mymod.defines.class.player)
-- FR : MyModGui : base des fenêtres (hérite de MyModPlayer)
-- EN : MyModGui: windows base (inherits MyModPlayer)
require(mymod.defines.class.gui)
-- FR : MyModGuiElement : description d'un élément GUI
-- EN : MyModGuiElement: GUI element description
require(mymod.defines.class.gui_element)
-- FR : MyModGuiPanel : fenêtre panel (hérite de MyModGui)
-- EN : MyModGuiPanel: panel window (inherits MyModGui)
require(mymod.defines.class.gui_panel)
