---------------------------------------------------------------------------------------------
-- MIGRATIONS
---------------------------------------------------------------------------------------------
-- FR : Migrations exécutées dans on_configuration_changed quand le mod change de version :
--      une entrée par version, exécutées dans l'ordre si elles sont plus récentes que l'ancienne version.
-- EN : Migrations run in on_configuration_changed when the mod changes version:
--      one entry per version, run in order if they are newer than the old version.
---------------------------------------------------------------------------------------------


---**EN**
---
---Description: Splits a version "1.2.3" into numbers.
---
---──────────────────────────────
---
---**FR**
---
---Description: Découpe une version « 1.2.3 » en nombres.
---@param version string
---@return integer[]
local function parseVersion(version)
    local numbers = {}

    -- FR : Chaque groupe de chiffres, dans l'ordre
    -- EN : Each group of digits, in order
    for number in string.gmatch(version, "%d+") do
        numbers[#numbers + 1] = tonumber(number)
    end
    return numbers
end


---**EN**
---
---Description: True if version `a` is older than version `b`. A missing `a` (mod just added) is never older.
---
---──────────────────────────────
---
---**FR**
---
---Description: Vrai si la version `a` est plus ancienne que `b`. Une `a` absente (mod qui vient d'être ajouté) ne l'est jamais.
---@param a string?
---@param b string
---@return boolean
local function isOlder(a, b)
    -- FR : Pas d'ancienne version : rien à migrer
    -- EN : No old version: nothing to migrate
    if a == nil then
        return false
    end

    -- FR : Comparaison nombre par nombre
    -- EN : Number by number comparison
    local va = parseVersion(a)
    local vb = parseVersion(b)
    for index = 1, math.max(#va, #vb) do
        local x = va[index] or 0
        local y = vb[index] or 0
        if x ~= y then
            return x < y
        end
    end
    return false
end


-- FR : Liste des migrations, de la plus ancienne à la plus récente (exemple commenté)
-- EN : Migrations list, from oldest to newest (commented example)
local migration_list = {
    -- { version = "0.2.0", run = function() storage.new_key = storage.new_key or {} end },
}


---**EN**
---
---Description: Runs the migrations newer than `old_version`, in order.
---
---──────────────────────────────
---
---**FR**
---
---Description: Exécute les migrations plus récentes que `old_version`, dans l'ordre.
---@param old_version string?
local function run(old_version)
    for _, migration in ipairs(migration_list) do
        -- FR : Migration plus récente que l'ancienne version du mod
        -- EN : Migration newer than the mod old version
        if isOlder(old_version, migration.version) then
            log("> MyMod migration " .. migration.version)
            migration.run()
        end
    end
end


return {
    run = run,
}
