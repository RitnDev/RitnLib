local constants = {}


local tint = {

    ["red"] = --Rouge
        {
            primary = {r = 1.000, g = 0.0958, b = 0.0958, a = 1.000},
            secondary = {r = 1.000, g = 0.0852, b = 0.172, a = 1.000},
            tertiary = {r = 1.000, g = 0.0869, b = 0.0597, a = 1.000},
            quaternary = {r = 1.000, g = 0.1, b = 0.19, a = 1.000},
        },

    ["green"] = --Vert
        {
            primary = {r = 0.268, g = 0.723, b = 0.223, a = 1.000},
            secondary = {r = 0.432, g = 0.793, b = 0.386, a = 1.000},
            tertiary = {r = 0.323, g = 0.717, b = 0.043, a = 1.000},
            quaternary = {r = 0.400, g = 0.823, b = 0.099, a = 1.000},
        },

    ["blue"] = --Bleu
        {
            primary = {r = 0.268, g = 0.723, b = 0.969, a = 1.000},
            secondary = {r = 0.432, g = 0.793, b = 0.969, a = 1.000},
            tertiary = {r = 0.268, g = 0.723, b = 0.969, a = 1.000},
            quaternary = {r = 0.432, g = 0.793, b = 0.969, a = 1.000},
        },

    ["yellow"] = --Jaune
        {
        primary = {r = 1.000, g = 0.958, b = 0.000, a = 1.000},
        secondary = {r = 1.000, g = 0.852, b = 0.172, a = 1.000},
        tertiary = {r = 0.876, g = 0.869, b = 0.597, a = 1.000},
        quaternary = {r = 0.969, g = 1.000, b = 0.019, a = 1.000},
        },

    ["purple"] = --Violet
        {
            primary = {r = 0.755, g = 0.245, b = 0.869, a = 1.000},
            secondary = {r = 0.852, g = 0.382, b = 0.965, a = 1.000},
            tertiary = {r = 0.607, g = 0.295, b = 0.677, a = 1.000},
            quaternary = {r = 0.467, g = 0.162, b = 0.535, a = 1.000},
        },

    ["black"] = --Noir
        {
            primary = {r = 0.035, g = 0.033, b = 0.033, a = 1.000},
            secondary = {r = 0.116, g = 0.116, b = 0.116, a = 1.000},
            tertiary = {r = 0.051, g = 0.051, b = 0.051, a = 1.000},
            quaternary = {r = 0.017, g = 0.017, b = 0.017, a = 1.000},
        },


    ["automation"] = --Rouge
        {
            primary = {r = 1.000, g = 0.0958, b = 0.0958, a = 1.000},
            secondary = {r = 1.000, g = 0.0852, b = 0.172, a = 1.000},
            tertiary = {r = 1.000, g = 0.0869, b = 0.0597, a = 1.000},
            quaternary = {r = 1.000, g = 0.1, b = 0.19, a = 1.000},
        },

    ["logistic"] = --Vert
        {
            primary = {r = 0.268, g = 0.723, b = 0.223, a = 1.000},
            secondary = {r = 0.432, g = 0.793, b = 0.386, a = 1.000},
            tertiary = {r = 0.323, g = 0.717, b = 0.043, a = 1.000},
            quaternary = {r = 0.400, g = 0.823, b = 0.099, a = 1.000},
        },

    ["chemical"] = --Bleu
        {
            primary = {r = 0.268, g = 0.723, b = 0.969, a = 1.000},
            secondary = {r = 0.432, g = 0.793, b = 0.969, a = 1.000},
            tertiary = {r = 0.268, g = 0.723, b = 0.969, a = 1.000},
            quaternary = {r = 0.432, g = 0.793, b = 0.969, a = 1.000},
        },

    ["utility"] = --Jaune
        {
        primary = {r = 1.000, g = 0.958, b = 0.000, a = 1.000},
        secondary = {r = 1.000, g = 0.852, b = 0.172, a = 1.000},
        tertiary = {r = 0.876, g = 0.869, b = 0.597, a = 1.000},
        quaternary = {r = 0.969, g = 1.000, b = 0.019, a = 1.000},
        },

    ["production"] = --Violet
        {
            primary = {r = 0.755, g = 0.245, b = 0.869, a = 1.000},
            secondary = {r = 0.852, g = 0.382, b = 0.965, a = 1.000},
            tertiary = {r = 0.607, g = 0.295, b = 0.677, a = 1.000},
            quaternary = {r = 0.467, g = 0.162, b = 0.535, a = 1.000},
        },

    ["military"] = --Noir
        {
            primary = {r = 0.035, g = 0.033, b = 0.033, a = 1.000},
            secondary = {r = 0.116, g = 0.116, b = 0.116, a = 1.000},
            tertiary = {r = 0.051, g = 0.051, b = 0.051, a = 1.000},
            quaternary = {r = 0.017, g = 0.017, b = 0.017, a = 1.000},
        },

}


local listTint = {
    "red",
    "green",
    "blue",
    "yellow",
    "purple",
    "black",
    "automation",
    "logistic",
    "chemical",
    "utility",
    "production",
    "military",
}



------------------------------
constants.listTint = listTint
constants.tint = tint
------------------------------
return constants