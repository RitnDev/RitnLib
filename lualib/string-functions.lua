local TOKEN_EMPTY_STRING = ""
local rLib = require("__RitnLib__/lualib/other-functions")
-----------------------------------------------------

-- Retourne vrai si la valeur est une chaine de caractère
local function isString(value) 
    return (type(value) == "string")
end

-- Si la chaine est vide ou nil on retourne une valeur par défaut
local function defaultValue(value, default)
    if default == nil then default = TOKEN_EMPTY_STRING end
    return rLib.ifElse(isString(value) == false, default, value)
end

-- Retourne true si la chaine est vide ou nil
local function isEmptyString(value)
    return rLib.ifElse(defaultValue(value) == TOKEN_EMPTY_STRING, true, false)
end

-- Retourne true si la chaine est non vide ou non nil
local function isNotEmptyString(value)
    return not isEmptyString(value)
end

-- Retourne true si la chaine est égale à nil
local function isNil(value)
    return rLib.ifElse(value == nil, true, false)
end

-- Retourne true si la chaine n'est pas égale à nil
local function isNotNil(value)
    return not isNil(value)
end


-- Retourne true si les 2 chaines sont égales
local function equals(value1, value2) 
    return value1 == value2
end

local function startsWith(str, value)
    if isString(str) == false then return false end
    if isString(value) == false then return false end
    return string.find(str, value) == 1
end

-----------------------------------------------------
local flib = {
    string = {
        -- Constants
        TOKEN_EMPTY_STRING = TOKEN_EMPTY_STRING,
        -- functions
        byte = string.byte,         -- Retourne le code numérique d'un ou plusieurs caractères. ( code ASCII )
        char = string.char,         -- Retourne un caractère ou une chaîne à partir de son code ASCII.
        dump = string.dump,         -- Retourne une chaîne en une représentation binaire de la fonction donnée.
        find = string.find,         -- Retourne l'emplacement du caractère ou de la sous-chaine recherché.
        format = string.format,     -- Retourne une chaîne de caractères formatée.
        gmatch = string.gmatch,     -- Retourne une sous-chaîne de la chaîne principale.
        gsub = string.gsub,         -- Remplace les occurences d'une sous-chaîne.
        replace = string.gsub,      -- Remplace les occurences d'une sous-chaîne.
        len = string.len,           -- Retourne la longueur d'une chaîne de caractères.
        length = string.len,        -- Retourne la longueur d'une chaîne de caractères.
        lower = string.lower,       -- Convertit les MAJUSCULES en minuscules.
        toLower = string.lower,     -- Convertit les MAJUSCULES en minuscules.
        upper = string.upper,       -- Convertit les minuscules en MAJUSCULES.
        toUpper = string.upper,     -- Convertit les minuscules en MAJUSCULES.
        match = string.match,       -- Retourne une sous chaîne de caractères.
        rep = string.rep,           -- Retourne une chaîne par concaténation multiple.
        reverse = string.reverse,   -- Inverse une chaîne de caractères.
        sub = string.sub,           -- Retourne une sous chaîne.
        isString = isString,
        defaultValue = defaultValue,            -- Si la chaine est vide ou nil on retourne une valeur par défaut
        isNotEmptyString = isNotEmptyString,    -- Retourne true si la chaine est non vide ou non nil
        isNotNil = isNotNil,                    -- Retourne true si la chaine n'est pas égale à nil
        isNil = isNil,                          -- Retourne true si la chaine est égale à nil
        isEmptyString = isEmptyString,          -- Retourne true si la chaine est vide ou nil
        equals = equals,                         -- Retourne true si les 2 chaines sont égales
        startsWith = startsWith,                 -- Retourne true si le début de la chaine commence par la valeur
    }
}
return flib.string