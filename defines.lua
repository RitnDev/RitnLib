ritnlib = {
    defines = {
        gvv = "__gvv__.gvv",             
        event = "__RitnLib__/core/eventListener",
        gui = "__RitnLib__/lualib/gui-functions",
        inventory = "__RitnLib__/lualib/inventory",
        entity = "__RitnLib__/lualib/entity-functions",
        --item = "__RitnLib__/lualib/item-functions",                 -- DEPRECATED
        --log = "__RitnLib__/lualib/log-functions",                   -- DEPRECATED
        styles = "__RitnLib__/lualib/LuaStyle-functions",
        --ore = "__RitnLib__/lualib/ore-functions",                   -- DEPRECATED
        other = "__RitnLib__/lualib/other-functions",
        table = "__RitnLib__/lualib/table-functions",
        json = "__RitnLib__/lualib/json-functions",
        --recipe = "__RitnLib__/lualib/recipe-functions",             -- DEPRECATED
        --technology = "__RitnLib__/lualib/technology-functions",     -- DEPRECATED
        vanilla = {
            util = "__RitnLib__/lualib/vanilla/util",
            crash_site = "__RitnLib__/lualib/vanilla/crash-site",
        },
        fonts = "__RitnLib__/prototypes/fonts",
        

        class = {
            core = "__RitnLib__.core.class",
            prototype = {
                tech = "__RitnLib__/classes/prototypes/Technology",
                ore = "__RitnLib__/classes/prototypes/Ore",
                entity = "__RitnLib__/classes/prototypes/Entity",
                item = "__RitnLib__/classes/prototypes/Item",
                recipe = "__RitnLib__/classes/prototypes/Recipe",
                group = "__RitnLib__/classes/prototypes/ItemGroup",
                subgroup = "__RitnLib__/classes/prototypes/ItemSubgroup",
                category = "__RitnLib__/classes/prototypes/RecipeCategory",
                fuelCategory = "__RitnLib__/classes/prototypes/FuelCategory",
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
                bold12 = "ritn-default-bold-12",
                bold14 = "ritn-default-bold-14",
                bold16 = "ritn-default-bold-16",
                bold18 = "ritn-default-bold-18",
                bold20 = "ritn-default-bold-20",
            }
        },
    }
}
