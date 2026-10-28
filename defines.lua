---@class RitnLibDefinesVanilla
---@field util string
---@field crash_site string

---@class RitnLibDefinesClassPrototypeUtility
---@field constants string

---@class RitnLibDefinesClassPrototype
---@field tech string
---@field technology string
---@field ore string
---@field entity string
---@field item string
---@field recipe string
---@field group string
---@field subgroup string
---@field category string
---@field fuelCategory string
---@field tile string
---@field style string
---@field sprite string
---@field customInput string
---@field utility RitnLibDefinesClassPrototypeUtility

---@class RitnLibDefinesClassLuaClass
---@field event string
---@field player string
---@field entity string
---@field force string
---@field surface string
---@field recipe string
---@field tech string
---@field gui string

---@class RitnLibDefinesClassRitnClass
---@field prototype string
---@field ingredient string
---@field inventory string
---@field setting string
---@field informatron string

---@class RitnLibDefinesClassGui
---@field element string
---@field style string

---@class RitnLibDefinesClass
---@field core string
---@field prototype RitnLibDefinesClassPrototype
---@field luaClass RitnLibDefinesClassLuaClass
---@field ritnClass RitnLibDefinesClassRitnClass
---@field gui RitnLibDefinesClassGui

---@class RitnLibDefinesNamesFont
---@field defaut12 string
---@field defaut14 string
---@field defaut16 string
---@field defaut18 string
---@field defaut20 string
---@field defaut22 string
---@field defaut24 string
---@field defaut26 string
---@field defaut28 string
---@field defaut30 string
---@field defaut32 string
---@field bold12 string
---@field bold14 string
---@field bold16 string
---@field bold18 string
---@field bold20 string
---@field bold22 string
---@field bold24 string
---@field bold26 string
---@field bold28 string
---@field bold30 string
---@field bold32 string

---@class RitnLibDefinesNames
---@field font RitnLibDefinesNamesFont

---@class RitnLibDefines
---@field gvv string                                  Path to the gvv debugger entry point (optional dep).
---@field event string                                Path to the Factorio core event_handler (NOT the local fork).
---@field constants string                            Path to core/constants.lua (tints, colors, strings, types).
---@field other string                                Path to lualib/other-functions.lua (custom util.type, ifElse, …).
---@field table string                                Path to lualib/table-functions.lua.
---@field string string                               Path to lualib/string-functions.lua.
---@field json string                                 Path to lualib/json-functions.lua (rxi/json).
---@field vanilla RitnLibDefinesVanilla               Forks of Factorio vanilla helpers.
---@field fonts string                                Path to prototypes/fonts.lua — require from your data.lua to register ritn-default-* fonts.
---@field gui_styles string                           Path to prototypes/gui-style.lua — require from your data.lua to register *-ritngui styles.
---@field setup string                                Path to core/setup-classes.lua (used internally).
---@field class RitnLibDefinesClass                   Paths to every RitnLib class file.
---@field names RitnLibDefinesNames                   Constants for prototype names (fonts, …).

---@class RitnLibGlobal
---@field defines RitnLibDefines
---@field classFactory RitnClassFactory

---Path registry and class factory shared by every RitnLib consumer.
---Required once at the top of any consumer file; subsequent requires are idempotent.
---
---Usage:
--- ```lua
--- require("__RitnLib__.defines")
--- local Recipe = require(ritnlib.defines.class.prototype.recipe)
--- ```
---@type RitnLibGlobal
ritnlib = {
    defines = {
        gvv = "__gvv__.gvv",
        event = "__core__/lualib/event_handler",
        constants = "__RitnLib__.core.constants",

        other = "__RitnLib__/lualib/other-functions",
        table = "__RitnLib__/lualib/table-functions",
        string = "__RitnLib__/lualib/string-functions",
        json = "__RitnLib__/lualib/json-functions",
        vanilla = {
            util = "__RitnLib__/lualib/vanilla/util",
            crash_site = "__RitnLib__/lualib/vanilla/crash-site",
        },
        fonts = "__RitnLib__/prototypes/fonts",
        gui_styles = "__RitnLib__/prototypes/gui-style",
        -- gui,                         -- DEPRECATED
        -- inventory,                   -- DEPRECATED
        -- item,                        -- DEPRECATED
        -- log,                         -- DEPRECATED
        -- styles,                      -- DEPRECATED
        -- ore,                         -- DEPRECATED
        -- recipe,                      -- DEPRECATED
        -- entity,                      -- DEPRECATED
        -- technology,                  -- DEPRECATED

        -- setup-classes
        setup = "__RitnLib__.core.setup-classes",


        class = {
            core = "__RitnLib__.core.class",
            prototype = {
                tech = "__RitnLib__/classes/prototypes/Technology",
                technology = "__RitnLib__/classes/prototypes/Technology",
                ore = "__RitnLib__/classes/prototypes/Ore",
                entity = "__RitnLib__/classes/prototypes/Entity",
                item = "__RitnLib__/classes/prototypes/Item",
                recipe = "__RitnLib__/classes/prototypes/Recipe",
                group = "__RitnLib__/classes/prototypes/ItemGroup",
                subgroup = "__RitnLib__/classes/prototypes/ItemSubgroup",
                category = "__RitnLib__/classes/prototypes/RecipeCategory",
                fuelCategory = "__RitnLib__/classes/prototypes/FuelCategory",
                tile = "__RitnLib__/classes/prototypes/Tile",
                style = "__RitnLib__/classes/prototypes/Style",
                sprite = "__RitnLib__/classes/prototypes/Sprite",
                customInput = "__RitnLib__/classes/prototypes/CustomInput",
                utility = {
                    constants = "__RitnLib__/classes/prototypes/UtilityConstants",
                }
            },
            luaClass = {
                event = "__RitnLib__/classes/LuaClass/RitnEvent",
                player = "__RitnLib__/classes/LuaClass/RitnPlayer",
                entity = "__RitnLib__/classes/LuaClass/RitnEntity",
                force = "__RitnLib__/classes/LuaClass/RitnForce",
                surface = "__RitnLib__/classes/LuaClass/RitnSurface",
                recipe = "__RitnLib__/classes/LuaClass/RitnRecipe",
                tech = "__RitnLib__/classes/LuaClass/RitnTechnology",
                gui = "__RitnLib__/classes/LuaClass/RitnGui",
            },
            ritnClass = {
                prototype = "__RitnLib__/classes/RitnClass/RitnPrototype",
                ingredient = "__RitnLib__/classes/RitnClass/RitnIngredient",
                inventory = "__RitnLib__/classes/RitnClass/RitnInventory",
                setting = "__RitnLib__/classes/RitnClass/RitnSetting",
                informatron = "__RitnLib__/classes/RitnClass/RitnInformatron", -- beta
            },
            gui = {
                element = "__RitnLib__/classes/RitnClass/gui/RitnGuiElement",
                style = "__RitnLib__/classes/RitnClass/gui/RitnStyle",
            },
        },


        names = {
            font = {
                defaut12 = "ritn-default-12",
                defaut14 = "ritn-default-14",
                defaut16 = "ritn-default-16",
                defaut18 = "ritn-default-18",
                defaut20 = "ritn-default-20",
                defaut22 = "ritn-default-22",
                defaut24 = "ritn-default-24",
                defaut26 = "ritn-default-26",
                defaut28 = "ritn-default-28",
                defaut30 = "ritn-default-30",
                defaut32 = "ritn-default-32",
                bold12 = "ritn-default-bold-12",
                bold14 = "ritn-default-bold-14",
                bold16 = "ritn-default-bold-16",
                bold18 = "ritn-default-bold-18",
                bold20 = "ritn-default-bold-20",
                bold22 = "ritn-default-bold-22",
                bold24 = "ritn-default-bold-24",
                bold26 = "ritn-default-bold-26",
                bold28 = "ritn-default-bold-28",
                bold30 = "ritn-default-bold-30",
                bold32 = "ritn-default-bold-32",
            }
        },
    }
}


ritnlib.classFactory = require(ritnlib.defines.class.core)
