--Others Functions :
--------------------------
local types = require("__RitnLib__.core.constants").types
--------------------------

-- print() pour Ritn uniquement

---**EN**
---
---Description: Prints `txt` to the player named "Ritn" only.
---
---⚠ Personal debug helper — crashes if no player named "Ritn" exists in the game. Do not use in shipped consumer code.
---
---──────────────────────────────
---
---**FR**
---
---Description: Imprime `txt` au joueur nommé "Ritn" uniquement.
---
---⚠ Helper de debug personnel — plante si aucun joueur nommé "Ritn" n'existe en jeu. Ne pas utiliser dans du code consommateur livré.
---@param txt string
local function ritnPrint(txt)
    if game.players.Ritn.valid then
        game.players.Ritn.print(txt)
    end
end


---**EN**
---
---Description: `print()` wrapped in a pcall — writes to stdout (visible in the server console), logging the error if printing fails.
---
---──────────────────────────────
---
---**FR**
---
---Description: `print()` encapsulé dans un pcall — écrit sur stdout (visible dans la console serveur), log l'erreur si l'impression échoue.
---@param txt string
local function ritnLog(txt)
    local statut, errorMsg = pcall(function()
        print(txt)
    end)
    if statut == (false or nil) then
        print(">> error ritnlog : " .. errorMsg)
    end
end


---**EN**
---
---Description: Naive recursive table→JSON string serialiser. Handles nested tables, strings and `tostring`-able values.
---
---⚠ No escaping of special characters in strings, no array support (everything is serialised as an object). For robust JSON, use [`lualib/json-functions.lua`](json-functions.lua) (rxi/json) instead.
---
---──────────────────────────────
---
---**FR**
---
---Description: Sérialiseur naïf récursif table→string JSON. Gère les tables imbriquées, les strings et les valeurs `tostring`-ables.
---
---⚠ Pas d'échappement des caractères spéciaux dans les strings, pas de support des arrays (tout est sérialisé comme un objet). Pour du JSON robuste, utiliser [`lualib/json-functions.lua`](json-functions.lua) (rxi/json) à la place.
---@param table table
---@return string
local function table_to_json(table)
    local json = "{"
    for key, value in pairs(table) do
        if type(value) == "table" then
            json = json .. '"' .. key .. '":' .. table_to_json(value) .. ','
        elseif type(value) == "string" then
            json = json .. '"' .. key .. '":"' .. value .. '",'
        else
            json = json .. '"' .. key .. '":' .. tostring(value) .. ','
        end
    end
    json = json:sub(1, -2) .. "}"
    return json
end


-- Fonction try catch avec log

---**EN**
---
---Description: Try/catch built on `pcall`. Runs `funcTry`; on error, logs `[ERROR] > <message>` then runs `funcCatch` if provided.
---
---──────────────────────────────
---
---**FR**
---
---Description: Try/catch construit sur `pcall`. Exécute `funcTry` ; en cas d'erreur, log `[ERROR] > <message>` puis exécute `funcCatch` si fourni.
---@param funcTry function
---@param funcCatch? function
local function tryCatch(funcTry, funcCatch)
    if type(funcTry) == 'function' then
        local result, errorMsg = pcall(funcTry)
        if result == false then
            log('[ERROR] > '..errorMsg)
            if type(funcCatch) == 'function' then
                funcCatch()
            end
        end
    else
        log("[ERROR] > tryCatch(f1, f2) -> [f1] is'nt function (try)")
    end
end

-- if then else -> façon ternaire

---**EN**
---
---Description: Ternary-style helper: returns `Then` when `Condition` is truthy, else `Else`. If the selected branch is a function it is invoked through `tryCatch`.
---
---⚠ Unlike a real ternary, **both** `Then` and `Else` arguments are evaluated at call time (Lua evaluates arguments eagerly). Don't pass expressions with side effects.
---
---──────────────────────────────
---
---**FR**
---
---Description: Helper façon ternaire : retourne `Then` quand `Condition` est vraie, sinon `Else`. Si la branche sélectionnée est une fonction elle est invoquée via `tryCatch`.
---
---⚠ Contrairement à un vrai ternaire, les **deux** arguments `Then` et `Else` sont évalués à l'appel (Lua évalue les arguments immédiatement). Ne pas passer d'expressions à effets de bord.
---@param Condition any
---@param Then any
---@param Else any
---@return any
local function ifElse(Condition, Then, Else)
    if Condition then
        if type(Then) == "function" then
            return tryCatch(Then())
        else
            return Then
        end
    else
        if type(Else) == "function" then
            return tryCatch(Else())
        else
            return Else
        end
    end
end


-- return type or object_name

---**EN**
---
---Description: Extended `type()` — returns `value.object_name` when present (e.g. `"LuaPlayer"`, `"LuaEntity"`, `"RitnLibPlayer"`), else falls back to the native Lua `type()`. This is how RitnLib distinguishes Factorio runtime objects and its own wrappers from plain tables.
---
---──────────────────────────────
---
---**FR**
---
---Description: `type()` étendu — retourne `value.object_name` quand présent (ex: `"LuaPlayer"`, `"LuaEntity"`, `"RitnLibPlayer"`), sinon fallback sur le `type()` natif de Lua. C'est ainsi que RitnLib distingue les objets runtime Factorio et ses propres wrappers des simples tables.
---@param value any
---@return string
local function data_type(value)
	local data_type

	local result = pcall(function()
		data_type = value.object_name
	end)
	if result then return data_type end

	return type(value)
end


-- Retourne vrai si la valeur est une chaine de caractère

---**EN**
---
---Description: Returns true if `data_type(value) == pType`. The `pType` must be one of the basic Lua types whitelisted in `core/constants.lua::types` (boolean, string, number, table, function, nil).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `data_type(value) == pType`. Le `pType` doit faire partie des types Lua de base whitelistés dans `core/constants.lua::types` (boolean, string, number, table, function, nil).
---@param value any
---@param pType string
---@return boolean
local function isType(value, pType)
	-- vérification que pType fait partie de la liste des types accepté
	if types[pType] == nil then return false end

	return (data_type(value) == pType)
end


--La chaîne de caractère 'str' commence par 'start'
--@deprecated use string-functions

---**EN**
---
---Description: Returns true if `str` starts with `start`.
---
---⚠ Deprecated — use `string-functions.startsWith` instead.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne true si `str` commence par `start`.
---
---⚠ Déprécié — utiliser `string-functions.startsWith` à la place.
---@deprecated
---@param str string
---@param start string
---@return boolean
local function str_start(str, start)
    return str:sub(1, #start) == start
end


-- Retourne tableau

---**EN**
---
---Description: Splits `inputstr` on separator `sep` (Lua pattern char-class; default whitespace `%s`) and returns the parts as an array.
---
---──────────────────────────────
---
---**FR**
---
---Description: Découpe `inputstr` sur le séparateur `sep` (char-class de pattern Lua ; défaut espace `%s`) et retourne les morceaux dans un array.
---@param inputstr string
---@param sep? string
---@return string[]
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

---**EN**
---
---Description: Returns the highest numeric index found in `tab` (a count for array-like tables, even sparse ones). Returns 0 for nil input.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le plus grand index numérique trouvé dans `tab` (un compte pour les tables de type array, même creuses). Retourne 0 pour une entrée nil.
---@param tab table?
---@return number
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

---**EN**
---
---Description: Inserts `item` into the player's inventory via `LuaPlayer.insert`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Insère `item` dans l'inventaire du joueur via `LuaPlayer.insert`.
---@param LuaPlayer LuaPlayer
---@param item ItemStackIdentification  e.g. `{name = "iron-plate", count = 8}`
local function give_item(LuaPlayer, item)
    LuaPlayer.insert(item)
end

-- Give une list d'items

---**EN**
---
---Description: Inserts every item of `items` into the player's inventory.
---
---──────────────────────────────
---
---**FR**
---
---Description: Insère chaque item de `items` dans l'inventaire du joueur.
---@param LuaPlayer LuaPlayer
---@param items ItemStackIdentification[]
local function give_item_list(LuaPlayer, items)
    for _, item in pairs(items) do
        give_item(LuaPlayer, item)
    end
end

-- Transforme un nombre de sec en timer foramt 00:00:00

---**EN**
---
---Description: Formats a duration in seconds as an `HH:MM:SS` clock string. Returns `"00:00:00"` for non-positive input.
---
---──────────────────────────────
---
---**FR**
---
---Description: Formate une durée en secondes au format horloge `HH:MM:SS`. Retourne `"00:00:00"` pour une entrée non positive.
---@param time number  Seconds
---@return string
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



---**EN**
---
---Description: Appends `identifierer .. appendContent` to the globals `currentProductionStats` / `tempProductionStats`.
---
---⚠ Those two globals are not declared anywhere in RitnLib — the consumer must define them before calling, otherwise this errors on the nil concatenation.
---
---──────────────────────────────
---
---**FR**
---
---Description: Concatène `identifierer .. appendContent` aux globals `currentProductionStats` / `tempProductionStats`.
---
---⚠ Ces deux globals ne sont déclarés nulle part dans RitnLib — le consommateur doit les définir avant l'appel, sinon erreur de concaténation nil.
---@param identifierer string
---@param appendContent string
local function writeToProductionStats(identifierer, appendContent)
    currentProductionStats = currentProductionStats .. identifierer .. appendContent;
	tempProductionStats = tempProductionStats .. "p" .. identifierer .. appendContent;
end

---**EN**
---
---Description: Returns `output .. appendContent`, or nothing when `appendContent` is nil.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne `output .. appendContent`, ou rien quand `appendContent` est nil.
---@param output string
---@param appendContent string?
---@return string?
local function writeToOutput(output, appendContent)
	if appendContent ~= nil then
		return output .. appendContent
	end
end

---**EN**
---
---Description: Generates a UUID v4-format string using `math.random`.
---
---⚠ Factorio's `math.random` is deterministic per map seed and synchronised in multiplayer — generated UUIDs are reproducible across clients (which is what you want for desync safety), not cryptographically random.
---
---──────────────────────────────
---
---**FR**
---
---Description: Génère une string au format UUID v4 via `math.random`.
---
---⚠ Le `math.random` de Factorio est déterministe par seed de map et synchronisé en multijoueur — les UUID générés sont reproductibles entre clients (ce qu'on veut pour éviter les desyncs), pas cryptographiquement aléatoires.
---@return string
local function uuid()
	local random = math.random
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end



-- Ajoute les tuyaux d'entrées pour les machines d'assemblages 1

---**EN**
---
---Description: Returns the 4-direction pipe-picture table (N/E/S/W) for assembling-machine-1-style fluid connections, with file paths rooted at `path`. Data-stage helper.
---
---⚠ Uses the legacy `hr_version` sprite layout (Factorio 1.x). Factorio 2.0 ignores `hr_version` — works, but only the base-resolution sprites are used.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne la table pipe-picture 4 directions (N/E/S/W) pour des connexions fluide style assembling-machine-1, avec les chemins de fichiers enracinés à `path`. Helper data-stage.
---
---⚠ Utilise le layout sprite legacy `hr_version` (Factorio 1.x). Factorio 2.0 ignore `hr_version` — fonctionne, mais seuls les sprites en résolution de base sont utilisés.
---@param path string  Graphics folder path
---@return table
local function assembler1pipepictures(path)
    return {
        north = {
            filename = path .."/assembling-machine-1-pipe-N.png",
            priority = "extra-high",
            width = 35,
            height = 18,
            shift = util.by_pixel(2.5, 14),
            hr_version = {
                filename = path .."/hr-assembling-machine-1-pipe-N.png",
                priority = "extra-high",
                width = 71,
                height = 38,
                shift = util.by_pixel(2.25, 13.5),
                scale = 0.5
            }
        },
        east = {
            filename = path .."/assembling-machine-1-pipe-E.png",
            priority = "extra-high",
            width = 20,
            height = 38,
            shift = util.by_pixel(-25, 1),
            hr_version = {
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
            hr_version = {
                filename = path.."/hr-assembling-machine-1-pipe-S.png",
                priority = "extra-high",
                width = 88,
                height = 61,
                shift = util.by_pixel(0, -31.25),
                scale = 0.5
            }
        },
        west = {
            filename = path .."/assembling-machine-1-pipe-W.png",
            priority = "extra-high",
            width = 19,
            height = 37,
            shift = util.by_pixel(25.5, 1.5),
            hr_version = {
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

---**EN**
---
---Description: Returns the 4-direction pipe-covers table (N/E/S/W, each with sprite + shadow layers), with file paths rooted at `path`. Data-stage helper.
---
---⚠ Same `hr_version` legacy layout note as `assembler1pipepictures`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne la table pipe-covers 4 directions (N/E/S/W, chacune avec layers sprite + ombre), avec les chemins de fichiers enracinés à `path`. Helper data-stage.
---
---⚠ Même note de layout legacy `hr_version` que `assembler1pipepictures`.
---@param path string  Graphics folder path
---@return table
local function pipecoverspictures(path)
    return {
		north = {
			layers = {
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
		east = {
			layers = {
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
		south = {
			layers = {
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
		west = {
			layers = {
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


---**EN**
---
---Description: Returns a standard 2-entry `fluid_boxes` table (input at `{0,-2}`, output at `{0,2}`, `off_when_no_fluid_recipe = true`) using `assembler1pipepictures` and `pipecoverspictures` for graphics. Data-stage helper for crafting machines.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne une table `fluid_boxes` standard à 2 entrées (input à `{0,-2}`, output à `{0,2}`, `off_when_no_fluid_recipe = true`) en utilisant `assembler1pipepictures` et `pipecoverspictures` pour les graphismes. Helper data-stage pour les machines de craft.
---@param entity string  Graphics path prefix
---@return table?
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


---**EN**
---
---Description: Wraps the `freeplay` / `silo_script` scenario remote calls behind one switch. Every call is `pcall`-protected (no-op if the scenario interface isn't registered).
---
---Supported `function_call` values:
---- `"set_created_items"` — items given at game start (default `{}`)
---- `"set_respawn_items"` — items given on respawn (default `{}`)
---- `"set_skip_intro"` — skip the crash-site intro (default `true`)
---- `"set_disable_crashsite"` — remove the crash site (default `true`)
---- `"no_finish"` — `silo_script.set_no_victory` (default `true`)
---- `"all"` — apply the four freeplay calls in one shot
---
---──────────────────────────────
---
---**FR**
---
---Description: Encapsule les remote calls des scénarios `freeplay` / `silo_script` derrière un seul switch. Chaque appel est protégé par `pcall` (no-op si l'interface scénario n'est pas enregistrée).
---
---Valeurs de `function_call` supportées :
---- `"set_created_items"` — items donnés au démarrage (défaut `{}`)
---- `"set_respawn_items"` — items donnés au respawn (défaut `{}`)
---- `"set_skip_intro"` — saute l'intro du crash-site (défaut `true`)
---- `"set_disable_crashsite"` — supprime le site de crash (défaut `true`)
---- `"no_finish"` — `silo_script.set_no_victory` (défaut `true`)
---- `"all"` — applique les quatre appels freeplay d'un coup
---@param function_call "set_created_items"|"set_respawn_items"|"set_skip_intro"|"set_disable_crashsite"|"no_finish"|"all"
---@param value? any  Items table for the `set_*_items` calls, boolean for the others
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
        pcall(function() remote.call("freeplay", "set_disable_crashsite", default) end)

    elseif function_call == "no_finish" then

		local default = true
		if value == false then default = false end
		pcall(function() remote.call("silo_script", "set_no_victory", default) end)

    elseif function_call == "all" then

        pcall(function() remote.call("freeplay", "set_created_items", default) end)
        pcall(function() remote.call("freeplay", "set_respawn_items", default) end)
        pcall(function() remote.call("freeplay", "set_skip_intro", default) end)
        pcall(function() remote.call("freeplay", "set_disable_crashsite", true) end)

    end
end



---------------------------------------------------
-- Chargement des fonctions

---**EN**
---
---Description: RitnLib "other" utility module — exposed via `require(ritnlib.defines.other)`. The most important member is `type` (the extended `object_name`-aware type resolver used by every wrapper class).
---
---──────────────────────────────
---
---**FR**
---
---Description: Module utilitaire "other" de RitnLib — exposé via `require(ritnlib.defines.other)`. Le membre le plus important est `type` (le résolveur de type étendu basé sur `object_name`, utilisé par toutes les classes wrapper).
---@class RitnLibOtherFunctions
---@field ritnPrint fun(txt: string)
---@field ritnLog fun(txt: string)
---@field type fun(value: any): string
---@field ifElse fun(Condition: any, Then: any, Else: any): any
---@field tryCatch fun(funcTry: function, funcCatch?: function)
---@field isType fun(value: any, pType: string): boolean
---@field str_start fun(str: string, start: string): boolean
---@field split fun(inputstr: string, sep?: string): string[]
---@field getn fun(tab: table?): number
---@field give_item fun(LuaPlayer: LuaPlayer, item: table)
---@field give_item_list fun(LuaPlayer: LuaPlayer, items: table[])
---@field build_clock_string fun(time: number): string
---@field assembler1pipepictures fun(path: string): table
---@field pipecoverspictures fun(path: string): table
---@field spairs nil                         ⚠ Exported but never defined in this module — always nil (see table-functions.spairs)
---@field uuid fun(): string
---@field clearOutput nil                    ⚠ Exported but never defined in this module — always nil
---@field writeToOutput fun(output: string, appendContent: string?): string?
---@field writeToProductionStats fun(identifierer: string, appendContent: string)
---@field addFluidBoxes fun(entity: string): table?
---@field callRemoteFreeplay fun(function_call: string, value?: any)
---@field table_to_json fun(table: table): string
local ritnlib = {}
ritnlib = {
	ritnPrint = ritnPrint,
	ritnLog = ritnLog,
	type = data_type,
	ifElse = ifElse,
	tryCatch = tryCatch,
	isType = isType,
	str_start = str_start,
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
	table_to_json = table_to_json,
}

return ritnlib
