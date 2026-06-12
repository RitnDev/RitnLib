---@meta
---@diagnostic disable

-- ============================================================================
-- Type-only meta file for RitnLib runtime classes.
-- ============================================================================
--
-- NOT loaded at runtime by Factorio. Sole purpose: help LuaLS resolve global
-- class references across source files.
--
-- The full class definitions (with bilingual descriptions and method docs)
-- live in their respective source files in classes/LuaClass/ etc. This file
-- re-declares the @class signatures inline so Sumneko picks them up reliably
-- even when cross-file global resolution fails.
--
-- Discipline: when you add a @field to a class in its source file, mirror it
-- here too. Keep the @operator call signatures identical.
-- ============================================================================


-- ═══ classes/LuaClass/ (runtime wrappers) ═══════════════════════════════════

---@class RitnLibEvent
---@field isPresent boolean
---@field mod_name string
---@field event EventData
---@field name string
---@field index uint
---@field object_name "RitnLibEvent"
---@field player LuaPlayer?
---@field surface LuaSurface?
---@field force LuaForce?
---@field recipe LuaRecipe?
---@field technology LuaTechnology?
---@field entity LuaEntity?
---@field robot LuaEntity?
---@field rocket LuaEntity?
---@field inventory LuaInventory?
---@field cause LuaEntity?
---@field reason defines.disconnect_reason?
---@field queued_count number?
---@field gui_type string?
---@field source LuaForce?
---@field source_name string?
---@field area BoundingBox?
---@field element LuaGuiElement?
---@field setting_name string?
---@field setting_type string?
---@field position MapPosition?
---@operator call(EventData, string?): RitnLibEvent
RitnLibEvent = {}

---@class RitnLibPlayer
---@field player LuaPlayer
---@field index uint
---@field name string
---@field surface LuaSurface
---@field force LuaForce
---@field controller_type defines.controllers
---@field controller_name string?
---@field character LuaEntity?
---@field admin boolean
---@field driving boolean
---@field vehicle LuaEntity?
---@field connected boolean
---@field isPresent boolean
---@field object_name "RitnLibPlayer"
---@operator call(LuaPlayer): RitnLibPlayer
RitnLibPlayer = {}

---@class RitnLibSurface
---@field surface LuaSurface
---@field name string
---@field index uint
---@field isNauvis boolean
---@field isPresent boolean
---@field object_name "RitnLibSurface"
---@operator call(LuaSurface): RitnLibSurface
RitnLibSurface = {}

---@class RitnLibForce
---@field force LuaForce
---@field name string
---@field index uint
---@field items_launched table<string, uint>?
---@field rockets_launched uint?
---@field FORCE_ENEMY_NAME "enemy"
---@field FORCE_PLAYER_NAME "player"
---@field FORCE_NEUTRAL_NAME "neutral"
---@field isPresent boolean
---@field object_name "RitnLibForce"
---@operator call(LuaForce): RitnLibForce
RitnLibForce = {}

---@class RitnLibEntity
---@field entity LuaEntity
---@field name string
---@field id uint?
---@field unit_number uint?
---@field type string
---@field prototype LuaEntityPrototype
---@field surface LuaSurface
---@field force LuaForce
---@field position MapPosition
---@field backer_name string?
---@field isCharacter boolean
---@field isCar boolean
---@field isSpiderVehicle boolean
---@field allowsPassenger boolean
---@field player LuaPlayer?
---@field drive LuaEntity|LuaPlayer|nil
---@field passenger LuaEntity|LuaPlayer|nil
---@field TOKEN_EMPTY_STRING string
---@field isPresent boolean
---@field object_name "RitnLibEntity"
---@operator call(LuaEntity): RitnLibEntity
RitnLibEntity = {}

---@class RitnLibRecipe
---@field recipe LuaRecipe
---@field prototype LuaRecipePrototype
---@field isPresent boolean
---@field object_name "RitnLibRecipe"
---@operator call(LuaRecipe): RitnLibRecipe
RitnLibRecipe = {}

---@class RitnLibTechnology
---@field technology LuaTechnology
---@field name string
---@field force LuaForce
---@field entity_type string
---@field isPresent boolean
---@field object_name "RitnLibTechnology"
---@operator call(LuaTechnology): RitnLibTechnology
RitnLibTechnology = {}

---@class RitnLibGui : RitnLibPlayer
---@field object_name "RitnLibGui"
---@field mod_name string
---@field event EventData
---@field element LuaGuiElement?
---@field gui_action table<string, table<string, true>>
---@field content table
---@field gui_name string
---@field main_gui string?
---@field gui table
---@field list_valid table<string, true>
---@field pattern string
---@operator call(EventData, string, string?): RitnLibGui
RitnLibGui = {}


-- ═══ classes/RitnClass/ (hybrid classes) ════════════════════════════════════

---@class RitnLibInformatron : RitnLibGui
---@field object_name "RitnLibInformatron"
---@field gui_name "informatron"
---@field page_name string?
---@field gui { [1]: LuaGuiElement }
---@field content table
---@field content_origine string[]
---@field FLAG_PAGE_DISPLAY true
---@field FLAG_PAGE_NOT_DISPLAY false
---@operator call(string, EventData): RitnLibInformatron
RitnLibInformatron = {}

---@class RitnLibInventory
---@field object_name "RitnLibInventory"
---@field data table<string, table>
---@field player LuaPlayer
---@field name string
---@field INVENTORY_SIZE_MAX 65535
---@field inventory_size integer
---@operator call(LuaPlayer, table): RitnLibInventory
RitnLibInventory = {}


-- ═══ classes/RitnClass/gui/ (GUI builders) ══════════════════════════════════

---@class RitnLibGuiElement
---@field object_name "RitnLibGuiElement"
---@field gui_name string
---@field pattern string
---@field name string
---@field type string
---@field ui string
---@field action string
---@field hsp "auto"|"never"|"always"|"auto-and-reserve-space"|"dont-show-but-allow-scrolling"
---@field hsp_valid table<string, true>
---@field string_valid table<string, true>
---@field orientation_valid table<string, true>
---@field text_valid table<string, true>
---@field button_valid table<string, true>
---@field sprite_valid table<string, true>
---@field check_valid table<string, true>
---@field gui_element table
---@operator call(string, string, string): RitnLibGuiElement
RitnLibGuiElement = {}

---@class RitnLibStyle
---@field object_name "RitnLibStyle"
---@field style LuaStyle
---@field stretch boolean
---@field visible boolean
---@field center "center"
---@field color table
---@field alignH string
---@field alignV string
---@operator call(LuaGuiElement): RitnLibStyle
RitnLibStyle = {}
