-- INITIALIZE
-----------------------------------------------------------------
local libMod = "__RitnLib__"
local ritnlib = {}
ritnlib.util        = require(libMod .. ".lualib.other-functions")
ritnlib.entity      = require(libMod .. ".lualib.entity-functions")
ritnlib.ore         = require(libMod .. ".lualib.ore-functions")
ritnlib.item        = require(libMod .. ".lualib.item-functions")
ritnlib.recipe      = require(libMod .. ".lualib.recipe-functions")
ritnlib.tech        = require(libMod .. ".lualib.technology-functions")
ritnlib.gui         = require(libMod .. ".lualib.gui-functions")
ritnlib.style       = require(libMod .. ".lualib.LuaStyle-functions")
-----------------------------------------------------------------

if script.active_mods["gvv"] then require("__gvv__.gvv")() end