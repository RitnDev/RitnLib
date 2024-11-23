-- RitnLibSurface
----------------------------------------------------------------
local table = require(ritnlib.defines.table)
local string = require(ritnlib.defines.string)
local util = require(ritnlib.defines.other)
----------------------------------------------------------------
local entity_types = require("__RitnLib__.lualib.vanilla.types_entity")
----------------------------------------------------------------


----------------------------------------------------------------
RitnLibSurface = ritnlib.classFactory.newclass(function(self, LuaSurface)
    if util.type(LuaSurface) ~= "LuaSurface" then log('not LuaSurface !') return end
    if LuaSurface.valid == false then return end
    ----
    self.object_name = "RitnLibSurface"
    --------------------------------------------------
    self.surface = LuaSurface
    self.name = LuaSurface.name
    self.index = LuaSurface.index
    self.isNauvis = (LuaSurface.name == "nauvis")
    --------------------------------------------------
    --log('> [RITNLIB] > RitnLibSurface')
end)
----------------------------------------------------------------


function RitnLibSurface:print(text)
    if type(text) == "table" then 
        self.surface.print(serpent.block(text))
        return self
    end
    if type(text) ~= "string" then 
        pcall(function()
            self.surface.print(tostring(text))
        end)
        return self
    end

    self.surface.print(text)
    return self
end


function RitnLibSurface:getEntity(position, unit_number, name, entityType) 
    log('> '.. self.object_name .. ':getEntity(unit_number: '.. tostring(unit_number) ..', name: '.. tostring(name) ..', entityType: '.. tostring(entityType) .. ')')
    if not table.isPosition(position) then log("not position or nil") return nil end
    if type(unit_number) == "nil" then log("unit_number is't an number, is: " .. type(unit_number)) return nil end

    -- enregistrement des valeurs de recherche, par défaut seulement la position
    local search = {
        position=position,
    }

    -- si le nom de l'entité est renseigné, on l'ajoute au critère de recherche
    if type(name) == "string" then search.name = name end
    -- si le type est renseigné et exite, on l'ajoute au critère de recherche
    local vEntityType = string.defaultValue(entityType)
    if vEntityType ~= string.TOKEN_EMPTY_STRING then 
        if table.indexOf(entity_types, vEntityType) > 0 then 
            search.type = vEntityType 
        else
            log("not entityType available")
        end
    end

    -- on lance la recherche -> retourne un tableau d'entité
    local tabEntities = self.surface.find_entities_filtered(search)

    -- On récupère l'entité avec son unit_number dans la liste
    if table.length(tabEntities) > 0 then 
        log("> LuaEntity found: ".. tostring(table.length(tabEntities)))

        local index = table.index(tabEntities, "unit_number", unit_number)

        if index > 0 then 
            LuaEntity = tabEntities[index]
        else
            -- au cas où on retourne le premier de la liste
            LuaEntity = tabEntities[1] or self.surface.find_entity(name, position)
        end
    else 
        log("> LuaEntity not find !")
    end

    return LuaEntity
end

----------------------------------------------------------------
--return RitnLibSurface