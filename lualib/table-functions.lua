-- TABLE Functions :
--------------------------------------------------------------
local rLib = require("__RitnLib__/lualib/other-functions")
--------------------------------------------------------------

-- Retourne vrai si la valeur est une table

---**EN**
---
---Description: Returns true if `value` is a non-nil table.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `value` est une table non-nil.
---@param value any
---@return boolean
local function isTable(value)
    if value == nil then return false end
    return (type(value) == "table")
end


-- Retourne vrai si la valeur est une position

---**EN**
---
---Description: Returns true if `value` is a `MapPosition`-shaped table with numeric `.x` and `.y` fields.
---
---⚠ Only recognises the object form `{x = …, y = …}`. The pure array form `{x, y}` (also accepted by Factorio APIs) is rejected.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `value` est une table de forme `MapPosition` avec des champs numériques `.x` et `.y`.
---
---⚠ Ne reconnaît que la forme objet `{x = …, y = …}`. La forme array pure `{x, y}` (aussi acceptée par les API Factorio) est rejetée.
---@param value any
---@return boolean
local function isPosition(value)
    if not isTable(value) then return false end
    if #value > 2 then return false end
    if value.x == nil then return false end
    if (type(value.x) ~= "number") then return false end
    if value.y == nil then return false end
    if (type(value.y) ~= "number") then return false end

    return true
end


-- Retourne taille du tableau

---**EN**
---
---Description: Returns the element count of `pTable` via Factorio's `table_size` (works on dict-style tables, unlike `#`). Returns -1 when the input is not a table.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le nombre d'éléments de `pTable` via le `table_size` de Factorio (fonctionne sur les tables dict, contrairement à `#`). Retourne -1 quand l'entrée n'est pas une table.
---@param pTable any
---@return integer
local function length(pTable)
    return rLib.ifElse(isTable(pTable), table_size(pTable), -1)
end


-- tableau est vide ?

---**EN**
---
---Description: Returns true if `pTable` has no elements (or is not a table).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `pTable` n'a aucun élément (ou n'est pas une table).
---@param pTable any
---@return boolean
local function isEmpty(pTable)
    return rLib.ifElse(length(pTable) <= 0, true, false)
end

-- tableau est vide ?

---**EN**
---
---Description: Negation of `isEmpty`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Négation de `isEmpty`.
---@param pTable any
---@return boolean
local function isNotEmpty(pTable)
    return not isEmpty(pTable)
end


-- tableau est plein ?

---**EN**
---
---Description: Returns true as soon as one key with a non-nil value is found in `pTable`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true dès qu'une clé avec une valeur non-nil est trouvée dans `pTable`.
---@param pTable table
---@return boolean
local function busy(pTable)
    for key,_ in pairs(pTable) do
        if pTable[key] ~= nil then
            return true
        end
    end
    return false
end


-- position de l'index par rapport à une valeur donnée

---**EN**
---
---Description: Returns the 1-based iteration position of the first element equal to `pValue`, or -1 if absent.
---
---⚠ The returned value is the **iteration order position** (the Nth pair visited by `pairs`), not necessarily the table key. For pure array tables both coincide.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne la position d'itération (base 1) du premier élément égal à `pValue`, ou -1 si absent.
---
---⚠ La valeur retournée est la **position dans l'ordre d'itération** (le Nème couple visité par `pairs`), pas forcément la clé de la table. Pour les tables array pures les deux coïncident.
---@param pTable any
---@param pValue any
---@return integer
local function indexOf(pTable, pValue)
    local rIndex = -1

    if isTable(pTable) then
        local index = 0
        for i,v in pairs(pTable) do
            index = index + 1
            if pTable[i] == pValue then
                rIndex = index
                break
            end
        end
    end

    return rIndex
end


--renvoie la valeur de l'index selon la valeur d'une key

---**EN**
---
---Description: Searches a table of records and returns the key of the first record whose `record[key] == value`, or -1 if none.
---
---Example: `index(entities, "unit_number", 42)` returns the table key of the entity with `unit_number == 42`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Cherche dans une table d'enregistrements et retourne la clé du premier enregistrement dont `record[key] == value`, ou -1 si aucun.
---
---Exemple : `index(entities, "unit_number", 42)` retourne la clé de table de l'entité avec `unit_number == 42`.
---@param pTable table
---@param key any
---@param value any
---@return any  Table key of the matching record, or -1
local function index(pTable, key, value)
    local rIndex = -1

    if isNotEmpty(pTable) then
        for index,_ in pairs(pTable) do
            if pTable[index][key] == value then
                rIndex = index
                break
            end
        end
    end

    return rIndex
end

--renvoie la valeur de l'index selon la position dans le tableau (min position = 1)

---**EN**
---
---Description: Returns the table key found at the `pPosition`-th step of `pairs` iteration (1-based), or nil if out of range.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne la clé de table trouvée à la `pPosition`-ième étape de l'itération `pairs` (base 1), ou nil si hors limite.
---@param pTable table
---@param pPosition integer
---@return any?
local function getIndex(pTable, pPosition)
    local indexPosition = 0

    if isNotEmpty(pTable) then
        for index,_ in pairs(pTable) do
            indexPosition = indexPosition + 1
            if (indexPosition == pPosition) then
                return index
            end
        end
    end

    return nil
end


-- Vérifie que la clé existe dans la table

---**EN**
---
---Description: Returns true if `key` exists as a key of `pTable`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `key` existe comme clé de `pTable`.
---@param pTable table
---@param key any
---@return boolean
local function containsKey(pTable, key)
    local result = false
    for index,_ in pairs(pTable) do
        if index == key then
            result = true
            break
        end
    end
    return result
end



-- Supprime de la table le premier element égale à la valeur trouvé dans la table

---**EN**
---
---Description: Removes (via `table.remove`) the first element equal to `value`, using `indexOf` to locate it.
---
---──────────────────────────────
---
---**FR**
---
---Description: Supprime (via `table.remove`) le premier élément égal à `value`, en le localisant via `indexOf`.
---@param pTable table
---@param value any
local function removeByValue(pTable, value)
    local index = indexOf(pTable, value)
    if index > 0 then
        table.remove(pTable, index)
    end
end



-- Retourne une valeur au hasard de mon tableau

---**EN**
---
---Description: Returns a random element of the array `pTable` via `math.random`, or nil when empty.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un élément au hasard de l'array `pTable` via `math.random`, ou nil si vide.
---@param pTable table
---@return any?
local function getRandom(pTable)
    if isEmpty(pTable) then return nil end
    local min = 1
    local max = length(pTable)
    local index = math.random(min, max)

    return pTable[index]
end


---**EN**
---
---Description: Sorted-pairs iterator. With no `order` function, falls back to plain `pairs`. Otherwise collects the keys, sorts them with `order(pTable, a, b)` (inside a pcall), and returns an iterator that walks them in sorted order.
---
---⚠ Defined here but **not exported** in the returned module table — only usable inside this file.
---
---──────────────────────────────
---
---**FR**
---
---Description: Itérateur à paires triées. Sans fonction `order`, fallback sur `pairs` simple. Sinon collecte les clés, les trie avec `order(pTable, a, b)` (dans un pcall), et retourne un itérateur qui les parcourt dans l'ordre trié.
---
---⚠ Définie ici mais **non exportée** dans la table de module retournée — utilisable seulement dans ce fichier.
---@param pTable table
---@param order? fun(t: table, a: any, b: any): boolean
---@return function
local function spairs(pTable, order)
	-- bypass
	if order == nil then return pairs(pTable) end
	-- collect the keys
	local keys = {}
	for k in pairs(pTable) do keys[#keys+1] = k end

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys
	pcall(function()
		table.sort(keys, function(a,b) return order(pTable, a, b) end)
	end)

	-- return the iterator function
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], pTable[keys[i]]
		end
	end
end



-----------------------------------------------------

---**EN**
---
---Description: RitnLib table utility module — exposed via `require(ritnlib.defines.table)`. Re-exports the native/Factorio `table.*` functions (`deepcopy`, `compare`, `insert`, …) augmented with the helpers above.
---
---──────────────────────────────
---
---**FR**
---
---Description: Module utilitaire table de RitnLib — exposé via `require(ritnlib.defines.table)`. Ré-exporte les fonctions natives/Factorio `table.*` (`deepcopy`, `compare`, `insert`, …) augmentées des helpers ci-dessus.
---@class RitnLibTableFunctions
---@field compare fun(tbl1: table, tbl2: table): boolean       Factorio `table.compare`
---@field concat fun(list: table, sep?: string, i?: integer, j?: integer): string
---@field deepcopy fun(object: any): any                       Factorio `table.deepcopy`
---@field insert fun(list: table, pos_or_value: any, value?: any)
---@field maxn fun(list: table): number
---@field pack fun(...: any): table
---@field pairs_concat function?                               ⚠ `table.pairs_concat` doesn't exist in the Factorio runtime — always nil
---@field remove fun(list: table, pos?: integer): any
---@field removeByValue fun(pTable: table, value: any)
---@field sort fun(list: table, comp?: fun(a: any, b: any): boolean)
---@field unpack fun(list: table, i?: integer, j?: integer): ...
---@field getRandom fun(pTable: table): any?
---@field busy fun(pTable: table): boolean
---@field isEmpty fun(pTable: any): boolean
---@field isNotEmpty fun(pTable: any): boolean
---@field empty fun(pTable: any): boolean                      Alias of `isEmpty`
---@field length fun(pTable: any): integer
---@field indexOf fun(pTable: any, pValue: any): integer
---@field index fun(pTable: table, key: any, value: any): any
---@field getIndex fun(pTable: table, pPosition: integer): any?
---@field isTable fun(value: any): boolean
---@field isPosition fun(value: any): boolean
---@field containsKey fun(pTable: table, key: any): boolean
local flib = {
    table = {
        compare = table.compare,
        concat = table.concat,
        deepcopy = table.deepcopy,
        insert = table.insert,
        maxn = table.maxn,
        pack = table.pack,
        pairs_concat = table.pairs_concat,
        remove = table.remove,
        removeByValue = removeByValue,
        sort = table.sort,
        unpack = table.unpack,
        getRandom = getRandom,
        busy = busy,
        isEmpty = isEmpty,
        isNotEmpty = isNotEmpty,
        empty = isEmpty,
        length = length,
        indexOf = indexOf,
        index = index,
        getIndex = getIndex,
        isTable = isTable,
        isPosition = isPosition,
        containsKey = containsKey,
    }
}
return flib.table
