local TOKEN_EMPTY_STRING = ""
local rLib = require("__RitnLib__/lualib/other-functions")
-----------------------------------------------------

-- Retourne vrai si la valeur est une chaine de caractère

---**EN**
---
---Description: Returns true if `value` is a string.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `value` est une string.
---@param value any
---@return boolean
local function isString(value)
    return (type(value) == "string")
end

-- Si la chaine est vide ou nil on retourne une valeur par défaut

---**EN**
---
---Description: Returns `value` if it's a string, else `default` (which itself defaults to `""`). The standard nil-safe string guard used across RitnLib.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne `value` si c'est une string, sinon `default` (qui par défaut vaut `""`). La garde nil-safe standard utilisée partout dans RitnLib.
---@param value any
---@param default? string  Default `""`
---@return string
local function defaultValue(value, default)
    if default == nil then default = TOKEN_EMPTY_STRING end
    return rLib.ifElse(isString(value) == false, default, value)
end

-- Retourne true si la chaine est vide ou nil

---**EN**
---
---Description: Returns true if `value` is the empty string, nil, or not a string at all.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `value` est la string vide, nil, ou pas une string du tout.
---@param value any
---@return boolean
local function isEmptyString(value)
    return rLib.ifElse(defaultValue(value) == TOKEN_EMPTY_STRING, true, false)
end

-- Retourne true si la chaine est non vide ou non nil

---**EN**
---
---Description: Negation of `isEmptyString`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Négation de `isEmptyString`.
---@param value any
---@return boolean
local function isNotEmptyString(value)
    return not isEmptyString(value)
end

-- Retourne true si la chaine est égale à nil

---**EN**
---
---Description: Returns true if `value` is nil.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `value` est nil.
---@param value any
---@return boolean
local function isNil(value)
    return rLib.ifElse(value == nil, true, false)
end

-- Retourne true si la chaine n'est pas égale à nil

---**EN**
---
---Description: Negation of `isNil`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Négation de `isNil`.
---@param value any
---@return boolean
local function isNotNil(value)
    return not isNil(value)
end


-- Retourne true si les 2 chaines sont égales

---**EN**
---
---Description: Plain `==` comparison.
---
---──────────────────────────────
---
---**FR**
---
---Description: Comparaison `==` simple.
---@param value1 any
---@param value2 any
---@return boolean
local function equals(value1, value2)
    return value1 == value2
end

---**EN**
---
---Description: Returns true if `str` starts with `value`, using `string.find` position 1.
---
---⚠ `value` is interpreted as a Lua **pattern**, not a plain string — magic characters (`-`, `%`, `.`, …) are active. e.g. `startsWith("a-b", "a-")` works but the `-` is a pattern quantifier.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `str` commence par `value`, via `string.find` position 1.
---
---⚠ `value` est interprété comme un **pattern** Lua, pas une string brute — les caractères magiques (`-`, `%`, `.`, …) sont actifs. ex: `startsWith("a-b", "a-")` fonctionne mais le `-` est un quantificateur de pattern.
---@param str any
---@param value any
---@return boolean
local function startsWith(str, value)
    if isString(str) == false then return false end
    if isString(value) == false then return false end
    return string.find(str, value) == 1
end

-----------------------------------------------------

---**EN**
---
---Description: RitnLib string utility module — exposed via `require(ritnlib.defines.string)`. Re-exports the native `string.*` functions (with French inline docs) augmented with nil-safe helpers (`defaultValue`, `isEmptyString`, `startsWith`, …).
---
---──────────────────────────────
---
---**FR**
---
---Description: Module utilitaire string de RitnLib — exposé via `require(ritnlib.defines.string)`. Ré-exporte les fonctions natives `string.*` (avec docs inline en français) augmentées des helpers nil-safe (`defaultValue`, `isEmptyString`, `startsWith`, …).
---@class RitnLibStringFunctions
---@field TOKEN_EMPTY_STRING ""                  Empty-string marker constant
---@field byte fun(s: string, i?: integer, j?: integer): integer ...
---@field char fun(...: integer): string
---@field dump fun(f: function): string
---@field find fun(s: string, pattern: string, init?: integer, plain?: boolean): integer?, integer?, ...
---@field format fun(s: string, ...: any): string
---@field gmatch fun(s: string, pattern: string): function
---@field gsub fun(s: string, pattern: string, repl: string|table|function, n?: integer): string, integer
---@field replace fun(s: string, pattern: string, repl: string|table|function, n?: integer): string, integer  Alias of `gsub`
---@field len fun(s: string): integer
---@field length fun(s: string): integer        Alias of `len`
---@field lower fun(s: string): string
---@field toLower fun(s: string): string        Alias of `lower`
---@field upper fun(s: string): string
---@field toUpper fun(s: string): string        Alias of `upper`
---@field match fun(s: string, pattern: string, init?: integer): string ...
---@field rep fun(s: string, n: integer): string
---@field reverse fun(s: string): string
---@field sub fun(s: string, i: integer, j?: integer): string
---@field isString fun(value: any): boolean
---@field defaultValue fun(value: any, default?: string): string
---@field isNotEmptyString fun(value: any): boolean
---@field isNotNil fun(value: any): boolean
---@field isNil fun(value: any): boolean
---@field isEmptyString fun(value: any): boolean
---@field equals fun(value1: any, value2: any): boolean
---@field startsWith fun(str: any, value: any): boolean
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
