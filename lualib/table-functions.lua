-- TABLE Functions :
--------------------------


-- Retourne taille du tableau
local function length(table)
    local size = 0
    if table == nil then return size end
    for _ in pairs(table) do size = size + 1 end
    return size
  end
  
  
-- tableau est plein ?
local function busy(table)
    for key,_ in pairs(table) do
        if table[key] ~= nil then 
            return true
        end
    end
    return false
end
  
-- position de l'index par rapport à une valeur donnée
local function indexOf(table, value)
    local index = 0
    for i,v in pairs(table) do
        index = index + 1
        if table[i] == value then 
            return index
        end
    end
    return -1
end
  

--renvoie la valeur de l'index selon la valeur d'une key
local function index(table, key, value)
    for index,_ in pairs(table) do
      if table[index][key] == value then 
          return index
      end
    end
    return nil
end


local function spairs(t, order)
	-- bypass
	if order == nil then return pairs(t) end
	-- collect the keys
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys
	pcall(function()
		table.sort(keys, function(a,b) return order(t, a, b) end)
	end)

	-- return the iterator function
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
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
        busy = busy,
        length = length,
        indexOf = indexOf,
        index = index,
    }
}
return flib.table