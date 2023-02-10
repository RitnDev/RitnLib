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
        --recipe = "__RitnLib__/lualib/recipe-functions",             -- DEPRECATED
        --technology = "__RitnLib__/lualib/technology-functions",     -- DEPRECATED
        vanilla = {
            util = "__RitnLib__/lualib/vanilla/util",
            crash_site = "__RitnLib__/lualib/vanilla/crash-site",
        },


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
                utility = {
                    constants = "__RitnLib__/classes/prototypes/UtilityConstants",
                }
            },
            luaClass = {
                event = "__RitnLib__/classes/LuaClass/RitnEvent",
                player = "__RitnLib__/classes/LuaClass/RitnPlayer",
                force = "__RitnLib__/classes/LuaClass/RitnForce",
                recipe = "__RitnLib__/classes/LuaClass/RitnRecipe",
                tech = "__RitnLib__/classes/LuaClass/RitnTechnology",
            },
            ritnClass = {
                prototype = "__RitnLib__/classes/RitnClass/RitnPrototype",
                ingredient = "__RitnLib__/classes/RitnClass/RitnIngredient",
            } 
        },
    }
}
