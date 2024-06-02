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


local color = {
    white = {r=1,g=1,b=1,a=1},
    black = {r=0,g=0,b=0,a=1},
    darkgrey = {r=0.109804,g=0.109804,b=0.109804,a=1},
    grey = {r=0.557,g=0.557,b=0.557,a=1},
    lightgrey = {r=0.763,g=0.763,b=0.763,a=1},
    titlecolor = {r=1,g=0.901961,b=0.752941,a=1},
    orange = {r = 0.98, g = 0.66, b = 0.22},
    green = {r = 0.529, g = 0.847, b = 0.545, a=1},
}

local strings = {
    empty = "", 
    space = " ",
    hyphen = "-",
    ["hyphen-decorator"] = " - ",
    tilde = "~",
    ["tilde-decorator"] = " ~ ",
    tilde3 = "~~~",
    special = {
        ["right-arrow"] = "→",
        ["right-arrow-decorator"] = " → ",
        ["left-arrow"] = "←",
        ["left-arrow-decorator"] = " ← ",
        ["two-way-arrow"] = "↔",
        ["two-way-arrow-decorator"] = " ↔ ",
    },
    puce = {
        triangular = "‣",
        ["triangular-decorator"] = " ‣ ",
    }
}

------------------------------
constants.listTint = listTint
constants.tint = tint
constants.color = color
constants.strings = strings
------------------------------
return constants