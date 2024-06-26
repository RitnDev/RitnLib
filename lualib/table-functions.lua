-- TABLE Functions :
--------------------------------------------------------------
local rLib = require("__RitnLib__/lualib/other-functions")
--------------------------------------------------------------

-- Retourne vrai si la valeur est une table
local function isTable(value) 
    if value == nil then return false end 
    return (type(value) == "table")
end


-- Retourne vrai si la valeur est une position
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
local function length(pTable)
    return rLib.ifElse(isTable(pTable), table_size(pTable), -1)
end


-- tableau est vide ?
local function isEmpty(pTable)
    return rLib.ifElse(length(pTable) <= 0, true, false)
end

-- tableau est vide ?
local function isNotEmpty(pTable)
    return not isEmpty(pTable)
end
  

-- tableau est plein ?
local function busy(pTable)
    for key,_ in pairs(pTable) do
        if pTable[key] ~= nil then 
            return true
        end
    end
    return false
end


-- position de l'index par rapport à une valeur donnée
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


-- Retourne une valeur au hasard de mon tableau
local function getRandom(pTable)
    if isEmpty(pTable) then return nil end
    local min = 1
    local max = length(pTable)
    local index = math.random(min, max)

    return pTable[index]
end


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
    }
}
return flib.table