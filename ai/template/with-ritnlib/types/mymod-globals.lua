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

---@class MyModGuiPanel : RitnLibGui
---@field object_name string
---@operator call(table): MyModGuiPanel
MyModGuiPanel = {}
