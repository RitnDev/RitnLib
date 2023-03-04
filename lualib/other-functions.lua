--Others Functions :
--------------------------

-- print() pour Ritn uniquement
local function ritnPrint(txt)
  if game.players.Ritn.valid then
      game.players.Ritn.print(txt)
  end
end


local function ritnLog(txt) 
  local statut, errorMsg = pcall(function() 
      print(txt)
  end)
  if statut == (false or nil) then 
      print(">> error ritnlog : " .. errorMsg)
  end
end


--La chaîne de caractère 'str' commence par 'start'
local function str_start(str, start)
    return str:sub(1, #start) == start
end

-- Retourne taille du tableau

local function tableLength(T)
  local size = 0
  if T == nil then return size end
  for _ in pairs(T) do size = size + 1 end
  return size
end


-- tableau est plein ?
local function tableBusy(table)
    for key,_ in pairs(table) do
        if table[key] ~= nil then 
            return true
        end
    end
    return false
end



-- Retourne tableau 
local function split(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    return t
end
  
--récupère le nombre d'entité / items
local function getn(tab)
  if tab ~= nil then
      if type(tab.n) == "number" then return t.n end
      local result = 0
      for i, _ in pairs(tab) do
          if type(i) == "number" and i>result then 
            result=i 
          end
      end
      return result
  else
      return 0
  end
end

-- give item
local function give_item(LuaPlayer, item)
  LuaPlayer.insert(item)
end

-- Give une list d'items
local function give_item_list(LuaPlayer, items)
    for _, item in pairs(items) do
        give_item(LuaPlayer, item)
    end
end
  
-- Transforme un nombre de sec en timer foramt 00:00:00
local function build_clock_string(time)
      local seconds = time
  
      if seconds <= 0 then
          return "00:00:00";
      else
          local hours = string.format("%02.f", math.floor(seconds/3600));
          local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
          local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
          return hours..":"..mins..":"..secs
      end
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


local function writeToProductionStats(identifierer, appendContent)
    currentProductionStats = currentProductionStats .. identifierer .. appendContent;
	tempProductionStats = tempProductionStats .. "p" .. identifierer .. appendContent;
end

local function writeToOutput(output, appendContent)
	if appendContent ~= nil then
		return output .. appendContent
	end
end

local function uuid()
	local random = math.random
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end



-- Ajoute les tuyaux d'entrées pour les machines d'assemblages 1 
local function assembler1pipepictures(path)
    return
    {
      north =
      {
        filename = path .."/assembling-machine-1-pipe-N.png",
        priority = "extra-high",
        width = 35,
        height = 18,
        shift = util.by_pixel(2.5, 14),
        hr_version =
        {
          filename = path .."/hr-assembling-machine-1-pipe-N.png",
          priority = "extra-high",
          width = 71,
          height = 38,
          shift = util.by_pixel(2.25, 13.5),
          scale = 0.5
        }
      },
      east =
      {
        filename = path .."/assembling-machine-1-pipe-E.png",
        priority = "extra-high",
        width = 20,
        height = 38,
        shift = util.by_pixel(-25, 1),
        hr_version =
        {
          filename = path .."/hr-assembling-machine-1-pipe-E.png",
          priority = "extra-high",
          width = 42,
          height = 76,
          shift = util.by_pixel(-24.5, 1),
          scale = 0.5
        }
      },
      south =
      {
        filename = path .."/assembling-machine-1-pipe-S.png",
        priority = "extra-high",
        width = 44,
        height = 31,
        shift = util.by_pixel(0, -31.5),
        hr_version =
        {
          filename = path.."/hr-assembling-machine-1-pipe-S.png",
          priority = "extra-high",
          width = 88,
          height = 61,
          shift = util.by_pixel(0, -31.25),
          scale = 0.5
        }
      },
      west =
      {
        filename = path .."/assembling-machine-1-pipe-W.png",
        priority = "extra-high",
        width = 19,
        height = 37,
        shift = util.by_pixel(25.5, 1.5),
        hr_version =
        {
          filename = path .."/hr-assembling-machine-1-pipe-W.png",
          priority = "extra-high",
          width = 39,
          height = 73,
          shift = util.by_pixel(25.75, 1.25),
          scale = 0.5
        }
      }
    }
  end

local function pipecoverspictures(path)
    return
    {
      north =
      {
        layers =
        {
          {
            filename = path .."/pipe-cover-north.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            hr_version =
            {
              filename = path .."/hr-pipe-cover-north.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5
            }
          },
          {
            filename = path .."/pipe-cover-north-shadow.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            draw_as_shadow = true,
            hr_version =
            {
              filename = path .."/hr-pipe-cover-north-shadow.png", -- "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north-shadow.png"
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5,
              draw_as_shadow = true
            }
          }
        }
      },
      east =
      {
        layers =
        {
          {
            filename = path .."/pipe-cover-east.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            hr_version =
            {
              filename = path .."/hr-pipe-cover-east.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5
            }
          },
          {
            filename = path .."/pipe-cover-east-shadow.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            draw_as_shadow = true,
            hr_version =
            {
              filename = path .."/hr-pipe-cover-east-shadow.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5,
              draw_as_shadow = true
            }
          }
        }
      },
      south =
      {
        layers =
        {
          {
            filename = path .."/pipe-cover-south.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            hr_version =
            {
              filename = path .."/hr-pipe-cover-south.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5
            }
          },
          {
            filename = path .."/pipe-cover-south-shadow.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            draw_as_shadow = true,
            hr_version =
            {
              filename = path .."/hr-pipe-cover-south-shadow.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5,
              draw_as_shadow = true
            }
          }
        }
      },
      west =
      {
        layers =
        {
          {
            filename = path .."/pipe-cover-west.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            hr_version =
            {
              filename = path .."/hr-pipe-cover-west.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5
            }
          },
          {
            filename = path .."/pipe-cover-west-shadow.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            draw_as_shadow = true,
            hr_version =
            {
              filename = path .."/hr-pipe-cover-west-shadow.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5,
              draw_as_shadow = true
            }
          }
        }
      }
    }
  end

  
local function addFluidBoxes(entity)
  if entity == nil then return end

  return {
    {
      production_type = "input",
      pipe_picture = assembler1pipepictures(entity .. "pipe_connections"),
      pipe_covers = pipecoverspictures(entity .. "pipe-covers"),
      base_area = 10,
      base_level = -1,
      pipe_connections = {{type="input", position = {0,-2}}},
      secondary_draw_orders = { north = -1 }
    },
    {
      production_type = "output",
      pipe_picture = assembler1pipepictures(entity .. "pipe_connections"),
      pipe_covers = pipecoverspictures(entity .. "pipe-covers"),
      base_area = 10,
      base_level = 1,
      pipe_connections = {{type="output", position={0, 2}}},
      secondary_draw_orders = {north = -1}
    },
      off_when_no_fluid_recipe = true
  }
end


local function callRemoteFreeplay(function_call, value)
    if function_call == "set_created_items" then 

        local default = {}
        if value ~= nil then default = value end
        pcall(function() remote.call("freeplay", "set_created_items", default) end) 

    elseif function_call == "set_respawn_items" then 

        local default = {}
        if value ~= nil then default = value end
        pcall(function() remote.call("freeplay", "set_respawn_items", default) end) 

    elseif function_call == "set_skip_intro" then 

        local default = true
        if value == false then default = false end
        pcall(function() remote.call("freeplay", "set_skip_intro", default) end) 

    elseif function_call == "set_disable_crashsite" then 

        local default = true
        if value == false then default = false end
        pcall(function() remote.call("freeplay", "set_disable_crashsite", true) end) 

    elseif function_call == "all" then

        pcall(function() remote.call("freeplay", "set_created_items", default) end) 
        pcall(function() remote.call("freeplay", "set_respawn_items", default) end)
        pcall(function() remote.call("freeplay", "set_skip_intro", default) end)
        pcall(function() remote.call("freeplay", "set_disable_crashsite", true) end)

    end
end



---------------------------------------------------
-- Chargement des fonctions
local ritnlib = {}
ritnlib = {
  table = {
    busy = tableBusy,
    length = tableLength,
  },
  tableBusy = tableBusy,
  ritnPrint = ritnPrint,
  ritnLog = ritnLog,
  str_start = str_start,
  tablelength = tableLength,
  split = split,
  getn = getn,
  give_item = give_item,
  give_item_list = give_item_list,
  build_clock_string = build_clock_string,
  assembler1pipepictures = assembler1pipepictures,
  pipecoverspictures = pipecoverspictures,
  spairs = spairs,
  uuid = uuid,
  clearOutput = clearOutput,
  writeToOutput = writeToOutput,
  writeToProductionStats = writeToProductionStats,
  addFluidBoxes = addFluidBoxes,
  callRemoteFreeplay = callRemoteFreeplay,
}

return ritnlib