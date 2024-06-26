require('core.setup-classes')
require("core.interfaces") -- beta
-- Activation de gvv s'il est présent
if script.active_mods["gvv"] then require("__gvv__.gvv")() end