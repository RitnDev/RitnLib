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
    self.object_name = "RitnLibSurface"
    if LuaSurface == nil then return end
    if LuaSurface.valid == false then return end
    if LuaSurface.object_name ~= "LuaSurface" then return end
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
    log('> '.. self.object_name .. ':getEntity()')
    if not table.isPosition(position) then log("not position or nil") return nil end
    if type(unit_number) == "nil" then log("not unit_number or nil") return nil end

    -- enregistrement des valeurs de recherche, par défaut seulement la position
    local search = {
        position=position,
    }

    -- si le nom de l'entité est renseigné, on l'ajoute au critère de recherche
    if type(name) == "string" then search.name = name end
    -- si le type est renseigné et exite, on l'ajoute au critère de recherche
    local vEntityType = string.isNotEmptyString(entityType)
    if vEntityType ~= nil then 
        if table.indexOf(entity_types, vEntityType) > 0 then 
            search.type = vEntityType 
        else
            log("not unit_number or nil")
        end
    end

    -- on lance la recherche -> retourne un tableau d'entité
    local tabEntities = self.surface.find_entities_filtered(search)
 
    local LuaEntity = table.index(tabEntities, "unit_number", id)
    
    if type(LuaEntity) ~= "nil" then 
        return LuaEntity
    end

    return nil
end

----------------------------------------------------------------
--return RitnLibSurface