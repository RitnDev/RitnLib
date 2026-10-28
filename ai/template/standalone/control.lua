---------------------------------------------------------------------------------------------
-- CONTROL
---------------------------------------------------------------------------------------------

-- FR : Registre des chemins
-- EN : Path registry
require("core.defines")

-- FR : Factory et classes
-- EN : Factory and classes
require(mymod.defines.setup)

-- FR : Modules envoyés à l'event handler
-- EN : Modules sent to the event handler
local listener = require(mymod.defines.event).add_libraries(require(mymod.defines.modules.core))

-- FR : Rend le storage du mod lisible par gvv (si gvv est installé)
-- EN : Makes the mod storage readable by gvv (if gvv is installed)
if script.active_mods["gvv"] then require("__gvv__.gvv")() end

-- FR : Tests en jeu avec RitnTest (développement seulement)
-- EN : In-game tests with RitnTest (development only)
if script.active_mods["RitnTest"] then require("__RitnTest__.interface") end
