---@meta
---@diagnostic disable
-- ============================================================================
-- Type-only meta file for MyMod runtime globals.
-- ============================================================================
-- NOT loaded at runtime by Factorio. Sole purpose: help LuaLS resolve global
-- class references across source files (shipped in the mod zip on purpose).
--
-- Discipline: when you add a @field to a class in its source file, mirror it
-- here too. Keep the @operator call signatures identical.
-- ============================================================================

---@class MyModGlobal
---@field defines table
---@field classFactory MyModClassFactory
mymod = {}

---@class MyModPlayer
---@field object_name string
---@field isPresent boolean
---@field player LuaPlayer
---@field index uint
---@field name string
---@field admin boolean
---@field connected boolean
---@operator call(LuaPlayer?): MyModPlayer
MyModPlayer = {}

---@class MyModGui : MyModPlayer
---@field object_name string
---@field event table
---@field element LuaGuiElement?
---@field gui_name string
---@field main_gui string
---@field gui LuaGuiElement[]
---@field content table
---@field gui_action table<string, string|function>
---@operator call(table, string?, string?): MyModGui
MyModGui = {}

---@class MyModGuiElement
---@field object_name string
---@field gui_name string
---@field name string
---@field type string
---@field ui string
---@field action string
---@field gui_element table
---@operator call(string, string, string): MyModGuiElement
MyModGuiElement = {}

---@class MyModGuiPanel : MyModGui
---@field object_name string
---@operator call(table): MyModGuiPanel
MyModGuiPanel = {}
