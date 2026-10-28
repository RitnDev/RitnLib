---------------------------------------------------------------------------------------------
-- SETUP CLASSES
---------------------------------------------------------------------------------------------
-- FR : Charge les classes de RitnLib dans la VM de ce mod, puis celles du mod (parent avant enfant).
-- EN : Loads RitnLib's classes inside this mod VM, then the mod classes (parent before child).
---------------------------------------------------------------------------------------------

-- FR : Classes runtime de RitnLib (RitnLibPlayer, RitnLibGui, RitnLibGuiElement...)
-- EN : RitnLib runtime classes (RitnLibPlayer, RitnLibGui, RitnLibGuiElement...)
require(ritnlib.defines.setup)

-- FR : Classes du mod
-- EN : Mod classes
require(ritnlib.defines.mymod.class.gui_panel)      -- MyModGuiPanel : extends RitnLibGui
