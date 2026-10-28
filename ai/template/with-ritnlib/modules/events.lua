---------------------------------------------------------------------------------------------
-- MODULE : EVENTS
---------------------------------------------------------------------------------------------
-- FR : Cycle de vie du mod : création de storage, migrations.
-- EN : Mod life cycle: storage creation, migrations.
---------------------------------------------------------------------------------------------
local Migrations = require(ritnlib.defines.mymod.migrations)
---------------------------------------------------------------------------------------------


---**EN**
---
---Description: Creates the missing `storage` tables (new game, or mod added to a game).
---
---──────────────────────────────
---
---**FR**
---
---Description: Crée les tables de `storage` manquantes (nouvelle partie, ou mod ajouté à une partie).
local function initStorage()
    -- FR : Données par joueur
    -- EN : Per-player data
    if storage.players == nil then
        storage.players = {}
    end
end


---**EN**
---
---Description: Mod configuration changed: storage completed, migrations run when MyMod changes version.
---
---──────────────────────────────
---
---**FR**
---
---Description: Configuration changée : storage complété, migrations exécutées quand MyMod change de version.
---@param data ConfigurationChangedData
local function on_configuration_changed(data)
    initStorage()

    -- FR : Ancienne version du mod (absente s'il vient d'être ajouté : rien à migrer)
    -- EN : Old mod version (missing if it was just added: nothing to migrate)
    local changes = data.mod_changes and data.mod_changes[ritnlib.defines.mymod.name]
    if changes and changes.old_version then
        Migrations.run(changes.old_version)
    end
end


---@type MyModModule
local module = {events = {}}
module.on_init = initStorage
module.on_configuration_changed = on_configuration_changed
return module
