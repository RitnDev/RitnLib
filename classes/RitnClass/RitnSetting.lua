-- RitnLibSetting
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------
local json = require('__RitnLib__.lualib.json-functions')
----------------------------------------------------------------
-- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Fluent builder that produces a Factorio mod-setting prototype and registers it via `data:extend({...})`. Used at settings stage.
---
---Usage:
---```lua
---local Setting = require(ritnlib.defines.class.ritnClass.setting)
---Setting("my-mod-enable-x")
---    :setSettingStartup()
---    :setDefaultValueBool(true)
---    :new()
---```
---
---⚠ **Internal chain caveat**: `:getType()` and `:getDefaultValue()` look up `self.TYPE[self.dataType]`. Since `self.TYPE` has UPPERCASE keys (`BOOL`, `INTEGER`, …) and `self.dataType` is set to the lowercase **value** ("bool", "int", …) by `setTypeBoolean`/`setTypeInteger`/etc., the chained lookup `self.TYPE[self.dataType]` returns nil. This means `:getType()` will crash on the subsequent `.. self.SETTING_SUFFIX`. To avoid the crash today, only bool settings work, and only via the `setSettingStartup`/`setDefaultValueBool` path that bypasses `setType*`.
---
---⚠ **`:setDefaultValueBool` guard**: tests `self.dataType ~= self.TYPE.bool` (lowercase `bool`). `self.TYPE` has no lowercase `bool` key, so `self.TYPE.bool` is nil. The guard short-circuits and the setter early-returns when called after `setTypeBoolean`. Workaround: don't call `setTypeBoolean` before `setDefaultValueBool` — the constructor's default `dataType = 'bool'` already makes the chain work for bool.
---
---──────────────────────────────
---
---**FR**
---
---Description: Builder fluent qui produit un prototype de mod-setting Factorio et l'enregistre via `data:extend({...})`. À utiliser au settings stage.
---
---Usage :
---```lua
---local Setting = require(ritnlib.defines.class.ritnClass.setting)
---Setting("mon-mod-enable-x")
---    :setSettingStartup()
---    :setDefaultValueBool(true)
---    :new()
---```
---
---⚠ **Chaîne interne** : `:getType()` et `:getDefaultValue()` font `self.TYPE[self.dataType]`. Comme `self.TYPE` a des clés MAJUSCULES (`BOOL`, `INTEGER`, …) et que `self.dataType` est mis à la **valeur** minuscule ("bool", "int", …) par `setTypeBoolean`/`setTypeInteger`/etc., la lecture chaînée `self.TYPE[self.dataType]` retourne nil. `:getType()` plante donc sur le `.. self.SETTING_SUFFIX` qui suit. Pour éviter le crash aujourd'hui, seuls les settings bool fonctionnent, et seulement via la voie `setSettingStartup`/`setDefaultValueBool` qui bypass `setType*`.
---
---⚠ **Garde de `:setDefaultValueBool`** : teste `self.dataType ~= self.TYPE.bool` (`bool` minuscule). `self.TYPE` n'a pas de clé minuscule `bool`, donc `self.TYPE.bool` est nil. La garde court-circuite et le setter return tôt si appelé après `setTypeBoolean`. Contournement : ne pas appeler `setTypeBoolean` avant `setDefaultValueBool` — le défaut `dataType = 'bool'` du constructeur fait déjà fonctionner la chaîne pour bool.
---@class RitnLibSetting
---@field object_name "RitnLibSetting"               Sentinel
---@field name string                                Setting name (defaults to placeholder if not passed)
---@field dataType string                            One of `"bool"|"int"|"double"|"string"|"color"` (the VALUE, not the TYPE key)
---@field typeForSetting string                      Resolved `bool-setting` / `int-setting` / etc.
---@field defaultValue any                           Current default value
---@field data_setting table                         The `data:extend` payload being built
---@field TYPE { bool: "bool", integer: "int", double: "double", string: "string", color: "color" }
---@field VALUE { bool: false, int: 0, double: 0.0, string: "", color: table }
---@field SETTING_TYPE { startup: "startup", runtime: "runtime-global", player: "runtime-per-user" }
---@field SETTING_SUFFIX "-setting"
---@operator call(string?): RitnLibSetting
---@type RitnLibSetting
local RitnLibSetting = class.newclass(function(self, name)
    self.object_name = "RitnLibSetting"
    -----------------------------------------
    self.name = "insert-setting-name-please"
    if name ~= nil then
        if type(name) == "string" then
            self.name = name
        end
    end
    -----
    self.dataType = 'bool'
    -----
    self.typeForSetting = 'bool-setting'
    self.defaultValue = false
    -----
    self.data_setting = {
        type = self.dataType,
        name = name,
        default_value = self.defaultValue,
        setting_type = "startup",
    }
    --------------------------------------------------
end) --[[@as RitnLibSetting]]
------------------ CONSTANTES -------------------
RitnLibSetting.TYPE = {
    bool = "bool",
    int = "int",
    double = "double",
    string = "string",
    color = "color",
}
RitnLibSetting.VALUE = {
    bool = false,
    int = 0,
    double = 0.0,
    string = "",
    color = {},
}
RitnLibSetting.SETTING_TYPE = {
    startup = "startup",
    runtime = "runtime-global",
    player = "runtime-per-user",
}
RitnLibSetting.SETTING_SUFFIX = "-setting"
--------------------------------------------------

---**EN**
---
---Description: Resolves the full setting type string (e.g. `"bool-setting"`).
---
---⚠ Will crash if `self.dataType` doesn't match an UPPERCASE key of `self.TYPE` after the first deref.
---
---──────────────────────────────
---
---**FR**
---
---Description: Résout la string complète de type de setting (ex: `"bool-setting"`).
---
---⚠ Plantera si `self.dataType` ne correspond pas à une clé MAJUSCULE de `self.TYPE` après le premier déréf.
---@return string
function RitnLibSetting:getType()
    self.dataType = self.TYPE[self.dataType]
    return self.TYPE[self.dataType] .. self.SETTING_SUFFIX
end

---**EN**
---
---Description: Calls `:getType()` and writes the result into `self.typeForSetting` + `self.data_setting.type`. Also updates `default_value` from `:getDefaultValue()`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Appelle `:getType()` et écrit le résultat dans `self.typeForSetting` + `self.data_setting.type`. Met aussi à jour `default_value` depuis `:getDefaultValue()`.
---@return RitnLibSetting self  Chainable
function RitnLibSetting:setType()
    self.typeForSetting = self:getType()
    ----
    self.data_setting.type = self.typeForSetting
    self.data_setting.default_value = self:getDefaultValue()
    ---------------------------------------
    return self
end

--------------------------------------------------

---**EN**
---
---Description: Returns the default value matching the current `dataType` from `self.VALUE`.
---
---⚠ Same caveat as `:getType()` — `self.TYPE[self.dataType]` lookup fails when the TYPE keys are UPPERCASE.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne la valeur par défaut correspondant au `dataType` courant depuis `self.VALUE`.
---
---⚠ Même problème que `:getType()` — `self.TYPE[self.dataType]` échoue quand les clés TYPE sont MAJUSCULES.
---@return any
function RitnLibSetting:getDefaultValue()
    log('> ' .. self.object_name .. ':getDefaultValue() -> dataType = ' .. self.dataType)
    log('> ' .. self.object_name .. ':getDefaultValue() -> self.TYPE[self.dataType] = ' .. self.TYPE[self.dataType])
    ---------------------------------------
    return self.VALUE[self.TYPE[self.dataType]]
end

--------------------------------------------------

---**EN**
---
---Description: Sets `dataType` to `bool` then calls `:setType()`. ⚠ `:setType()` will crash on the chained lookup; in practice only the constructor default path (no `setTypeBoolean` call) works for bool settings.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `dataType` à `bool` puis appelle `:setType()`. ⚠ `:setType()` plantera sur la lecture chaînée ; en pratique seule la voie défaut du constructeur (sans appeler `setTypeBoolean`) fonctionne pour les settings bool.
---@return RitnLibSetting self
function RitnLibSetting:setTypeBoolean()
    self.dataType = self.TYPE.bool
    ---------------------------------------
    return self:setType()
end

---**EN**
---
---Description: Sets `dataType` to `int` then calls `:setType()`. ⚠ Crashes — `:setType()` chain breaks.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `dataType` à `int` puis appelle `:setType()`. ⚠ Plante — la chaîne `:setType()` casse.
---@return RitnLibSetting self
function RitnLibSetting:setTypeInteger()
    self.dataType = self.TYPE.integer
    ---------------------------------------
    return self:setType()
end

---**EN**
---
---Description: Sets `dataType` to `double` then calls `:setType()`. ⚠ Crashes — `:setType()` chain breaks.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `dataType` à `double` puis appelle `:setType()`. ⚠ Plante — la chaîne `:setType()` casse.
---@return RitnLibSetting self
function RitnLibSetting:setTypeDouble()
    self.dataType = self.TYPE.double
    ---------------------------------------
    return self:setType()
end

---**EN**
---
---Description: Sets `dataType` to `string` then calls `:setType()`. ⚠ Crashes — `:setType()` chain breaks.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `dataType` à `string` puis appelle `:setType()`. ⚠ Plante — la chaîne `:setType()` casse.
---@return RitnLibSetting self
function RitnLibSetting:setTypeString()
    self.dataType = self.TYPE.string
    ---------------------------------------
    return self:setType()
end

---**EN**
---
---Description: Sets `dataType` to `color` then calls `:setType()`. ⚠ Crashes — `:setType()` chain breaks.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `dataType` à `color` puis appelle `:setType()`. ⚠ Plante — la chaîne `:setType()` casse.
---@return RitnLibSetting self
function RitnLibSetting:setTypeColor()
    self.dataType = self.TYPE.color
    ---------------------------------------
    return self:setType()
end

--------------------------------------------------

---**EN**
---
---Description: Sets `setting_type = "startup"`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `setting_type = "startup"`.
---@return RitnLibSetting self
function RitnLibSetting:setSettingStartup()
    self.data_setting.setting_type = self.SETTING_TYPE.startup
    ---------------------------------------
    return self
end

---**EN**
---
---Description: Sets `setting_type = "runtime-global"`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `setting_type = "runtime-global"`.
---@return RitnLibSetting self
function RitnLibSetting:setSettingRuntime()
    self.data_setting.setting_type = self.SETTING_TYPE.runtime
    ---------------------------------------
    return self
end

---**EN**
---
---Description: Sets `setting_type = "runtime-per-user"`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `setting_type = "runtime-per-user"`.
---@return RitnLibSetting self
function RitnLibSetting:setSettingPlayer()
    self.data_setting.setting_type = self.SETTING_TYPE.player
    ---------------------------------------
    return self
end

--------------------------------------------------

---**EN**
---
---Description: Sets the boolean default value.
---
---⚠ Guard `self.dataType ~= self.TYPE.bool` always returns true (because `self.TYPE.bool` is nil — TYPE keys are uppercase). The setter then early-returns whenever `:setTypeBoolean()` was called before it. **Workaround**: rely on the constructor's default `dataType = 'bool'` and don't call `:setTypeBoolean()` first.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit la valeur par défaut booléenne.
---
---⚠ La garde `self.dataType ~= self.TYPE.bool` retourne toujours true (car `self.TYPE.bool` est nil — clés TYPE en majuscules). Le setter return tôt quand `:setTypeBoolean()` a été appelé avant. **Contournement** : se reposer sur le défaut `dataType = 'bool'` du constructeur et ne pas appeler `:setTypeBoolean()` d'abord.
---@param value boolean
---@return RitnLibSetting self
function RitnLibSetting:setDefaultValueBool(value)
    log('> ' .. self.object_name .. ':setDefaultValueBool() -> value = ' .. tostring(value))
    if self.dataType ~= self.TYPE.bool then return self end
    if type(value) ~= "boolean" then return self end
    ---------------------------------------
    self.defaultValue = value
    ---------------------------------------
    return self
end

--------------------------------------------------

---**EN**
---
---Description: Sets `data_setting.order` for in-menu sorting. No-op if not a string.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `data_setting.order` pour le tri en menu. No-op si pas string.
---@param order string
---@return RitnLibSetting self
function RitnLibSetting:setOrder(order)
    if order == nil then return self end
    if type(order) ~= "string" then return self end

    self.data_setting.order = order
    ---------------------------------------
    log('> ' .. self.object_name .. ':setOrder(' .. order .. ')')
    ---------------------------------------

    return self
end

--------------------------------------------------

---**EN**
---
---Description: Final call — runs `:setType()` to refresh `data_setting`, then `data:extend({ self.data_setting })`.
---
---⚠ Crashes when `:setType()` is called with a non-default `dataType` because of the chained lookup bug above.
---
---──────────────────────────────
---
---**FR**
---
---Description: Appel final — exécute `:setType()` pour rafraîchir `data_setting`, puis `data:extend({ self.data_setting })`.
---
---⚠ Plante quand `:setType()` est appelé avec un `dataType` non-défaut à cause du bug de lecture chaînée ci-dessus.
function RitnLibSetting:new()
    self:setType()
    self.data_setting.default_value = self.defaultValue
    ---------------------------------------
    log('> ' .. self.object_name .. ':new() -> data_setting = ' .. json.encode(self.data_setting))
    ---------------------------------------
    return data:extend({ self.data_setting })
end

----------------------------------------------------------------
return RitnLibSetting
