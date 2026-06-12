--[[
	This is modified version of https://github.com/wube/factorio-data/blob/master/core/lualib/event_handler.lua
	Modified by ZwerOxotnik
]]

---**EN**
---
---Description: Event-handler aggregator (fork of Factorio's `event_handler.lua`, modified by ZwerOxotnik). Lets several "libs" register their event handlers through one shared dispatcher: each lib exposes optional `events`, `on_nth_tick`, `on_init`, `on_load`, `on_configuration_changed`, `add_remote_interface`, `add_commands` members, and the aggregator wires everything to `script.*` (merging multiple handlers per event into a loop when needed).
---
---If the [`zk-lib`](https://mods.factorio.com/mod/zk-lib) mod is active, this file delegates entirely to its optimised `event_handler_vZO` and returns that instead.
---
---⚠ Requiring this file has side effects: it immediately registers `script.on_init` / `script.on_load` / `script.on_configuration_changed`. A mod can only have **one** handler per `script.*` slot — don't mix this aggregator with direct `script.on_init(...)` calls in the same mod.
---
---⚠ Not loaded by RitnLib's own `control.lua` — provided as an opt-in for consumer mods. Note that `ritnlib.defines.event` points to the vanilla `__core__/lualib/event_handler`, not to this file.
---
---──────────────────────────────
---
---**FR**
---
---Description: Agrégateur d'event-handlers (fork du `event_handler.lua` de Factorio, modifié par ZwerOxotnik). Permet à plusieurs "libs" d'enregistrer leurs handlers via un dispatcher partagé : chaque lib expose les membres optionnels `events`, `on_nth_tick`, `on_init`, `on_load`, `on_configuration_changed`, `add_remote_interface`, `add_commands`, et l'agrégateur câble le tout sur `script.*` (en fusionnant les handlers multiples par event dans une boucle si besoin).
---
---Si le mod [`zk-lib`](https://mods.factorio.com/mod/zk-lib) est actif, ce fichier délègue entièrement à son `event_handler_vZO` optimisé et le retourne à la place.
---
---⚠ Le require de ce fichier a des effets de bord : il enregistre immédiatement `script.on_init` / `script.on_load` / `script.on_configuration_changed`. Un mod ne peut avoir qu'**un** handler par slot `script.*` — ne pas mélanger cet agrégateur avec des appels `script.on_init(...)` directs dans le même mod.
---
---⚠ Non chargé par le `control.lua` de RitnLib — fourni en opt-in pour les mods consommateurs. À noter : `ritnlib.defines.event` pointe vers le `__core__/lualib/event_handler` vanilla, pas vers ce fichier.
---@class RitnLibEventLib
---@field events? table<defines.events|string|integer, fun(event: EventData)>   Handlers indexed by event id
---@field on_nth_tick? table<integer, fun(event: NthTickEventData)>             Handlers indexed by tick interval
---@field on_init? fun()
---@field on_load? fun()
---@field on_configuration_changed? fun(data: ConfigurationChangedData)
---@field add_remote_interface? fun()
---@field add_commands? fun()

-- Priorise l'event-listener de ZwerOxotnik si son mod est activé
if script.active_mods["zk-lib"] then
	-- Same as Factorio "event_handler", but slightly better performance
	local is_ok, zk_event_handler = pcall(require, "__zk-lib__/static-libs/lualibs/event_handler_vZO.lua")
	if is_ok then
		return zk_event_handler
	end
end

---@type RitnLibEventLib[]
local libraries = {}


local script = script -- some mod devs overwrite it


local setup_ran = false

---**EN**
---
---Description: Runs each lib's `add_remote_interface` and `add_commands` once (guarded by `setup_ran` because `on_init` and `on_load` can both fire in special cases).
---
---──────────────────────────────
---
---**FR**
---
---Description: Exécute `add_remote_interface` et `add_commands` de chaque lib une seule fois (gardé par `setup_ran` car `on_init` et `on_load` peuvent tous deux se déclencher dans certains cas).
local register_remote_interfaces = function()
	--Sometimes, in special cases, on_init and on_load can be run at the same time. Only register events once in this case.
	if setup_ran then return end
	setup_ran = true

	for _, lib in pairs(libraries) do
		if lib.add_remote_interface then
			lib.add_remote_interface()
		end

		if lib.add_commands then
			lib.add_commands()
		end
	end
end

---**EN**
---
---Description: Collects every lib's `events` and `on_nth_tick` tables, then registers them on `script.on_event` / `script.on_nth_tick`. When a single lib handles an event, its handler is registered directly; when several libs handle the same event, a wrapper loops over all of them.
---
---──────────────────────────────
---
---**FR**
---
---Description: Collecte les tables `events` et `on_nth_tick` de chaque lib, puis les enregistre sur `script.on_event` / `script.on_nth_tick`. Quand une seule lib gère un event, son handler est enregistré directement ; quand plusieurs libs gèrent le même event, un wrapper boucle sur toutes.
local register_events = function()
	local all_events = {}
	local on_nth_tick = {}

	for lib_name, lib in pairs(libraries) do
		if lib.events then
		for k, handler in pairs(lib.events) do
			all_events[k] = all_events[k] or {}
			all_events[k][lib_name] = handler
		end
		end

		if lib.on_nth_tick then
		for n, handler in pairs(lib.on_nth_tick) do
			on_nth_tick[n] = on_nth_tick[n] or {}
			on_nth_tick[n][lib_name] = handler
		end
		end
	end

	for event, handlers in pairs(all_events) do
			local count = 0
			for _ in pairs(handlers) do
				count = count + 1
			end
			if count == 1 then
				local _, func = next(handlers)
				script.on_event(event, func)
			else
				-- TODO: improve
				local action = function(_event)
					for _, handler in pairs(handlers) do
						handler(_event)
					end
				end
				script.on_event(event, action)
			end
	end

	for n, handlers in pairs(on_nth_tick) do
			local count = 0
			for _ in pairs(handlers) do
				count = count + 1
			end

			if count == 1 then
				local _, func = next(handlers)
				script.on_nth_tick(n, func)
			else
				-- TODO: improve
				local action = function(event)
					for _, handler in pairs(handlers) do
						handler(event)
					end
				end
				script.on_nth_tick(n, action)
			end
	end

end

script.on_init(function()
	register_remote_interfaces()
	register_events()
	for _, lib in pairs(libraries) do
		if lib.on_init then
			lib.on_init()
		end
	end
end)

script.on_load(function()
	register_remote_interfaces()
	register_events()
	for _, lib in pairs(libraries) do
		if lib.on_load then
			lib.on_load()
		end
	end
end)

script.on_configuration_changed(function(data)
	for _, lib in pairs(libraries) do
		if lib.on_configuration_changed then
			lib.on_configuration_changed(data)
		end
	end
end)


---**EN**
---
---Description: The aggregator's public API — returned by the require. Register your libs with `add_lib` / `add_libraries` **before** `on_init`/`on_load` fire (i.e. at the top level of `control.lua`).
---
---──────────────────────────────
---
---**FR**
---
---Description: L'API publique de l'agrégateur — retournée par le require. Enregistrer ses libs via `add_lib` / `add_libraries` **avant** que `on_init`/`on_load` ne se déclenchent (donc au top level de `control.lua`).
---@class RitnLibEventHandler
---@field build 1
---@field add_lib fun(lib: RitnLibEventLib)             Registers one lib (errors when registering the same lib twice)
---@field add_libraries fun(libs: RitnLibEventLib[])    Registers several libs at once
local handler = {build = 1}

handler.add_lib = function(lib)
	for _, current in pairs(libraries) do
		if current == lib then
			error("Trying to register same lib twice")
		end
	end
	table.insert(libraries, lib)
end

handler.add_libraries = function(libs)
	for _, lib in pairs(libs) do
		handler.add_lib(lib)
	end
end

return handler
