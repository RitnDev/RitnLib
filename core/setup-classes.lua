if not ritnlib then 
    require("__RitnLib__.defines") 
    log('> imported : ritnlib.defines')
end
-----------------------------------------------------------
require(ritnlib.defines.class.luaClass.recipe)                  -- RitnLibRecipe
require(ritnlib.defines.class.luaClass.tech)                    -- RitnLibTechnology
require(ritnlib.defines.class.luaClass.force)                   -- RitnLibForce
require(ritnlib.defines.class.luaClass.surface)                 -- RitnLibSurface
require(ritnlib.defines.class.luaClass.player)                  -- RitnLibPlayer
require(ritnlib.defines.class.luaClass.event)                   -- RitnLibEvent
require(ritnlib.defines.class.luaClass.gui)                     -- RitnLibGui               extends: RitnLibPlayer
-- specifics
require(ritnlib.defines.class.ritnClass.inventory)              -- RitnLibInventory
-- gui
require(ritnlib.defines.class.gui.element)                      -- RitnLibGuiElement
require(ritnlib.defines.class.gui.style)                        -- RitnLibStyle
-- informatron
require(ritnlib.defines.class.ritnClass.informatron)            -- RitnLibInformatron       extends: RitnLibGui