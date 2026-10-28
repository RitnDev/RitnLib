---------------------------------------------------------------------------------------------
-- MODULES
---------------------------------------------------------------------------------------------
-- FR : Liste des modules envoyés à l'event handler (__core__/lualib/event_handler) par control.lua.
-- EN : List of the modules sent to the event handler (__core__/lualib/event_handler) by control.lua.
---------------------------------------------------------------------------------------------

---**EN**
---
---Description: Shape of a module (`modules/*.lua`), sent to `__core__/lualib/event_handler`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Forme d'un module (`modules/*.lua`), envoyé à `__core__/lualib/event_handler`.
---@class MyModModule
---@field events? table<defines.events|string, fun(event: table)>   Handlers indexed by event id or custom input name
---@field on_init? fun()
---@field on_load? fun()
---@field on_configuration_changed? fun(data: ConfigurationChangedData)
---@field add_commands? fun()

---@type table<string, MyModModule>
local modules = {}

-- FR : Un module par domaine
-- EN : One module per domain
modules.events = require(mymod.defines.modules.events)     -- FR : cycle de vie / EN : life cycle
modules.gui = require(mymod.defines.modules.gui)           -- FR : fenêtre panel / EN : panel window

return modules
